import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:picka/app/api_urls.dart';

part 'auth_api_service.g.dart';

@RestApi(baseUrl: ApiUrls.baseUrl)
abstract class AuthServiceClient {
  factory AuthServiceClient(Dio dio, {String baseUrl}) = _AuthServiceClient;

  @FormUrlEncoded()
  @POST(ApiUrls.updateUserToken)
  Future<dynamic> updateUserToken({
    @Field("userID") required String userID,
    @Field("Token") required String token
  });


}
