import 'package:haru_admin/model/intro_data_model.dart';
import 'package:haru_admin/api/network/dio_client.dart';
import 'package:haru_admin/utils/secure_storage.dart';

class IntroDataRepository {
  final dio = DioClient().provideDio();
  SecureStorage secureStorage = SecureStorage();

  Future<IntroDataList> getIntroDataList(
      {required int page, required int size}) async {
    try {
      final response = await dio.get('/intro-list?page=$page&size=$size');
      final introData = IntroDataList.fromJson(response.data);

      return introData;
    } catch (e) {
      print("error : $e");
      throw Exception(e);
    }
  }

  Future<IntroModel> getIntroData({required int id}) async {
    try {
      final response = await dio.get('/intro/$id');
      final introData = IntroModel.fromJson(response.data);

      return introData;
    } catch (e) {
      print("error : $e");
      throw Exception(e);
    }
  }

  addToIntroDataList(AddIntroData data) async {
    try {
      final response = await dio.post('/intro', data: data.toJson());

      return response;
    } catch (e) {
      print("error : $e");
      throw Exception(e);
    }
  }

  deleteIntroData(List<int> ids) async {
    try {
      final response = await dio.delete('/intro', data: ids);

      return response;
    } catch (e) {
      print("error : $e");
    }
  }
}
