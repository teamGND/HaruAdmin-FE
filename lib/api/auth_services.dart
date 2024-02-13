import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:haru_admin/api/network/dio_client.dart';
import 'package:haru_admin/utils/secure_storage.dart';

class AuthRepository {
  final dio = DioClient().provideDio();
  SecureStorage secureStorage = SecureStorage();

  signup(adminId, password, name, ranks, phoneNumber) async {
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
        print('로그인 성공: $token');
        secureStorage.setAccessToken(token);
      } else {
        print('로그인 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('로그인 중 예외 발생 $e');
    }
  }

  adminIdCheck(adminId) async {
    try {
      final response = await dio.get(
        '/id-validate/$adminId',
      );
      // alert 창 띄우기
      if (response.statusCode == 200) {
        print('사용 가능한 아이디입니다.');
      } else {
        print('이미 사용중인 아이디입니다.');
      }
    } catch (e) {
      print("error : $e");
    }
  }

  getMyInfo() async {
    try {
      final response = await dio.get(
        '/',
      );
      final myInfo = MyInfo.fromJson(response.data);
      return myInfo;
    } catch (e) {
      print("error : $e");
    }
  }

  getAdminList(int pageNumber) async {
    try {
      final response = await dio.get(
        '/role-list?page=$pageNumber',
      );
      final testData =
          response.data['content'].map((e) => AdminList.fromJson(e)).toList();
      final totalPage = response.data['totalPages'];
      final totalElements = response.data['totalElements'];
      return {
        'adminData': testData,
        'totalPage': totalPage,
        'totalElements': totalElements
      };
    } catch (e) {
      print("error : $e");
    }
  }

  getdataList() async {
    try {
      final response = await dio.get(
        '/test-list',
      );
    } catch (e) {
      print("error : $e");
    }
  }
}
