import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/categoria_model.dart';

/// Slider de nota para votação — 0.0 a 10.0 com visual colorido.
class NotaSlider extends StatelessWidget {
  const NotaSlider({
    super.key,
    required this.categoria,
    required this.nota,
    required this.onChanged,
    this.isReadOnly = false,
  });

  final CategoriaModel categoria;
  final double nota;
  final ValueChanged<double> onChanged;
  final bool isReadOnly;

  Color get _notaColor {
    if (nota < 4) return AppColors.error;
    if (nota < 6) return AppColors.warning;
    if (nota < 8) return AppColors.teal;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _notaColor.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: nome + peso + nota
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoria.nome,
                      style: AppTypography.titleSmall,
                    ),
                    if (categoria.descricao.isNotEmpty)
                      Text(
                        categoria.descricao,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Peso
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.teal.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Peso: ${categoria.pesoLabel}',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.teal,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Nota atual
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _notaColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: _notaColor, width: 2),
                ),
                child: Center(
                  child: Text(
                    nota.toStringAsFixed(1),
                    style: AppTypography.titleMedium.copyWith(
                      color: _notaColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Slider
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: _notaColor,
              inactiveTrackColor: AppColors.border,
              thumbColor: _notaColor,
              overlayColor: _notaColor.withOpacity(0.2),
              valueIndicatorColor: _notaColor,
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 10,
              ),
            ),
            child: Slider(
              value: nota,
              min: 0.0,
              max: 10.0,
              divisions: 100,
              label: nota.toStringAsFixed(1),
              onChanged: isReadOnly ? null : onChanged,
            ),
          ),

          // Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0.0',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textHint,
                  )),
              Text('5.0',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textHint,
                  )),
              Text('10.0',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textHint,
                  )),
            ],
          ),

          if (isReadOnly)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  const Icon(Icons.lock_rounded,
                      color: AppColors.textHint, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    'Voto registrado',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
