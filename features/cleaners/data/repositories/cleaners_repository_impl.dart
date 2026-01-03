import 'package:dartz/dartz.dart';
import 'package:buzzy_bee/core/network/repository_helper.dart';
import 'package:buzzy_bee/features/cleaners/data/datasources/cleaners_remote_data_source.dart';
import 'package:buzzy_bee/features/cleaners/domain/repositories/cleaners_repository.dart';

class CleanersRepositoryImpl implements CleanersRepository {
  final CleanersRemoteDataSource _remoteDataSource;

  CleanersRepositoryImpl(this._remoteDataSource);

  
  // Example implementation with dartz Either:
  // @override
  // ResultFuture<List<CleanersEntity>> getCleanerss() async {
  //   return await RepositoryHelper.execute(
  //     operation: () async {
  //       final models = await _remoteDataSource.getCleanerss();
  //       return models.map((model) => model.toEntity()).toList();
  //     },
  //     operationName: 'Get Cleanerss',
  //   );
  // }
  
  
}
