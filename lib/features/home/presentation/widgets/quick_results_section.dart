import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/ciranda_avatar.dart';
import '../../../../models/resultado_model.dart';
import '../../../../router/route_names.dart';

class QuickResultsSection extends StatelessWidget {
  const QuickResultsSection({super.key, required this.resultados});

  final List<ResultadoModel> resultados;

  @override
  Widget build(BuildContext context) {
    // Agrupa por festival e mostra top 3 do mais recente
    final top3 = resultados.take(3).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          ...top3.asMap().entries.map((entry) {
            final index = entry.key;
            final resultado = entry.value;
            return _ResultadoTile(
              resultado: resultado,
              displayPosition: index + 1,
            );
          }),
        ],
      ),
    );
  }
}

class _ResultadoTile extends StatelessWidget {
  const _ResultadoTile({
    required this.resultado,
    required this.displayPosition,
  });

  final ResultadoModel resultado;
  final int displayPosition;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          PositionBadge(position: displayPosition),
          const SizedBox(width: 12),
          CirandaAvatar(
            imageUrl: resultado.quadrilhaFotoUrl,
            displayName: resultado.quadrilhaNome,
            radius: 18,
            showBorder: false,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resultado.quadrilhaNome,
                  style: AppTypography.titleSmall,
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
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                resultado.pontuacaoFinal.toStringAsFixed(2),
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text('pts',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
