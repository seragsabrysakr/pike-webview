import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:picka/app/api_urls.dart';

import '../../../data/storage/local/app_prefs.dart';
import '../../constants.dart';

const String applicationJson = "application/json";
const String contentType = "content-type";
const String accept = "accept";
const String acceptLanguage = ".aspnetcore.culture";
const String authorization = "authorization";

@module
abstract class DioModule {
  @preResolve
  @factoryMethod
  Future<Dio> getDio(AppPreferences _preferences) async {
    Dio dio = Dio();

    dio.updateHeader(_preferences);

    if (!kReleaseMode) {
      // its debug mode so print app logs
      dio.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
    }

    return dio;
  }
}

extension DioHeader on Dio {
  void updateHeader(AppPreferences preferences) {
    Map<String, String> headers = {
      contentType: applicationJson,
      accept: applicationJson,
      acceptLanguage: preferences.lang,
    };
    options = BaseOptions(
        baseUrl: ApiUrls.baseUrl,
        headers: headers,
        receiveTimeout: Constants.apiTimeOut,
        sendTimeout: Constants.apiTimeOut);
  }
}
