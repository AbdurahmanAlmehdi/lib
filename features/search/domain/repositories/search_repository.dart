import 'package:buzzy_bee/core/network/repository_helper.dart';
import 'package:buzzy_bee/features/search/domain/entities/search_result.dart';

abstract class SearchRepository {
  ResultFuture<List<SearchResult>> search(String query);
}
