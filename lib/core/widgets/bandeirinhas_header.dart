import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Widget decorativo de bandeirinhas de festa junina.
/// Pode ser usado como header, divisor ou decoração de fundo.
class BandeirinhasHeader extends StatelessWidget {
  const BandeirinhasHeader({
    super.key,
    this.height = 48,
    this.flagCount = 12,
    this.animate = true,
  });

  final double height;
  final int flagCount;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _BandeirinhasPainter(flagCount: flagCount),
      ),
    );
  }
}

class _BandeirinhasPainter extends CustomPainter {
  const _BandeirinhasPainter({required this.flagCount});

  final int flagCount;

  static const List<Color> _colors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.accent,
    AppColors.teal,
    Color(0xFF9C27B0), // purple
    Color(0xFF4CAF50), // green
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final cordPaint = Paint()
      ..color = AppColors.textSecondary.withOpacity(0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Corda principal
    final cordPath = Path();
    cordPath.moveTo(0, size.height * 0.35);

    final segmentWidth = size.width / (flagCount - 1);

    for (int i = 0; i < flagCount; i++) {
      final x = i * segmentWidth;
      final y = (i % 2 == 0) ? size.height * 0.2 : size.height * 0.5;
      if (i == 0) {
        cordPath.lineTo(x, y);
      } else {
        cordPath.lineTo(x, y);
      }
    }

    canvas.drawPath(cordPath, cordPaint);

    // Bandeirinhas (triângulos)
    for (int i = 0; i < flagCount; i++) {
      final x = i * segmentWidth;
      final y = (i % 2 == 0) ? size.height * 0.2 : size.height * 0.5;
      final color = _colors[i % _colors.length];
      _drawFlag(canvas, x, y, size, color, i % 2 == 1);
    }
  }

  void _drawFlag(
      Canvas canvas, double x, double y, Size size, Color color, bool flip) {
    final flagWidth = size.width / flagCount * 0.7;
    final flagHeight = size.height * 0.55;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Sombra suave
    final shadowPath = Path();
    if (!flip) {
      shadowPath.moveTo(x - flagWidth / 2 + 2, y + 2);
      shadowPath.lineTo(x + flagWidth / 2 + 2, y + 2);
      shadowPath.lineTo(x + 2, y + flagHeight + 2);
    } else {
      shadowPath.moveTo(x - flagWidth / 2 + 2, y - 2);
      shadowPath.lineTo(x + flagWidth / 2 + 2, y - 2);
      shadowPath.lineTo(x + 2, y - flagHeight - 2);
    }
    shadowPath.close();
    canvas.drawPath(shadowPath, shadowPaint);

    // Bandeirinha
    final flagPath = Path();
    if (!flip) {
      flagPath.moveTo(x - flagWidth / 2, y);
      flagPath.lineTo(x + flagWidth / 2, y);
      flagPath.lineTo(x, y + flagHeight);
    } else {
      flagPath.moveTo(x - flagWidth / 2, y);
      flagPath.lineTo(x + flagWidth / 2, y);
      flagPath.lineTo(x, y - flagHeight);
    }
    flagPath.close();
    canvas.drawPath(flagPath, paint);

    // Borda da bandeirinha
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawPath(flagPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _BandeirinhasPainter oldDelegate) =>
      oldDelegate.flagCount != flagCount;
}

/// Versão animada das bandeirinhas com leve balanço
class AnimatedBandeirinhasHeader extends StatefulWidget {
  const AnimatedBandeirinhasHeader({
    super.key,
    this.height = 56,
    this.flagCount = 14,
  });

  final double height;
  final int flagCount;

  @override
  State<AnimatedBandeirinhasHeader> createState() =>
      _AnimatedBandeirinhasHeaderState();
}

class _AnimatedBandeirinhasHeaderState
    extends State<AnimatedBandeirinhasHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _swingAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _swingAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _swingAnimation,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.rotationZ(_swingAnimation.value),
          alignment: Alignment.topCenter,
          child: BandeirinhasHeader(
            height: widget.height,
            flagCount: widget.flagCount,
            animate: false,
          ),
        );
      },
    );
  }
}

/// Divisor decorativo com bandeirinhas pequenas
class BandeirinhaDivider extends StatelessWidget {
  const BandeirinhaDivider({super.key, this.flagCount = 8});

  final int flagCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: BandeirinhasHeader(
        height: 32,
        flagCount: flagCount,
        animate: false,
      ),
    );
  }
}

/// Painter para fundo com padrão de chita (bolinhas coloridas)
class ChitaPatternPainter extends CustomPainter {
  const ChitaPatternPainter({this.opacity = 0.05});

  final double opacity;

  static const List<Color> _colors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.accent,
    AppColors.teal,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    const dotRadius = 3.0;
    const spacing = 28.0;

    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        final offsetX = (rng.nextDouble() - 0.5) * 8;
        final offsetY = (rng.nextDouble() - 0.5) * 8;
        final color = _colors[rng.nextInt(_colors.length)];

        canvas.drawCircle(
          Offset(x + offsetX, y + offsetY),
          dotRadius * (0.5 + rng.nextDouble() * 0.5),
          Paint()..color = color.withOpacity(opacity),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ChitaPatternPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}
