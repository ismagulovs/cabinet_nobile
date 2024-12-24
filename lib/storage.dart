
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:unique_identifier/unique_identifier.dart';


class SecureStorageService{

  final storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }


  Future<bool> isToken() async {
    String? token;
    await getToken().then((String? result) {
      token = result;
    });
    return token != null;
  }

  Future<void> deleteToken() async {
    await storage.delete(key: 'auth_token');
  }

  Future<String> getDeviceIdentifier() async {
    String? identifier;
    try {
      identifier = await UniqueIdentifier.serial;
      if (identifier == null || identifier.isEmpty) {
        throw Exception('Unable to retrieve device identifier.');
      }
    } catch (e) {
      identifier = 'Failed to get unique identifier: $e';
    }
    return identifier;
  }
}

