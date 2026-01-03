import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:buzzy_bee/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:buzzy_bee/features/wallet/domain/entities/wallet.dart';
import 'package:buzzy_bee/features/wallet/domain/entities/wallet_transaction.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository _repository;

  WalletBloc(this._repository) : super(const WalletState.initial()) {
    on<WalletLoadRequested>(_onLoadRequested);
    on<WalletTransactionsLoadRequested>(_onTransactionsLoadRequested);
    on<WalletAddFundsRequested>(_onAddFundsRequested);
    on<WalletPaymentCompleted>(_onPaymentCompleted);
    on<WalletRefreshRequested>(_onRefreshRequested);
    on<WalletClearPaymentUrl>(_onClearPaymentUrl);
  }

  Future<void> _onLoadRequested(
    WalletLoadRequested event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(status: WalletStatus.loading));

    final result = await _repository.getWallet();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: WalletStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (wallet) => emit(
        state.copyWith(
          status: WalletStatus.success,
          wallet: wallet,
        ),
      ),
    );
  }

  Future<void> _onTransactionsLoadRequested(
    WalletTransactionsLoadRequested event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(isLoadingTransactions: true));

    final result = await _repository.getTransactions();

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingTransactions: false,
          errorMessage: failure.message,
        ),
      ),
      (transactions) => emit(
        state.copyWith(
          isLoadingTransactions: false,
          transactions: transactions,
        ),
      ),
    );
  }

  Future<void> _onAddFundsRequested(
    WalletAddFundsRequested event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(status: WalletStatus.loading));

    final result = await _repository.initiatePayment(event.amount);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: WalletStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (paymentUrl) {
        // Store payment URL for UI to open webview
        // Create a pending transaction first
        emit(
          state.copyWith(
            status: WalletStatus.success,
            paymentUrl: paymentUrl,
          ),
        );
      },
    );
  }

  Future<void> _onPaymentCompleted(
    WalletPaymentCompleted event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(status: WalletStatus.loading));

    final result = await _repository.chargeWallet(event.transactionId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: WalletStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (wallet) {
        emit(
          state.copyWith(
            status: WalletStatus.success,
            wallet: wallet,
          ),
        );
        // Reload transactions
        add(const WalletTransactionsLoadRequested());
      },
    );
  }

  Future<void> _onRefreshRequested(
    WalletRefreshRequested event,
    Emitter<WalletState> emit,
  ) async {
    add(const WalletLoadRequested());
    add(const WalletTransactionsLoadRequested());
  }

  void _onClearPaymentUrl(
    WalletClearPaymentUrl event,
    Emitter<WalletState> emit,
  ) {
    emit(state.copyWith(paymentUrl: null));
  }
}

