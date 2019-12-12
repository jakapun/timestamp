import 'package:flutter/material.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  // Explicit
  String codeCenter =
      'ยินดีต้อนรับ \r\n กรุณากด Icon \'แฮมเบอร์เกอร์\' มุมซ้ายบน \r\n หรือ slide หน้าจอจากขอบด้านซ้ายไปขวา';

  // Method
  Widget showImage() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      height: 200.0,
      child: codeCenter == null
          ? Image.asset('images/pic.png')
          : Image.asset('images/pic.png'),
    );
  }

  Widget showText() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        '$codeCenter',
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          showImage(),
          showText(),
        ],
      ),
    );
  }
}
