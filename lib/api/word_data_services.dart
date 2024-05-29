import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:haru_admin/model/word_data_model.dart';
import 'package:haru_admin/api/network/dio_client.dart';
import 'package:haru_admin/utils/secure_storage.dart';

class WordDataRepository {
  final dio = DioClient().provideDio();
  SecureStorage secureStorage = SecureStorage();

  getWordDataList({required int page, required int size}) async {
    try {
      final response = await dio.get('/word-list');
      final WordDataList wordDataList = WordDataList.fromJson(response.data);

      return wordDataList;
    } catch (e) {
      throw Exception(e);
    }
  }

  addToWordDataList({required WordDataListComponent wordData}) async {
    try {
      final response = await dio.post('/word', data: wordData.toJson());
    } catch (e) {
      print("error : $e");
    }
  }

  getWordData({required int id}) async {
    try {
      final response = await dio.get('/word/$id');
      final wordChapterDataList = WordChapterDataList.fromJson(response.data);

      return wordChapterDataList;
    } catch (e) {
      throw Exception(e);
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
