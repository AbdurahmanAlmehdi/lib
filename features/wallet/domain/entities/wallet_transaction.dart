import 'package:equatable/equatable.dart';

enum WalletTransactionType {
  deposit,
  withdrawal,
  payment,
}

enum WalletTransactionStatus {
  pending,
  completed,
  failed,
  cancelled,
}

class WalletTransaction extends Equatable {
  final String id;
  final String walletId;
  final double amount;
  final WalletTransactionType type;
  final WalletTransactionStatus status;
  final String? referenceId;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const WalletTransaction({
    required this.id,
    required this.walletId,
    required this.amount,
    required this.type,
    required this.status,
    this.referenceId,
    this.description,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        walletId,
        amount,
        type,
        status,
        referenceId,
        description,
        createdAt,
        updatedAt,
      ];
}

