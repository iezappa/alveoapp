import 'package:flutter/material.dart';

/// A compact line of values (1..5 mood by default). `null` entries are gaps —
/// the line breaks and resumes around them.
class Sparkline extends StatelessWidget {
  const Sparkline({
    super.key,
    required this.values,
    this.min = 1,
    this.max = 5,
    this.height = 56,
  });

  final List<double?> values;
  final double min;
  final double max;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _SparklinePainter(values, min, max, scheme.primary),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter(this.values, this.min, this.max, this.color);

  final List<double?> values;
  final double min;
  final double max;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final dx = size.width / (values.length - 1);
    double y(double v) =>
        size.height -
        ((v - min) / (max - min)).clamp(0.0, 1.0) * size.height;

    final stroke = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final dot = Paint()..color = color;

    Path? segment;
    void flush() {
      if (segment != null) {
        canvas.drawPath(segment!, stroke);
        segment = null;
      }
    }

    for (var i = 0; i < values.length; i++) {
      final v = values[i];
      if (v == null) {
        flush();
        continue;
      }
      final point = Offset(i * dx, y(v));
      if (segment == null) {
        segment = Path()..moveTo(point.dx, point.dy);
      } else {
        segment!.lineTo(point.dx, point.dy);
      }
      canvas.drawCircle(point, 2.5, dot);
    }
    flush();
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter old) =>
      old.values != values || old.color != color;
}
