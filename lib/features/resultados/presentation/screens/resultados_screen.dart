import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/ciranda_app_bar.dart';
import '../../../../core/widgets/ciranda_error_widget.dart';
import '../../../../core/widgets/ciranda_loading.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../festivais/presentation/providers/festivais_provider.dart';
import '../providers/resultados_provider.dart';
import '../widgets/podium_widget.dart';
import '../widgets/ranking_item.dart';

class ResultadosScreen extends ConsumerWidget {
  const ResultadosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final festivaisAsync = ref.watch(festivaisListProvider);
    final selectedFestivalId = ref.watch(resultadosFestivalControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: CirandaAppBar(
        title: 'Resultados',
        showBandeirinhas: true,
      ),
      body: Column(
        children: [
          // Seletor de festival
          festivaisAsync.when(
            data: (festivais) {
              if (festivais.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: DropdownButtonFormField<String>(
                  value: selectedFestivalId,
                  hint: const Text('Selecione um festival'),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.celebration_rounded,
                        color: AppColors.primary),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  items: festivais
                      .map((f) => DropdownMenuItem(
                            value: f.id,
                            child: Text(
                              '${f.nome} — ${f.cidadeEstado}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  onChanged: (id) => ref
                      .read(resultadosFestivalControllerProvider.notifier)
                      .selectFestival(id),
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Lista de resultados
          Expanded(
            child: selectedFestivalId == null
                ? EmptyStateWidget(
                    title: 'Selecione um festival',
                    subtitle:
                        'Escolha o festival acima para ver o resultado',
                    icon: Icons.emoji_events_outlined,
                  )
                : _ResultadosList(festivalId: selectedFestivalId),
          ),
        ],
      ),
    );
  }
}

class _ResultadosList extends ConsumerWidget {
  const _ResultadosList({required this.festivalId});

  final String festivalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultadosAsync =
        ref.watch(resultadosFestivalProvider(festivalId));

    return resultadosAsync.when(
      data: (resultados) {
        if (resultados.isEmpty) {
          return EmptyStateWidget(
            title: 'Sem resultados publicados',
            subtitle: 'Os resultados ainda não foram divulgados',
            icon: Icons.hourglass_empty_rounded,
          );
        }

        final top3 = resultados.take(3).toList();
        final resto = resultados.skip(3).toList();

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async =>
              ref.invalidate(resultadosFestivalProvider(festivalId)),
          child: CustomScrollView(
            slivers: [
              // Pódio
              SliverToBoxAdapter(
                child: PodiumWidget(top3: top3),
              ),

              // Lista restante
              if (resto.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Text('Classificação completa',
                        style: AppTypography.titleLarge),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList.separated(
                    itemCount: resto.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) =>
                        RankingItem(resultado: resto[index]),
                  ),
                ),
              ],

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      },
      loading: () => const CirandaLoading.inline(),
      error: (e, _) => CirandaErrorWidget(
        message: e.toString(),
        onRetry: () =>
            ref.invalidate(resultadosFestivalProvider(festivalId)),
      ),
    );
  }
}
