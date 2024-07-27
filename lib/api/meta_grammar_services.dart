import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:haru_admin/api/network/dio_client.dart';
import 'package:haru_admin/model/meta_data_model.dart';
import 'package:haru_admin/utils/secure_storage.dart';

class MetaGrammarDataRepository {
  final dio = DioClient().provideDio();
  final dio4File = DioClient().provideDioForFile();
  SecureStorage secureStorage = SecureStorage();

  getMetaGrammerDataList({
    required int page,
    required int size,
  }) async {
    try {
      final response = await dio.get(
        '/grammar/meta-list?pageNumber=$page&pageSize=$size',
      );
      return MetaGrammarDataList.fromJson(response.data);
    } catch (e) {
      print("error : $e");
    }
  }

  addNewMetaData({
    required AddMetaData data,
  }) {
    try {
      dio.post(
        '/grammar/meta',
        data: data.toJson(),
      );
    } catch (e) {
      print("error : $e");
    }
  }

  updateMetaData({
    required AddMetaData data,
    required int id,
  }) {
    try {
      dio.patch(
        '/grammar/meta/$id',
        data: data.toJson(),
      );
    } catch (e) {
      print("error : $e");
    }
  }

  deleteMetaData(List<int> ids) async {
    try {
      final response = await dio.delete('/grammar/meta', data: ids);

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

      final response =
          await dio4File.post('/grammar/meta/file', data: formData);

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
