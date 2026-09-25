import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Plain AppBar back button with an accessibility tooltip.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return IconButton(
      tooltip: l10n?.commonBack ?? 'Kembali',
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 20,
        color: AppColors.textPrimary,
      ),
      onPressed: onBack ?? () => Navigator.maybePop(context),
    );
  }
}

/// Circular white back button, typically used as a conditional AppBar leading.
class AppCircleBackButton extends StatelessWidget {
  const AppCircleBackButton({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Tooltip(
      message: l10n?.commonBack ?? 'Kembali',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: Colors.white,
          shape: const CircleBorder(),
          elevation: 0.5,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onBack ?? () => Navigator.maybePop(context),
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Rounded square back button used by the product screens.
class AppSquareBackButton extends StatelessWidget {
  const AppSquareBackButton({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Tooltip(
      message: l10n?.commonBack ?? 'Kembali',
      child: Padding(
        padding: const EdgeInsets.only(left: 14),
        child: Center(
          child: InkWell(
            onTap: onBack ?? () => Navigator.maybePop(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.greyBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.greyBorder),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
