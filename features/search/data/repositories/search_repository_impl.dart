import 'package:buzzy_bee/core/network/repository_helper.dart';
import 'package:buzzy_bee/features/search/data/datasources/search_remote_data_source.dart';
import 'package:buzzy_bee/features/search/domain/repositories/search_repository.dart';
import 'package:buzzy_bee/features/search/domain/entities/search_result.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;

  SearchRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<List<SearchResult>> search(String query) async {
    return await RepositoryHelper.execute(
      operation: () async {
        final models = await _remoteDataSource.search(query);
        return models.map((model) => model.toEntity()).toList();
      },
      operationName: 'Search',
    );
  }
}

