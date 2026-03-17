import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';
import '../theme/app_typography.dart';

/// Botão primário da Ciranda com glow colorido.
class CirandaButton extends StatelessWidget {
  const CirandaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.color,
    this.width,
  });

  /// Botão primário (rosa pink)
  const CirandaButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
  }) : color = AppColors.primary;

  /// Botão secundário (amarelo)
  const CirandaButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
  }) : color = AppColors.secondary;

  /// Botão terciário (laranja)
  const CirandaButton.accent({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
  }) : color = AppColors.accent;

  /// Botão teal
  const CirandaButton.teal({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
  }) : color = AppColors.teal;

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final Color? color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final btnColor = color ?? AppColors.primary;
    final isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: isDisabled
              ? BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                )
              : AppDecorations.glowButton(btnColor),
          child: InkWell(
            onTap: isDisabled ? null : onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: btnColor == AppColors.secondary
                            ? AppColors.textOnSecondary
                            : Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            color: isDisabled
                                ? AppColors.textHint
                                : (btnColor == AppColors.secondary
                                    ? AppColors.textOnSecondary
                                    : Colors.white),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          label,
                          style: AppTypography.button.copyWith(
                            color: isDisabled
                                ? AppColors.textHint
                                : (btnColor == AppColors.secondary
                                    ? AppColors.textOnSecondary
                                    : Colors.white),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Botão outlined (borda colorida, fundo transparente).
class CirandaOutlinedButton extends StatelessWidget {
  const CirandaOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.isLoading = false,
    this.width,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final bool isLoading;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final btnColor = color ?? AppColors.primary;

    return SizedBox(
      width: width,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: btnColor),
              )
            : (icon != null ? Icon(icon, color: btnColor, size: 18) : const SizedBox.shrink()),
        label: Text(label,
            style: AppTypography.button.copyWith(color: btnColor)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: btnColor, width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
    );
  }
}

/// Botão de ação rápida (ícone + rótulo, compacto).
class CirandaActionButton extends StatelessWidget {
  const CirandaActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color = AppColors.primary,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: isActive ? color : AppColors.textSecondary,
        size: 20,
      ),
      label: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: isActive ? color : AppColors.textSecondary,
        ),
      ),
      style: TextButton.styleFrom(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
