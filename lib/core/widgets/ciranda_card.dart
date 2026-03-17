import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';

/// Card base da Ciranda com suporte a borda colorida e sombra vibrante.
class CirandaCard extends StatelessWidget {
  const CirandaCard({
    super.key,
    required this.child,
    this.onTap,
    this.accentColor,
    this.padding,
    this.margin,
    this.borderRadius,
    this.heroTag,
    this.elevation = 0,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color? accentColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final String? heroTag;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(16);
    final decoration = accentColor != null
        ? AppDecorations.cardWithAccent(accentColor!)
        : AppDecorations.card;

    Widget card = Container(
      margin: margin,
      decoration: decoration.copyWith(
        borderRadius: radius,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: (accentColor ?? AppColors.primary).withOpacity(0.2),
                  blurRadius: elevation * 4,
                  offset: Offset(0, elevation * 2),
                ),
              ]
            : decoration.boxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          splashColor: (accentColor ?? AppColors.primary).withOpacity(0.1),
          highlightColor: (accentColor ?? AppColors.primary).withOpacity(0.05),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );

    if (heroTag != null) {
      card = Hero(tag: heroTag!, child: card);
    }

    return card;
  }
}

/// Card de festival com imagem de capa em destaque.
class FestivalBannerCard extends StatelessWidget {
  const FestivalBannerCard({
    super.key,
    required this.imageUrl,
    required this.child,
    this.onTap,
    this.height = 200,
    this.heroTag,
  });

  final String imageUrl;
  final Widget child;
  final VoidCallback? onTap;
  final double height;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Imagem de fundo
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.surfaceVariant,
                child: const Icon(Icons.image_not_supported,
                    color: AppColors.textHint, size: 48),
              ),
            ),
            // Gradiente escuro na parte inferior
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, AppColors.scrim],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.3, 1.0],
                ),
              ),
            ),
            // Conteúdo
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                splashColor: AppColors.primary.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (heroTag != null) {
      card = Hero(tag: heroTag!, child: card);
    }

    return card;
  }
}

/// Card compacto de quadrilha/jurado com foto circular.
class CircularPhotoCard extends StatelessWidget {
  const CircularPhotoCard({
    super.key,
    required this.imageUrl,
    required this.label,
    this.sublabel,
    this.onTap,
    this.size = 80,
    this.accentColor,
  });

  final String? imageUrl;
  final String label;
  final String? sublabel;
  final VoidCallback? onTap;
  final double size;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: accentColor ?? AppColors.primary,
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: (accentColor ?? AppColors.primary).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: imageUrl != null
                  ? Image.network(imageUrl!, fit: BoxFit.cover)
                  : Container(
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.person,
                          color: AppColors.textHint),
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (sublabel != null)
            Text(
              sublabel!,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
