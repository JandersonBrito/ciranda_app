abstract final class RouteNames {
  // Auth
  static const String splash = 'splash';
  static const String login = 'login';
  static const String register = 'register';

  // Shell (bottom nav)
  static const String home = 'home';
  static const String festivaisList = 'festivais';
  static const String quadrilhasList = 'quadrilhas';
  static const String resultados = 'resultados';
  static const String perfil = 'perfil';

  // Festival
  static const String festivalDetail = 'festival-detail';

  // Quadrilha
  static const String quadrilhaDetail = 'quadrilha-detail';

  // Jurado / Votação
  static const String juradosList = 'jurados';
  static const String votacao = 'votacao';

  // Resultado detalhe
  static const String resultadoDetalhe = 'resultado-detalhe';

  // Perfil
  static const String perfilEdit = 'perfil-edit';
}

abstract final class RoutePaths {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  // Shell
  static const String home = '/home';
  static const String festivaisList = '/festivais';
  static const String quadrilhasList = '/quadrilhas';
  static const String resultados = '/resultados';
  static const String perfil = '/perfil';

  // Nested
  static String festivalDetail(String id) => '/festivais/$id';
  static String quadrilhaDetail(String id) => '/quadrilhas/$id';
  static String festivalVotacao(String festivalId, String quadrilhaId) =>
      '/festivais/$festivalId/votar/$quadrilhaId';
  static String resultadoDetalhe(String festivalId) =>
      '/resultados/$festivalId';
  static const String perfilEdit = '/perfil/editar';
}
