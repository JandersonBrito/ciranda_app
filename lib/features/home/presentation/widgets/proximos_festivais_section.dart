import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../models/festival_model.dart';
import '../../../../router/route_names.dart';

class ProximosFestivaisSection extends StatelessWidget {
  const ProximosFestivaisSection({super.key, required this.festivais});

  final List<FestivalModel> festivais;

  @override
  Widget build(BuildContext context) {
    if (festivais.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'Nenhum festival próximo cadastrado',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: festivais.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final festival = festivais[index];
          return _ProximoFestivalCard(festival: festival);
        },
      ),
    );
  }
}

class _ProximoFestivalCard extends StatelessWidget {
  const _ProximoFestivalCard({required this.festival});

  final FestivalModel festival;

  static const List<Color> _cardColors = [
    AppColors.primary,
    AppColors.accent,
    AppColors.teal,
    Color(0xFF9C27B0),
    AppColors.secondary,
  ];

  @override
  Widget build(BuildContext context) {
    final accentColor =
        _cardColors[festival.id.hashCode.abs() % _cardColors.length];

    return GestureDetector(
      onTap: () => context.goNamed(
        RouteNames.festivalDetail,
        pathParameters: {'festivalId': festival.id},
      ),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withOpacity(0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ícone colorido
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.celebration_rounded,
                color: accentColor,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),

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
                Icon(Icons.location_on_outlined,
                    color: AppColors.textSecondary, size: 12),
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
            const Spacer(),

            // Data
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                DateFormatter.shortDayMonth(festival.dataInicio),
                style: AppTypography.labelSmall.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
