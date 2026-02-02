import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DrawingLayerWidget extends StatefulWidget {
  final Widget child;
  final Function(dynamic) onWidgetHit;

  const DrawingLayerWidget({
    super.key,
    required this.child,
    required this.onWidgetHit,

  });

  @override
  State<DrawingLayerWidget> createState() => _DrawingLayerWidgetState();
}

class _DrawingLayerWidgetState extends State<DrawingLayerWidget> {
  final ValueNotifier<List<Offset>> _points = ValueNotifier([]);
  final Set<dynamic> _sessionHits = {};

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        _sessionHits.clear();
        _points.value = [details.localPosition];
      },

      onPanUpdate: (details) {
        final newPoints = List<Offset>.from(_points.value)..add(details.localPosition);
        _points.value = newPoints;
        _performHitTest(details);
      },

      onPanEnd: (details) {
        _points.value = [];
        _sessionHits.clear();
      },

      child: ValueListenableBuilder<List<Offset>>(
        valueListenable: _points,
        builder: (context, points, child) {
          return CustomPaint(
            // Draw the trail ON TOP of the child
            foregroundPainter: _SmoothTrailPainter(points: points),
            child: widget.child, // <--- Render the habits below
          );
        },
      ),
    );
  }

  void _performHitTest(DragUpdateDetails details) {
    // If targetKey is provided, use it. Otherwise, hit test the child context.
    final RenderBox? targetRenderBox  = context.findRenderObject() as RenderBox?;

    if (targetRenderBox != null) {
      final localOffset = targetRenderBox.globalToLocal(details.globalPosition);
      final BoxHitTestResult result = BoxHitTestResult();

      // Hit test specifically to find MetaData
      if (targetRenderBox.hitTest(result, position: localOffset)) {
        for (final item in result.path) {
          if (item.target is RenderMetaData) {
            final data = (item.target as RenderMetaData).metaData;
            if (data != null && !_sessionHits.contains(data)) {
              _sessionHits.add(data);
              widget.onWidgetHit(data);
            }
          }
        }
      }
    }
  }
}
// Painter class remains the same...
// Painter remains the same...
class _SmoothTrailPainter extends CustomPainter {
  final List<Offset> points;
  _SmoothTrailPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

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
  bool shouldRepaint(covariant _SmoothTrailPainter oldDelegate) =>
      oldDelegate.points != points;
}