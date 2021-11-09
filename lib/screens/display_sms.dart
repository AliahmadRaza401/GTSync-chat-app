import 'package:flutter/material.dart';

class DisplaySMS extends StatelessWidget {
  var num;
  var msg;
  DisplaySMS({@required this.msg, @required this.num});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(num ?? ""),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(msg),
            ),
          ],
        ),
      ),
    );
  }
}
