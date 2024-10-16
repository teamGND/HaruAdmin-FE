import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:haru_admin/model/grammer_data_model.dart';
import 'package:haru_admin/api/network/dio_client.dart';
import 'package:haru_admin/utils/secure_storage.dart';

class GrammerDataRepository {
  final dio = DioClient().provideDio();
  final dio4File = DioClient().provideDioForFile();
  SecureStorage secureStorage = SecureStorage();

  getGrammerDataList({
    required int page,
    required int size,
  }) async {
    try {
      final response = await dio.get(
        '/grammar-list?page=$page&size=$size',
      );
      return GrammarDataList.fromJson(response.data);
    } catch (e) {
      print("error : $e");
    }
  }

  getGrammarData({required int id}) async {
    try {
      final response = await dio.get('/grammar/$id');
      return GrammarChapterDataList.fromJson(response.data);
    } catch (e) {
      print("error : $e");
    }
  }

  addToGrammerDataList(AddGrammarData data) async {
    try {
      final response = await dio.post('/grammar', data: data.toJson());

      return response;
    } catch (e) {
      print("error : $e");
    }
  }

  postGrammarChapterData(
      {required int id, required AddGrammarData data}) async {
    try {
      final response = await dio.post('/grammar', data: data.toJson());
      return response;
    } catch (e) {
      print("error : $e");
    }
  }

  updateGrammarData({required int id, required AddGrammarData data}) async {
    try {
      final response = await dio.patch('/grammar/$id', data: data.toJson());
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

      final response = await dio4File.post('/grammar/file', data: formData);

      if (response.statusCode == 200) {
        String? fileUrl = response.data;
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
