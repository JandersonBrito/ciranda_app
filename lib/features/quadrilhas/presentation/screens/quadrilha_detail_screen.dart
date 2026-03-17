import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bandeirinhas_header.dart';
import '../../../../core/widgets/ciranda_avatar.dart';
import '../../../../core/widgets/ciranda_error_widget.dart';
import '../../../../core/widgets/ciranda_loading.dart';
import '../../../../models/quadrilha_model.dart';
import '../providers/quadrilhas_provider.dart';

class QuadrilhaDetailScreen extends ConsumerWidget {
  const QuadrilhaDetailScreen({super.key, required this.quadrilhaId});

  final String quadrilhaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quadrilhaAsync = ref.watch(quadrilhaDetailProvider(quadrilhaId));

    return quadrilhaAsync.when(
      data: (quadrilha) => _QuadrilhaDetailView(quadrilha: quadrilha),
      loading: () => const Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: CirandaLoading.fullScreen(),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.backgroundDark,
        appBar: AppBar(title: const Text('Quadrilha')),
        body: CirandaErrorWidget(message: e.toString()),
      ),
    );
  }
}

class _QuadrilhaDetailView extends ConsumerWidget {
  const _QuadrilhaDetailView({required this.quadrilha});

  final QuadrilhaModel quadrilha;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final integrantesAsync =
        ref.watch(integrantesProvider(quadrilha.id));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              expandedHeight: 240,
              pinned: true,
              backgroundColor: AppColors.backgroundDark,
              actions: [
                IconButton(
                  icon: const Icon(Icons.share_rounded),
                  onPressed: () => Share.share(
                    '${quadrilha.nome} — ${quadrilha.cidadeEstado}\n'
                    'Fundada em ${quadrilha.anoFundacao}',
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Foto de capa
                    if (quadrilha.fotoUrl != null)
                      Image.network(quadrilha.fotoUrl!, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _buildGradientBg())
                    else
                      _buildGradientBg(),

                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Color(0xEE000000)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.3, 1.0],
                        ),
                      ),
                    ),

                    // Header info
                    Positioned(
                      bottom: 56,
                      left: 20,
                      right: 20,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Logo da quadrilha
                          CirandaAvatar(
                            imageUrl: quadrilha.logoUrl ?? quadrilha.fotoUrl,
                            displayName: quadrilha.nome,
                            radius: 32,
                            borderColor: AppColors.primary,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(quadrilha.nome,
                                    style: AppTypography.titleLarge),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_rounded,
                                        color: AppColors.primary, size: 14),
                                    const SizedBox(width: 2),
                                    Text(quadrilha.cidadeEstado,
                                        style: AppTypography.bodySmall
                                            .copyWith(
                                                color: AppColors
                                                    .textSecondary)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (quadrilha.posicao > 0)
                            PositionBadge(
                                position: quadrilha.posicao, size: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: BandeirinhasHeader(height: 32, flagCount: 12),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                const TabBar(
                  tabs: [
                    Tab(text: 'Sobre'),
                    Tab(text: 'Integrantes'),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              // Aba Sobre
              ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  if (quadrilha.pontuacaoTotal > 0) ...[
                    _ScoreCard(quadrilha: quadrilha),
                    const SizedBox(height: 20),
                  ],
                  Text('História', style: AppTypography.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    quadrilha.descricao.isEmpty
                        ? 'Sem descrição disponível.'
                        : quadrilha.descricao,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Fundação',
                    value: '${quadrilha.anoFundacao}',
                    color: AppColors.secondary,
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.location_city_rounded,
                    label: 'Município',
                    value: quadrilha.cidadeEstado,
                    color: AppColors.teal,
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.people_rounded,
                    label: 'Seguidores',
                    value: '${quadrilha.seguidores}',
                    color: AppColors.primary,
                  ),
                ],
              ),

              // Aba Integrantes
              integrantesAsync.when(
                data: (integrantes) {
                  if (integrantes.isEmpty) {
                    return const Center(
                        child: Text('Nenhum integrante cadastrado'));
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: integrantes.length,
                    itemBuilder: (context, index) {
                      final integrante = integrantes[index];
                      return Column(
                        children: [
                          CirandaAvatar(
                            imageUrl: integrante.fotoUrl,
                            displayName: integrante.nome,
                            radius: 32,
                            borderColor: AppColors.primary,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            integrante.nome,
                            style: AppTypography.labelSmall,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            integrante.funcao,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      );
                    },
                  );
                },
                loading: () => const CirandaLoading.inline(),
                error: (e, _) =>
                    CirandaErrorWidget(message: e.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientBg() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A0030), Color(0xFF1A1A1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({required this.quadrilha});

  final QuadrilhaModel quadrilha;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A0020), AppColors.surfaceCard],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppColors.primary.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        children: [
          PositionBadge(position: quadrilha.posicao, size: 52),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(quadrilha.posicaoLabel,
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.secondary,
                  )),
              Text(
                  '${quadrilha.pontuacaoTotal.toStringAsFixed(2)} pontos',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Text('$label: ',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            )),
        Text(value, style: AppTypography.bodyMedium),
      ],
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  const _TabBarDelegate(this.tabBar);
  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: AppColors.backgroundDark, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate old) => false;
}
