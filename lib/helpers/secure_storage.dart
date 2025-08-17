import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();

  static Future<void> writeToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  static Future<String?> readToken() async {
    return await _storage.read(key: 'token');
  }

  static Future<void> removeToken() async {
    await _storage.delete(key: 'token');
  }
}
