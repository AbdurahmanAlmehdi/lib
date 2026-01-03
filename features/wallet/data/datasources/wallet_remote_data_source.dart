import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:buzzy_bee/core/network/supabase_client.dart';
import 'package:buzzy_bee/core/network/api_helper.dart';
import 'package:buzzy_bee/features/wallet/data/models/wallet_model.dart';
import 'package:buzzy_bee/features/wallet/data/models/wallet_transaction_model.dart';
import 'package:buzzy_bee/features/wallet/domain/entities/wallet_transaction.dart';

abstract class WalletRemoteDataSource {
  Future<WalletModel> getWallet();
  Future<List<WalletTransactionModel>> getTransactions();
  Future<String> initiatePayment(double amount);
  Future<WalletModel> chargeWallet(String transactionId);
  Future<WalletModel> deductWallet(double amount, String description);
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final AppSupabaseClient _supabase;
  final Dio _dio;

  WalletRemoteDataSourceImpl(this._supabase, this._dio);

  @override
  Future<WalletModel> getWallet() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      final response = await _supabase.database
          .from('wallets')
          .select()
          .eq('user_id', user.id)
          .single();

      return WalletModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get wallet');
    }
  }

  @override
  Future<List<WalletTransactionModel>> getTransactions() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      final walletResponse = await _supabase.database
          .from('wallets')
          .select('id')
          .eq('user_id', user.id)
          .single();

      final walletId = walletResponse['id'] as String;

      final response = await _supabase.database
          .from('wallet_transactions')
          .select()
          .eq('wallet_id', walletId)
          .order('created_at', ascending: false)
          .limit(50);

      return (response as List<dynamic>)
          .map(
            (e) => WalletTransactionModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw ServerException('Failed to get transactions');
    }
  }

  @override
  Future<String> initiatePayment(double amount) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      final walletResponse = await _supabase.database
          .from('wallets')
          .select('id')
          .eq('user_id', user.id)
          .single();

      final walletId = walletResponse['id'] as String;

      final transactionResponse = await _supabase.database
          .from('wallet_transactions')
          .insert({
            'wallet_id': walletId,
            'amount': amount,
            'type': 'deposit',
            'status': 'pending',
            'reference_id': DateTime.now().millisecondsSinceEpoch.toString(),
            'description': 'إضافة أموال عبر معاملات',
          })
          .select()
          .single();

      final transactionId = transactionResponse['id'] as String;

      final response = await _dio.post(
        '/api/moamalat-mataa/initiate',
        data: {'amount': amount, 'odooOwnerId': '100440'},
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        final data = response.data['data'];
        final moamalatTransactionId = data['id'];

        final transactionData = List.from(
          data['transactionDetailDtos'] ?? [],
        ).map((e) => WalletTransactionDetailsModel.fromJson(e ?? {}));

        final paymentUrl = transactionData
            .firstWhereOrNull((e) => e.key == 'url')
            ?.value;

        if (paymentUrl == null) {
          throw ServerException('Payment URL not found in response');
        }

        final referenceId = moamalatTransactionId != null
            ? moamalatTransactionId.toString()
            : transactionId;

        await _supabase.database
            .from('wallet_transactions')
            .update({'reference_id': referenceId})
            .eq('id', transactionId);

        return paymentUrl;
      } else {
        await _supabase.database
            .from('wallet_transactions')
            .delete()
            .eq('id', transactionId);
        throw ServerException('Failed to initiate payment');
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(e.message ?? 'Failed to initiate payment');
      }
      throw ServerException('Failed to initiate payment');
    }
  }

  @override
  Future<WalletModel> chargeWallet(String transactionId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      final walletResponse = await _supabase.database
          .from('wallets')
          .select('id')
          .eq('user_id', user.id)
          .single();

      final walletId = walletResponse['id'] as String;

      Map<String, dynamic> transactionResponse;
      try {
        transactionResponse = await _supabase.database
            .from('wallet_transactions')
            .select()
            .eq('wallet_id', walletId)
            .eq('reference_id', transactionId)
            .single();
      } catch (e) {
        try {
          transactionResponse = await _supabase.database
              .from('wallet_transactions')
              .select()
              .eq('wallet_id', walletId)
              .eq('id', transactionId)
              .single();
        } catch (e2) {
          throw ServerException('Transaction not found');
        }
      }

      final transaction = WalletTransactionModel.fromJson(transactionResponse);

      if (transaction.status == WalletTransactionStatus.completed) {
        final walletResponse = await _supabase.database
            .from('wallets')
            .select()
            .eq('id', walletId)
            .single();
        return WalletModel.fromJson(walletResponse);
      }

      await _supabase.database
          .from('wallet_transactions')
          .update({'status': 'completed'})
          .eq('id', transaction.id);

      final currentWalletResponse = await _supabase.database
          .from('wallets')
          .select()
          .eq('id', walletId)
          .single();

      final currentWallet = WalletModel.fromJson(currentWalletResponse);

      final updatedWalletResponse = await _supabase.database
          .from('wallets')
          .update({'balance': currentWallet.balance + transaction.amount})
          .eq('id', walletId)
          .select()
          .single();

      return WalletModel.fromJson(updatedWalletResponse);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Failed to charge wallet: ${e.toString()}');
    }
  }

  @override
  Future<WalletModel> deductWallet(double amount, String description) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      final walletResponse = await _supabase.database
          .from('wallets')
          .select()
          .eq('user_id', user.id)
          .single();

      final currentWallet = WalletModel.fromJson(walletResponse);
      final walletId = currentWallet.id;

      if (currentWallet.balance < amount) {
        throw ServerException('Insufficient wallet balance');
      }

      await _supabase.database.from('wallet_transactions').insert({
        'wallet_id': walletId,
        'amount': amount,
        'type': 'payment',
        'status': 'completed',
        'description': description,
      });

      final updatedWalletResponse = await _supabase.database
          .from('wallets')
          .update({'balance': currentWallet.balance - amount})
          .eq('id', walletId)
          .select()
          .single();

      return WalletModel.fromJson(updatedWalletResponse);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Failed to deduct from wallet: ${e.toString()}');
    }
  }
}
