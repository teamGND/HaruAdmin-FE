import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:haru_admin/model/word_data_model.dart';
import 'package:haru_admin/api/network/dio_client.dart';
import 'package:haru_admin/utils/secure_storage.dart';

class WordDataRepository {
  final dio = DioClient().provideDio();
  final dio4File = DioClient().provideDioForFile();
  SecureStorage secureStorage = SecureStorage();

  Future<WordDataList> getWordDataList(
      {required int page, required int size}) async {
    try {
      final response = await dio.get('/word-list?page=$page&size=$size');
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

  Future<WordChapterDataList> getWordData({required int id}) async {
    try {
      final response = await dio.get('/word/$id');
      final wordChapterDataList = WordChapterDataList.fromJson(response.data);

      return wordChapterDataList;
    } catch (e) {
      throw Exception(e);
    }
  }

  saveWordData({required int id, required PatchWordChapterData data}) async {
    try {
      final response = await dio.patch(
        '/word/$id',
        data: data.toJson(),
      );
      if (response.statusCode == 409) {
        String errorMessage = response.data['message'];
        return errorMessage;
      }

      return response;
    } catch (e) {
      print("error : $e");
    }
  }

  Future<String?> uploadFile(
      {required Uint8List fileBytes,
      required String fileName,
      required String fileType}) async {
    try {
      FormData formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: '$fileName.$fileType',
        ),
      });

      final response = await dio4File.post('/word/file', data: formData);

      if (response.statusCode == 200) {
        String? fileUrl = response.data['fileUrl'];
        if (fileUrl != null) {
          return fileUrl;
        } else {
          return null;
        }
      } else {
        print('File upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
    return null;
  }
}
