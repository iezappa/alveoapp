import 'dart:math' as math;

import 'package:flutter/material.dart';

/// One slice of the wheel: a Plutchik primary emotion and its canonical colour.
class PlutchikWedge {
  const PlutchikWedge({required this.key, required this.color});

  final String key;
  final Color color;
}

/// The eight primaries in canonical wheel order, clockwise from the top.
/// Opposite emotions sit four slices apart (joy/sadness, trust/disgust, ...).
const List<PlutchikWedge> plutchikWheel = [
  PlutchikWedge(key: 'joy', color: Color(0xFFF6D743)),
  PlutchikWedge(key: 'trust', color: Color(0xFF9CCC65)),
  PlutchikWedge(key: 'fear', color: Color(0xFF2E7D4F)),
  PlutchikWedge(key: 'surprise', color: Color(0xFF4DD0C4)),
  PlutchikWedge(key: 'sadness', color: Color(0xFF4A79D4)),
  PlutchikWedge(key: 'disgust', color: Color(0xFF8E63B5)),
  PlutchikWedge(key: 'anger', color: Color(0xFFE05548)),
  PlutchikWedge(key: 'anticipation', color: Color(0xFFF0993B)),
];

const int _wedgeCount = 8; // == plutchikWheel.length
const double _sweep = 2 * math.pi / _wedgeCount;
const double _startAngle = -math.pi / 2 - _sweep / 2; // wedge 0 centred on north

/// Interactive Plutchik wheel. Tapping a wedge toggles it through [onToggle];
/// [selected] holds the currently chosen emotion keys.
class PlutchikWheel extends StatelessWidget {
  const PlutchikWheel({
    super.key,
    required this.selected,
    required this.onToggle,
    required this.labelFor,
  });

  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final String Function(String key) labelFor;

  int? _wedgeAt(Offset local, Size size) {
    final center = size.center(Offset.zero);
    final v = local - center;
    final radius = size.shortestSide / 2;
    if (v.distance > radius) return null;

    var a = math.atan2(v.dy, v.dx) - _startAngle;
    a %= 2 * math.pi;
    if (a < 0) a += 2 * math.pi;
    return (a / _sweep).floor() % plutchikWheel.length;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size.square(constraints.biggest.shortestSide);
          return GestureDetector(
            onTapUp: (details) {
              final index = _wedgeAt(details.localPosition, size);
              if (index != null) onToggle(plutchikWheel[index].key);
            },
            child: CustomPaint(
              size: size,
              painter: _WheelPainter(
                selected: selected,
                labelFor: labelFor,
                textDirection: Directionality.of(context),
                outlineColor: Theme.of(context).colorScheme.outline,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  _WheelPainter({
    required this.selected,
    required this.labelFor,
    required this.textDirection,
    required this.outlineColor,
  });

  final Set<String> selected;
  final String Function(String key) labelFor;
  final TextDirection textDirection;
  final Color outlineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    for (var i = 0; i < plutchikWheel.length; i++) {
      final wedge = plutchikWheel[i];
      final isSelected = selected.contains(wedge.key);
      final start = _startAngle + i * _sweep;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(rect, start, _sweep, false)
        ..close();

      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.fill
          ..color = isSelected
              ? wedge.color
              : wedge.color.withValues(alpha: 0.28),
      );
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = isSelected ? 3 : 1
          ..color = isSelected ? outlineColor : outlineColor.withValues(alpha: 0.4),
      );

      final mid = start + _sweep / 2;
      final labelPos = center +
          Offset(math.cos(mid), math.sin(mid)) * (radius * 0.62);
      final tp = TextPainter(
        text: TextSpan(
          text: labelFor(wedge.key),
          style: TextStyle(
            fontSize: radius * 0.11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: Colors.black.withValues(alpha: isSelected ? 0.9 : 0.65),
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: textDirection,
      )..layout(maxWidth: radius * 0.9);
      tp.paint(canvas, labelPos - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(_WheelPainter old) =>
      old.selected.length != selected.length ||
      !old.selected.containsAll(selected) ||
      old.outlineColor != outlineColor;
}
