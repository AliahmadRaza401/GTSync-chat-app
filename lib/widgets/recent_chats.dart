import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:gtsync/screens/display_sms.dart';
import 'package:sms/sms.dart';

class RecentChats extends StatefulWidget {
  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  var sms = FirebaseDatabase.instance.reference().child('sms');
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getData();
    print('loading init: $loading');
  }

  Future getData() async {
    var sms = await FirebaseDatabase.instance.reference().child('sms');
  }

  void messageSent(number, msg) {
    SmsSender sender = new SmsSender();
    SmsMessage message = new SmsMessage(number, msg);
    sender.sendSms(message);
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
      } else if (state == SmsMessageState.Fail) {
        var snackBar = SnackBar(
          content: Text('SMS not sent!'),
          duration: const Duration(milliseconds: 500),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        var snackBar = SnackBar(
          content: Text('Error!!'),
          duration: const Duration(milliseconds: 500),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web Messages"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
          Container(
            child: FirebaseAnimatedList(
              shrinkWrap: true,
              query: sms,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                loading = false;
                print('snapshot: $snapshot');
                print('loading: $loading');
                messageSent(
                  snapshot.value['number'],
                  snapshot.value['message'],
                );
                return Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisplaySMS(
                                msg: snapshot.value['message'],
                                num: snapshot.value['number']),
                          ),
                        );
                      },
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
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
