import 'package:buzzy_bee/features/orders/domain/entities/order.dart';
import 'package:buzzy_bee/features/home/data/models/cleaner_model.dart';
import 'package:buzzy_bee/features/booking/domain/entities/booking.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.serviceId,
    required super.serviceName,
    required super.cleaner,
    required super.scheduledDate,
    required super.scheduledTime,
    required super.status,
    required super.totalPrice,
    required super.createdAt,
    super.rating,
    super.review,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      serviceId: json['service_id'] as String,
      serviceName: json['service_name'] as String? ?? 'Service',
      cleaner: CleanerModel.fromJson(json['cleaner'] as Map<String, dynamic>),
      scheduledDate: DateTime.parse(json['scheduled_date'] as String),
      scheduledTime: json['scheduled_time'] as String,
      status: _parseStatus(json['status'] as String),
      totalPrice: (json['total_price'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      review: json['review'] as String?,
    );
  }

  static BookingStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return BookingStatus.pending;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'in_progress':
        return BookingStatus.inProgress;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.pending;
    }
  }
}

