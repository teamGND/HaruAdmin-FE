import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:haru_admin/api/network/dio_client.dart';
import 'package:haru_admin/model/test_data_model.dart';
import 'package:haru_admin/utils/secure_storage.dart';

class TestDataRepository {
  final dio = DioClient().provideDio();
  final dio4File = DioClient().provideDioForFile();

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

  getTestData({required id}) async {
    try {
      final response = await dio.get(
        '/test/$id',
      );

      if (response.statusCode == 200) {
        return TestDataEntity.fromJson(response.data);
      }
    } catch (e) {
      print("error : $e");
    }
  }

  postTestData({required List<ProblemDataModel>? testDataList}) async {
    try {
      await dio.post(
        '/test',
        data: LstReq(lstReq: testDataList).toJson(),
      );
    } catch (e) {
      print("error : $e");
    }
    return null;
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

      final response = await dio4File.post('/test/file', data: formData);

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

  getCurrentSetsTest({
    required String level,
    required int cycle,
    required int set,
  }) async {
    try {
      final response = await dio.get(
        '/test/sets/$level/$cycle/$set',
      );

      if (response.statusCode == 200) {
        List<ProblemDataModel> problemList = [];
        for (var item in response.data) {
          problemList.add(ProblemDataModel.fromJson(item));
        }
        return problemList;
      }
    } catch (e) {
      print("error : $e");
    }
  }

  getCurrentCycleTest({
    required String level,
    required int cycle,
  }) async {
    try {
      final response = await dio.get(
        '/test/cycle/$level/$cycle',
      );

      if (response.statusCode == 200) {
        List<ProblemDataModel> problemList = [];
        for (var item in response.data) {
          problemList.add(ProblemDataModel.fromJson(item));
        }
        return problemList;
      }
    } catch (e) {
      print("error : $e");
    }
  }

  approveTest({
    required String level,
    required int cycle,
    required int set,
    required int chapter,
  }) async {
    try {
      await dio.post(
        '/test/approve/$level/$cycle/$set/$chapter',
      );
    } catch (e) {
      print("error : $e");
    }
  }

  deleteTest({required int id}) async {
    try {
      await dio.delete(
        '/test/$id',
      );
    } catch (e) {
      print("error : $e");
    }
  }
}
