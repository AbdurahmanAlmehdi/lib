import 'package:buzzy_bee/core/network/repository_helper.dart';
import 'package:buzzy_bee/features/wallet/data/datasources/wallet_remote_data_source.dart';
import 'package:buzzy_bee/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:buzzy_bee/features/wallet/domain/entities/wallet.dart';
import 'package:buzzy_bee/features/wallet/domain/entities/wallet_transaction.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource _remoteDataSource;

  WalletRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<Wallet> getWallet() async {
    return await RepositoryHelper.execute(
      operation: () async {
        final model = await _remoteDataSource.getWallet();
        return model;
      },
      operationName: 'Get Wallet',
    );
  }

  @override
  ResultFuture<List<WalletTransaction>> getTransactions() async {
    return await RepositoryHelper.execute(
      operation: () async {
        final models = await _remoteDataSource.getTransactions();
        return models;
      },
      operationName: 'Get Wallet Transactions',
    );
  }

  @override
  ResultFuture<String> initiatePayment(double amount) async {
    return await RepositoryHelper.execute(
      operation: () async {
        return await _remoteDataSource.initiatePayment(amount);
      },
      operationName: 'Initiate Payment',
    );
  }

  @override
  ResultFuture<Wallet> chargeWallet(String transactionId) async {
    return await RepositoryHelper.execute(
      operation: () async {
        final model = await _remoteDataSource.chargeWallet(transactionId);
        return model;
      },
      operationName: 'Charge Wallet',
    );
  }

  @override
  ResultFuture<Wallet> deductWallet(double amount, String description) async {
    return await RepositoryHelper.execute(
      operation: () async {
        final model = await _remoteDataSource.deductWallet(amount, description);
        return model;
      },
      operationName: 'Deduct Wallet',
    );
  }
}
