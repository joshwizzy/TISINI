import 'package:flutter/material.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';

class SettingsToggleTile extends StatelessWidget {
  const SettingsToggleTile({
    required this.title,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      title: Text(title, style: AppTypography.bodyMedium),
      value: value,
      onChanged: enabled ? onChanged : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    );
  }
}
