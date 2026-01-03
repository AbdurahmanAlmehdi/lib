import 'package:buzzy_bee/core/network/repository_helper.dart';
import 'package:buzzy_bee/features/wallet/domain/entities/wallet.dart';
import 'package:buzzy_bee/features/wallet/domain/entities/wallet_transaction.dart';

abstract class WalletRepository {
  ResultFuture<Wallet> getWallet();
  ResultFuture<List<WalletTransaction>> getTransactions();
  ResultFuture<String> initiatePayment(double amount);
  ResultFuture<Wallet> chargeWallet(String transactionId);
  ResultFuture<Wallet> deductWallet(double amount, String description);
}
