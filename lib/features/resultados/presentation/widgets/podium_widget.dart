import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/ciranda_avatar.dart';
import '../../../../models/resultado_model.dart';

/// Pódio animado com 1º, 2º e 3º lugar.
class PodiumWidget extends StatefulWidget {
  const PodiumWidget({
    super.key,
    required this.top3,
  });

  final List<ResultadoModel> top3;

  @override
  State<PodiumWidget> createState() => _PodiumWidgetState();
}

class _PodiumWidgetState extends State<PodiumWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _scales;
  late final List<Animation<double>> _heights;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // 2º sobe primeiro, depois 3º, depois 1º (drama!)
    _scales = [
      // 1º
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
        ),
      ),
      // 2º
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
        ),
      ),
      // 3º
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
        ),
      ),
    ];

    _heights = [
      // 1º — mais alto
      Tween<double>(begin: 0, end: 120).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
        ),
      ),
      // 2º
      Tween<double>(begin: 0, end: 80).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
        ),
      ),
      // 3º
      Tween<double>(begin: 0, end: 60).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
        ),
      ),
    ];

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Ordem visual: 2º, 1º, 3º
  static const _order = [1, 0, 2];
  static const _podiumColors = [
    AppColors.gold,
    AppColors.silver,
    AppColors.bronze,
  ];

  @override
  Widget build(BuildContext context) {
    final top3 = widget.top3;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1A0020),
                AppColors.backgroundDark,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              // Título
              Text(
                '🏆 Resultado Final',
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 24),

              // Pódio
              SizedBox(
                height: 240,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _order.map((posIdx) {
                    if (posIdx >= top3.length) {
                      return const SizedBox(width: 100);
                    }
                    final resultado = top3[posIdx];
                    final color = _podiumColors[posIdx];
                    final scale = _scales[posIdx].value;
                    final height = _heights[posIdx].value;

                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Avatar + nome
                          Transform.scale(
                            scale: scale,
                            child: Column(
                              children: [
                                CirandaAvatar(
                                  imageUrl: resultado.quadrilhaFotoUrl,
                                  displayName: resultado.quadrilhaNome,
                                  radius: posIdx == 0 ? 32 : 24,
                                  borderColor: color,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  resultado.quadrilhaNome,
                                  style: AppTypography.labelSmall.copyWith(
                                    color: color,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  resultado.pontuacaoFinal
                                      .toStringAsFixed(2),
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Barra do pódio
                          Container(
                            height: height,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.2),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8)),
                              border: Border.all(
                                  color: color.withOpacity(0.5),
                                  width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, -4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '${posIdx + 1}º',
                                style: AppTypography.headlineSmall.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
