import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/bandeirinhas_header.dart';
import '../../../../core/widgets/ciranda_button.dart';
import '../../../../core/widgets/ciranda_error_widget.dart';
import '../../../../core/widgets/ciranda_loading.dart';
import '../../../../models/festival_model.dart';
import '../../../quadrilhas/presentation/providers/quadrilhas_provider.dart';
import '../../../quadrilhas/presentation/widgets/quadrilha_card.dart';
import '../../../resultados/presentation/providers/resultados_provider.dart';
import '../../../resultados/presentation/widgets/ranking_item.dart';
import '../providers/festivais_provider.dart';
import '../widgets/festival_map_section.dart';

class FestivalDetailScreen extends ConsumerWidget {
  const FestivalDetailScreen({super.key, required this.festivalId});

  final String festivalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final festivalAsync = ref.watch(festivalDetailProvider(festivalId));

    return festivalAsync.when(
      data: (festival) => _FestivalDetailView(festival: festival),
      loading: () => const Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: CirandaLoading.fullScreen(),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.backgroundDark,
        appBar: AppBar(title: const Text('Festival')),
        body: CirandaErrorWidget(message: e.toString()),
      ),
    );
  }
}

class _FestivalDetailView extends ConsumerWidget {
  const _FestivalDetailView({required this.festival});

  final FestivalModel festival;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            // ── SliverAppBar com banner ──────────────────────────────────
            SliverAppBar(
              expandedHeight: 260,
              pinned: true,
              backgroundColor: AppColors.backgroundDark,
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share_rounded),
                  onPressed: () => Share.share(
                    'Confira o ${festival.nome} em ${festival.cidadeEstado}!\n'
                    '${DateFormatter.dateRange(festival.dataInicio, festival.dataFim)}',
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'festival-banner-${festival.id}',
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Banner
                      if (festival.bannerUrl != null)
                        Image.network(
                          festival.bannerUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _buildGradientBg(),
                        )
                      else
                        _buildGradientBg(),

                      // Gradiente
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Color(0xEE000000),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.4, 1.0],
                          ),
                        ),
                      ),

                      // Nome do festival
                      Positioned(
                        bottom: 56,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              festival.nome,
                              style: AppTypography.headlineMedium,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded,
                                    color: AppColors.primary, size: 16),
                                const SizedBox(width: 4),
                                Text(festival.cidadeEstado,
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    )),
                                const Spacer(),
                                const Icon(Icons.calendar_today_rounded,
                                    color: AppColors.secondary, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormatter.dateRange(
                                      festival.dataInicio, festival.dataFim),
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bandeirinhas ─────────────────────────────────────────────
            const SliverToBoxAdapter(
              child: BandeirinhasHeader(height: 36, flagCount: 14),
            ),

            // ── TabBar ───────────────────────────────────────────────────
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                TabBar(
                  isScrollable: false,
                  tabs: const [
                    Tab(text: 'Info'),
                    Tab(text: 'Quadrilhas'),
                    Tab(text: 'Resultados'),
                    Tab(text: 'Mapa'),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              // ── Aba Info ─────────────────────────────────────────────
              _InfoTab(festival: festival),

              // ── Aba Quadrilhas ───────────────────────────────────────
              _QuadrilhasTab(festivalId: festival.id),

              // ── Aba Resultados ───────────────────────────────────────
              _ResultadosTab(festivalId: festival.id),

              // ── Aba Mapa ─────────────────────────────────────────────
              FestivalMapSection(festival: festival),
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
          colors: [Color(0xFF4A0030), Color(0xFF1A1A1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

// ── Aba Informações ─────────────────────────────────────────────────────────
class _InfoTab extends StatelessWidget {
  const _InfoTab({required this.festival});

  final FestivalModel festival;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Descrição
        Text('Sobre o Festival', style: AppTypography.titleLarge),
        const SizedBox(height: 8),
        Text(
          festival.descricao.isEmpty
              ? 'Sem descrição disponível.'
              : festival.descricao,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),

        // Datas
        _InfoTile(
          icon: Icons.calendar_today_rounded,
          color: AppColors.secondary,
          label: 'Data',
          value: DateFormatter.dateRange(
              festival.dataInicio, festival.dataFim),
        ),
        const SizedBox(height: 10),

        // Local
        _InfoTile(
          icon: Icons.location_on_rounded,
          color: AppColors.primary,
          label: 'Local',
          value:
              '${festival.endereco}\n${festival.cidadeEstado}',
        ),
        const SizedBox(height: 20),

        // Botão Como Chegar
        CirandaButton.primary(
          label: 'Como Chegar',
          icon: Icons.directions_rounded,
          width: double.infinity,
          onPressed: () async {
            final url = Uri.parse(
              'https://maps.google.com?q=${festival.latitude},${festival.longitude}',
            );
            if (await canLaunchUrl(url)) {
              await launchUrl(url,
                  mode: LaunchMode.externalApplication);
            }
          },
        ),
        const SizedBox(height: 12),
        CirandaOutlinedButton(
          label: 'Abrir no Waze',
          icon: Icons.navigation_rounded,
          color: AppColors.teal,
          width: double.infinity,
          onPressed: () async {
            final url = Uri.parse(
              'waze://?ll=${festival.latitude},${festival.longitude}&navigate=yes',
            );
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
          },
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: AppTypography.labelSmall.copyWith(
                    color: color,
                  )),
              const SizedBox(height: 2),
              Text(value,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.4,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Aba Quadrilhas ───────────────────────────────────────────────────────────
class _QuadrilhasTab extends ConsumerWidget {
  const _QuadrilhasTab({required this.festivalId});

  final String festivalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quadrilhasAsync =
        ref.watch(quadrilhasListProvider(festivalId));

    return quadrilhasAsync.when(
      data: (quadrilhas) {
        if (quadrilhas.isEmpty) {
          return const Center(
            child: Text('Nenhuma quadrilha inscrita ainda'),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: quadrilhas.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) => QuadrilhaCard(
            quadrilha: quadrilhas[index],
            festivalId: festivalId,
          ),
        );
      },
      loading: () => const CirandaLoading.inline(),
      error: (e, _) => CirandaErrorWidget(message: e.toString()),
    );
  }
}

// ── Aba Resultados ───────────────────────────────────────────────────────────
class _ResultadosTab extends ConsumerWidget {
  const _ResultadosTab({required this.festivalId});

  final String festivalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultadosAsync =
        ref.watch(resultadosFestivalProvider(festivalId));

    return resultadosAsync.when(
      data: (resultados) {
        if (resultados.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('Resultados não publicados ainda'),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: resultados.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) =>
              RankingItem(resultado: resultados[index]),
        );
      },
      loading: () => const CirandaLoading.inline(),
      error: (e, _) => CirandaErrorWidget(message: e.toString()),
    );
  }
}

// ── TabBar delegate ──────────────────────────────────────────────────────────
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
    return Container(
      color: AppColors.backgroundDark,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
