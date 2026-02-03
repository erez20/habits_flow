import 'dart:async';

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
  final ValueNotifier<List<_TrailPoint>> _points = ValueNotifier([]);
  final Set<dynamic> _sessionHits = {};
  Timer? _trailCleanupTimer;

  @override
  void initState() {
    super.initState();
    // Start a periodic timer to clean up old points
    _trailCleanupTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_points.value.isNotEmpty) {
        final now = DateTime.now();
        final newPoints = _points.value.where((p) {
          return now.difference(p.timestamp).inMilliseconds < 500; // Keep points younger than 500ms
        }).toList();

        if (newPoints.length != _points.value.length) {
          _points.value = newPoints;
        }
      }
    });
  }

  @override
  void dispose() {
    _trailCleanupTimer?.cancel();
    _points.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        _sessionHits.clear();
        final newPoint = _TrailPoint(details.localPosition);
        _points.value = [newPoint];
      },
      onPanUpdate: (details) {
        final newPoint = _TrailPoint(details.localPosition);
        _points.value = List.from(_points.value)..add(newPoint);
        _performHitTest(details);
      },
      onPanEnd: (details) {
        // Don't clear points, let the timer handle it
        _sessionHits.clear();
      },
      child: ValueListenableBuilder<List<_TrailPoint>>(
        valueListenable: _points,
        builder: (context, points, child) {
          return CustomPaint(
            foregroundPainter: _SmoothTrailPainter(points: points),
            child: widget.child,
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
  final Duration maxAge = const Duration(milliseconds: 500);

  _SmoothTrailPainter({required this.points});

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
        ..color = Colors.blue.withOpacity(opacity)
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 12.0
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round;

      final path = Path()
        ..moveTo(p1.offset.dx, p1.offset.dy)
        ..lineTo(p2.offset.dx, p2.offset.dy);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SmoothTrailPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
