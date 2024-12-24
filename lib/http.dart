import 'dart:convert';

import 'package:cabinet_mobile/notice/notice-page.dart';
import 'package:cabinet_mobile/profile/profile-page.dart';
import 'package:cabinet_mobile/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'main.dart';

class HttpService{
  final SecureStorageService storageService = SecureStorageService();
  final String _url = 'https://test-my.kdb.kz/api';
  final String _url_qr = 'https://test-my.kdb.kz/api-qr';

  Future<Map<String, dynamic>> authReg(String token, String key) async {
    String? deviceId;
    await storageService.getDeviceIdentifier().then((String? result) { deviceId = result; });
    final headers = {"Content-Type": "application/json; charset=UTF-8"};
    final body = jsonEncode({"token": token, "key": key, "deviceId": deviceId});
    final response = await sendPost(Uri.parse('$_url/auth/reg-mobile'), headers, body);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if(jsonResponse['errorCode']==2){
        throw Exception("key");
      }else{
        throw Exception(response.body);
      }
    }
  }

  Future<Map<String, dynamic>> updateUserBux(bool bux) async {
    final headers = {"Content-Type": "application/json; charset=UTF-8"};
    final response = await sendPost(Uri.parse('$_url/mobile/user/updateBux?bux=${bux}'), headers, "");

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print('Response data: ${response.body}');
      return jsonResponse;
    } else {
        print('Response data: ${response.body}');
        throw Exception(response.body);
    }
  }

  Future<Map<String, dynamic>> updateUserPhone(String phone) async {
    final headers = {"Content-Type": "application/json; charset=UTF-8"};
    final body = jsonEncode({"data": phone});
    final response = await sendPost(Uri.parse('$_url/mobile/user/updatePhone'), headers, body);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
        throw Exception(response.body);
    }
  }

  Future<Map<String, dynamic>> updateUserEmail(String email) async {
    final headers = {"Content-Type": "application/json; charset=UTF-8"};
    final body = jsonEncode({"data": email});
    final response = await sendPost(Uri.parse('$_url/mobile/user/updateEmail'), headers, body);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
        throw Exception(response.body);
    }
  }

  Future<Map<String, dynamic>> updateUserPositionKaz(String positionKaz) async {
    final headers = {"Content-Type": "application/json; charset=UTF-8"};
    final body = jsonEncode({"data": positionKaz});
    final response = await sendPost(Uri.parse('$_url/mobile/user/updatePositionKaz'), headers, body);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
        throw Exception(response.body);
    }
  }

  Future<Map<String, dynamic>> updateUserPositionRus(String positionRus) async {
    final headers = {"Content-Type": "application/json; charset=UTF-8"};
    final body = jsonEncode({"data": positionRus});
    final response = await sendPost(Uri.parse('$_url/mobile/user/updatePositionRus'), headers, body);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
        throw Exception(response.body);
    }
  }
  Future<Map<String, dynamic>> updateUserPositionEng(String positionEng) async {
    final headers = {"Content-Type": "application/json; charset=UTF-8"};
    final body = jsonEncode({"data": positionEng});
    final response = await sendPost(Uri.parse('$_url/mobile/user/updatePositionEng'), headers, body);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
        throw Exception(response.body);
    }
  }

  Future<User> getUserInfo() async {
    final response = await sendGet(Uri.parse('$_url/mobile/info'));
    if (response.statusCode == 200) {
      print('Response data: ${response.body}');
      // final String responseBody = utf8.decode(response.bodyBytes);
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('ошибка регистрации устройства');
    }
  }
  Future<String> getAut() async {
    final response = await sendGet(Uri.parse('$_url_qr/auth/newId/applicant'));
    if (response.statusCode == 200) {
      print('Response data: ${response.body}');
      return response.body;
    } else {
      throw Exception('ошибка запроса токена авторизации');
    }
  }


  Future<Map<String, dynamic>> authEgovReg(String token) async {
    String? deviceId;
    await storageService.getDeviceIdentifier().then((String? result) { deviceId = result; });
    final headers = {"Content-Type": "application/json; charset=UTF-8"};
    headers["Authorization"] = "Bearer ${token}";
    final body = jsonEncode({ "deviceId": deviceId});
    final response = await sendPost(Uri.parse('$_url/mobile-auth/reg-egov'), headers, body);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if(jsonResponse['errorCode']==2){
        throw Exception("key");
      }else{
        throw Exception(response.body);
      }
    }
  }

  Future<Map<String, dynamic>> pingAuth(String id) async {
    try{
      final response = await sendGet(Uri.parse('$_url_qr/auth/$id/checkAuth'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      } else {
        throw Exception('ошибка запроса токена авторизации');
      }
    }catch(e){
      return {'isDone': false};
    }

  }

  Future<List<Notice>> getNoticeList() async {
    final response = await sendGet(Uri.parse('$_url/mobile/notice'));
    if (response.statusCode == 200) {
      print('Response data: ${response.body}');
      final List<dynamic> noticeJson = jsonDecode(response.body);
      return noticeJson.map((json) => Notice.fromJson(json)).toList();
    } else {
      throw Exception('ошибка регистрации устройства');
    }
  }

   Future<Response> sendPost(Uri uri, Map<String, String> headers, String body) async{
    String? deviceId;
    String? token;
    await storageService.getDeviceIdentifier().then((String? result) { deviceId = result; });
    await storageService.getToken().then((String? result) { token = result; });
    if(token!=null&&token!.length>5) headers["Authorization"] = "Bearer-mobile ${token!}";
    headers["Device-id"] = deviceId!;
    return await http.post(uri, headers: headers, body: body);
  }

   Future<Response> sendGet(Uri uri) async{
    String? deviceId;
    String? token;
    await storageService.getDeviceIdentifier().then((String? result) { deviceId = result; });
    await storageService.getToken().then((String? result) { token = result; });
    final headers = {"Content-Type": "application/json; charset=UTF-8"};
    if(token!=null&&token!.length>5) headers["Authorization"] = "Bearer-mobile ${token!}";
    headers["Device-id"] = deviceId!;

    final response = await http.get(uri, headers: headers);
    if(response.statusCode == 200){
      return response;
    }else if(response.statusCode == 401){
      storageService.deleteToken();
      navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => MyHomePage(num: 2)));
    }
    return response;
  }

}
