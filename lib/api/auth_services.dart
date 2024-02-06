import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:haru_admin/api/network/dio_client.dart';
import 'package:haru_admin/utils/secure_storage.dart';

class AuthRepository {
  final dio = DioClient().provideDio();

//회원가입 로직
  signup(
    adminId,
    password,
    name,
    ranks,
    phoneNumber,
  ) async {
    try {
      Map<String, dynamic> requestBody = {
        "adminId": '$adminId',
        "name": '$name',
        "password": "$password",
        "ranks": 'MASTER',
        "phoneNumber": "$phoneNumber",
      };
      var jsondata = jsonEncode(requestBody);
      print('jsondata: $jsondata');
      final response = await dio.post('/signup', data: jsondata);
      print('response: $response');

      if (response.statusCode == 200) {
        Map<String, dynamic> resp = jsonDecode(response.data);
        print(resp);
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
        'adminId': adminId,
        'password': password,
      };
      Response response = await dio.post('/login', data: requestBody);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        Map<String, dynamic> adminData = responseData['headers'];
        String token = adminData['Authorization'][0];
        SecureStorage secureStorage = SecureStorage();
        secureStorage.setAccessToken(token);
      } else {
        print('로그인 실패: ${response.statusCode}');
      }
    } catch (e) {
      if (e == DioErrorType.connectTimeout) {
        print('로그인 실패: ${e.toString()}');
      } else {
        print('로그인 중 예외 발생 $e');
      }
    }
  }

  // 아이디 중복체크
  adminIdCheck(
    String adminId,
  ) async {
    try {
      Response response =
          await dio.post('/id-validate/$adminId', data: adminId);

      if (response.statusCode == 200) {
        json.decode(response.data.toString());
        print(response.data);
      }
    } catch (e) {
      print('$e');
    }
  }
}
