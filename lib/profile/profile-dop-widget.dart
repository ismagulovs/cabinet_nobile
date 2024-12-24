import 'package:cabinet_mobile/profile/profile-page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../http.dart';
import '../theme.dart';

class ProfileDopWidget extends StatefulWidget {
  final User user;

  const ProfileDopWidget({super.key, required this.user});

  @override
  _ProfileDopWidget createState() => _ProfileDopWidget();
}

class _ProfileDopWidget extends State<ProfileDopWidget>{
  final HttpService httpServer = HttpService();

  int _highlightedIndex = -1;

  List<String> _columns = [
    "номер телефон",//0
    "электронная почта",//1
    "Должность на казахском языке",//2
    "Должность на русском языке",//3
    "Должность на английском языке",//4
  ];

  void toggleHighlight(int index) {
    setState(() {
      _highlightedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return  Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.zero,
        child:  Column(
          children: [
            _buildDopText(widget.user!.phone, Icons.phone, 0),
            _buildDopText(widget.user!.email, Icons.email_outlined, 1),
            CheckboxListTile(
                title: const Text('Вы являетесь бухгалтером компании?'),
                value: widget.user!.bux,
                onChanged: (bool? value){
                  setState(() {
                    _sendBux(value!);
                  });
                }
            ),
            Visibility(
              visible: !widget.user!.bux,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDopText(widget.user!.positionKazDb, Icons.account_box, 2),
                    _buildDopText(widget.user!.positionRusDb, Icons.account_box, 3),
                    _buildDopText(widget.user!.positionEngDb, Icons.account_box, 4),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _sendBux(bool _bux) async {
    try {
      Map<String, dynamic> response = await httpServer.updateUserBux(_bux);
      if (response['errorCode'] == 0) {
        setState(() {
          widget.user!.bux = _bux;
        });
      } else {
        _showErrorAlert('Ошибка обновления данных');
      }
    } catch (e) {
      _showErrorAlert(e.toString());
    }
  }

  void _showErrorAlert(String message) {
    Alert(context: context, title: "Ошибка", content: Text(message)).show();
  }


  void _showChangePhone() {

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final MaskedTextController _controller = MaskedTextController(mask: '+70000000000');

    _controller.text = widget.user.phone;

    String? _validatePhone(String? value) {
      if (value == null || value.isEmpty) {
        return 'Поле не должно быть пустым';
      }
      if (value.length!=12) {
        return 'Введите корректный номер телефона';
      }
      return null;
    }
    Alert(
      title: "Изменение номера телефона",
      content: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: TextFormField(
            controller: _controller,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Номер телефона',
              hintText: 'Ввкдите номер телефона',
              prefixIcon: Icon(Icons.phone),
            ),
            validator: _validatePhone,
          ),
        ),
      ),
      context: context,
      style: myAlert,
      type: AlertType.none,
      buttons: [
        DialogButton(onPressed:(){
          if (_formKey.currentState!.validate()) {
              _sendUserUpdate(_controller.text, 0);

          }
        }, color: colorGold, child: Text('Сохранить')),
        DialogButton(onPressed:(){ Navigator.of(context).pop(); }, color: Colors.white70, child: Text('Отмена'))
      ],
    ).show();
  }

  void _showChangeEmail() {

    final TextEditingController _controller = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    String? _validateEmail(String? value) {
      if (value == null || value.isEmpty) {
        return 'Поле не должно быть пустым';
      }
      final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      if (!regex.hasMatch(value)) {
        return 'Введите корректный адрес электронной почты';
      }
      return null;
    }

    _controller.text = widget.user.email;

    Alert(
      title: "Изменение электронной почты",
      content: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Электронная почта',
                  hintText: 'example@domain.com',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: _validateEmail,
              ),
            ],
          ),
        ),
      ),
      context: context,
      style: myAlert,
      type: AlertType.none,
      buttons: [
        DialogButton(onPressed:(){
          if (_formKey.currentState!.validate()) {
            _sendUserUpdate(_controller.text, 1);
          }
        }, color: colorGold, child: Text('Сохранить')),
        DialogButton(onPressed:(){ Navigator.of(context).pop(); }, color: Colors.white70, child: Text('Отмена'))
      ],
    ).show();
  }

  void _showChangePositionKaz() {

    final TextEditingController _controller = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    String? _validate(String? value) {
      if (value == null || value.isEmpty) {
        return 'Поле не должно быть пустым';
      }
      return null;
    }

    _controller.text = widget.user.positionKazDb;

    Alert(
      title: "Изменение Должность на казахском языке",
      content: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Должность на казахском языке',
                  hintText: 'Должность',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_box),
                ),
                validator: _validate,
              ),
            ],
          ),
        ),
      ),
      context: context,
      style: myAlert,
      type: AlertType.none,
      buttons: [
        DialogButton(onPressed:(){
          if (_formKey.currentState!.validate()) {
            _sendUserUpdate(_controller.text, 2);
          }
        }, color: colorGold, child: Text('Сохранить')),
        DialogButton(onPressed:(){ Navigator.of(context).pop(); }, color: Colors.white70, child: Text('Отмена'))
      ],
    ).show();
  }

  void _showChangePositionRus() {

    final TextEditingController _controller = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    String? _validate(String? value) {
      if (value == null || value.isEmpty) {
        return 'Поле не должно быть пустым';
      }
      return null;
    }

    _controller.text = widget.user.positionRusDb;

    Alert(
      title: "Изменение Должность на русском языке",
      content: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Должность на русском языке',
                  hintText: 'Должность',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_box),
                ),
                validator: _validate,
              ),
            ],
          ),
        ),
      ),
      context: context,
      style: myAlert,
      type: AlertType.none,
      buttons: [
        DialogButton(onPressed:(){
          if (_formKey.currentState!.validate()) {
            _sendUserUpdate(_controller.text, 3);
          }
        }, color: colorGold, child: Text('Сохранить')),
        DialogButton(onPressed:(){ Navigator.of(context).pop(); }, color: Colors.white70, child: Text('Отмена'))
      ],
    ).show();
  }
  void _showChangePositionEng() {

    final TextEditingController _controller = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    String? _validate(String? value) {
      if (value == null || value.isEmpty) {
        return 'Поле не должно быть пустым';
      }
      return null;
    }

    _controller.text = widget.user.positionEngDb;

    Alert(
      title: "Изменение ДДолжность на английском языке",
      content: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Должность на английском языке',
                  hintText: 'Должность',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_box),
                ),
                validator: _validate,
              ),
            ],
          ),
        ),
      ),
      context: context,
      style: myAlert,
      type: AlertType.none,
      buttons: [
        DialogButton(onPressed:(){
          if (_formKey.currentState!.validate()) {
            _sendUserUpdate(_controller.text, 4);
          }
        }, color: colorGold, child: Text('Сохранить')),
        DialogButton(onPressed:(){ Navigator.of(context).pop(); }, color: Colors.white70, child: Text('Отмена'))
      ],
    ).show();
  }

  _sendUserUpdate(String text, int index) async {
    try{
      Map<String, dynamic> response;
      switch(index){
        case 0: response = await httpServer.updateUserPhone(text); break;
        case 1: response = await httpServer.updateUserEmail(text); break;
        case 2: response = await httpServer.updateUserPositionKaz(text); break;
        case 3: response = await httpServer.updateUserPositionRus(text); break;
        case 4: response = await httpServer.updateUserPositionEng(text); break;
        default: throw Exception("error");
      }
      if (response['errorCode'] == 0) {
        setState(() {
          switch(index){
            case 0: widget.user.phone = text;
            case 1: widget.user.email = text;
            case 2: widget.user.positionKazDb = text;
            case 3: widget.user.positionRusDb = text;
            case 4: widget.user.positionEngDb = text;
            default: throw Exception("error");
          }
        });
      }else{
        _showErrorAlert('Ошибка обновления данных');
      }
      Navigator.of(context).pop();
    }catch (e){
      Navigator.of(context).pop();
      _showErrorAlert('Ошибка обновления данных');
    }
  }

  void _showContextMenu(BuildContext context, int index, Offset position) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx, position.dy),
      items: [
        PopupMenuItem<int>(value: 0, child: Text("Изменить")),
      ],
    ).then((value) {
      if (value != null) {
        switch (index){
          case 0: _showChangePhone(); break;
          case 1: _showChangeEmail(); break;
          case 2: _showChangePositionKaz(); break;
          case 3: _showChangePositionRus(); break;
          case 4: _showChangePositionEng(); break;
        }
      }
    });
  }

  Widget _buildDopText(String text, IconData icon, int index){
    return
      GestureDetector(
        onLongPressStart: (LongPressStartDetails details){ _showContextMenu(context, index, details.globalPosition);},
        child: ElevatedButton(
          style: eBtnNone,
          child:
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child:  Row(children: [
              Icon(icon, size: 36, color: colorGreen,),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text, style: const TextStyle(fontSize: 18),),
                  Text(_columns[index], style: const TextStyle(fontSize: 10),)],
              )
            ],),
          ),
          onPressed: () {},
          // on: () => toggleHighlight(0),
        ),
      );
  }

}
