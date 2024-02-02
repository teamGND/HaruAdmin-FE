import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:haru_admin/model/auth_model.dart';
import 'package:haru_admin/utils/secure_storage.dart';

//final dio = Dio(BaseOptions(
//  baseUrl: 'https://www.haruhangeul.com',
//  contentType: 'application/json'));

class AuthRepository {
  final dio = Dio();
  SecureStorage secureStorage = SecureStorage();
  bool isIdavailable = false;
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

      Response response = await dio
          .post('https://www.haruhangeul.com/admin/signup', data: requestBody);

      if (response.statusCode == 200) {
        print('회원가입 완료!');
      } else {
        print('회원가입 실패: ${response.data}');
      }
    } catch (e) {
      print(' 회원가입 중 예외 발생: $e');
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
      Response response = await dio.post('https://www.haruhangeul.com/signup',
          data: requestBody);

      AdminLogin login = AdminLogin.fromJson(response.data);
      if (response.statusCode == 200) {
        final authorization = response.headers['Authorization'];
        if (authorization != null) {
          secureStorage.setAccessToken(authorization.first);
        }
      } else if (response.statusCode == 401) {
        print('로그인 실패: 승인되지 않은 사용자');
      } else {
        print('로그인 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('로그인 중 예외 발생 $e');
    }
  }

  // 아이디 중복체크
  adminIdCheck(
    adminId,
  ) async {
    try {
      Map<String, dynamic> requestBody = {
        'adminId': '$adminId',
      };
      Response response = await dio.post(
          'https://www.haruhangeul.com/id-validate/$adminId',
          data: requestBody);

      if (response.statusCode == 200) {
        final approval = json.decode(response.data.toString());
        isIdavailable = true;
        return approval;
      }
    } catch (e) {
      print('아이디 중복체크 중 예외 발생: $e');
    }
  }
}
