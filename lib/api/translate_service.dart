import 'package:dio/dio.dart';
import 'package:haru_admin/api/network/dio_client.dart';
import 'package:haru_admin/model/translate_model.dart';
import 'package:haru_admin/utils/secure_storage.dart';

class TranslateRepository {
  final dio = DioClient().provideDio();
  final dio4File = DioClient().provideDioForFile();
  SecureStorage secureStorage = SecureStorage();

  Future<TranslatedResponse?> translate({
    required String korean,
    required String? english,
  }) async {
    try {
      Response res = await dio.get('/translate', data: {
        "korean": korean,
        "english": english,
      });

      return TranslatedResponse.fromJson(res.data);
    } catch (e) {
      print("error : $e");
    }
    return null;
  }
}
