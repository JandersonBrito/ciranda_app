import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/bandeirinhas_header.dart';
import '../../../../core/widgets/ciranda_button.dart';
import '../../../../router/route_names.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authControllerProvider.notifier).signInWithEmail(
          _emailController.text,
          _passwordController.text,
        );
  }

  Future<void> _onGoogleSignIn() async {
    await ref.read(authControllerProvider.notifier).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (prev, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authErrorMessage(next.error!)),
            backgroundColor: AppColors.error,
          ),
        );
      } else if (next.hasValue && prev?.isLoading == true) {
        context.goNamed(RouteNames.home);
      }
    });

    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header com bandeirinhas
              const BandeirinhasHeader(height: 56, flagCount: 16),

              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),

                      // Logo e título
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.4),
                                    blurRadius: 24,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: CustomPaint(painter: _MiniLogoMandala()),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Bem-vindo ao',
                              style: AppTypography.bodyLarge.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              'Ciranda App',
                              style: AppTypography.displaySmall.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Faça login para continuar',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),

                      // Campo E-mail
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        enabled: !isLoading,
                        style: AppTypography.bodyLarge,
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          hintText: 'seu@email.com',
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: AppColors.primary),
                        ),
                        validator: Validators.email,
                      ),
                      const SizedBox(height: 16),

                      // Campo Senha
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        enabled: !isLoading,
                        style: AppTypography.bodyLarge,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline_rounded,
                              color: AppColors.primary),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: Validators.password,
                        onFieldSubmitted: (_) => _onSubmit(),
                      ),

                      // Esqueci a senha
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: isLoading
                              ? null
                              : () => _showForgotPasswordDialog(),
                          child: const Text('Esqueci a senha'),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Botão entrar
                      CirandaButton.primary(
                        label: 'Entrar',
                        onPressed: isLoading ? null : _onSubmit,
                        isLoading: isLoading,
                        width: double.infinity,
                      ),

                      const SizedBox(height: 16),

                      // Divisor
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(color: AppColors.divider),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'ou',
                              style: AppTypography.bodySmall,
                            ),
                          ),
                          const Expanded(
                            child: Divider(color: AppColors.divider),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Botão Google
                      CirandaOutlinedButton(
                        label: 'Continuar com Google',
                        onPressed: isLoading ? null : _onGoogleSignIn,
                        isLoading: isLoading,
                        icon: Icons.g_mobiledata_rounded,
                        color: AppColors.teal,
                        width: double.infinity,
                      ),

                      const SizedBox(height: 32),

                      // Link cadastro
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Não tem conta? ',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: isLoading
                                ? null
                                : () =>
                                    context.goNamed(RouteNames.register),
                            child: Text(
                              'Cadastre-se',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Entrar como visitante
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () => context.goNamed(RouteNames.home),
                        child: Text(
                          'Entrar como visitante',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Recuperar senha'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'E-mail',
            hintText: 'seu@email.com',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              if (controller.text.isNotEmpty) {
                await ref
                    .read(authControllerProvider.notifier)
                    .sendPasswordReset(controller.text);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('E-mail de recuperação enviado!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              }
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}

class _MiniLogoMandala extends CustomPainter {
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
      final angle = -3.14159265 / 2 + i * 2 * 3.14159265 / numPoints;
      final nextAngle = angle + 2 * 3.14159265 / numPoints;
      final midAngle = angle + 3.14159265 / numPoints;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(center.dx + outerRadius * _cos(angle),
            center.dy + outerRadius * _sin(angle))
        ..lineTo(center.dx + innerRadius * _cos(midAngle),
            center.dy + innerRadius * _sin(midAngle))
        ..lineTo(center.dx + outerRadius * _cos(nextAngle),
            center.dy + outerRadius * _sin(nextAngle))
        ..close();

      canvas.drawPath(
          path, Paint()..color = _colors[i % _colors.length]);
    }
    canvas.drawCircle(
        center, innerRadius * 0.55, Paint()..color = Colors.white);
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
