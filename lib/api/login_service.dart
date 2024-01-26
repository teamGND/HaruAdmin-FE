import 'package:dio/dio.dart';
import 'package:haru_admin/api/network/dio_client.dart';

class LoginService {
  final DioClient dio = DioClient();

  LoginService();

  // 성공, 실패, ... 계정없음, -> bool 말고 객체. enum
  Future<bool> login() async {
    // try catch
    // access token 가져와서넣기

    return false;
  }
}
