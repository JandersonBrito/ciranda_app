import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bandeirinhas_header.dart';
import '../../../../providers/firebase_providers.dart';
import '../../../../router/route_names.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _bgController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<double> _bgOpacity;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _bgOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeIn),
    );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _bgController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 700));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 1500));
    _navigateNext();
  }

  void _navigateNext() {
    if (!mounted) return;
    final authState = ref.read(authStateChangesProvider);
    final isAuthenticated = authState.valueOrNull != null;
    if (isAuthenticated) {
      context.goNamed(RouteNames.home);
    } else {
      context.goNamed(RouteNames.login);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AnimatedBuilder(
        animation: Listenable.merge([_bgController, _logoController, _textController]),
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Fundo com padrão de chita
              FadeTransition(
                opacity: _bgOpacity,
                child: CustomPaint(
                  painter: ChitaPatternPainter(opacity: 0.04),
                ),
              ),

              // Gradiente radial no centro
              FadeTransition(
                opacity: _bgOpacity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.8,
                      colors: [
                        AppColors.primary.withOpacity(0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Conteúdo central
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo animado
                    ScaleTransition(
                      scale: _logoScale,
                      child: FadeTransition(
                        opacity: _logoOpacity,
                        child: _CirandaLogoLarge(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Nome do app
                    FadeTransition(
                      opacity: _textOpacity,
                      child: Column(
                        children: [
                          Text(
                            'Ciranda',
                            style: AppTypography.displaySmall.copyWith(
                              color: AppColors.primary,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            'MÍDIA',
                            style: AppTypography.titleLarge.copyWith(
                              color: AppColors.secondary,
                              letterSpacing: 8,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'O melhor do São João\nna palma da mão',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bandeirinhas no topo
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _textOpacity,
                  child: const SafeArea(
                    child: BandeirinhasHeader(height: 56, flagCount: 18),
                  ),
                ),
              ),

              // Bandeirinhas na base
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _textOpacity,
                  child: const SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Column(
                        children: [
                          BandeirinhasHeader(height: 40, flagCount: 14),
                          SizedBox(height: 12),
                          Text(
                            'versão 1.0.0',
                            style: TextStyle(
                              color: AppColors.textHint,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CirandaLogoLarge extends StatefulWidget {
  @override
  State<_CirandaLogoLarge> createState() => _CirandaLogoLargeState();
}

class _CirandaLogoLargeState extends State<_CirandaLogoLarge>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotateController;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotateController,
      builder: (_, child) {
        return Transform.rotate(
          angle: _rotateController.value * 2 * 3.14159265,
          child: child,
        );
      },
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.5),
              blurRadius: 40,
              spreadRadius: 10,
            ),
            BoxShadow(
              color: AppColors.secondary.withOpacity(0.3),
              blurRadius: 60,
              spreadRadius: 5,
            ),
          ],
        ),
        child: CustomPaint(
          painter: _LogoMandala(),
        ),
      ),
    );
  }
}

class _LogoMandala extends CustomPainter {
  static const List<Color> _colors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.accent,
    AppColors.teal,
    Color(0xFF9C27B0),
    Color(0xFF4CAF50),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.38;
    const numPoints = 6;

    for (int i = 0; i < numPoints; i++) {
      final paint = Paint()
        ..color = _colors[i % _colors.length]
        ..style = PaintingStyle.fill;

      final angle = -3.14159265 / 2 + i * 2 * 3.14159265 / numPoints;
      final nextAngle = angle + 2 * 3.14159265 / numPoints;
      final midAngle = angle + 3.14159265 / numPoints;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(
          center.dx + outerRadius * _cos(angle),
          center.dy + outerRadius * _sin(angle),
        )
        ..lineTo(
          center.dx + innerRadius * _cos(midAngle),
          center.dy + innerRadius * _sin(midAngle),
        )
        ..lineTo(
          center.dx + outerRadius * _cos(nextAngle),
          center.dy + outerRadius * _sin(nextAngle),
        )
        ..close();

      canvas.drawPath(path, paint);

      // Bordas brancas entre fatias
      canvas.drawPath(
          path,
          Paint()
            ..color = Colors.white.withOpacity(0.15)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5);
    }

    // Círculo branco no centro
    canvas.drawCircle(
      center,
      innerRadius * 0.55,
      Paint()..color = Colors.white,
    );

    // Círculo de borda externa
    canvas.drawCircle(
      center,
      outerRadius - 1,
      Paint()
        ..color = Colors.white.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  static double _cos(double x) {
    double r = 1, t = 1;
    for (int i = 1; i <= 6; i++) {
      t *= -x * x / ((2 * i - 1) * (2 * i));
      r += t;
    }
    return r;
  }

  static double _sin(double x) => _cos(x - 3.14159265 / 2);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
