import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_flow/ui/common/constants.dart';
import 'package:habits_flow/ui/widgets/create_habit/create_habit_provider.dart';
import 'package:habits_flow/ui/widgets/habit/habit_provider.dart';
import 'package:habits_flow/ui/widgets/habits_collection/habits_collection_cubit.dart';
import 'package:habits_flow/ui/widgets/habits_collection/habits_collection_state.dart';

class HabitsCollectionWidget extends StatefulWidget {
  const HabitsCollectionWidget({super.key});

  @override
  State<HabitsCollectionWidget> createState() => _HabitsCollectionWidgetState();
}

class _HabitsCollectionWidgetState extends State<HabitsCollectionWidget> {
  // 1. We create a key to specifically target the Wrap widget
  final GlobalKey _wrapKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitsCollectionCubit, HabitCollectionState>(
      builder: (context, state) {
        return Stack(
          children: [
            // LAYER 1: The Habits
            Wrap(
              key: _wrapKey, // <--- Attach the key here
              alignment: WrapAlignment.start,
              spacing: Constants.habitsSep,
              runSpacing: Constants.habitsSep,
              children: [
                ...state.habits.map((habit) {
                  return MetaData(
                    behavior: HitTestBehavior.opaque,
                    metaData: habit,
                    child: HabitProvider(
                      key: ValueKey(habit.id),
                      habit: habit,
                    ),
                  );
                }),
                CreateHabitProvider(groupId: state.groupId),
              ],
            ),

            // LAYER 2: Drawing
            Positioned.fill(
              child: _HabitDrawingLayer(
                // We pass the key down so the layer knows where to check
                targetKey: _wrapKey,
                onHabitHit: (habitData) {
                  print("✅ HIT HABIT: ${habitData.id}");
                  // context.read<HabitsCollectionCubit>().toggleHabit(habitData.id);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// INTERNAL HELPER WIDGETS
// -----------------------------------------------------------------------------

class _HabitDrawingLayer extends StatefulWidget {
  final GlobalKey targetKey;
  final Function(dynamic) onHabitHit;

  const _HabitDrawingLayer({
    required this.targetKey,
    required this.onHabitHit,
  });

  @override
  State<_HabitDrawingLayer> createState() => _HabitDrawingLayerState();
}

class _HabitDrawingLayerState extends State<_HabitDrawingLayer> {
  final ValueNotifier<List<Offset>> _points = ValueNotifier([]);
  dynamic _lastHitHabit;

  void _handlePointerMove(PointerEvent event) {
    // 1. Update Drawing Visuals
    final newPoints = List<Offset>.from(_points.value)..add(event.localPosition);
    _points.value = newPoints;

    // 2. TARGETED HIT TEST
    // Instead of checking the whole screen, we check ONLY the Wrap's RenderBox.
    final RenderBox? targetRenderBox = widget.targetKey.currentContext?.findRenderObject() as RenderBox?;

    if (targetRenderBox != null) {
      // Convert the global finger position to the Wrap's local coordinate system
      final localOffset = targetRenderBox.globalToLocal(event.position);

      // Create a manual HitTest result
      final BoxHitTestResult result = BoxHitTestResult();

      // Ask the Wrap: "Is this point hitting you or your children?"
      if (targetRenderBox.hitTest(result, position: localOffset)) {

        bool hitFound = false;

        // Iterate through the results found INSIDE the Wrap
        for (final item in result.path) {
          if (item.target is RenderMetaData) {
            final data = (item.target as RenderMetaData).metaData;

            if (data != null && data != _lastHitHabit) {
              _lastHitHabit = data;
              widget.onHabitHit(data);
              hitFound = true;
            } else if (data == _lastHitHabit) {
              hitFound = true;
            }
          }
        }
        if (!hitFound) _lastHitHabit = null;
      }
    }
  }

  void _handlePointerUp(PointerEvent event) {
    _points.value = [];
    _lastHitHabit = null;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerUp,
      child: ValueListenableBuilder<List<Offset>>(
        valueListenable: _points,
        builder: (context, points, child) {
          return CustomPaint(
            painter: _SmoothTrailPainter(points: points),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

// Painter stays the same...
class _SmoothTrailPainter extends CustomPainter {
  final List<Offset> points;
  _SmoothTrailPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      path.quadraticBezierTo(
        p0.dx, p0.dy,
        (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2,
      );
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SmoothTrailPainter oldDelegate) => oldDelegate.points != points;
}