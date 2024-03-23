import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:haru_admin/model/intro_data_model.dart';
import 'package:haru_admin/api/network/dio_client.dart';
import 'package:haru_admin/utils/secure_storage.dart';

class IntroDataRepository {
  final dio = DioClient().provideDio();
  SecureStorage secureStorage = SecureStorage();

  getIntroDataList({required int page, required int size}) async {
    try {
      final response = await dio.get('/intro-list?page=$page&size=$size');
      final introData = IntroDataList.fromJson(response.data);

      return introData;
    } catch (e) {
      print("error : $e");
    }
  }

  // getWordDataList() async {
  //   try {
  //     final response = await dio.get('/word-list');
  //     final List<WordDataList> wordDataList =
  //     (response.data as List).map((e) => WordDataList.fromJson(e)).toList();
  //     print(wordDataList);
  //     return wordDataList;
  //   } catch (e) {
  //     print("error : $e");
  //   }
  // }

  addToIntroDataList(AddIntroData data) async {
    try {
      final response = await dio.post('/intro', data: data.toJson());

      return response;
    } catch (e) {
      print("error : $e");
    }
  }
}
