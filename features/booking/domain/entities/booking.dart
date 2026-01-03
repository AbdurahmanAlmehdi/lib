import 'package:equatable/equatable.dart';
import 'package:buzzy_bee/features/booking/domain/entities/location.dart';

enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
}

class Booking extends Equatable {
  final String id;
  final String userId;
  final String serviceId;
  final List<String> cleanerIds;
  final DateTime scheduledDate;
  final String scheduledTime;
  final Location location;
  final BookingStatus status;
  final double totalPrice;
  final DateTime createdAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;

  const Booking({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.cleanerIds,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.location,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    this.cancelledAt,
    this.cancellationReason,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        serviceId,
        cleanerIds,
        scheduledDate,
        scheduledTime,
        location,
        status,
        totalPrice,
        createdAt,
        cancelledAt,
        cancellationReason,
      ];
}

