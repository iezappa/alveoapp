import 'dart:math' as math;

import 'package:flutter/material.dart';

/// One slice of the wheel: a Plutchik primary emotion and its (muted) colour.
class PlutchikWedge {
  const PlutchikWedge({required this.key, required this.color});

  final String key;
  final Color color;
}

/// The eight primaries in canonical wheel order, clockwise from the top.
/// Opposite emotions sit four slices apart (joy/sadness, trust/disgust, ...).
/// Colours are desaturated to sit calmly next to the app's sage palette.
const List<PlutchikWedge> plutchikWheel = [
  PlutchikWedge(key: 'joy', color: Color(0xFFE7C55C)),
  PlutchikWedge(key: 'trust', color: Color(0xFF9DBE7A)),
  PlutchikWedge(key: 'fear', color: Color(0xFF5C8C6E)),
  PlutchikWedge(key: 'surprise', color: Color(0xFF6FBAB4)),
  PlutchikWedge(key: 'sadness', color: Color(0xFF6E8FC0)),
  PlutchikWedge(key: 'disgust', color: Color(0xFF9784B6)),
  PlutchikWedge(key: 'anger', color: Color(0xFFC97B6E)),
  PlutchikWedge(key: 'anticipation', color: Color(0xFFDDA269)),
];

const int _wedgeCount = 8; // == plutchikWheel.length
const double _sweep = 2 * math.pi / _wedgeCount;
const double _startAngle =
    -math.pi / 2 - _sweep / 2; // wedge 0 centred on north
const double _gap = 0.03; // angular gap between wedges (radians)
const double _innerRatio = 0.34; // donut hole

/// Interactive Plutchik wheel — a donut of eight tappable emotion slices.
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
    final dist = v.distance;
    if (dist > radius || dist < radius * _innerRatio) return null;

    var a = math.atan2(v.dy, v.dx) - _startAngle;
    a %= 2 * math.pi;
    if (a < 0) a += 2 * math.pi;
    return (a / _sweep).floor() % _wedgeCount;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
                gapColor: scheme.surfaceContainerLow,
                idleText: scheme.onSurfaceVariant,
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
    required this.gapColor,
    required this.idleText,
  });

  final Set<String> selected;
  final String Function(String key) labelFor;
  final TextDirection textDirection;
  final Color gapColor;
  final Color idleText;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final innerRadius = radius * _innerRatio;
    final bandRadius = (radius + innerRadius) / 2;

    for (var i = 0; i < _wedgeCount; i++) {
      final wedge = plutchikWheel[i];
      final isSelected = selected.contains(wedge.key);
      final start = _startAngle + i * _sweep + _gap / 2;
      final sweep = _sweep - _gap;

      final outer = Rect.fromCircle(center: center, radius: radius);
      final inner = Rect.fromCircle(center: center, radius: innerRadius);
      final path = Path()
        ..arcTo(outer, start, sweep, true)
        ..arcTo(inner, start + sweep, -sweep, false)
        ..close();

      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.fill
          ..color = isSelected
              ? wedge.color
              : wedge.color.withValues(alpha: 0.16),
      );
      if (isSelected) {
        canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = wedge.color,
        );
      }

      final mid = start + sweep / 2;
      final labelPos =
          center + Offset(math.cos(mid), math.sin(mid)) * bandRadius;
      final tp = TextPainter(
        text: TextSpan(
          text: labelFor(wedge.key),
          style: TextStyle(
            fontSize: radius * 0.1,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? _readableOn(wedge.color)
                : idleText.withValues(alpha: 0.75),
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: textDirection,
      )..layout(maxWidth: (radius - innerRadius) * 1.4);
      tp.paint(canvas, labelPos - Offset(tp.width / 2, tp.height / 2));
    }
  }

  Color _readableOn(Color background) =>
      background.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;

  @override
  bool shouldRepaint(_WheelPainter old) =>
      old.selected.length != selected.length ||
      !old.selected.containsAll(selected) ||
      old.gapColor != gapColor ||
      old.idleText != idleText;
}
