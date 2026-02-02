import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DrawingLayerWidget extends StatefulWidget {
  final GlobalKey targetKey;
  final Function(dynamic) onWidgetHit;

  const DrawingLayerWidget({
    super.key,
    required this.targetKey,
    required this.onWidgetHit,
  });

  @override
  State<DrawingLayerWidget> createState() => _DrawingLayerWidgetState();
}

class _DrawingLayerWidgetState extends State<DrawingLayerWidget> {
  final ValueNotifier<List<Offset>> _points = ValueNotifier([]);
  dynamic _lastHit;

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

            if (data != null && data != _lastHit) {
              _lastHit = data;
              widget.onWidgetHit(data);
              hitFound = true;
            } else if (data == _lastHit) {
              hitFound = true;
            }
          }
        }
        if (!hitFound) _lastHit = null;
      }
    }
  }

  void _handlePointerUp(PointerEvent event) {
    _points.value = [];
    _lastHit = null;
  }
}

// Painter stays the same...
class _SmoothTrailPainter extends CustomPainter {
  final List<Offset> points;
  _SmoothTrailPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty || points.length < 25) return;
    print("Drawing ${points.length} points");

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