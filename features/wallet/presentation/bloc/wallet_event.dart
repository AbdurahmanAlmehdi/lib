part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class WalletLoadRequested extends WalletEvent {
  const WalletLoadRequested();
}

class WalletTransactionsLoadRequested extends WalletEvent {
  const WalletTransactionsLoadRequested();
}

class WalletAddFundsRequested extends WalletEvent {
  final double amount;

  const WalletAddFundsRequested(this.amount);

  @override
  List<Object?> get props => [amount];
}

class WalletPaymentCompleted extends WalletEvent {
  final String transactionId;

  const WalletPaymentCompleted(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}

class WalletRefreshRequested extends WalletEvent {
  const WalletRefreshRequested();
}

class WalletClearPaymentUrl extends WalletEvent {
  const WalletClearPaymentUrl();
}

