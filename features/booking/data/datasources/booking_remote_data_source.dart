import 'package:buzzy_bee/core/network/api_helper.dart';
import 'package:buzzy_bee/core/network/supabase_client.dart';
import 'package:buzzy_bee/features/booking/data/models/booking_model.dart';

import 'package:buzzy_bee/features/home/data/models/cleaner_model.dart';

abstract class BookingRemoteDataSource {
  Future<List<CleanerModel>> getAvailableCleaners({
    required DateTime date,
    required String serviceId,
    int count = 1,
  });
  Future<int> getAvailableCleanersCount({
    required DateTime date,
    required String serviceId,
  });
  Future<BookingModel> createBooking(BookingModel booking, String phoneNumber);
  Future<List<BookingModel>> getUserBookings();
  Future<BookingModel> cancelBooking(String bookingId, String? reason);
  Future<String> getUserPhone();
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final AppSupabaseClient _supabase;

  BookingRemoteDataSourceImpl(this._supabase);

  Future<Set<String>> _getBookedCleanerIds(DateTime date) async {
    try {
      final bookingsResponse = await _supabase.database
          .from('bookings')
          .select('id')
          .eq('scheduled_date', date.toIso8601String().split('T')[0])
          .or('status.eq.pending,status.eq.confirmed,status.eq.in_progress');

      final bookingIds =
          (bookingsResponse as List<dynamic>?)
              ?.map((e) => e['id'] as String)
              .toList() ??
          [];

      if (bookingIds.isEmpty) {
        return <String>{};
      }

      final bookedCleanersResponse = await _supabase.database
          .from('booking_cleaners')
          .select('cleaner_id')
          .inFilter('booking_id', bookingIds);

      final bookedCleanerIds =
          (bookedCleanersResponse as List<dynamic>?)
              ?.map((e) => e['cleaner_id'] as String)
              .toSet() ??
          <String>{};

      return bookedCleanerIds;
    } catch (e) {
      return <String>{};
    }
  }

  @override
  Future<List<CleanerModel>> getAvailableCleaners({
    required DateTime date,
    required String serviceId,
    int count = 1,
  }) async {
    try {
      final response = await _supabase.database
          .from('cleaner_services')
          .select('''
            cleaner_id,
            cleaners!inner(*)
          ''')
          .eq('service_id', serviceId);

      final bookedCleanerIds = await _getBookedCleanerIds(date);

      final List<dynamic> data = response as List<dynamic>;
      final cleaners = <CleanerModel>[];

      for (final item in data) {
        final cleanerData = item['cleaners'] as Map<String, dynamic>;
        final cleanerId = cleanerData['id'] as String;

        if (bookedCleanerIds.contains(cleanerId)) {
          continue;
        }

        final servicesResponse = await _supabase.database
            .from('cleaner_services')
            .select('service_id')
            .eq('cleaner_id', cleanerId);

        final serviceIds =
            (servicesResponse as List<dynamic>?)
                ?.map((e) => e['service_id'] as String)
                .toList() ??
            [];

        cleaners.add(
          CleanerModel.fromJson({...cleanerData, 'service_ids': serviceIds}),
        );

        if (cleaners.length >= count) {
          break;
        }
      }

      return cleaners;
    } catch (e) {
      throw ServerException('Failed to get available cleaners');
    }
  }

  @override
  Future<int> getAvailableCleanersCount({
    required DateTime date,
    required String serviceId,
  }) async {
    try {
      final response = await _supabase.database
          .from('cleaner_services')
          .select('cleaner_id')
          .eq('service_id', serviceId);

      final allCleanerIds = (response as List<dynamic>)
          .map((e) => e['cleaner_id'] as String)
          .toSet();

      final bookedCleanerIds = await _getBookedCleanerIds(date);

      final availableCount = allCleanerIds
          .where((id) => !bookedCleanerIds.contains(id))
          .length;

      return availableCount;
    } catch (e) {
      throw ServerException('Failed to get available cleaners count');
    }
  }

  @override
  Future<BookingModel> createBooking(
    BookingModel booking,
    String phoneNumber,
  ) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final bookingId = await _supabase.database.rpc(
        'create_booking_with_cleaners',
        params: {
          'p_service_id': booking.serviceId,
          'p_scheduled_date': booking.scheduledDate.toIso8601String().split(
            'T',
          )[0],
          'p_scheduled_time': booking.scheduledTime,
          'p_location_address': booking.location.address,
          'p_location_latitude': booking.location.latitude,
          'p_location_longitude': booking.location.longitude,
          'p_location_building_number': booking.location.buildingNumber,
          'p_location_apartment_number': booking.location.apartmentNumber,
          'p_location_notes': booking.location.notes,
          'p_phone_number': phoneNumber,
          'p_total_price': booking.totalPrice,
          'p_cleaner_ids': booking.cleanerIds,
        },
      );

      final locationData = {
        'id': 'location_$bookingId',
        'address': booking.location.address,
        'latitude': booking.location.latitude,
        'longitude': booking.location.longitude,
        'building_number': booking.location.buildingNumber,
        'apartment_number': booking.location.apartmentNumber,
        'notes': booking.location.notes,
        'is_default': false,
      };

      return BookingModel.fromJson({
        'id': bookingId,
        'user_id': user.id,
        'service_id': booking.serviceId,
        'scheduled_date': booking.scheduledDate.toIso8601String().split('T')[0],
        'scheduled_time': booking.scheduledTime,
        'location_address': booking.location.address,
        'location_latitude': booking.location.latitude,
        'location_longitude': booking.location.longitude,
        'location_building_number': booking.location.buildingNumber,
        'location_apartment_number': booking.location.apartmentNumber,
        'location_notes': booking.location.notes,
        'phone_number': phoneNumber,
        'status': 'pending',
        'total_price': booking.totalPrice,
        'created_at': DateTime.now().toIso8601String(),
        'location': locationData,
        'cleaner_ids': booking.cleanerIds,
      });
    } catch (e) {
      throw ServerException('Failed to create booking');
    }
  }

  @override
  Future<List<BookingModel>> getUserBookings() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        return [];
      }

      final response = await _supabase.database
          .from('bookings')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) {
        final locationData = {
          'id': 'location_${json['id']}',
          'address': json['location_address'],
          'latitude': json['location_latitude'],
          'longitude': json['location_longitude'],
          'building_number': json['location_building_number'],
          'apartment_number': json['location_apartment_number'],
          'notes': json['location_notes'],
          'is_default': false,
        };

        return BookingModel.fromJson(
          {...json, 'location': locationData, 'cleaner_ids': []}
              as Map<String, dynamic>,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<BookingModel> cancelBooking(String bookingId, String? reason) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.database
          .from('bookings')
          .update({
            'status': 'cancelled',
            'cancelled_at': DateTime.now().toIso8601String(),
            'cancellation_reason': reason,
          })
          .eq('id', bookingId)
          .eq('user_id', user.id)
          .select()
          .single();

      final locationData = {
        'id': 'location_$bookingId',
        'address': response['location_address'],
        'latitude': response['location_latitude'],
        'longitude': response['location_longitude'],
        'building_number': response['location_building_number'],
        'apartment_number': response['location_apartment_number'],
        'notes': response['location_notes'],
        'is_default': false,
      };

      return BookingModel.fromJson({
        ...response,
        'location': locationData,
        'cleaner_ids': [],
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> getUserPhone() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      final response = await _supabase.database
          .from('users')
          .select('phone')
          .eq('id', user.id)
          .single();

      return response['phone'] as String;
    } catch (e) {
      throw ServerException('Failed to get user phone');
    }
  }
}
