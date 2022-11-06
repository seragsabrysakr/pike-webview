import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'error_handler.dart';
import 'network_info.dart';

@injectable
class SafeApi {
  final NetworkInfo _networkInfo;

  SafeApi(this._networkInfo);

  Future<Either<Failure, T>> call<T, M>(
      {required Future<dynamic> apiCall}) async {
    if (await _networkInfo.isConnected) {
      try {
        // its safe to call API
        final response = await apiCall;
        return Right(response);
      } catch (error, stacktrace) {
        debugPrint("SafeApi Error: $error");
        debugPrint("$stacktrace");
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return network connection error
      // return left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
