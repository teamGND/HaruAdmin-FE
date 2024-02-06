import 'package:dio/dio.dart';

class CustomLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print(
        'REQUEST[${options.method}] => PATH: ${options.path}, \n\tHEADER: ${options.headers}\n\tDATA: ${options.data}\n');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}, \n\tBODY: ${response.data}\n',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 400) {
      print(
          'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}\n');
      print('DATA : ${err.response?.data}\n');

      print('잘못된 요청입니다.');
      return;
    }
    if (err.response?.statusCode == 401) {
      print(
          'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}\n');
      print('로그인이 필요합니다.');
      return;
    }
    if (err.response?.statusCode == 500) {
      print(
          'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}\n');
      print('서버 오류입니다.');
      return;
    }

    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}\n',
    );
    super.onError(err, handler);
  }
}
