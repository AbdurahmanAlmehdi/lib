import 'package:dartz/dartz.dart';
import 'package:buzzy_bee/core/network/api_helper.dart';


typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultVoid = Future<Either<Failure, void>>;


abstract class Failure {
  final String message;
  final String? code;
  final dynamic data;

  const Failure(this.message, {this.code, this.data});

  @override
  String toString() => 'Failure: $message${code != null ? ' ($code)' : ''}';
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code, super.data});
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code, super.data});
}

class FailureHandler {
  const FailureHandler._();

  static Failure handle(ServerException error, [String? operationName]) {
    if (error is NoInternetException) {
      return NetworkFailure(
        error.message,
        code: 'NO_INTERNET',
      );
    }

    if (error is TimeoutException) {
      return NetworkFailure(
        error.message,
        code: 'TIMEOUT',
      );
    }

    if (error is ApiException) {
      return ServerFailure(
        error.message,
        code: error.statusCode?.toString(),
        data: error.data,
      );
    }

    return ServerFailure(
      error.message,
      data: error.data,
    );
  }
}


class RepositoryHelper {
  const RepositoryHelper._();

  static ResultFuture<T> execute<T>({
    required Future<T> Function() operation,
    ResultFuture<T> Function(ServerException e)? onError,
    required String operationName,
  }) async {
    try {
      final result = await operation();
      return right(result);
    } on ServerException catch (e) {
      if (onError != null) {
        return await onError(e);
      }
      return left(FailureHandler.handle(e, operationName));
    } catch (e) {
      final error = ExceptionHandler.handle(e, operationName);
      if (onError != null) {
        return await onError(error);
      }

      return left(FailureHandler.handle(error, operationName));
    }
  }

  static ResultVoid executeVoid({
    required Future<void> Function() operation,
    required String operationName,
  }) async {
    return execute<void>(
      operation: operation,
      operationName: operationName,
    );
  }
}

