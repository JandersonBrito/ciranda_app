import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Avatar circular com fallback de iniciais e borda colorida.
class CirandaAvatar extends StatelessWidget {
  const CirandaAvatar({
    super.key,
    this.imageUrl,
    required this.displayName,
    this.radius = 26,
    this.borderColor,
    this.showBorder = true,
    this.onTap,
  });

  final String? imageUrl;
  final String displayName;
  final double radius;
  final Color? borderColor;
  final bool showBorder;
  final VoidCallback? onTap;

  String get _initials {
    final parts = displayName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
  }

  Color get _fallbackColor {
    final colors = [
      AppColors.primary,
      AppColors.accent,
      AppColors.teal,
      const Color(0xFF9C27B0),
    ];
    return colors[displayName.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final borderCol = borderColor ?? AppColors.primary;
    final totalRadius = showBorder ? radius + 2.5 : radius;

    Widget avatar = Container(
      width: totalRadius * 2,
      height: totalRadius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(color: borderCol, width: 2.5)
            : null,
        boxShadow: showBorder
            ? [
                BoxShadow(
                  color: borderCol.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) => _buildPlaceholder(),
                errorWidget: (_, __, ___) => _buildInitials(),
              )
            : _buildInitials(),
      ),
    );

    if (onTap != null) {
      avatar = GestureDetector(onTap: onTap, child: avatar);
    }

    return avatar;
  }

  Widget _buildInitials() {
    return Container(
      color: _fallbackColor,
      child: Center(
        child: Text(
          _initials,
          style: TextStyle(
            fontSize: radius * 0.7,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

/// Badge de posição (1º, 2º, 3º) com cor de ouro/prata/bronze.
class PositionBadge extends StatelessWidget {
  const PositionBadge({super.key, required this.position, this.size = 32});

  final int position;
  final double size;

  Color get _color => switch (position) {
        1 => AppColors.gold,
        2 => AppColors.silver,
        3 => AppColors.bronze,
        _ => AppColors.surfaceVariant,
      };

  String get _emoji => switch (position) {
        1 => '🏆',
        2 => '🥈',
        3 => '🥉',
        _ => '#$position',
      };

  @override
  Widget build(BuildContext context) {
    if (position > 3) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '$position',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _color.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: _color, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: _color.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          _emoji,
          style: TextStyle(fontSize: size * 0.5),
        ),
      ),
    );
  }
}
