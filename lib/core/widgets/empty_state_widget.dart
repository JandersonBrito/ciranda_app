import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'ciranda_button.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                icon ?? Icons.search_off_rounded,
                color: AppColors.textHint,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textHint,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              CirandaButton.primary(
                label: actionLabel!,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
