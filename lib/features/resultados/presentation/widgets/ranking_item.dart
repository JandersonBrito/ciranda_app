import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/ciranda_avatar.dart';
import '../../../../models/resultado_model.dart';

class RankingItem extends StatelessWidget {
  const RankingItem({super.key, required this.resultado});

  final ResultadoModel resultado;

  @override
  Widget build(BuildContext context) {
    final isTop3 = resultado.posicao <= 3;
    final accentColor = switch (resultado.posicao) {
      1 => AppColors.gold,
      2 => AppColors.silver,
      3 => AppColors.bronze,
      _ => AppColors.border,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isTop3 ? accentColor.withOpacity(0.4) : AppColors.border,
          width: isTop3 ? 1.5 : 1,
        ),
        boxShadow: isTop3
            ? [
                BoxShadow(
                  color: accentColor.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Posição
          PositionBadge(position: resultado.posicao, size: 36),
          const SizedBox(width: 12),

          // Avatar
          CirandaAvatar(
            imageUrl: resultado.quadrilhaFotoUrl,
            displayName: resultado.quadrilhaNome,
            radius: 22,
            borderColor: isTop3 ? accentColor : AppColors.border,
            showBorder: isTop3,
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resultado.quadrilhaNome,
                  style: AppTypography.titleSmall.copyWith(
                    color: isTop3 ? accentColor : AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  resultado.cidadeEstado,
                  style: AppTypography.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Pontuação
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                resultado.pontuacaoFinal.toStringAsFixed(2),
                style: AppTypography.titleSmall.copyWith(
                  color: isTop3 ? accentColor : AppColors.secondary,
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
      ),
    );
  }
}
