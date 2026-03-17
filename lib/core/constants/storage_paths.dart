abstract final class StoragePaths {
  static String festivalBanner(String festivalId) =>
      'festivais/$festivalId/banner.jpg';

  static String festivalPhoto(String festivalId, String photoId) =>
      'festivais/$festivalId/photos/$photoId.jpg';

  static String quadrilhaPhoto(String quadrilhaId) =>
      'quadrilhas/$quadrilhaId/cover.jpg';

  static String quadrilhaLogo(String quadrilhaId) =>
      'quadrilhas/$quadrilhaId/logo.png';

  static String integrantePhoto(String quadrilhaId, String integranteId) =>
      'quadrilhas/$quadrilhaId/integrantes/$integranteId.jpg';

  static String juradoPhoto(String juradoId) =>
      'jurados/$juradoId/photo.jpg';

  static String userAvatar(String uid) =>
      'users/$uid/avatar.jpg';

  static String postMedia(String postId, String fileName) =>
      'posts/$postId/$fileName';
}
