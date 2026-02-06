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

class _DrawingLayerWidgetState extends State<DrawingLayerWidget> with SingleTickerProviderStateMixin {
  final List<_TrailPoint> _points = [];
  final Set<dynamic> _sessionHits = {};
  late final AnimationController _controller;
  static const _trailDuration = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _trailDuration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        _sessionHits.clear();
        _points.add(_TrailPoint(details.localPosition));
        if (!_controller.isAnimating) {
          _controller.repeat();
        }
      },
      onPanUpdate: (details) {
        _points.add(_TrailPoint(details.localPosition));
        _performHitTest(details);
      },
      onPanEnd: (details) {
        _sessionHits.clear();
      },
      child: AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (context, child) {
          // Cleanup old points
          _points.removeWhere((p) => DateTime.now().difference(p.timestamp) > _trailDuration);

          // Stop animation if no points are left
          if (_points.isEmpty && _controller.isAnimating) {
            _controller.stop();
          }

          return CustomPaint(
            foregroundPainter: _SmoothTrailPainter(
              points: _points,
              maxAge: _trailDuration,
            ),
            child: child,
          );
        },
      ),
    );
  }

  void _performHitTest(DragUpdateDetails details) {
    final RenderBox? targetRenderBox = context.findRenderObject() as RenderBox?;
    if (targetRenderBox != null) {
      final localOffset = targetRenderBox.globalToLocal(details.globalPosition);
      final BoxHitTestResult result = BoxHitTestResult();
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

class _TrailPoint {
  final Offset offset;
  final DateTime timestamp;

  _TrailPoint(this.offset) : timestamp = DateTime.now();
}

class _SmoothTrailPainter extends CustomPainter {
  final List<_TrailPoint> points;
  final Duration maxAge;

  _SmoothTrailPainter({required this.points, required this.maxAge});

  @override
  void paint(Canvas canvas, Size size) {
    final now = DateTime.now();

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];

      final age = now.difference(p1.timestamp);
      final opacity = 1.0 - (age.inMilliseconds / maxAge.inMilliseconds).clamp(0.0, 1.0);

      if (opacity <= 0) continue;

      final paint = Paint()
        ..color = Colors.blue.withValues(alpha: opacity)
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 12.0
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round;

      canvas.drawLine(p1.offset, p2.offset, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SmoothTrailPainter oldDelegate) {
    // We want to repaint on every frame of the animation.
    return true;
  }
}
