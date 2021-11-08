import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gtsync/widgets/recent_chats.dart';
import 'package:sms/sms.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final fireBaseDB = FirebaseDatabase.instance.reference();
  SmsQuery query = new SmsQuery();
  List messages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllMessages();
    print('init');
  }

  fetchSMS() async {
    print("get SMS");
    var sms = await query.getAllSms;
    setState(() {
      messages = sms;
    });
    print('messages: $messages');
  }

  Future getAllMessages() async {
    await fetchSMS();
    messages.forEach((element) {
      fireBaseDB.push().set(
        {
          'number': element.address,
          'message': element.body,
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SMS Inbox"),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecentChats(),
                  ),
                );
              },
              splashColor: Color(0xff022b5e),
              child: Icon(
                Icons.message_rounded,
              ),
            ),
          ),
        ],
      ),
      body: messages == null
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                  ),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.markunread,
                      color: Colors.red,
                    ),
                    title: Text(messages[index].address),
                    subtitle: Text(
                      messages[index].body,
                      maxLines: 2,
                      style: TextStyle(),
                    ),
                  ),
                );
              }),
    );
  }
}
