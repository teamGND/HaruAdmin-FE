import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:haru_admin/utils/secure_storage.dart';
import 'package:go_router/go_router.dart';

class AuthRepository {
  Dio dio = Dio();
  SecureStorage secureStorage = SecureStorage();

//회원가입 로직
  signup(adminId, password, name, ranks, phoneNumber) async {
    try {
      final response = await dio.post(
        'https://www.haruhangeul.com/admin/signup',
        data: {
          "adminId": "$adminId",
          "name": "$name",
          "password": "$password",
          "ranks": "$ranks",
          "phoneNumber": "$phoneNumber",
        },
      );
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      rethrow;
    }
  }

//로그인 로직
  loginPressed(
    adminId,
    password,
  ) async {
    try {
      var idAndPassword = {
        'adminId': adminId,
        'password': password,
      };

      Response response = await dio
          .post('https://www.haruhangeul.com/admin/login', data: idAndPassword);
      print(response.data);
      if (response.statusCode == 200) {
        final token = json.decode(response.headers['Authorization']
            .toString()); //HTTP 응답에서 headers에'authorization' 키에 해당하는 값을 JSON으로 디코딩하여 변수 token에 저장
        print(token);
        //var accessToken = jsonEncode(Login('$token));
        //await secureStorage.setAccessToken(accessToken); //key가 accesstoken으로 지정되어 있고, value가 ㅁㅊㅊㄷㄴㄴ새ㅏ두
        return true;
      }
    } catch (e) {
      rethrow;
    }
  }

  // 아이디 중복체크
  adminIdCheck(adminId) async {
    try {
      final response = await dio.post(
        'https://www.haruhangeul.com/admin/id-validate/$adminId',
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
