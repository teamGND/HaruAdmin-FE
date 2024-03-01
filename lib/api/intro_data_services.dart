import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:haru_admin/model/intro_data_model.dart';
import 'package:haru_admin/api/network/dio_client.dart';
import 'package:haru_admin/utils/secure_storage.dart';

class IntroDataRepository {
  final dio = DioClient().provideDio();
  SecureStorage secureStorage = SecureStorage();

  getIntroDataList() async {
    try {
      final response = await dio.get(
        '/intro-list',
      );
      final introData =
          response.data.map((e) => IntroData.fromJson(e)).toList();
      return introData;
    } catch (e) {
      print("error : $e");
    }
  }

  addToIntroDataList(AddIntroData data) async {
    try {
      final response = await dio.post('/intro', data: data.toJson());

      return response;
    } catch (e) {
      print("error : $e");
    }
  }
}
