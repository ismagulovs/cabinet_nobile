import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../http.dart';
import '../theme.dart';


class NoticePage extends StatefulWidget {
  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  final List<String> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final HttpService httpService = HttpService();
  late Future<List<Notice>> noticesRes;

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(_controller.text);
        _controller.clear();
      });
    }
  }
  @override
  void initState()  {
    super.initState();
    getNoticeData();
  }

  void getNoticeData(){
    setState(() {
      noticesRes = httpService.getNoticeList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Notice>>(
        future: noticesRes,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else if (snap.hasError)
            return Center(child: Text('Error: ${snap.error}'));
          else if (snap.hasData) {
            List<Notice>? notices = snap.data;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: notices?.length,
                    itemBuilder: (context, index) {
                      return _buildChat(notices?[index].messageRus, notices?[index].createDateTime, true);
                    },
                  ),
                ),
              ],
            );
          }else{
            return Center(child: Text('data not found'));
          }
        },);
  }

  Widget _buildChat(String? message, String? dateString, bool isSentByMe){
    DateTime datetime = DateTime.parse(dateString!);
    String _date = DateFormat('dd.MM.yyyy HH:mm').format(datetime);
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSentByMe ? colorGold : Colors.grey[300],
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16.0),
              topLeft: Radius.circular(16.0), bottomRight:  Radius.zero, topRight:  Radius.circular(16.0)),
        ),
        child: Column(
          crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text( message ?? '',
              style: TextStyle(
                color: isSentByMe ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Text(
              _date ?? '',
              style: TextStyle(
                color: isSentByMe ? Colors.white70 : Colors.black54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Notice{
  int id;
  String? createDateTime;
  String? messageKaz;
  String? messageRus;
  String? messageEng;


  Notice({required this.id, this.createDateTime, this.messageKaz, this.messageRus, this.messageEng});


  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'],
      createDateTime: json['createDateTime'],
      messageKaz: json['messageKaz'],
      messageRus: json['messageRus'],
      messageEng: json['messageEng']
    );
  }
}