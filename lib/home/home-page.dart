

import 'package:cabinet_mobile/home/home-page-webview.dart';
import 'package:flutter/material.dart';

import '../theme.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 40, top: 40, right: 40),
      child: Column(
        children: [
          ElevatedButton(
            style: eBtnGold,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePageWebview()));
            },
            child: Row( mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.list_alt),  SizedBox(width: 5), Text('Статистика')],),
          ),
        ],
      ) ,
    );
  }
}