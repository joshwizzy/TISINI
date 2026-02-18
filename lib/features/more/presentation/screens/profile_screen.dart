import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/more/providers/more_provider.dart';
import 'package:tisini/features/more/providers/profile_edit_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _fullNameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _emailController = TextEditingController();
  KycAccountType? _accountType;
  bool _initialized = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _businessNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: profileAsync.when(
        data: (profile) {
          if (!_initialized) {
            _fullNameController.text = profile.fullName ?? '';
            _businessNameController.text = profile.businessName ?? '';
            _emailController.text = profile.email ?? '';
            _accountType = profile.accountType;
            _initialized = true;
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              // Phone (read-only)
              TextField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                controller: TextEditingController(text: profile.phoneNumber),
                enabled: false,
              ),
              const SizedBox(height: AppSpacing.md),
              // Full name
              TextField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: AppSpacing.md),
              // Business name
              TextField(
                controller: _businessNameController,
                decoration: const InputDecoration(labelText: 'Business Name'),
              ),
              const SizedBox(height: AppSpacing.md),
              // Email
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.md),
              // Account type
              const Text('Account Type', style: AppTypography.bodySmall),
              const SizedBox(height: AppSpacing.sm),
              SegmentedButton<KycAccountType>(
                segments: const [
                  ButtonSegment(
                    value: KycAccountType.business,
                    label: Text('Business'),
                  ),
                  ButtonSegment(
                    value: KycAccountType.gig,
                    label: Text('Gig Worker'),
                  ),
                ],
                selected: {_accountType ?? KycAccountType.business},
                onSelectionChanged: (selected) {
                  setState(() {
                    _accountType = selected.first;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              // Save button
              FilledButton(
                onPressed: () {
                  ref
                      .read(profileEditControllerProvider.notifier)
                      .saveProfile(
                        fullName: _fullNameController.text,
                        businessName: _businessNameController.text,
                        email: _emailController.text,
                        accountType: _accountType,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile saved')),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Failed to load profile')),
      ),
    );
  }
}
