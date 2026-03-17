import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/ciranda_app_bar.dart';
import '../../../../core/widgets/ciranda_error_widget.dart';
import '../../../../core/widgets/ciranda_loading.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../providers/quadrilhas_provider.dart';
import '../widgets/quadrilha_card.dart';

class QuadrilhasListScreen extends ConsumerWidget {
  const QuadrilhasListScreen({super.key, this.festivalId});

  final String? festivalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(quadrilhasSearchControllerProvider);
    final quadrilhasAsync = ref.watch(allQuadrilhasProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: CirandaAppBar(
        title: 'Quadrilhas',
        showBandeirinhas: true,
      ),
      body: Column(
        children: [
          // Busca
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar quadrilha, cidade...',
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.primary),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () => ref
                            .read(quadrilhasSearchControllerProvider.notifier)
                            .clear(),
                      )
                    : null,
              ),
              onChanged: (v) => ref
                  .read(quadrilhasSearchControllerProvider.notifier)
                  .setQuery(v),
            ),
          ),

          Expanded(
            child: quadrilhasAsync.when(
              data: (quadrilhas) {
                final filtered = searchQuery.isEmpty
                    ? quadrilhas
                    : quadrilhas
                        .where((q) =>
                            q.nome
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()) ||
                            q.municipio
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()) ||
                            q.estado
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()))
                        .toList();

                if (filtered.isEmpty) {
                  return EmptyStateWidget(
                    title: 'Nenhuma quadrilha encontrada',
                    subtitle:
                        'Tente buscar por outro nome ou cidade',
                    icon: Icons.groups_outlined,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) => QuadrilhaCard(
                    quadrilha: filtered[index],
                  ),
                );
              },
              loading: () => const CirandaLoading.inline(),
              error: (e, _) =>
                  CirandaErrorWidget(message: e.toString()),
            ),
          ),
        ],
      ),
    );
  }
}
