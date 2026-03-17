import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/ciranda_avatar.dart';
import '../../../../core/widgets/ciranda_button.dart';
import '../../../../core/widgets/ciranda_loading.dart';
import '../../../../providers/firebase_providers.dart';
import '../providers/perfil_provider.dart';

class PerfilEditScreen extends ConsumerStatefulWidget {
  const PerfilEditScreen({super.key});

  @override
  ConsumerState<PerfilEditScreen> createState() => _PerfilEditScreenState();
}

class _PerfilEditScreenState extends ConsumerState<PerfilEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final perfil = ref.read(perfilProvider).valueOrNull;
    if (perfil != null) {
      _nameController.text = perfil.displayName;
      _cidadeController.text = perfil.cidade;
      _estadoController.text = perfil.estado;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    final perfil = ref.read(perfilProvider).valueOrNull;
    if (perfil == null) return;

    final updated = perfil.copyWith(
      displayName: _nameController.text.trim(),
      cidade: _cidadeController.text.trim(),
      estado: _estadoController.text.trim(),
    );

    await ref.read(perfilControllerProvider.notifier).updatePerfil(updated);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil atualizado com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final perfilAsync = ref.watch(perfilProvider);
    final controllerState = ref.watch(perfilControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
      ),
      body: perfilAsync.when(
        data: (usuario) {
          if (usuario == null) {
            return const Center(child: Text('Não autenticado'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  Stack(
                    children: [
                      CirandaAvatar(
                        imageUrl: usuario.fotoUrl,
                        displayName: usuario.displayName,
                        radius: 52,
                        borderColor: AppColors.primary,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt_rounded,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toque para alterar foto',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Nome
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    style: AppTypography.bodyLarge,
                    decoration: const InputDecoration(
                      labelText: 'Nome completo',
                      prefixIcon: Icon(Icons.person_outline_rounded,
                          color: AppColors.primary),
                    ),
                    validator: Validators.name,
                  ),
                  const SizedBox(height: 16),

                  // Cidade
                  TextFormField(
                    controller: _cidadeController,
                    textCapitalization: TextCapitalization.words,
                    style: AppTypography.bodyLarge,
                    decoration: const InputDecoration(
                      labelText: 'Cidade',
                      prefixIcon: Icon(Icons.location_city_rounded,
                          color: AppColors.teal),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Estado
                  TextFormField(
                    controller: _estadoController,
                    textCapitalization: TextCapitalization.characters,
                    style: AppTypography.bodyLarge,
                    maxLength: 2,
                    decoration: const InputDecoration(
                      labelText: 'Estado (UF)',
                      hintText: 'CE',
                      prefixIcon: Icon(Icons.map_outlined,
                          color: AppColors.accent),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Botão salvar
                  CirandaButton.primary(
                    label: 'Salvar alterações',
                    icon: Icons.save_rounded,
                    isLoading: controllerState.isLoading,
                    width: double.infinity,
                    onPressed:
                        controllerState.isLoading ? null : _onSave,
                  ),

                  if (controllerState.hasError) ...[
                    const SizedBox(height: 12),
                    Text(
                      controllerState.error.toString(),
                      style: AppTypography.bodySmall.copyWith(
                          color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
        loading: () => const CirandaLoading.fullScreen(),
        error: (e, _) => Center(child: Text('Erro: $e')),
      ),
    );
  }
}
