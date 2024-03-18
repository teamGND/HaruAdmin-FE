import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:haru_admin/model/word_data_model.dart';
import 'package:haru_admin/api/network/dio_client.dart';
import 'package:haru_admin/utils/secure_storage.dart';

class WordDataRepository {
  final dio = DioClient().provideDio();
  SecureStorage secureStorage = SecureStorage();

  getWordDataList() async {
    try {
      final response = await dio.get('/word-list');
      final List<WordDataList> wordDataList =
          (response.data as List).map((e) => WordDataList.fromJson(e)).toList();
      print(wordDataList);
      return wordDataList;
    } catch (e) {
      print("error : $e");
    }
  }

  addToWordDataList({required WordData wordData}) async {
    try {
      final response = await dio.post('/word', data: wordData.toJson());
      print(response.data);
    } catch (e) {
      print("error : $e");
    }
  }

  // addToWordFile(String imageURL) async {
  //   try {
  //     final bytes = await http
  //         .get(Uri.parse(imageURL))
  //         .then((response) => response.bodyBytes);

  //     var formData = FormData.fromMap({
  //       'f': MultipartFile.fromBytes(bytes,
  //           filename: imageURL.split('/').last,
  //           contentType: MediaType('image', 'png')),
  //     });

  //     final response =
  //         await dio.post('/grammer/file', data: {'file': formData});

  //     return response;
  //   } catch (e) {
  //     print("error : $e");
  //   }
  // }
}
