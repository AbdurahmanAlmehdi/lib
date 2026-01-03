import 'package:equatable/equatable.dart';
import 'package:buzzy_bee/features/booking/domain/entities/booking.dart';
import 'package:buzzy_bee/features/home/domain/entities/cleaner.dart';

class Order extends Equatable {
  final String id;
  final String userId;
  final String serviceId;
  final String serviceName;
  final Cleaner cleaner;
  final DateTime scheduledDate;
  final String scheduledTime;
  final BookingStatus status;
  final double totalPrice;
  final DateTime createdAt;
  final double? rating;
  final String? review;

  const Order({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.serviceName,
    required this.cleaner,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    this.rating,
    this.review,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        serviceId,
        serviceName,
        cleaner,
        scheduledDate,
        scheduledTime,
        status,
        totalPrice,
        createdAt,
        rating,
        review,
      ];
}

enum OrderFilter {
  all,
  inProgress,
  completed,
  cancelled,
}

