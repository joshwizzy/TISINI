import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/router/route_names.dart';
import 'package:tisini/features/auth/domain/entities/kyc_status.dart';
import 'package:tisini/features/more/presentation/widgets/more_menu_tile.dart';
import 'package:tisini/features/more/providers/more_provider.dart';

class MoreHubScreen extends ConsumerWidget {
  const MoreHubScreen({super.key});

  String _kycLabel(KycStatus status) {
    return switch (status) {
      KycStatus.notStarted => 'Not started',
      KycStatus.inProgress => 'In progress',
      KycStatus.pending => 'Pending',
      KycStatus.approved => 'Approved',
      KycStatus.failed => 'Failed',
    };
  }

  Color _kycColor(KycStatus status) {
    return switch (status) {
      KycStatus.approved => AppColors.success,
      KycStatus.pending || KycStatus.inProgress => AppColors.warning,
      KycStatus.failed => AppColors.error,
      KycStatus.notStarted => AppColors.grey,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('More'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // User header
          profileAsync.when(
            data: (profile) => Container(
              color: AppColors.cardWhite,
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.darkBlue.withValues(alpha: 0.1),
                    child: Text(
                      (profile.fullName ?? 'U').substring(0, 1).toUpperCase(),
                      style: AppTypography.headlineMedium.copyWith(
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.fullName ?? 'User',
                          style: AppTypography.titleLarge,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          profile.phoneNumber,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            loading: () => Container(
              color: AppColors.cardWhite,
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              height: 88,
              child: const Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => Container(
              color: AppColors.cardWhite,
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: const Text('Failed to load profile'),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Menu tiles
          MoreMenuTile(
            icon: PhosphorIconsBold.user,
            title: 'Profile',
            onTap: () => context.goNamed(RouteNames.profile),
          ),
          MoreMenuTile(
            icon: PhosphorIconsBold.bank,
            title: 'Connected Accounts',
            onTap: () => context.goNamed(RouteNames.connectedAccounts),
          ),
          MoreMenuTile(
            icon: PhosphorIconsBold.shieldCheck,
            title: 'Security',
            onTap: () => context.goNamed(RouteNames.securitySettings),
          ),
          MoreMenuTile(
            icon: PhosphorIconsBold.bell,
            title: 'Notifications',
            onTap: () => context.goNamed(RouteNames.notificationSettings),
          ),
          MoreMenuTile(
            icon: PhosphorIconsBold.pushPin,
            title: 'Pinned Merchants',
            onTap: () => context.goNamed(RouteNames.pinnedMerchants),
          ),
          MoreMenuTile(
            icon: PhosphorIconsBold.fileArrowUp,
            title: 'Import Statements',
            onTap: () => context.goNamed(RouteNames.importSource),
          ),
          // KYC tile with status badge
          profileAsync.when(
            data: (profile) => MoreMenuTile(
              icon: PhosphorIconsBold.identificationCard,
              title: 'KYC Verification',
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _kycColor(profile.kycStatus).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _kycLabel(profile.kycStatus),
                  style: AppTypography.labelSmall.copyWith(
                    color: _kycColor(profile.kycStatus),
                  ),
                ),
              ),
              onTap: () => context.goNamed(RouteNames.kycEntry),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          MoreMenuTile(
            icon: PhosphorIconsBold.question,
            title: 'Help & Support',
            onTap: () => context.goNamed(RouteNames.helpSupport),
          ),
          MoreMenuTile(
            icon: PhosphorIconsBold.scales,
            title: 'Legal & About',
            onTap: () => context.goNamed(RouteNames.legalAbout),
          ),
          // App version footer
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: Text(
              'Tisini v1.0.0',
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
