import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:gtsync/models/message_model.dart';
import 'package:gtsync/screens/chat_screen.dart';

class RecentChats extends StatefulWidget {
  // RecentChats({required this.app});
  // final FirebaseApp app;
  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  final databaseReference = FirebaseDatabase.instance.reference().child("sms");
  var sms = FirebaseDatabase.instance.reference().child('sms');
  final fb = FirebaseDatabase.instance;
  @override
  void initState() {
    super.initState();
    readData();
    // sms = databaseReference.reference().child('sms');
  }

  void readData() {
    print("run");
    // var sms = databaseReference.child('message');
    // print('data: ${sms.get()}');
    databaseReference.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });
    print("-----------");
  }

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference().child("sms");
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.greenAccent,
        child: Column(
          children: [
            Text("Send Message"),
            ElevatedButton(
              onPressed: () {
                print("click");
                ref.child("message").once().then((DataSnapshot data) {
                  print(data.value);
                });
              },
              child: Text("GET"),
            ),
            Flexible(
              child: FirebaseAnimatedList(
                shrinkWrap: true,
                query: sms,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  return new ListTile(
                    title: new Text(snapshot.value['message']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
