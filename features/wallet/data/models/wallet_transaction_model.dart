import 'package:buzzy_bee/features/wallet/domain/entities/wallet_transaction.dart';

class WalletTransactionModel extends WalletTransaction {
  const WalletTransactionModel({
    required super.id,
    required super.walletId,
    required super.amount,
    required super.type,
    required super.status,
    super.referenceId,
    super.description,
    required super.createdAt,
    super.updatedAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'] as String,
      walletId: json['wallet_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: _parseType(json['type'] as String),
      status: _parseStatus(json['status'] as String),
      referenceId: json['reference_id'] as String?,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  static WalletTransactionType _parseType(String type) {
    switch (type) {
      case 'deposit':
        return WalletTransactionType.deposit;
      case 'withdrawal':
        return WalletTransactionType.withdrawal;
      case 'payment':
        return WalletTransactionType.payment;
      default:
        return WalletTransactionType.deposit;
    }
  }

  static WalletTransactionStatus _parseStatus(String status) {
    switch (status) {
      case 'pending':
        return WalletTransactionStatus.pending;
      case 'completed':
        return WalletTransactionStatus.completed;
      case 'failed':
        return WalletTransactionStatus.failed;
      case 'cancelled':
        return WalletTransactionStatus.cancelled;
      default:
        return WalletTransactionStatus.pending;
    }
  }

  String get typeString {
    switch (type) {
      case WalletTransactionType.deposit:
        return 'deposit';
      case WalletTransactionType.withdrawal:
        return 'withdrawal';
      case WalletTransactionType.payment:
        return 'payment';
    }
  }

  String get statusString {
    switch (status) {
      case WalletTransactionStatus.pending:
        return 'pending';
      case WalletTransactionStatus.completed:
        return 'completed';
      case WalletTransactionStatus.failed:
        return 'failed';
      case WalletTransactionStatus.cancelled:
        return 'cancelled';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wallet_id': walletId,
      'amount': amount,
      'type': typeString,
      'status': statusString,
      'reference_id': referenceId,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}

class WalletTransactionDetailsModel {
  final String key;
  final String value;

  WalletTransactionDetailsModel({
    required this.key,
    required this.value,
  });

  factory WalletTransactionDetailsModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionDetailsModel(
      key: json['key'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }
}
