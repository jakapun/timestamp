import 'package:flutter/material.dart';

class Mysuccess extends StatefulWidget {

  final String successtxt;

  Mysuccess({
    Key key,
    @required this.successtxt,
  }) : super(key: key);

  @override
  _MysuccessState createState() => _MysuccessState();
}

class _MysuccessState extends State<Mysuccess> {

  String txtisshow = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      txtisshow = widget.successtxt;
    });
  }

  Widget showText() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        '$txtisshow \r\n slide หน้าจอจากขอบด้านซ้ายไปขวา \r\n เลือกเมนูเพื่อทำงานต่อ',
        style: TextStyle(fontSize: 22.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.white, Colors.green.shade900],
              radius: 1.2,
            ),
          ),
          alignment: Alignment.center,
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showText(),
              ],
            ),
          ),
        ),
      ),
    );
    // return Container(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       showText(),
    //     ],
    //   ),
    // );
  }
}