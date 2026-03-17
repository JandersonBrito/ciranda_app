import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bandeirinhas_header.dart';
import '../../../../core/widgets/ciranda_app_bar.dart';
import '../../../../core/widgets/ciranda_error_widget.dart';
import '../../../../core/widgets/ciranda_loading.dart';
import '../../../../models/festival_model.dart';
import '../../../../models/resultado_model.dart';
import '../../../../providers/firebase_providers.dart';
import '../../../../router/route_names.dart';
import '../providers/home_provider.dart';
import '../widgets/festival_carousel.dart';
import '../widgets/proximos_festivais_section.dart';
import '../widgets/quick_results_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentFirebaseUserProvider);
    final festivaisAsync = ref.watch(festivaisDestaquesProvider);
    final proximosAsync = ref.watch(proximosFestivaisProvider);
    final resultadosAsync = ref.watch(ultimosResultadosProvider);

    final firstName = user?.displayName?.split(' ').first ?? 'Brincante';

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surfaceDark,
        onRefresh: () async {
          ref.invalidate(festivaisDestaquesProvider);
          ref.invalidate(proximosFestivaisProvider);
          ref.invalidate(ultimosResultadosProvider);
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: CustomScrollView(
          slivers: [
            // ── AppBar com bandeirinhas ────────────────────────────────────
            SliverAppBar(
              pinned: true,
              expandedHeight: 120,
              backgroundColor: AppColors.backgroundDark,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Fundo degradê
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1A0020), AppColors.backgroundDark],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    // Padrão de chita
                    CustomPaint(
                      painter: ChitaPatternPainter(opacity: 0.04),
                    ),
                    // Bandeirinhas + saudação
                    Column(
                      children: [
                        const SafeArea(
                          bottom: false,
                          child: BandeirinhasHeader(height: 48, flagCount: 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Boa festa, $firstName!',
                                      style: AppTypography.headlineSmall
                                          .copyWith(
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      'O melhor do São João está aqui',
                                      style:
                                          AppTypography.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              // Logo pequeno
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withOpacity(0.4),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                                child: CustomPaint(
                                    painter: _SmallMandala()),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              title: Row(
                children: [
                  SizedBox(
                      width: 28,
                      height: 28,
                      child: CustomPaint(painter: _SmallMandala())),
                  const SizedBox(width: 10),
                  Text(
                    'Ciranda App',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            // ── Carousel de festivais em destaque ─────────────────────────
            SliverToBoxAdapter(
              child: festivaisAsync.when(
                data: (festivais) => festivais.isEmpty
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: FestivalCarousel(festivais: festivais),
                      ),
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                      height: 200, child: CirandaLoading.inline()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: CirandaErrorWidget(message: e.toString()),
                ),
              ),
            ),

            // ── Seção "Próximos Festivais" ─────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Próximos Festivais',
                        style: AppTypography.titleLarge),
                    TextButton(
                      onPressed: () =>
                          context.goNamed(RouteNames.festivaisList),
                      child: const Text('Ver todos'),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: proximosAsync.when(
                data: (festivais) => ProximosFestivaisSection(
                    festivais: festivais),
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(height: 140, child: CirandaLoading.inline()),
                ),
                error: (e, _) => const SizedBox.shrink(),
              ),
            ),

            // ── Seção "Últimos Resultados" ─────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Últimos Resultados',
                        style: AppTypography.titleLarge),
                    TextButton(
                      onPressed: () =>
                          context.goNamed(RouteNames.resultados),
                      child: const Text('Ver todos'),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: resultadosAsync.when(
                data: (resultados) => resultados.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Nenhum resultado publicado ainda',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : QuickResultsSection(resultados: resultados),
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(height: 120, child: CirandaLoading.inline()),
                ),
                error: (e, _) => const SizedBox.shrink(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _SmallMandala extends CustomPainter {
  static const _colors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.accent,
    AppColors.teal,
    Color(0xFF9C27B0),
    Color(0xFF4CAF50),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;
    final inner = r * 0.38;
    for (int i = 0; i < 6; i++) {
      final a = -3.14159265 / 2 + i * 2 * 3.14159265 / 6;
      final na = a + 2 * 3.14159265 / 6;
      final ma = a + 3.14159265 / 6;
      final path = Path()
        ..moveTo(c.dx, c.dy)
        ..lineTo(c.dx + r * _cos(a), c.dy + r * _sin(a))
        ..lineTo(c.dx + inner * _cos(ma), c.dy + inner * _sin(ma))
        ..lineTo(c.dx + r * _cos(na), c.dy + r * _sin(na))
        ..close();
      canvas.drawPath(path, Paint()..color = _colors[i % _colors.length]);
    }
    canvas.drawCircle(c, inner * 0.55, Paint()..color = Colors.white);
  }

  static double _cos(double x) {
    double r = 1, t = 1;
    for (int i = 1; i <= 6; i++) {
      t *= -x * x / ((2 * i - 1) * (2 * i));
      r += t;
    }
    return r;
  }

  static double _sin(double x) => _cos(x - 3.14159265 / 2);

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
