import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:haru_admin/model/intro_data_model.dart';
import 'package:haru_admin/api/network/dio_client.dart';
import 'package:haru_admin/utils/secure_storage.dart';

class TestDataRepository {
  final dio = DioClient().provideDio();
  SecureStorage secureStorage = SecureStorage();

  getTestDataList() async {
    try {
      final response = await dio.get(
        '/test-list',
      );
    } catch (e) {
      print("error : $e");
    }
  }
}
