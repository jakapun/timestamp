import 'dart:io';
import 'package:flutter/material.dart';
import 'package:timestamp/screens/admin.dart';
import 'package:timestamp/screens/my_home.dart';
import 'package:timestamp/screens/qrbarcode.dart';
import 'package:timestamp/screens/stamp_in.dart';
import 'package:timestamp/screens/stamp_out.dart';

class Myservice extends StatefulWidget {

  @override
  _MyserviceState createState() => _MyserviceState();
}

class _MyserviceState extends State<Myservice> {

  Widget currentWidget = MyHome();

  Widget menuFormPage() {
    return ListTile(
      leading: Icon(
        Icons.alarm_add,
        size: 36.0,
        color: Colors.green[400],
      ),
      title: Text(
        'ลงเวลาเข้า',
        style: TextStyle(fontSize: 18.0),
        ),
      // on tap == on click
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          currentWidget = StampIn();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  Widget menuListViewPage() {
    return ListTile(
      leading: Icon(
        Icons.alarm_off,
        size: 36.0,
        color: Colors.red,
      ),
      title: Text(
        'ลงเวลาออก',
        style: TextStyle(fontSize: 18.0),
        ),
      // on tap == on click
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          currentWidget = StampOut();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  Widget menuQRcode() {
    return ListTile(
      leading: Icon(
        Icons.crop_free,
        size: 36.0,
        color: Colors.purple,
      ),
      title: Text(
        'สแกน Qrcode/Barcode',
        style: TextStyle(fontSize: 18.0),
      ),
      onTap: () {
        setState(() {
          currentWidget = QrBarcode();
          Navigator.of(context).pop();
        });
      },
    );
  }

  Widget menuAdmin() {
    return ListTile(
      leading: Icon(
        Icons.android,
        size: 36.0,
        color: Colors.purple,
      ),
      title: Text(
        'Admin เซคชั่น',
        style: TextStyle(fontSize: 18.0),
      ),
      onTap: () {
        setState(() {
          currentWidget = AdminSec();
          Navigator.of(context).pop();
        });
      },
    );
  }

  Widget signOutAnExit() {
    return ListTile(
      leading: Icon(
        Icons.exit_to_app,
        size: 36.0,
        color: Colors.red,
      ),
      title: Text(
        'ยกเลิกการใช้งาน',
        style: TextStyle(fontSize: 18.0),
      ),
      onTap: () {
        mySignOut();
      },
    );
  }

  Future<void> mySignOut() async {
    
      exit(0);
  
  }

  Widget showLogo() {
    return Container(
      width: 80.0,
      height: 80.0,
      child: Image.asset(
          'images/logo.png'), // https://www.iconfinder.com/search/?q=travel&price=free&maximum=512
    );
  }

  Widget myHead() {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.white, Colors.yellow[900]],
          radius: 1.5,
          center: Alignment.center,
        ),
      ),
      child: Column(
        children: <Widget>[
          showLogo(),
          Text(
            'Timestamp',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.blue[900],
            ),
          ),
          Text('Login by'),
        ],
      ),
    );
  }

  Widget myDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          myHead(),
          menuListViewPage(),
          Divider(),
          menuFormPage(),
          Divider(),
          menuQRcode(),
          Divider(),
          menuAdmin(),
          Divider(),
          signOutAnExit(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    findDisplayName();
  }

  Future<void> findDisplayName() async {
    // FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    setState(() {

    });
    print('name =');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Service'),
      ),
      body: currentWidget,
      drawer: myDrawer(), // call drawer
    );
  }
}