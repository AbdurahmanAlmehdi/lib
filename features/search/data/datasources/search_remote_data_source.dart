import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:buzzy_bee/features/search/data/models/search_result_model.dart';
import 'package:buzzy_bee/features/services/data/models/service_model.dart';
import 'package:buzzy_bee/features/home/data/models/cleaner_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchResultModel>> search(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final SupabaseClient _client;

  SearchRemoteDataSourceImpl(this._client);

  @override
  Future<List<SearchResultModel>> search(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final searchTerm = '%$query%';
    final results = <SearchResultModel>[];

    try {
      final servicesResponse = await _client
          .from('services')
          .select()
          .eq('is_active', true)
          .or('name_ar.ilike.$searchTerm,name_en.ilike.$searchTerm')
          .limit(10);

      final services = (servicesResponse as List<dynamic>)
          .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList();

      for (final service in services) {
        results.add(SearchResultModel.service(service));
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      final cleanersResponse = await _client
          .from('cleaners')
          .select('*, cleaner_services(service_id)')
          .eq('is_active', true)
          .ilike('name', searchTerm)
          .limit(10);

      final cleaners = (cleanersResponse as List<dynamic>)
          .map((e) => CleanerModel.fromJson(e as Map<String, dynamic>))
          .toList();

      for (final cleaner in cleaners) {
        results.add(SearchResultModel.cleaner(cleaner));
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return results;
  }
}
