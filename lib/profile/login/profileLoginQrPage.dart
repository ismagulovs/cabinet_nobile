
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cabinet_mobile/profile/login/profileLoginQrKey.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../http.dart';
import '../../main.dart';
import '../../storage.dart';
import '../../theme.dart';


class ProfileLoginQrPage extends StatefulWidget{
  @override
  _ProfileLoginQrPageState createState() => _ProfileLoginQrPageState();
}

class _ProfileLoginQrPageState extends State<ProfileLoginQrPage>{
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  HttpService httpService = HttpService();
  SecureStorageService storageService = SecureStorageService();

  Barcode? result;
  QRViewController? qrController;
  final prefixQr = 'kdbMobileAuth:';

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrController?.pauseCamera();
    }
    qrController?.resumeCamera();
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset('assets/qr.png', width: 100, height: 100, alignment: Alignment.bottomCenter,),
          SizedBox(height: 20),
          Text("Добро пожаловать!", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: colorGold, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Text("для входа на сайте my.kdb.kz в личном кабинете отканируйте qr код",
              textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: colorGold, fontWeight: FontWeight.normal)),
          SizedBox(height: 40),
          ElevatedButton(
            style: eBtn,
            onPressed: () {
              _showBottomSheet(context);
            },
            child: Row( mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.qr_code_2),  SizedBox(width: 5), Text('Сканировать')],),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            style: eBtn,
            onPressed: () {
              _authEgov();
            },
            child: Row( mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.fingerprint),  SizedBox(width: 5), Text('Войти через egov mobile')],),
          ),
        ],
      ),
    );
  }
  Future<void> _launchUrl(String url) async {
    // if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  void _authEgov() async {
    String newId = await httpService.getAut();
    String kdbLink = 'https://test-my.kdb.kz/api-qr/auth/$newId?mgovSign=true';
    await _launchUrl('https://mgovsign.page.link/?link=$kdbLink&apn=kz.mobile.mgov.business');
    await pingAuthSuccess(newId);
    // await _launchUrl('intent://mgovsign.page.link/?link=$kdbLink&apn=kz.mobile.mgov#Intent;package=com.google.android.gms;action=com.google.firebase.dynamiclinks.VIEW_DYNAMIC_LINK;scheme=https;S.browser_fallback_url=https://play.google.com/store/apps/details%3Fid%3Dkz.mobile.mgov&pcampaignid%3Dfdl_long&url%3D$kdbLink;end');
  }


  Future<void> pingAuthSuccess(String id) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    Timer.periodic(const Duration(seconds: 5), (timer) async {
      try{
        Map<String, dynamic> res = await httpService.pingAuth(id);
        EGovResultModel authPingRes = EGovResultModel.fromJson(res);
        if (authPingRes.isDone&&authPingRes.token!=null) {
          print(authPingRes.token);
          Map<String, dynamic> response = await httpService.authEgovReg(authPingRes.token!.token);
          setState(() {
            storageService.saveToken(response['str']);
            timer.cancel();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(num: 2)));
          });
        }
      }catch(e){
        timer.cancel();
        Navigator.of(context).pop();
        Alert(context: context, title: "ошибка", type: AlertType.error, desc: e.toString(), buttons: []).show();
      }
    });
  }


  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 5,
                  child:QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: colorGreen, borderRadius: 10, borderLength: 30,
                      borderWidth: 15, cutOutSize: 300
                    ),
                  )
              ),
              Expanded(flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: eBtnGold,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Отмена'),
                    ),
                  )
              )
            ],
          ),
        );
      },
    );
  }

  void _onQRViewCreated(QRViewController qrController) async {
    setState(() {
      this.qrController = qrController;
    });
    qrController.scannedDataStream.listen((scanData){
      qrController.pauseCamera();
      setState(() {
        result = scanData;
        String? token = result?.code;
        if(token!=null){
          if(token.startsWith(prefixQr)){
            String remainingToken = token.substring(prefixQr.length);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileLoginQrKey(token: remainingToken)));
            // _sendToken(remainingToken);
          }
          // _showCodeInputDialog(context, token);
        }
      });
      qrController.resumeCamera();
    });
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }
}


class EGovResultTokenModel {
  final int errorCode;
  final DateTime created;
  final String token;

  EGovResultTokenModel({
    required this.errorCode,
    required this.created,
    required this.token,
  });

  factory EGovResultTokenModel.fromJson(Map<String, dynamic> json) {
    return EGovResultTokenModel(
      errorCode: json['errorCode'],
      created: DateTime.parse(json['created']),
      token: json['token'],
    );
  }
}

class EGovResultModel {
  final bool isDone;
  final EGovResultTokenModel? token;

  EGovResultModel({
    required this.isDone,
    this.token
  });

  factory EGovResultModel.fromJson(Map<String, dynamic> json) {
    return EGovResultModel(
      isDone: json['isDone'],
      token: json['token'] != null ? EGovResultTokenModel.fromJson(json['token']) : null,
    );
  }
}