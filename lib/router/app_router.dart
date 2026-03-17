import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/widgets/ciranda_bottom_nav.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/festivais/presentation/screens/festival_detail_screen.dart';
import '../features/festivais/presentation/screens/festivais_list_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/jurados/presentation/screens/votacao_screen.dart';
import '../features/perfil/presentation/screens/perfil_edit_screen.dart';
import '../features/perfil/presentation/screens/perfil_screen.dart';
import '../features/quadrilhas/presentation/screens/quadrilha_detail_screen.dart';
import '../features/quadrilhas/presentation/screens/quadrilhas_list_screen.dart';
import '../features/resultados/presentation/screens/resultado_detalhe_screen.dart';
import '../features/resultados/presentation/screens/resultados_screen.dart';
import '../providers/firebase_providers.dart';
import 'route_names.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      if (isLoading) return null;

      final isAuthenticated = authState.valueOrNull != null;
      final isOnAuthPage = state.matchedLocation == RoutePaths.login ||
          state.matchedLocation == RoutePaths.register ||
          state.matchedLocation == RoutePaths.splash;

      if (!isAuthenticated && !isOnAuthPage) {
        return RoutePaths.login;
      }

      if (isAuthenticated && state.matchedLocation == RoutePaths.login) {
        return RoutePaths.home;
      }

      return null;
    },
    routes: [
      // ── Splash ──────────────────────────────────────────────────────────
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // ── Auth ────────────────────────────────────────────────────────────
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),

      // ── Votação (acesso direto, sem bottom nav) ──────────────────────────
      GoRoute(
        path: '/festivais/:festivalId/votar/:quadrilhaId',
        name: RouteNames.votacao,
        builder: (context, state) => VotacaoScreen(
          festivalId: state.pathParameters['festivalId']!,
          quadrilhaId: state.pathParameters['quadrilhaId']!,
        ),
      ),

      // ── Resultado detalhe ────────────────────────────────────────────────
      GoRoute(
        path: '/resultados/:festivalId',
        name: RouteNames.resultadoDetalhe,
        builder: (context, state) => ResultadoDetalheScreen(
          festivalId: state.pathParameters['festivalId']!,
        ),
      ),

      // ── Perfil Editar ────────────────────────────────────────────────────
      GoRoute(
        path: RoutePaths.perfilEdit,
        name: RouteNames.perfilEdit,
        builder: (context, state) => const PerfilEditScreen(),
      ),

      // ── Shell com Bottom Navigation ──────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return CirandaScaffoldWithNav(
            navigationShell: navigationShell,
          );
        },
        branches: [
          // 0 — Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                name: RouteNames.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // 1 — Festivais
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.festivaisList,
                name: RouteNames.festivaisList,
                builder: (context, state) => const FestivaisListScreen(),
                routes: [
                  GoRoute(
                    path: ':festivalId',
                    name: RouteNames.festivalDetail,
                    builder: (context, state) => FestivalDetailScreen(
                      festivalId: state.pathParameters['festivalId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 2 — Quadrilhas
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.quadrilhasList,
                name: RouteNames.quadrilhasList,
                builder: (context, state) => const QuadrilhasListScreen(),
                routes: [
                  GoRoute(
                    path: ':quadrilhaId',
                    name: RouteNames.quadrilhaDetail,
                    builder: (context, state) => QuadrilhaDetailScreen(
                      quadrilhaId: state.pathParameters['quadrilhaId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 3 — Resultados
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.resultados,
                name: RouteNames.resultados,
                builder: (context, state) => const ResultadosScreen(),
              ),
            ],
          ),

          // 4 — Perfil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.perfil,
                name: RouteNames.perfil,
                builder: (context, state) => const PerfilScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// Scaffold raiz com Bottom Navigation Bar
class CirandaScaffoldWithNav extends StatelessWidget {
  const CirandaScaffoldWithNav({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: CirandaBottomNav(
        navigationShell: navigationShell,
      ),
    );
  }
}
