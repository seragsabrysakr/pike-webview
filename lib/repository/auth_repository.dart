import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:picka/data/requests/update_user_token_request.dart';

import '../app/network/error_handler.dart';
import '../app/network/save_api.dart';
import '../data/storage/local/app_prefs.dart';
import '../data/storage/remote/auth_api_service.dart';

@injectable
class AuthRepository {
  final AuthServiceClient _appServiceClient;
  final SafeApi safeApi;
  final AppPreferences appPreferences;

  AuthRepository(
    this._appServiceClient,
    this.safeApi,
    this.appPreferences,
  );

  Future<Either<Failure, dynamic>> updateUserToken(UpdateUserTokenRequest request) async {
    Future<Either<Failure, dynamic>> data =
    safeApi.call(
        apiCall: _appServiceClient.updateUserToken(
            userID: request.userID,
            token: request.token
        ));
    return data;
  }

}
