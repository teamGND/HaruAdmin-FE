import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:haru_admin/model/word_data_model.dart';
import 'package:haru_admin/api/network/dio_client.dart';
import 'package:haru_admin/utils/secure_storage.dart';
import 'package:http_parser/http_parser.dart';

class WordDataRepository {
  final dio = DioClient().provideDio();
  final dio4File = DioClient().provideDioForFile();
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
      if (response.statusCode == 409) {
        String errorMessage = response.data['message'];
        return errorMessage;
      }
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

  Future<String?> uploadImage(
      {required Uint8List fileBytes, required String fileName}) async {
    try {
      FormData formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
          contentType: MediaType(
            'image',
            'png',
          ),
        ),
        'description': 'A file to upload with Korean filename',
      });

      final response = await dio4File.post('/word/file', data: formData);

      if (response.statusCode == 200) {
        String? fileUrl = response.data['fileUrl'];
        if (fileUrl != null) {
          print(fileUrl);
          return fileUrl;
        } else {
          print('fileUrl is not present in the response');
          return null;
        }
        // return fileUrl;
      } else {
        print('File upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print("error : $e");
    }
  }
}
