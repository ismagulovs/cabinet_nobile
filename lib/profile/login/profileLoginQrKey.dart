import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../http.dart';
import '../../main.dart';
import '../../storage.dart';
import '../../theme.dart';


class ProfileLoginQrKey extends StatefulWidget {
  final String token;

  const ProfileLoginQrKey({super.key, required this.token});
  @override
  _ProfileLoginQrKeyState createState() => _ProfileLoginQrKeyState();
}

class _ProfileLoginQrKeyState extends State<ProfileLoginQrKey> {
  final List<TextEditingController> _controllers = List.generate(5, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (index) => FocusNode());

  final SecureStorageService secureStorageService = SecureStorageService();
  final HttpService httpServer = HttpService();

  String _token = '';

  @override
  void initState() {
    super.initState();
    _token = widget.token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: IconButton(icon: Icon(Icons.close), onPressed: () {_close();}),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => _buildCodeBox(index)),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitCode,
              style: eBtn,
              child: const Text('Отправить', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeBox(int index) {
    return Container(
      width: 60,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if(value.length == 1 && index < 3){
            FocusScope.of(context).requestFocus(_focusNodes[index +1]);
          } else if(value.isEmpty && index > 0){
            FocusScope.of(context).requestFocus(_focusNodes[index -1]);
          }else{
            _focusNodes[index].unfocus();
          }
        },
      ),
    );
  }

  void _sendToken(String token, String key) async {
    try{
      print('send');
      Map<String, dynamic> response = await httpServer.authReg(token, key);
      setState(() {
        print('Response data: ${response}');
        String newToken = response['str'];
        secureStorageService.saveToken(newToken);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(num: 2)));
      });
    }catch (e){
      setState(() {
        print(e);
        if(e.toString().endsWith("key")){
          _controllers.forEach((element) {
            element.text="";
          });
          Alert(context: context, title: "введен неверный код",
              type: AlertType.error,
              desc: 'попробуйте еще раз',
              buttons: []
          ).show();
        }else{
          Alert(context: context, title: "ошибка регистрации устройства",
              type: AlertType.error,
              desc: 'попробуйте обновить страницу в браузере и попробовать еще раз '+e.toString(),
              buttons: []
          ).show().then((value) => {
            _close()
          });
        }
      });
    }
  }

  void _submitCode() {
    String code = _controllers.map((c) => c.text).join();
    _sendToken(_token, code);
    print('Entered Code: $code');
  }
  void _close() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MyHomePage(num: 2)));
  }
}
