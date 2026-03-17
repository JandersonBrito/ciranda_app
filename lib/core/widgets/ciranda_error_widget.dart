import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'ciranda_button.dart';

class CirandaErrorWidget extends StatelessWidget {
  const CirandaErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.isFullScreen = false,
  });

  final String message;
  final VoidCallback? onRetry;
  final bool isFullScreen;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.error.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 48,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Ops! Algo deu errado',
          style: AppTypography.titleLarge.copyWith(color: AppColors.error),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        if (onRetry != null) ...[
          const SizedBox(height: 20),
          CirandaButton.primary(
            label: 'Tentar novamente',
            onPressed: onRetry,
            icon: Icons.refresh_rounded,
          ),
        ],
      ],
    );

    if (isFullScreen) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: content,
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: content,
      ),
    );
  }
}
