import 'package:flutter/material.dart';

class StampOut extends StatefulWidget {
  @override
  _StampOutState createState() => _StampOutState();
}

class _StampOutState extends State<StampOut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ลงเวลาออก ทำงาน'),
      ),
    );
  }
}