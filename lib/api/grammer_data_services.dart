import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:haru_admin/model/grammer_data_model.dart';
import 'package:haru_admin/api/network/dio_client.dart';
import 'package:haru_admin/utils/secure_storage.dart';
import 'package:http_parser/http_parser.dart';

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
        '/grammar-list?pageNumber=$page&pageSize=$size',
      );
      return GrammarDataList.fromJson(response.data);
    } catch (e) {
      print("error : $e");
    }
  }

  addToGrammerDataList(AddGrammerData data) async {
    try {
      final response = await dio.post('/grammer', data: data.toJson());

      return response;
    } catch (e) {
      print("error : $e");
    }
  }

  Future<String?> uploadFile(
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
      });

      final response = await dio4File.post('/grammar/file', data: formData);

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
