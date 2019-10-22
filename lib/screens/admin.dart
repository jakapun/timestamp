import 'package:flutter/material.dart';
import 'package:timestamp/screens/my_home.dart';
import 'package:timestamp/screens/new_section.dart';
import 'package:timestamp/screens/relate_id.dart';

class AdminSec extends StatefulWidget {
  @override
  _AdminSecState createState() => _AdminSecState();
}

class _AdminSecState extends State<AdminSec> {
  double mySize = 100.0;
  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  String emailString = '', passwordString = '';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Widget currentWidget;

  // Method

  @override
  void initState() {
    super.initState();
    // checkStatus();
  }

  Future<void> checkStatus() async {
    moveToService();
  }

  void moveToService() {
    var serviceRoute =
        MaterialPageRoute(builder: (BuildContext context) => MyHome());
    Navigator.of(context)
        .pushAndRemoveUntil(serviceRoute, (Route<dynamic> route) => false);
  }

  Widget mySizeBox() {
    return SizedBox(
      width: 8.0,
    );
  }

  Widget singUpButton() {
    return OutlineButton(
      borderSide: BorderSide(color: Colors.green.shade900),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Text(
        'สร้างข้อมูล ศูนย์/ส่วน',
        style: TextStyle(color: Colors.green.shade900),
      ),
      onPressed: () {
        print('You Click SingUp');

        // Create Route
        // var registerRoute =
        //     MaterialPageRoute(builder: (BuildContext context) => Myservice());
        // Navigator.of(context).push(registerRoute);

        // Navigator.of(context).pop();
        // setState(() {
        //   currentWidget = NewSection();
        // });

        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => NewSection());
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget singInButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Colors.green[900],
      child: Text(
        'ผูก รหัสพนักงาน',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        // formKey.currentState.save();
        // checkAuthen();
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => RelateId());
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Future<void> checkAuthen() async {
    print('email = $emailString, password = $passwordString');
    // await firebaseAuth
    //     .signInWithEmailAndPassword(
    //         email: emailString, password: passwordString)
    //     .then((response) {
    //   print('Authen Success');
    //   moveToService();
    // }).catchError((response) {
    //   String errorString = response.message;
    //   print('error = $errorString');
    //   myShowSnackBar(errorString);
    // });
  }

  Widget myButton() {
    return Container(
      width: 220.0,
      child: Row(
        children: <Widget>[
          Expanded(
            child: singInButton(),
          ),
          mySizeBox(),
          Expanded(
            child: singUpButton(),
          ),
        ],
      ),
    );
  }

  Widget passwordText() {
    return Container(
      width: 220.0,
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password :',
          hintText: 'More 6 Charactor',
        ),
        onSaved: (String value) {
          passwordString = value;
        },
      ),
    );
  }

  Widget emailText() {
    return Container(
      width: 220.0,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Email :',
          hintText: 'you@email.com',
        ),
        onSaved: (String value) {
          emailString = value;
        },
      ),
    );
  }

  Widget showLogo() {
    return Container(
      width: mySize,
      height: mySize,
      child: Image.asset(
        'images/logo.png',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget showText() {
    return Text(
      'Admin เซคชั่น',
      style: TextStyle(
          fontSize: 45.0,
          fontWeight: FontWeight.bold,
          color: Colors.brown[800],
          fontFamily: 'PermanentMarker'),
    );
  }

  void myShowSnackBar(String messageString) {
    SnackBar snackBar = SnackBar(
      content: Text(messageString),
      backgroundColor: Colors.green[700],
      duration: Duration(seconds: 8),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
        textColor: Colors.orange,
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // showLogo(),
                showText(),
                myButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
