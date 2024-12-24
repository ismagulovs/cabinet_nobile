import 'package:cabinet_mobile/http.dart';
import 'package:cabinet_mobile/profile/profile-dop-widget.dart';
import 'package:cabinet_mobile/storage.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../main.dart';
import '../theme.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SecureStorageService secureStorageService = SecureStorageService();
  final HttpService httpService = HttpService();
  late Future<User> userRes;
  @override
  void initState()  {
    super.initState();
    getUserData();
  }

  void getUserData(){
    setState(() {
      userRes = httpService.getUserInfo();
    });
  }

  void _exit() {
    Alert(
      title: "Подтверждение",
      content: Text("Вы уверенны, что хотите выйти?"),
      context: context,
      style: myAlert,
      type: AlertType.none,
      buttons: [
        DialogButton(onPressed:(){
          secureStorageService.deleteToken();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const MyHomePage(num: 2)));
          }, color: colorGold, child: Text('Да')),
        DialogButton(onPressed:(){ Navigator.of(context).pop(); }, color: Colors.white70, child: Text('Нет'))
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: userRes,
      builder: (context, snap) {
        if(snap.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        else if (snap.hasError)
          return Center(child: Text('Error: ${snap.error}'));
        else if (snap.hasData){
          User? user = snap.data;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: colorGreen,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWhileText(user!.commonName, 20, FontWeight.normal),
                        _buildWhileText("ИИН: ${user!.iin}", 18, FontWeight.bold),
                        const SizedBox(height: 20),
                        _buildWhileText(user!.organization, 20, FontWeight.normal),
                        _buildWhileText("БИН: ${user!.bin}", 18, FontWeight.bold),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(25, 25, 25, 5),
                    child: Text(
                      "ДОПОЛНИТЕЛЬНАЯ ИНФОРМАЦИЯ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: ProfileDopWidget(user: user),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _exit,
                          style: eBtnGold,
                          child: Text('выйти'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }else{
          return Center(child: Text('data not found'));
        }
      },
    );
  }
}

Widget _buildWhileText(String text, double fSize, FontWeight weight){
  return Text(
      text,
      style: TextStyle(fontSize: fSize,
          fontWeight: weight,
          color: Colors.white)
  );
}

Widget _buildDopText(String label, String text, IconData icon){
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child:  Row(children: [
        Icon(icon, size: 36, color: colorGreen,),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: const TextStyle(fontSize: 18),),
            Text(label, style: const TextStyle(fontSize: 10),)],
        )
      ],),
    );
}

class User {
  int id;
  String commonName;
  String iin;
  String bin;
  String organization;
  String phone;
  String email;
  bool bux;
  String positionKaz;
  String positionRus;
  String positionEng;
  String positionKazDb;
  String positionRusDb;
  String positionEngDb;

  User({required this.id, required this.commonName, required this.iin, required this.bin,
    required this.organization, required this.phone, required this.email, required this.bux,
    required this.positionKaz, required this.positionRus, required this.positionEng,
    required this.positionKazDb, required this.positionRusDb, required this.positionEngDb
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      commonName: json['commonName'],
      iin: json['iin'],
      bin: json['bin'],
      organization: json['organization'],
      phone: json['phone'],
      email: json['email'],
      bux: json['bux'],
      positionKaz: json['positionKaz'],
      positionRus: json['positionRus'],
      positionEng: json['positionEng'],
      positionKazDb: json['positionKazDb'],
      positionRusDb: json['positionRusDb'],
      positionEngDb: json['positionEngDb'],
    );
  }
}

