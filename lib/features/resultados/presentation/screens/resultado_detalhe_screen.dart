import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/ciranda_app_bar.dart';
import '../../../../core/widgets/ciranda_error_widget.dart';
import '../../../../core/widgets/ciranda_loading.dart';
import '../providers/resultados_provider.dart';
import '../widgets/podium_widget.dart';
import '../widgets/ranking_item.dart';

class ResultadoDetalheScreen extends ConsumerWidget {
  const ResultadoDetalheScreen({super.key, required this.festivalId});

  final String festivalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultadosAsync =
        ref.watch(resultadosFestivalProvider(festivalId));

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: const CirandaAppBar(
        title: 'Resultado do Festival',
        showBandeirinhas: false,
      ),
      body: resultadosAsync.when(
        data: (resultados) {
          if (resultados.isEmpty) {
            return const Center(
              child: Text('Resultado não disponível'),
            );
          }

          final top3 = resultados.take(3).toList();
          final resto = resultados.skip(3).toList();

          return ListView(
            children: [
              PodiumWidget(top3: top3),
              if (resto.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text('Classificação completa',
                      style: AppTypography.titleLarge),
                ),
              ...resto.map((r) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    child: RankingItem(resultado: r),
                  )),
              const SizedBox(height: 24),
            ],
          );
        },
        loading: () => const CirandaLoading.fullScreen(),
        error: (e, _) => CirandaErrorWidget(message: e.toString()),
      ),
    );
  }
}
