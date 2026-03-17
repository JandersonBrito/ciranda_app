import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../models/festival_model.dart';
import '../../../../router/route_names.dart';

/// Carousel horizontal de festivais em destaque.
class FestivalCarousel extends StatefulWidget {
  const FestivalCarousel({super.key, required this.festivais});

  final List<FestivalModel> festivais;

  @override
  State<FestivalCarousel> createState() => _FestivalCarouselState();
}

class _FestivalCarouselState extends State<FestivalCarousel> {
  final _pageController = PageController(viewportFraction: 0.88);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.festivais.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final festival = widget.festivais[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _FestivalCarouselCard(festival: festival),
              );
            },
          ),
        ),
        // Indicadores
        if (widget.festivais.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.festivais.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentPage == index ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? AppColors.primary
                      : AppColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _FestivalCarouselCard extends StatelessWidget {
  const _FestivalCarouselCard({required this.festival});

  final FestivalModel festival;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.goNamed(
        RouteNames.festivalDetail,
        pathParameters: {'festivalId': festival.id},
      ),
      child: Hero(
        tag: 'festival-banner-${festival.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Imagem de fundo
              if (festival.bannerUrl != null)
                Image.network(
                  festival.bannerUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildGradientFallback(),
                )
              else
                _buildGradientFallback(),

              // Gradiente
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Color(0xDD000000)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.3, 1.0],
                  ),
                ),
              ),

              // Conteúdo
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Badge de tipo
                    Align(
                      alignment: Alignment.topRight,
                      child: _StatusBadge(festival: festival),
                    ),

                    // Informações
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          festival.nome,
                          style: AppTypography.titleLarge.copyWith(
                            shadows: [
                              const Shadow(
                                  blurRadius: 8, color: Colors.black87)
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded,
                                color: AppColors.primary, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              festival.cidadeEstado,
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.white70,
                              ),
                            ),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A0030), Color(0xFF1A1A1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.celebration_rounded,
          color: AppColors.primary,
          size: 64,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.festival});

  final FestivalModel festival;

  @override
  Widget build(BuildContext context) {
    final String label;
    final Color color;

    if (festival.isHappening) {
      label = 'AO VIVO';
      color = AppColors.error;
    } else if (festival.isUpcoming) {
      label = 'EM BREVE';
      color = AppColors.teal;
    } else {
      label = 'ENCERRADO';
      color = AppColors.textHint;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 8,
          ),
        ],
      ),
      child: Text(
        label,
        style: AppTypography.overline.copyWith(
          color: Colors.white,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
