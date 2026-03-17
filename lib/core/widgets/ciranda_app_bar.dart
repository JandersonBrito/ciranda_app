import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'bandeirinhas_header.dart';

/// AppBar personalizada da Ciranda com bandeirinhas decorativas e gradiente.
class CirandaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CirandaAppBar({
    super.key,
    this.title,
    this.showLogo = false,
    this.showBandeirinhas = true,
    this.actions,
    this.leading,
    this.onBackPressed,
    this.bottom,
  });

  final String? title;
  final bool showLogo;
  final bool showBandeirinhas;
  final List<Widget>? actions;
  final Widget? leading;
  final VoidCallback? onBackPressed;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (showBandeirinhas ? 40 : 0) + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A0020), AppColors.backgroundDark],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: leading ??
                (Navigator.canPop(context)
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: AppColors.textPrimary, size: 20),
                        onPressed: onBackPressed ?? () => Navigator.pop(context),
                      )
                    : null),
            title: showLogo
                ? _CirandaLogo()
                : (title != null
                    ? Text(title!, style: AppTypography.titleLarge)
                    : null),
            actions: actions,
            bottom: bottom,
          ),
          if (showBandeirinhas)
            const BandeirinhasHeader(height: 40, flagCount: 16),
        ],
      ),
    );
  }
}

class _CirandaLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Estrela/mandala colorida representando o logo
        _StarLogo(size: 32),
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ciranda',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primary,
                height: 1.0,
              ),
            ),
            Text(
              'MÍDIA',
              style: AppTypography.overline.copyWith(
                color: AppColors.secondary,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Logo estrela/mandala da Ciranda Mídia (versão vetorial simples).
class _StarLogo extends StatelessWidget {
  const _StarLogo({this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _StarLogoPainter()),
    );
  }
}

class _StarLogoPainter extends CustomPainter {
  static const List<Color> _colors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.accent,
    AppColors.teal,
    Color(0xFF9C27B0),
    AppColors.primary,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.42;
    const numPoints = 6;
    const angleStep = 3.14159265 / numPoints;

    for (int i = 0; i < numPoints; i++) {
      final paint = Paint()
        ..color = _colors[i % _colors.length]
        ..style = PaintingStyle.fill;

      final path = Path();
      double angle = -3.14159265 / 2 + i * 2 * 3.14159265 / numPoints;

      final x1 = center.dx + outerRadius * _cos(angle);
      final y1 = center.dy + outerRadius * _sin(angle);

      final midAngle = angle + 3.14159265 / numPoints;
      final x2 = center.dx + innerRadius * _cos(midAngle);
      final y2 = center.dy + innerRadius * _sin(midAngle);

      final nextAngle = angle + 2 * 3.14159265 / numPoints;
      final x3 = center.dx + outerRadius * _cos(nextAngle);
      final y3 = center.dy + outerRadius * _sin(nextAngle);

      path.moveTo(center.dx, center.dy);
      path.lineTo(x1, y1);
      path.lineTo(x2, y2);
      path.lineTo(x3, y3);
      path.close();

      canvas.drawPath(path, paint);
    }

    // Círculo central branco
    canvas.drawCircle(
      center,
      innerRadius * 0.5,
      Paint()..color = Colors.white,
    );
  }

  static double _cos(double x) {
    double result = 1;
    double term = 1;
    for (int i = 1; i <= 6; i++) {
      term *= -x * x / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  static double _sin(double x) {
    return _cos(x - 3.14159265 / 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
