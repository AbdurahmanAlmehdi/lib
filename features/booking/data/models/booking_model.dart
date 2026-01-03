import 'package:buzzy_bee/features/booking/domain/entities/booking.dart';
import 'package:buzzy_bee/features/booking/data/models/location_model.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.userId,
    required super.serviceId,
    required super.cleanerIds,
    required super.scheduledDate,
    required super.scheduledTime,
    required super.location,
    required super.status,
    required super.totalPrice,
    required super.createdAt,
    super.cancelledAt,
    super.cancellationReason,
  });

  factory BookingModel.fromEntity(Booking entity) {
    if (entity is BookingModel) {
      return entity;
    }
    return BookingModel(
      id: entity.id,
      userId: entity.userId,
      serviceId: entity.serviceId,
      cleanerIds: entity.cleanerIds,
      scheduledDate: entity.scheduledDate,
      scheduledTime: entity.scheduledTime,
      location: LocationModel.fromEntity(entity.location),
      status: entity.status,
      totalPrice: entity.totalPrice,
      createdAt: entity.createdAt,
      cancelledAt: entity.cancelledAt,
      cancellationReason: entity.cancellationReason,
    );
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      serviceId: json['service_id'] as String,
      cleanerIds: (json['cleaner_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      scheduledDate: DateTime.parse(json['scheduled_date'] as String),
      scheduledTime: json['scheduled_time'] as String,
      location: LocationModel.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
      status: _parseStatus(json['status'] as String),
      totalPrice: (json['total_price'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'] as String)
          : null,
      cancellationReason: json['cancellation_reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service_id': serviceId,
      'cleaner_ids': cleanerIds,
      'scheduled_date': scheduledDate.toIso8601String(),
      'scheduled_time': scheduledTime,
      'location': (location as LocationModel).toJson(),
      'status': status.name,
      'total_price': totalPrice,
      'created_at': createdAt.toIso8601String(),
      'cancelled_at': cancelledAt?.toIso8601String(),
      'cancellation_reason': cancellationReason,
    };
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
