import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:picka/data/storage/remote/auth_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


@module
abstract class DIModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  InternetConnectionChecker get connectionChecker =>
      InternetConnectionChecker();

  AuthServiceClient getService(Dio client) => AuthServiceClient(client);

  Key getKey() => UniqueKey();
}
