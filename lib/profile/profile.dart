

import 'package:cabinet_mobile/profile/login/profileLoginQrPage.dart';
import 'package:cabinet_mobile/profile/profile-page.dart';
import 'package:cabinet_mobile/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _Profile createState() => _Profile();
}


class _Profile extends State<Profile> {
  final SecureStorageService secureStorageService = SecureStorageService();

  @override
  Widget build(BuildContext context) {
    
    Future<bool> _checkToken() async {
      String? token;
      await secureStorageService.getToken().then((String? result) {
          token = result;
      });
      return token != null;
    }
    
    return FutureBuilder(
        future: _checkToken(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }else if (snapshot.hasData && snapshot.data == true){
            return ProfilePage();
          }else{
            return ProfileLoginQrPage();
          }
        },
      );
  }

}