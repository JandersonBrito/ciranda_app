abstract final class AppConstants {
  static const String appName = 'Ciranda App';
  static const String appTagline = 'O melhor do São João na palma da mão';

  // Paginação
  static const int defaultPageSize = 20;
  static const int homeFeedPageSize = 10;

  // Mapa
  static const double mapDefaultZoom = 14.0;
  static const double brazilLatitude = -10.3333;
  static const double brazilLongitude = -53.2;

  // Animações
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 350);
  static const Duration animationSlow = Duration(milliseconds: 600);

  // Votação
  static const double notaMin = 0.0;
  static const double notaMax = 10.0;
  static const double notaStep = 0.1;

  // Imagens
  static const double avatarSizeSmall = 36.0;
  static const double avatarSizeMedium = 52.0;
  static const double avatarSizeLarge = 80.0;
  static const double avatarSizeXL = 120.0;

  // Layout
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
}
