import 'package:buzzy_bee/core/widgets/custom_elevated_button.dart';
import 'package:buzzy_bee/features/wallet/domain/entities/wallet.dart';
import 'package:flutter/material.dart' hide TextDirection;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/core/widgets/error_view.dart';
import 'package:buzzy_bee/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:buzzy_bee/core/routes/app_routes.dart';
import 'package:buzzy_bee/features/wallet/presentation/widgets/add_funds_bottom_sheet.dart';
import 'package:buzzy_bee/features/wallet/domain/entities/wallet_transaction.dart';
import 'package:intl/intl.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.wallet, style: AppTypography.titleLarge(context)),
        elevation: 0,
      ),
      body: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state.paymentUrl != null && state.paymentUrl!.isNotEmpty) {
            _openPaymentWebView(context, state.paymentUrl!);
          }
        },
        listenWhen: (previous, current) =>
            previous.paymentUrl != current.paymentUrl,
        builder: (context, state) {
          if (state.status == WalletStatus.loading && state.wallet == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == WalletStatus.error && state.wallet == null) {
            return ErrorView(
              errorMessage: state.errorMessage,
              onRetry: () {
                context.read<WalletBloc>().add(const WalletLoadRequested());
              },
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<WalletBloc>().add(const WalletRefreshRequested());
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _BalanceCard(wallet: state.wallet),
                  const SizedBox(height: 24),

                  CustomElevatedButton(
                    isLoading: false,
                    buttonText: context.t.addFunds,
                    onPressed: () {
                      final walletBloc = context.read<WalletBloc>();
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => BlocProvider.value(
                          value: walletBloc,
                          child: const AddFundsBottomSheet(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  Text(
                    context.t.transactionHistory,
                    style: AppTypography.headlineSmall(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (state.isLoadingTransactions)
                    const Center(child: CircularProgressIndicator())
                  else if (state.transactions.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          context.t.noTransactions,
                          style: AppTypography.bodyMedium(
                            context,
                          ).copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    ...state.transactions.map(
                      (transaction) =>
                          _TransactionItem(transaction: transaction),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openPaymentWebView(
    BuildContext context,
    String paymentUrl,
  ) async {
    context.read<WalletBloc>().add(const WalletClearPaymentUrl());

    final success = await context.push<bool>(
      AppRoutes.moamalatWebview,
      extra: paymentUrl,
    );

    if (success == true) {
      final uri = Uri.tryParse(paymentUrl);
      final transactionId = uri?.pathSegments.lastOrNull ?? '';
      if (!context.mounted) {
        return;
      }

      context.read<WalletBloc>().add(WalletPaymentCompleted(transactionId));
      if (context.mounted) {
        context.showSnackBar(context.t.fundsAddedSuccessfully);
      }
    } else if (success == false && context.mounted) {
      context.pop();
      context.showErrorSnackBar(context.t.paymentFailed);
    }
  }
}

class _BalanceCard extends StatelessWidget {
  final Wallet? wallet;

  const _BalanceCard({this.wallet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.t.availableBalance,
            style: AppTypography.bodyMedium(
              context,
            ).copyWith(color: AppColors.textOnPrimary.withOpacity(0.9)),
          ),
          const SizedBox(height: 8),
          Text(
            '${wallet?.balance.toStringAsFixed(2) ?? '0.00'} ${context.t.currency}',
            style: AppTypography.headlineLarge(context).copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textOnPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final WalletTransaction transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isDeposit = transaction.type == WalletTransactionType.deposit;
    final isCompleted = transaction.status == WalletTransactionStatus.completed;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDeposit
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDeposit ? Icons.add : Icons.remove,
              color: isDeposit ? AppColors.success : AppColors.error,
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTransactionTypeText(context, transaction.type),
                  style: AppTypography.bodyLarge(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('yyyy-MM-dd HH:mm').format(transaction.createdAt),
                  style: AppTypography.bodySmall(
                    context,
                  ).copyWith(color: AppColors.textSecondary),
                ),
                if (transaction.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    transaction.description!,
                    style: AppTypography.bodySmall(
                      context,
                    ).copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isDeposit ? '+' : '-'}${transaction.amount.toStringAsFixed(2)} ${context.t.currency}',
                style: AppTypography.bodyLarge(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDeposit ? AppColors.success : AppColors.error,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getStatusText(context, transaction.status),
                  style: AppTypography.bodySmall(context).copyWith(
                    color: isCompleted ? AppColors.success : AppColors.warning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getTransactionTypeText(
    BuildContext context,
    WalletTransactionType type,
  ) {
    switch (type) {
      case WalletTransactionType.deposit:
        return context.t.deposit;
      case WalletTransactionType.withdrawal:
        return context.t.withdrawal;
      case WalletTransactionType.payment:
        return context.t.payment;
    }
  }

  String _getStatusText(BuildContext context, WalletTransactionStatus status) {
    switch (status) {
      case WalletTransactionStatus.pending:
        return context.t.pending;
      case WalletTransactionStatus.completed:
        return context.t.completed;
      case WalletTransactionStatus.failed:
        return context.t.failed;
      case WalletTransactionStatus.cancelled:
        return context.t.cancelled;
    }
  }
}
