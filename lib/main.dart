import 'package:cabinet_mobile/profile/profile.dart';
import 'package:cabinet_mobile/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

import 'bottomNavBar.dart';
import 'home/home-page-webview.dart';
import 'home/home-page.dart';
import 'home/home.dart';
import 'notice/notice.dart';
import 'storage.dart';


String? token;
bool isAuth = false;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'KDB',
      theme: appTheme,
      home: const MyHomePage(num: 0),
    );
  }
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyHomePage extends StatefulWidget {
  final int num;
  const MyHomePage({super.key, required this.num});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SecureStorageService secureStorageService = SecureStorageService();
  int _num = 0;
  @override
  void initState() {
    super.initState();
    _num = widget.num;
  }

  static final List<Widget> _widgetOptions = <Widget>[
    HomePageWebview(),
    Notice(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _num = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(0, 122, 64, 0.9),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Image.asset('assets/logo_ru.png', height: 40),
          SizedBox(width: 10),
          // Text('БРК', style: TextStyle(color: Colors.white),)
          ],
        )
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: _widgetOptions.elementAt(_num),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _num,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home page'),
    );
  }
}

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('News page'),
    );
  }
}