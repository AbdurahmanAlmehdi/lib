import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  final String id;
  final String userId;
  final double balance;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Wallet({
    required this.id,
    required this.userId,
    required this.balance,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, userId, balance, createdAt, updatedAt];
}

