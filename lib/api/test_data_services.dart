import 'dart:convert';
import 'package:haru_admin/api/network/dio_client.dart';
import 'package:haru_admin/screens/test/entity/test_entity.dart';
import 'package:haru_admin/utils/secure_storage.dart';

class TestDataRepository {
  final dio = DioClient().provideDio();
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
        return TestDataEntity.fromJson(jsonDecode(response.data));
      }
    } catch (e) {
      print("error : $e");
    }
  }

  addTestDataList(List<ProblemDataModel>? testDataList) {
    try {
      dio.post(
        '/test-list',
        data: testDataList,
      );
    } catch (e) {
      print("error : $e");
    }
  }
}
