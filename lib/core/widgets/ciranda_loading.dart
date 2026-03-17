import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Widget de carregamento da Ciranda — tela cheia ou inline.
class CirandaLoading extends StatelessWidget {
  const CirandaLoading._({
    this.isFullScreen = false,
    this.message,
    this.size = 48,
  });

  /// Indicador inline centralizado.
  const CirandaLoading.inline({
    Key? key,
    double size = 36,
  }) : this._(isFullScreen: false, size: size);

  /// Tela cheia com fundo escuro e indicador centralizado.
  const CirandaLoading.fullScreen({
    Key? key,
    String? message,
  }) : this._(isFullScreen: true, message: message, size: 48);

  final bool isFullScreen;
  final String? message;
  final double size;

  @override
  Widget build(BuildContext context) {
    final indicator = _CirandaSpinner(size: size);

    if (!isFullScreen) {
      return Center(child: indicator);
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            indicator,
            if (message != null) ...[
              const SizedBox(height: 20),
              Text(
                message!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CirandaSpinner extends StatefulWidget {
  const _CirandaSpinner({this.size = 48});

  final double size;

  @override
  State<_CirandaSpinner> createState() => _CirandaSpinnerState();
}

class _CirandaSpinnerState extends State<_CirandaSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _SpinnerPainter(_controller.value),
        );
      },
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  const _SpinnerPainter(this.progress);

  final double progress;

  static const List<Color> _colors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.accent,
    AppColors.teal,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    for (int i = 0; i < _colors.length; i++) {
      final angle = (progress + i / _colors.length) * 2 * 3.14159;
      final x = center.dx + radius * 0.6 * _cosApprox(angle);
      final y = center.dy + radius * 0.6 * _sinApprox(angle);

      final paint = Paint()
        ..color = _colors[i].withOpacity(0.4 + 0.6 * (i == 0 ? 1 : (i / _colors.length)))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), 6 + i.toDouble(), paint);
    }
  }

  double _cosApprox(double angle) {
    // Simple cosine using series isn't available, use trigonometry from dart:math
    return _mathCos(angle);
  }

  double _sinApprox(double angle) {
    return _mathSin(angle);
  }

  // Use dart:math
  static double _mathCos(double x) {
    // Butterfly identity to keep range manageable
    final import = x % (2 * 3.14159265);
    return _taylorCos(import);
  }

  static double _mathSin(double x) {
    return _taylorCos(x - 3.14159265 / 2);
  }

  static double _taylorCos(double x) {
    // Rough approximation enough for animation
    double result = 1;
    double term = 1;
    for (int i = 1; i <= 6; i++) {
      term *= -x * x / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Shimmer de carregamento para listas
class CirandaShimmer extends StatelessWidget {
  const CirandaShimmer({
    super.key,
    required this.child,
    this.isLoading = true,
  });

  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    return _ShimmerWrapper(child: child);
  }
}

class _ShimmerWrapper extends StatefulWidget {
  const _ShimmerWrapper({required this.child});
  final Widget child;

  @override
  State<_ShimmerWrapper> createState() => _ShimmerWrapperState();
}

class _ShimmerWrapperState extends State<_ShimmerWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
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
      animation: _animation,
      builder: (_, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                AppColors.surfaceVariant,
                AppColors.surfaceDark,
                AppColors.surfaceVariant,
              ],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
