import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:haru_admin/api/network/dio_client.dart';
import 'package:haru_admin/model/auth_model.dart';
import 'package:haru_admin/utils/secure_storage.dart';

class AuthRepository {
  final dio = DioClient().provideDio();
  SecureStorage secureStorage = SecureStorage();
//텍스트 폼 유효성 검사

//회원가입 로직
  signup(adminId, password, name, ranks, phoneNumber) async {
    try {
      Map<String, dynamic> requestBody = {
        "adminId": "$adminId",
        "name": "$name",
        "password": "$password",
        "ranks": "$ranks",
        "phoneNumber": "$phoneNumber",
      };

      Response response = await dio.post('/signup', data: requestBody);

      if (response.statusCode == 200) {
        print('회원가입 완료!');
      } else {
        print('회원가입 실패: ${response.data}');
      }
    } catch (e) {
      print('$e');
    }
  }

//로그인 로직
  loginPressed(
    adminId,
    password,
  ) async {
    try {
      Map<String, dynamic> requestBody = {
        'adminId': '$adminId',
        'password': "$password",
      };
      Response response = await dio.post('/login', data: requestBody);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        Map<String, dynamic> adminData = responseData['headers'];
        String token = adminData['Authorization'][0];
        secureStorage.setAccessToken(token);
      } else {
        print('로그인 실패: ${response.statusCode}');
      }

      // final authorization = response.headers['Authorization'];
      // if (authorization != null) {
      //   secureStorage.setAccessToken(authorization.first);
      // } else if (response.statusCode == 401) {
      //   print('로그인 실패: 승인되지 않은 사용자');
      // } else {
      //   print('로그인 실패: ${response.statusCode}');
      // }
    } catch (e) {
      print('회원가입 중 예외 발생 $e');
    }
  }

  // 아이디 중복체크
  adminIdCheck(adminId) async {
    try {
      final response = await dio.post(
        '/id-validate/$adminId',
        data: {
          "adminId": adminId,
        },
      );
      final approveId = json.decode(response.data.toString());
      print(approveId);
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
