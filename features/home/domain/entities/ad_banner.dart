import 'package:equatable/equatable.dart';

class AdBanner extends Equatable {
  final String id;
  final String imageUrl;
  final String? actionUrl;
  final String? actionType;
  final String? actionId;
  final int priority;
  final DateTime? expiresAt;

  const AdBanner({
    required this.id,
    required this.imageUrl,
    this.actionUrl,
    this.actionType,
    this.actionId,
    required this.priority,
    this.expiresAt,
  });

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  @override
  List<Object?> get props => [
    id,
    imageUrl,
    actionUrl,
    actionType,
    actionId,
    priority,
    expiresAt,
  ];
}
