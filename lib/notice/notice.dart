
import 'package:cabinet_mobile/home/home-guest-page.dart';
import 'package:cabinet_mobile/home/home-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../storage.dart';
import 'notice-guest-page.dart';
import 'notice-page.dart';

class Notice extends StatefulWidget{
  @override
  _Notice createState() => _Notice();
}

class _Notice extends State<Notice> {
  final SecureStorageService secureStorageService = SecureStorageService();

  @override
  Widget build(BuildContext context){

    Future<bool> _checkToken() async {
      String? token;
      await secureStorageService.getToken().then((String? result) {
        token = result;
      });
      return token != null;
    }

    return FutureBuilder(
        future: _checkToken(),
        builder: (context, snap) {
          if(snap.connectionState == ConnectionState.waiting)
            return const CircularProgressIndicator();
          else if(snap.hasData && snap.data == true)
            return NoticePage();
          else
            return NoticeGuestPage();
        }
    );
  }
}