import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final SecureStorage _instance = SecureStorage._internal();
  late FlutterSecureStorage _storage;

  factory SecureStorage() {
    return _instance;
  }

  SecureStorage._internal() {
    _storage = const FlutterSecureStorage();
  }

  FlutterSecureStorage get secureStorage => _storage;

  // 토큰 가져오기 = read
  Future<String?> getAccessToken() async {
    String? value = await _storage.read(key: 'accessToken');
    return value;
  }

  // 토큰 설정하기 = 토큰 저장
  Future<void> setAccessToken(String token) async {
    _storage.write(key: 'accessToken', value: token);
  }

  // 토큰 삭제하기 = delete
  Future<void> deleteAccessToken() async {
    _storage.delete(key: 'accessToken');
  }
}
