import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/constants.dart';

@injectable
class AppPreferences {
  final String _isDarkMode = 'isDarkMode';
  final String _lang = 'lang';
  final String _isLogin = 'isLogin';
  final String _userToken = 'userToken';
  final String _firebaseToken = 'firebaseToken';
  final String _userData = 'userData';
  final String _isLanguageSelected = 'isLanguageSelected';

  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<bool> _putData(String key, dynamic value) async {
    if (value is String) return await _sharedPreferences.setString(key, value);
    if (value is int) return await _sharedPreferences.setInt(key, value);
    return await _sharedPreferences.setBool(key, value);
  }

  dynamic _getData(String key, dynamic def) {
    var value = _sharedPreferences.get(key);
    return value ?? def;
  }

  Future<bool> remove(String key) async {
    return await _sharedPreferences.remove(key);
  }

  String get lang => _getData(_lang, Constants.defaultLanguage);

  set lang(String value) {
    _putData(_lang, value);
  }

  bool get isDarkMode => _getData(_isDarkMode, false);

  set isDarkMode(bool value) {
    _putData(_isDarkMode, value);
  }


  String get firebaseToken => _getData(_firebaseToken, "");

  set firebaseToken(String value) {
    _putData(_firebaseToken, value);
  }



}
