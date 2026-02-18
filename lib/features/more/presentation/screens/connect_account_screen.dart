import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_spacing.dart';
import 'package:tisini/core/constants/app_typography.dart';
import 'package:tisini/core/enums.dart';
import 'package:tisini/features/more/providers/more_provider.dart';

class ConnectAccountScreen extends ConsumerStatefulWidget {
  const ConnectAccountScreen({super.key});

  @override
  ConsumerState<ConnectAccountScreen> createState() =>
      _ConnectAccountScreenState();
}

class _ConnectAccountScreenState extends ConsumerState<ConnectAccountScreen> {
  AccountProvider? _selectedProvider;
  final _identifierController = TextEditingController();
  bool _linking = false;

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  String _providerLabel(AccountProvider provider) {
    return switch (provider) {
      AccountProvider.mtn => 'MTN MoMo',
      AccountProvider.airtel => 'Airtel Money',
      AccountProvider.stanbic => 'Stanbic Bank',
      AccountProvider.dfcu => 'DFCU Bank',
      AccountProvider.equity => 'Equity Bank',
      AccountProvider.centenary => 'Centenary Bank',
    };
  }

  Future<void> _linkAccount() async {
    if (_selectedProvider == null || _identifierController.text.isEmpty) {
      return;
    }

    setState(() => _linking = true);
    try {
      final repository = ref.read(moreRepositoryProvider);
      await repository.connectAccount(
        provider: _selectedProvider!,
        identifier: _identifierController.text,
      );
      ref.invalidate(connectedAccountsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account linked successfully')),
        );
        context.pop();
      }
    } on Exception {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to link account')));
      }
    } finally {
      if (mounted) {
        setState(() => _linking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Connect Account'),
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          Text(
            'Select Provider',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          RadioGroup<AccountProvider>(
            groupValue: _selectedProvider,
            onChanged: (value) {
              setState(() => _selectedProvider = value);
            },
            child: Column(
              children: AccountProvider.values
                  .map(
                    (provider) => RadioListTile<AccountProvider>(
                      value: provider,
                      title: Text(
                        _providerLabel(provider),
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _identifierController,
            decoration: const InputDecoration(
              labelText: 'Account Identifier',
              hintText: 'Phone number or account number',
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: _linking ? null : _linkAccount,
            child: _linking
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Link Account'),
          ),
        ],
      ),
    );
  }
}
