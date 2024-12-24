

import 'package:cabinet_mobile/main.dart';
import 'package:cabinet_mobile/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';



class HomePageWebview extends StatefulWidget {
  @override
  _HomePageWebviewState createState() => _HomePageWebviewState();
}

class _HomePageWebviewState extends State<HomePageWebview> {
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    String currentUrl = "";
    return InAppWebView(
      // initialUrlRequest: URLRequest(url: Uri.parse('https://app.powerbi.com/view?r=eyJrIjoiNDYzNzdiMTctYWFhZS00Mzg5LTkwOWMtMTU0ODYxZDk2MTNkIiwidCI6ImQyYjg5N2M3LWZmZWEtNDdmYi1iZGUwLTk3ZDBmOWFiZGQ3YyIsImMiOjl9')),
      initialUrlRequest: URLRequest(url: Uri.parse('https://app.powerbi.com/view?r=eyJrIjoiNDYzNzdiMTctYWFhZS00Mzg5LTkwOWMtMTU0ODYxZDk2MTNkIiwidCI6ImQyYjg5N2M3LWZmZWEtNDdmYi1iZGUwLTk3ZDBmOWFiZGQ3YyIsImMiOjl9')),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
          javaScriptEnabled: true,
        ),
        android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
        ),
        ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true,
        ),
      ),
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
    );
  }
  void _close(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(num: 0)));
  }

}