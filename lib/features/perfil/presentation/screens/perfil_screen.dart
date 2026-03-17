import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bandeirinhas_header.dart';
import '../../../../core/widgets/ciranda_avatar.dart';
import '../../../../core/widgets/ciranda_button.dart';
import '../../../../core/widgets/ciranda_loading.dart';
import '../../../../models/usuario_model.dart';
import '../../../../router/route_names.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/perfil_provider.dart';

class PerfilScreen extends ConsumerWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfilAsync = ref.watch(perfilProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: perfilAsync.when(
        data: (usuario) => usuario == null
            ? const Center(child: Text('Não autenticado'))
            : _PerfilView(usuario: usuario),
        loading: () => const CirandaLoading.fullScreen(),
        error: (e, _) =>
            Center(child: Text('Erro: $e')),
      ),
    );
  }
}

class _PerfilView extends ConsumerWidget {
  const _PerfilView({required this.usuario});

  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A0020), AppColors.backgroundDark],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const BandeirinhasHeader(height: 44, flagCount: 14),
                  const SizedBox(height: 20),

                  // Avatar
                  CirandaAvatar(
                    imageUrl: usuario.fotoUrl,
                    displayName: usuario.displayName,
                    radius: 44,
                    borderColor: AppColors.primary,
                    onTap: () =>
                        context.goNamed(RouteNames.perfilEdit),
                  ),
                  const SizedBox(height: 12),

                  // Nome
                  Text(
                    usuario.displayName,
                    style: AppTypography.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    usuario.email,
                    style: AppTypography.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Role badge
                  _RoleBadge(role: usuario.role),

                  if (usuario.cidade.isNotEmpty || usuario.estado.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on_outlined,
                            color: AppColors.textSecondary, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          [usuario.cidade, usuario.estado]
                              .where((s) => s.isNotEmpty)
                              .join('/'),
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),

                  // Botão editar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: CirandaOutlinedButton(
                      label: 'Editar Perfil',
                      icon: Icons.edit_rounded,
                      color: AppColors.primary,
                      width: double.infinity,
                      onPressed: () =>
                          context.goNamed(RouteNames.perfilEdit),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),

        // Menu de configurações
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Configurações', style: AppTypography.titleLarge),
                const SizedBox(height: 12),

                _SettingsTile(
                  icon: Icons.notifications_outlined,
                  label: 'Notificações',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  label: 'Sobre o app',
                  onTap: () => _showAboutDialog(context),
                ),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  label: 'Política de Privacidade',
                  onTap: () {},
                ),

                const SizedBox(height: 24),
                const Divider(color: AppColors.divider),
                const SizedBox(height: 8),

                // Logout
                _SettingsTile(
                  icon: Icons.logout_rounded,
                  label: 'Sair',
                  color: AppColors.error,
                  onTap: () => _confirmLogout(context, ref),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair do app?'),
        content: const Text('Deseja mesmo encerrar a sessão?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: AppColors.error),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref
                  .read(authControllerProvider.notifier)
                  .signOut();
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Ciranda App',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2025 Ciranda Mídia',
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final (String label, Color color) = switch (role) {
      UserRole.admin => ('Administrador', AppColors.accent),
      UserRole.jurado => ('Jurado', AppColors.teal),
      UserRole.publico => ('Público', AppColors.textHint),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium.copyWith(color: color),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? AppColors.textPrimary;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: tileColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: tileColor, size: 20),
      ),
      title: Text(label, style: AppTypography.bodyLarge.copyWith(color: tileColor)),
      trailing: color == null
          ? const Icon(Icons.chevron_right_rounded,
              color: AppColors.textHint, size: 20)
          : null,
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }
}
