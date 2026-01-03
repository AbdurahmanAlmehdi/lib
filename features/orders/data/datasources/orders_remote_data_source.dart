import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:buzzy_bee/features/orders/data/models/order_model.dart';
import 'package:buzzy_bee/features/home/data/models/cleaner_model.dart';
import 'package:buzzy_bee/features/booking/domain/entities/booking.dart';

abstract class OrdersRemoteDataSource {
  Future<List<OrderModel>> getOrders();
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final SupabaseClient _client;

  OrdersRemoteDataSourceImpl(this._client);

  @override
  Future<List<OrderModel>> getOrders() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      return [];
    }

    final response = await _client
        .from('bookings')
        .select('''
          *,
          services!inner(name_ar, name_en),
          booking_cleaners(
            cleaners(*, cleaner_services(service_id))
          )
        ''')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    final List<dynamic> data = response as List<dynamic>;

    return data.map((json) {
      final serviceData = json['services'] as Map<String, dynamic>?;
      final serviceName = serviceData?['name_ar'] as String? ?? 'Service';

      final bookingCleaners = json['booking_cleaners'] as List<dynamic>? ?? [];
      CleanerModel? firstCleaner;

      if (bookingCleaners.isNotEmpty) {
        final cleanerData =
            bookingCleaners.first['cleaners'] as Map<String, dynamic>?;
        if (cleanerData != null) {
          firstCleaner = CleanerModel.fromJson(cleanerData);
        }
      }

      firstCleaner ??= CleanerModel(
        id: '',
        name: '-',
        avatarUrl: '',
        rating: 0,
        reviewsCount: 0,
        serviceIds: [],
        completedJobs: 0,
        joinedDate: DateTime.now(),
      );

      return OrderModel(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        serviceId: json['service_id'] as String,
        serviceName: serviceName,
        cleaner: firstCleaner,
        scheduledDate: DateTime.parse(json['scheduled_date'] as String),
        scheduledTime: json['scheduled_time'] as String,
        status: _parseStatus(json['status'] as String),
        totalPrice: (json['total_price'] as num).toDouble(),
        createdAt: DateTime.parse(json['created_at'] as String),
        rating: null,
        review: null,
      );
    }).toList();
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
