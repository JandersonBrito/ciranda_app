import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../models/festival_model.dart';

class FestivalCard extends StatelessWidget {
  const FestivalCard({
    super.key,
    required this.festival,
    this.onTap,
  });

  final FestivalModel festival;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          children: [
            // Thumbnail
            Hero(
              tag: 'festival-banner-${festival.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(16)),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: festival.bannerUrl != null
                      ? Image.network(
                          festival.bannerUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _buildFallback(),
                        )
                      : _buildFallback(),
                ),
              ),
            ),

            // Conteúdo
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge de status
                    Row(
                      children: [
                        _buildStatusBadge(),
                        const Spacer(),
                        _buildTipoBadge(),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Nome
                    Text(
                      festival.nome,
                      style: AppTypography.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Cidade
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            color: AppColors.primary, size: 12),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            festival.cidadeEstado,
                            style: AppTypography.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),

                    // Data
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded,
                            color: AppColors.secondary, size: 12),
                        const SizedBox(width: 2),
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
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textHint, size: 20),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Icon(Icons.celebration_rounded,
            color: AppColors.primary, size: 40),
      ),
    );
  }

  Widget _buildStatusBadge() {
    String label;
    Color color;

    if (festival.isHappening) {
      label = 'Em andamento';
      color = AppColors.success;
    } else if (festival.isUpcoming) {
      label = 'Em breve';
      color = AppColors.teal;
    } else {
      label = 'Encerrado';
      color = AppColors.textHint;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: color),
      ),
    );
  }

  Widget _buildTipoBadge() {
    final label = switch (festival.tipo) {
      FestivalTipo.nacional => 'Nacional',
      FestivalTipo.estadual => 'Estadual',
      FestivalTipo.regional => 'Regional',
      FestivalTipo.municipal => 'Municipal',
    };
    return Text(
      label,
      style: AppTypography.labelSmall.copyWith(
        color: AppColors.textHint,
      ),
    );
  }
}
