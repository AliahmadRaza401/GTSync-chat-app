import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gtsync/widgets/favorite_contacts.dart';
import 'package:gtsync/widgets/recent_chats.dart';
import 'package:sms/sms.dart';

import 'new_message.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final fireBaseDB = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllMessages();
  }

  // final databaseRef = FirebaseDatabase._instance_.reference(); //database reference object

  // void addData(String data) {
  //   databaseRef.push().set({'name': data, 'comment': 'A good season'});
  // }

  Future getAllMessages() async {
    SmsQuery query = new SmsQuery();
    List<SmsMessage> messages = await query.getAllSms;
    print("Total Messages : " + messages.length.toString());
    messages.forEach((element) {
      fireBaseDB.push().set({'number': '', 'message': element.body});

      print(element.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {},
        ),
        title: Text(
          'Chats',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          // CategorySelector(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  FavoriteContacts(),
                  RecentChats(),
                ],
              ),
            ),
          ),
        ],
      ),
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NewMessage()));
          // setState(() {
          //   i++;
          // });
        },
      ),
    );
  }
}
