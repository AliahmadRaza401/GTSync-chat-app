import 'package:contact_picker/contact_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var selectedNumber;
  var numberController = TextEditingController();
  var messageController = TextEditingController();
  final fireBaseDB = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Write new Message"),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMessageComposerNumber(),
            Container(
              child: Column(
                children: [
                  Divider(),
                  _buildMessageComposer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> openContactBook() async {
    Contact contact = await ContactPicker().selectContact();
    if (contact != null) {
      var phoneNumber = contact.phoneNumber.number
          .toString()
          .replaceAll(new RegExp(r"\s+"), "");
      return phoneNumber;
    }
    return "";
  }

  _buildMessageComposerNumber() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: <Widget>[
              // IconButton(
              //   icon: Icon(Icons.photo),
              //   iconSize: 25.0,
              //   color: Theme.of(context).primaryColor,
              //   onPressed: () {},
              // ),
              Expanded(
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.number,
                  controller: numberController,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {},
                  decoration: InputDecoration.collapsed(
                    hintText: 'Contact Number',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                iconSize: 25.0,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  selectedNumber = openContactBook();
                  setState(() {
                    numberController.text = selectedNumber;
                    //                 numberController.value = numberController.value.copyWith(
                    //   text: numberController.text + selectedNumber,
                    //   selection: TextSelection.collapsed(offset: numberController.value.selection.baseOffset + selectedNumber.length,),
                    // );
                  });
                },
              ),
            ],
          ),
          Divider()
        ],
      ),
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              controller: messageController,
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              fireBaseDB.push().set({
                'number': numberController.text,
                'message': messageController.text
              });
            },
          ),
        ],
      ),
    );
  }
}
