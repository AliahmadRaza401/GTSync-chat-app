import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:sms/sms.dart';

class RecentChats extends StatefulWidget {
  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  var sms = FirebaseDatabase.instance.reference().child('sms');

  void messageSent(number, msg) {
    SmsSender sender = new SmsSender();
    SmsMessage message = new SmsMessage(number, msg);
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        var snackBar = SnackBar(
          content: Text('SMS is sent!'),
          duration: const Duration(milliseconds: 500),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (state == SmsMessageState.Delivered) {
        var snackBar = SnackBar(
          content: Text('SMS is delivered!'),
          duration: const Duration(milliseconds: 500),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        var snackBar = SnackBar(
          content: Text('Error!!\nSMS not sent!'),
          duration: const Duration(milliseconds: 500),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    sender.sendSms(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web Messages"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: FirebaseAnimatedList(
        shrinkWrap: true,
        query: sms,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          messageSent(
            snapshot.value['number'],
            snapshot.value['message'],
          );
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(
                Icons.markunread,
                color: Colors.red,
              ),
              title: Text(snapshot.value['number']),
              subtitle: Text(
                snapshot.value['message'],
                maxLines: 2,
                style: TextStyle(),
              ),
            ),
          );
        },
      ),
    );
  }
}
