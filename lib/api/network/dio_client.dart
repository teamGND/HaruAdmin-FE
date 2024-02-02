import 'package:dio/dio.dart';

class DioClient {
  factory DioClient() => _instance;
  DioClient._();

  static final DioClient _instance = DioClient._();

  Dio provideDio() {
    final Dio dio = Dio(BaseOptions(baseUrl: "https://www.haruhangeul.com"));
    return dio;
  }
}

// class AuthInterceptor extends Interceptor {
//   @override
//   Future<void> onRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     // 인증이 필요 없는 API 인 경우
//     if (options.uri.path.startsWith('/login') ||
//         options.uri.path.startsWith('/signup')) {
//       return super.onRequest(options, handler);
//     }

//     // storage로부터 토큰을 가져온다.
//     final String? userToken = await SecureStorage().getAccessToken();

//     // 토큰이 없으면 reject
//     if (userToken == null) {
//       handler.reject(DioException(requestOptions: options));
//     }

    // TODO - 세션 방법으로 해야됨. 밑에는 refreshtoken jwt 방법임

    //   // 토큰 유효성 검증. 백엔드와 상의. 보통 JWT 안에는 만료시간이 있음.
    //   if (checkIsTokenValid(userToken!)) {
    //     return super.onRequest(
    //       options..headers['Authorization'] = 'Bearer $userToken',
    //       handler,
    //     );
    //   }

    //   // 토큰 갱신 및 다시 request
    //   await _handleRefreshAuth(options, handler);
    // }

    // @override
    // void onError(
    //   DioException err,
    //   ErrorInterceptorHandler handler,
    // ) {
    //   // 에러 처리. 일단 따로 필요 X
    // }

    // bool checkIsTokenValid(String userToken) {
    //   // 만료 때 화면 전환 정책이 있을 경우. 미리 몇 분 전 토큰 업데이트.
    //   // getExpirationDate 로 시간 가져올 수 있음.
    //   return !JwtDecoder.isExpired(userToken);
    // }

    // _handleRefreshAuth(
    //     RequestOptions options, RequestInterceptorHandler handler) async {
    //   // 토큰 갱신하는 api 호출
    //   try {
    //     final Dio dio = Dio(); // refresh 토큰을 위한 새 dio 생성
    //     final String? refreshToken =
    //         await SecureStorage().getRefreshToken(); // storage에서 refresh 토큰 가져오기

    //     if (refreshToken == null) {
    //       handler.reject(DioException(
    //         requestOptions: options,
    //         error: 'Refresh token not available',
    //       ));
    //       return;
    //     }

    //     // Access token 재발행 요청
    //     final response = await dio.get(
    //       '$serverUrl/reissue',
    //       data: {'refreshToken': refreshToken},
    //     );

    //     if (response.statusCode == 200) {
    //       // Refresh token 발급 성공
    //       final String newAccessToken = response.headers.toString();

    //       // 새 Access token 로컬 Shared Preferences에 저장
    //       SecureStorage().setAccessToken(newAccessToken);

    //       // Retry the original request with the new access token
    //       return super.onRequest(
    //         options..headers['Authorization'] = 'Bearer $newAccessToken',
    //         handler,
    //       );
    //     } else {
    //       // Token refresh failed
    //       handler.reject(DioException(
    //         requestOptions: options,
    //         error: 'Failed to refresh token',
    //       ));
    //     }
    //   } catch (e) {
    //     // Handle any errors that occur during the refresh process
    //     handler.reject(DioException(
    //       requestOptions: options,
    //       error: 'Error refreshing token: $e',
    //     ));
    //   }
  

