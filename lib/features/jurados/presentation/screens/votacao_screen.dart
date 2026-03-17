import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bandeirinhas_header.dart';
import '../../../../core/widgets/ciranda_button.dart';
import '../../../../core/widgets/ciranda_error_widget.dart';
import '../../../../core/widgets/ciranda_loading.dart';
import '../../../festivais/data/festivais_repository.dart';
import '../../../festivais/presentation/providers/festivais_provider.dart';
import '../../../quadrilhas/presentation/providers/quadrilhas_provider.dart';
import '../providers/jurados_provider.dart';
import '../widgets/nota_slider.dart';

class VotacaoScreen extends ConsumerStatefulWidget {
  const VotacaoScreen({
    super.key,
    required this.festivalId,
    required this.quadrilhaId,
  });

  final String festivalId;
  final String quadrilhaId;

  @override
  ConsumerState<VotacaoScreen> createState() => _VotacaoScreenState();
}

class _VotacaoScreenState extends ConsumerState<VotacaoScreen> {
  @override
  Widget build(BuildContext context) {
    final juradoAsync = ref.watch(currentJuradoProvider);
    final quadrilhaAsync =
        ref.watch(quadrilhaDetailProvider(widget.quadrilhaId));
    final categoriasAsync =
        ref.watch(festivalCategoriasProvider(widget.festivalId));

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Votação'),
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(36),
          child: const BandeirinhasHeader(height: 36, flagCount: 12),
        ),
      ),
      body: juradoAsync.when(
        data: (jurado) {
          if (jurado == null) {
            return const CirandaErrorWidget(
              message: 'Você não é um jurado ativo neste festival.',
            );
          }

          return quadrilhaAsync.when(
            data: (quadrilha) => categoriasAsync.when(
              data: (categorias) {
                if (categorias.isEmpty) {
                  return const CirandaErrorWidget(
                    message: 'Nenhuma categoria cadastrada para este festival.',
                  );
                }

                final controller = ref.watch(
                    votacaoControllerProvider(jurado.id));
                final notifier = ref.read(
                    votacaoControllerProvider(jurado.id).notifier);

                // Pré-carrega votos existentes
                ref.listen(
                  votosJuradoProvider((
                    festivalId: widget.festivalId,
                    quadrilhaId: widget.quadrilhaId,
                    juradoId: jurado.id,
                  )),
                  (_, next) {
                    next.whenData((votos) => notifier.loadExistingVotos(votos));
                  },
                );

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cabeçalho
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary.withOpacity(0.15),
                                border: Border.all(color: AppColors.primary),
                              ),
                              child: const Icon(Icons.groups_rounded,
                                  color: AppColors.primary, size: 28),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(quadrilha.nome,
                                      style: AppTypography.titleMedium),
                                  Text(quadrilha.cidadeEstado,
                                      style: AppTypography.bodySmall),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Jurado: ${jurado.nome}',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (controller.submitted)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Votado',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.success,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      Text('Notas por categoria',
                          style: AppTypography.titleLarge),
                      const SizedBox(height: 16),

                      // Sliders de nota
                      ...categorias.map((categoria) => Column(
                            children: [
                              NotaSlider(
                                categoria: categoria,
                                nota: controller.notas[categoria.id] ?? 0.0,
                                isReadOnly: controller.submitted,
                                onChanged: (nota) =>
                                    notifier.setNota(categoria.id, nota),
                              ),
                              const SizedBox(height: 16),
                            ],
                          )),

                      // Erro
                      if (controller.error != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            controller.error!,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Botão de envio
                      if (!controller.submitted)
                        CirandaButton.primary(
                          label: controller.isSubmitting
                              ? 'Enviando...'
                              : 'Confirmar Votação',
                          icon: Icons.check_circle_rounded,
                          isLoading: controller.isSubmitting,
                          width: double.infinity,
                          onPressed: controller.isSubmitting
                              ? null
                              : () => notifier.submitVotos(
                                    festivalId: widget.festivalId,
                                    quadrilhaId: widget.quadrilhaId,
                                    juradoNome: jurado.nome,
                                    categoriaIds: categorias
                                        .map((c) => c.id)
                                        .toList(),
                                    categoriaNomes:
                                        categorias.map((c) => c.nome).toList(),
                                  ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.success.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle_rounded,
                                  color: AppColors.success),
                              const SizedBox(width: 8),
                              Text(
                                'Votação confirmada!',
                                style: AppTypography.titleSmall.copyWith(
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
              loading: () => const CirandaLoading.fullScreen(),
              error: (e, _) =>
                  CirandaErrorWidget(message: e.toString()),
            ),
            loading: () => const CirandaLoading.fullScreen(),
            error: (e, _) => CirandaErrorWidget(message: e.toString()),
          );
        },
        loading: () => const CirandaLoading.fullScreen(),
        error: (e, _) => CirandaErrorWidget(message: e.toString()),
      ),
    );
  }
}
