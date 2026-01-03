import 'package:buzzy_bee/core/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart' hide TextDirection;
import 'package:flutter/material.dart' as material show TextDirection;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:go_router/go_router.dart';

class AddFundsBottomSheet extends StatefulWidget {
  const AddFundsBottomSheet({super.key});

  @override
  State<AddFundsBottomSheet> createState() => _AddFundsBottomSheetState();
}

class _AddFundsBottomSheetState extends State<AddFundsBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  final List<double> _quickAmounts = [1, 50, 100, 200];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onQuickAmountTap(double amount) {
    setState(() {
      _amountController.text = amount.toStringAsFixed(0);
    });
  }

  void _onAddFunds() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      context.showSnackBar(context.t.pleaseEnterValidAmount);
      return;
    }

    context.read<WalletBloc>().add(WalletAddFundsRequested(amount));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state.status == WalletStatus.error) {
          if (context.mounted) {
            context.pop();
            context.showErrorSnackBar(
              state.errorMessage ?? context.t.errorAddingFunds,
            );
          }
        }
      },
      child: Directionality(
        textDirection: material.TextDirection.rtl,
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  Text(
                    context.t.addFunds,
                    style: AppTypography.headlineSmall(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  Text(
                    context.t.quickAmounts,
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: _quickAmounts.map((amount) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: OutlinedButton(
                            onPressed: () => _onQuickAmountTap(amount),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              '${amount.toStringAsFixed(0)} ',
                              style: AppTypography.titleSmall(
                                context,
                              ).copyWith(color: AppColors.textPrimary),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    context.t.amount,
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    textDirection: material.TextDirection.ltr,
                    textAlign: TextAlign.left,
                    style: AppTypography.bodyLarge(
                      context,
                    ).copyWith(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: '0.00',
                      hintStyle: AppTypography.bodyLarge(
                        context,
                      ).copyWith(color: AppColors.textDisabled),
                      suffixText: context.t.currency,
                      suffixStyle: AppTypography.bodyLarge(
                        context,
                      ).copyWith(color: AppColors.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.t.pleaseEnterAmount;
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return context.t.pleaseEnterValidAmount;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  BlocBuilder<WalletBloc, WalletState>(
                    builder: (context, state) {
                      final isLoading = state.status == WalletStatus.loading;

                      return CustomElevatedButton(
                        onPressed: isLoading ? null : _onAddFunds,
                        isLoading: isLoading,
                        buttonText: context.t.addFunds,
                      );
                    },
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
