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

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authControllerProvider.notifier).registerWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
          displayName: _nameController.text,
        );
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
              const BandeirinhasHeader(height: 48, flagCount: 16),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            onPressed: () => context.pop(),
                          ),
                          Expanded(
                            child: Text(
                              'Criar conta',
                              style: AppTypography.headlineMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Faça parte da maior comunidade junina digital!',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),

                      // Nome
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        enabled: !isLoading,
                        style: AppTypography.bodyLarge,
                        decoration: const InputDecoration(
                          labelText: 'Nome completo',
                          hintText: 'Como você se chama?',
                          prefixIcon: Icon(Icons.person_outline_rounded,
                              color: AppColors.primary),
                        ),
                        validator: Validators.name,
                      ),
                      const SizedBox(height: 14),

                      // E-mail
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        enabled: !isLoading,
                        style: AppTypography.bodyLarge,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          hintText: 'seu@email.com',
                          prefixIcon: Icon(Icons.email_outlined,
                              color: AppColors.primary),
                        ),
                        validator: Validators.email,
                      ),
                      const SizedBox(height: 14),

                      // Senha
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        enabled: !isLoading,
                        style: AppTypography.bodyLarge,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          hintText: 'Mínimo 6 caracteres',
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
                      ),
                      const SizedBox(height: 14),

                      // Confirmar senha
                      TextFormField(
                        controller: _confirmController,
                        obscureText: _obscureConfirm,
                        textInputAction: TextInputAction.done,
                        enabled: !isLoading,
                        style: AppTypography.bodyLarge,
                        decoration: InputDecoration(
                          labelText: 'Confirmar senha',
                          hintText: 'Repita a senha',
                          prefixIcon: const Icon(Icons.lock_reset_rounded,
                              color: AppColors.primary),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () => setState(
                                () => _obscureConfirm = !_obscureConfirm),
                          ),
                        ),
                        validator: (val) => Validators.confirmPassword(
                            val, _passwordController.text),
                        onFieldSubmitted: (_) => _onSubmit(),
                      ),

                      const SizedBox(height: 28),

                      CirandaButton.primary(
                        label: 'Criar minha conta',
                        onPressed: isLoading ? null : _onSubmit,
                        isLoading: isLoading,
                        icon: Icons.celebration_rounded,
                        width: double.infinity,
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Já tem conta? ',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: isLoading
                                ? null
                                : () => context.goNamed(RouteNames.login),
                            child: Text(
                              'Entrar',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
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
}
