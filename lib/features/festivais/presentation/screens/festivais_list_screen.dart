import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/ciranda_app_bar.dart';
import '../../../../core/widgets/ciranda_error_widget.dart';
import '../../../../core/widgets/ciranda_loading.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../models/festival_model.dart';
import '../../../../router/route_names.dart';
import '../providers/festivais_provider.dart';
import '../widgets/festival_card.dart';

class FestivaisListScreen extends ConsumerWidget {
  const FestivaisListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(festivaisSearchControllerProvider);
    final festivaisAsync = searchQuery.isEmpty
        ? ref.watch(festivaisListProvider)
        : ref.watch(festivaisBuscaProvider(searchQuery));

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: CirandaAppBar(
        title: 'Festivais',
        showBandeirinhas: true,
      ),
      body: Column(
        children: [
          // Barra de busca
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar festival, cidade...',
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.primary),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded,
                            color: AppColors.textSecondary),
                        onPressed: () => ref
                            .read(festivaisSearchControllerProvider.notifier)
                            .clear(),
                      )
                    : null,
              ),
              onChanged: (value) => ref
                  .read(festivaisSearchControllerProvider.notifier)
                  .setQuery(value),
            ),
          ),

          // Lista de festivais
          Expanded(
            child: festivaisAsync.when(
              data: (festivais) {
                if (festivais.isEmpty) {
                  return EmptyStateWidget(
                    title: searchQuery.isEmpty
                        ? 'Nenhum festival cadastrado'
                        : 'Nenhum festival encontrado',
                    subtitle: searchQuery.isEmpty
                        ? 'Os festivais aparecerão aqui quando forem cadastrados'
                        : 'Tente buscar por outro nome ou cidade',
                    icon: Icons.celebration_outlined,
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: festivais.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final festival = festivais[index];
                    return FestivalCard(
                      festival: festival,
                      onTap: () => context.goNamed(
                        RouteNames.festivalDetail,
                        pathParameters: {'festivalId': festival.id},
                      ),
                    );
                  },
                );
              },
              loading: () => const CirandaLoading.inline(),
              error: (e, _) => CirandaErrorWidget(
                message: e.toString(),
                onRetry: () => ref.invalidate(festivaisListProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
