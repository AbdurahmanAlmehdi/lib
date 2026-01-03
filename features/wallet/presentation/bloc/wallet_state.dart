part of 'wallet_bloc.dart';

enum WalletStatus {
  initial,
  loading,
  success,
  error,
}

class WalletState extends Equatable {
  final WalletStatus status;
  final Wallet? wallet;
  final List<WalletTransaction> transactions;
  final String? errorMessage;
  final bool isLoadingTransactions;
  final String? paymentUrl;

  const WalletState({
    required this.status,
    this.wallet,
    this.transactions = const [],
    this.errorMessage,
    this.isLoadingTransactions = false,
    this.paymentUrl,
  });

  const WalletState.initial()
      : status = WalletStatus.initial,
        wallet = null,
        transactions = const [],
        errorMessage = null,
        isLoadingTransactions = false,
        paymentUrl = null;

  WalletState copyWith({
    WalletStatus? status,
    Wallet? wallet,
    List<WalletTransaction>? transactions,
    String? errorMessage,
    bool? isLoadingTransactions,
    String? paymentUrl,
  }) {
    return WalletState(
      status: status ?? this.status,
      wallet: wallet ?? this.wallet,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoadingTransactions: isLoadingTransactions ?? this.isLoadingTransactions,
      paymentUrl: paymentUrl ?? this.paymentUrl,
    );
  }

  @override
  List<Object?> get props => [
        status,
        wallet,
        transactions,
        errorMessage,
        isLoadingTransactions,
        paymentUrl,
      ];
}

