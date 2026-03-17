import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/ciranda_avatar.dart';
import '../../../../models/quadrilha_model.dart';
import '../../../../router/route_names.dart';

class QuadrilhaCard extends StatelessWidget {
  const QuadrilhaCard({
    super.key,
    required this.quadrilha,
    this.festivalId,
    this.onTap,
    this.showScore = true,
  });

  final QuadrilhaModel quadrilha;
  final String? festivalId;
  final VoidCallback? onTap;
  final bool showScore;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () => context.goNamed(
                RouteNames.quadrilhaDetail,
                pathParameters: {'quadrilhaId': quadrilha.id},
              ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          children: [
            // Posição
            if (quadrilha.posicao > 0) ...[
              PositionBadge(position: quadrilha.posicao, size: 36),
              const SizedBox(width: 12),
            ],

            // Avatar
            CirandaAvatar(
              imageUrl: quadrilha.fotoUrl,
              displayName: quadrilha.nome,
              radius: 26,
              borderColor: _accentColor,
            ),
            const SizedBox(width: 14),

            // Informações
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quadrilha.nome,
                    style: AppTypography.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: AppColors.textSecondary, size: 12),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          quadrilha.cidadeEstado,
                          style: AppTypography.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (quadrilha.anoFundacao > 0) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Fundada em ${quadrilha.anoFundacao}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Pontuação
            if (showScore && quadrilha.pontuacaoTotal > 0) ...[
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    quadrilha.pontuacaoTotal.toStringAsFixed(2),
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'pts',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textHint, size: 18),
          ],
        ),
      ),
    );
  }

  Color get _accentColor {
    final colors = [
      AppColors.primary,
      AppColors.accent,
      AppColors.teal,
      const Color(0xFF9C27B0),
    ];
    return colors[quadrilha.id.hashCode.abs() % colors.length];
  }
}
