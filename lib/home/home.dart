
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../storage.dart';
import 'home-guest-page.dart';
import 'home-page.dart';

class Home extends StatefulWidget{
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
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
            return HomePage();
          else
            return HomePage();
        }
    );
  }
}