import 'package:dio/dio.dart';
import 'package:haru_admin/utils/secure_storage.dart';

class DioClient {
  factory DioClient() => _instance;
  DioClient._();

  static final DioClient _instance = DioClient._();

  Dio provideDio() {
    final Dio dio = Dio(BaseOptions(
      baseUrl: "https://www.haruhangeul.com/admin",
      contentType: 'application/json',
    ));

    dio.interceptors.add(AuthInterceptor());
    return dio;
  }
}

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print(
        'REQUEST[${options.method}] => PATH: ${options.uri.path}, \n\tHEADER: ${options.headers}\n\tDATA: ${options.data}\n');

    if (options.path.startsWith('/login') ||
        options.path.startsWith('/signup') ||
        options.path.startsWith('/id-validate')) {
      return super.onRequest(options, handler);
    } else {
      final String? userToken = await SecureStorage().getAccessToken();
      if (userToken == null) {
        handler.reject(DioException(requestOptions: options));
        print('토큰이 없습니다.');
      } else {
        options.headers['Authorization'] = userToken;
      }
      return super.onRequest(options, handler);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.uri.path}, \n\tBODY: ${response.data}\n',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
      'ERROR[${err.response}] => PATH: ${err.requestOptions.uri.path}\n',
    );
    super.onError(err, handler);
  }
}
