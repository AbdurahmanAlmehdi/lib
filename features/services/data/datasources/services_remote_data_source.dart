import 'package:buzzy_bee/core/network/api_helper.dart';
import 'package:buzzy_bee/core/network/supabase_client.dart';
import 'package:buzzy_bee/features/services/data/models/service_model.dart';

abstract class ServicesRemoteDataSource {
  Future<List<ServiceModel>> getServices();
  Future<ServiceModel?> getServiceById(String id);
}

class ServicesRemoteDataSourceImpl implements ServicesRemoteDataSource {
  final AppSupabaseClient _supabase;

  ServicesRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<ServiceModel>> getServices() async {
    try {
      final response = await _supabase.database
          .from('services')
          .select()
          .eq('is_active', true)
          .order('display_order', ascending: true);

      final List<dynamic> data = response as List<dynamic>;
      return data
          .map((json) => ServiceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get services');
    }
  }

  @override
  Future<ServiceModel?> getServiceById(String id) async {
    try {
      final response = await _supabase.database
          .from('services')
          .select()
          .eq('id', id)
          .eq('is_active', true)
          .single();

      return ServiceModel.fromJson(response);
    } catch (_) {
      return null;
    }
  }
}
