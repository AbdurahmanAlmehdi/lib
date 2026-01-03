import 'package:dio/dio.dart';
import 'package:buzzy_bee/core/network/api_helper.dart';

abstract class CleanersRemoteDataSource {
  // Define your remote data source methods here
  // Example:
  // Future<List<CleanersModel>> getCleanerss();
}

class CleanersRemoteDataSourceImpl implements CleanersRemoteDataSource {
  final Dio _dio;

  CleanersRemoteDataSourceImpl(this._dio);

  // Implement your methods here using ApiHelper
  // Example:
  // @override
  // Future<List<CleanersModel>> getCleanerss() async {
  //   return await ApiHelper.call<List<CleanersModel>>(
  //     apiCall: () => _dio.get('/cleanerss'),
  //     successHandler: (response) async {
  //       final list = response.data as List;
  //       return list.map((e) => CleanersModel.fromJson(e)).toList();
  //     },
  //     operationName: 'Get Cleanerss',
  //   );
  // }
}
