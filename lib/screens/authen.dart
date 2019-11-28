import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timestamp/screens/my_service.dart';
import 'package:timestamp/screens/register.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imei_plugin/imei_plugin.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  double mySize = 100.0;
  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  String emailString = '', passwordString = '';
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _platformImei = 'Unknown';

  // Method

  @override
  void initState() {
    super.initState();
    initPlatformState();
    // checkStatus();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformImei;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei = await ImeiPlugin.getImei( shouldShowRequestPermissionRationale: false );
    } on PlatformException {
      platformImei = 'Failed to get platform version.';
      myShowSnackBar('$platformImei');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformImei = platformImei;
    });
  }

  Future<void> checkStatus() async {
    moveToService();
  }

  void moveToService() {
    var serviceRoute =
        MaterialPageRoute(builder: (BuildContext context) => Myservice());
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
        'Sign Up',
        style: TextStyle(color: Colors.green.shade900),
      ),
      onPressed: () {
        print('You Click SingUp');

        // Create Route
        var registerRoute =
            MaterialPageRoute(builder: (BuildContext context) => Register());
        Navigator.of(context).push(registerRoute);
      },
    );
  }

  Widget singInButton() {
    return RaisedButton(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Colors.green[900],
      child: Text(
        'Sign In',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        formKey.currentState.save();
        checkAuthen();
      },
    );
  }

  Future<void> checkAuthen() async {

    if ((emailString.length <= 5) || (passwordString.length <= 5)){
       print('email = $emailString, password = $passwordString');
       myShowSnackBar('$_platformImei username && password ต้องไม่เท่ากับ ว่าง');
    } else {

        // emailString = emailString.trim();
        // passwordString = passwordString.trim();

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
    /*
    str1.toLowerCase(); // lorem
    str1.toUpperCase(); // LOREM
    "   $str2  ".trim(); // 'Lorem ipsum'
    str3.split('\n'); // ['Multi', 'Line', 'Lorem Lorem ipsum'];
    str2.replaceAll('e', 'é'); // Lorém

    101.109.115.27:2500/api/flutterget/User=123456
    */
    // uid: user.fname, prv: user.province, priv: user.privilege
    String urlString = 'http://8a7a08360daf.sn.mynetname.net:2528/api/signin';

    var body = {
      "username": emailString.trim(),
      "password": passwordString.trim()
    };

    // var response = await get(urlString);
    var response = await post(urlString, body: body);

    if (response.statusCode == 200) {
    print(response.statusCode);
    var result = json.decode(response.body);
    // print('result = $result');

    if (result.toString() == 'null') {
      myAlert('User False', 'No $emailString in my Database');
    } else {
      // for (var myJSON in result) {
      //   print('myJSON = $myJSON');
      //   UserModel userModel = UserModel.fromJSON(myJSON);

      //   if (password == userModel.password.trim()) {
      //     print('Login Success $password');

      //     MaterialPageRoute materialPageRoute =
      //         MaterialPageRoute(builder: (BuildContext context) => MyService(userModel: userModel,));
      //     Navigator.of(context).pushAndRemoveUntil(
      //         materialPageRoute, (Route<dynamic> route) => false);
      //   } else {
      //     myAlert('Password False', 'Plese try Aganis Password False');
      //   }
      // }

        if (result['status']){
          String token = result['token'];
          token = token.split(' ').last;
          // print(token);
          if (token.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('stoken', token);
          //  read value from store_preference
          //  uid: user.fname, prv: user.province, priv: user.privilege
          await prefs.setString('suid', result['uid']);
          await prefs.setString('sprv', result['prv']);
          await prefs.setInt('spriv', result['priv']); //store preference Integer
          await prefs.setString('srelate', result['relate']);
          String sValue = prefs.getString('stoken');
          print(sValue);

          // ,headers: {HttpHeaders.authorizationHeader: "$sValue"},
          String urlString2 = 'http://8a7a08360daf.sn.mynetname.net:2528/api/flutterget/User=123456';
          var response2 = await get(urlString2, headers: {HttpHeaders.authorizationHeader: "JWT $sValue"});
          if (response2.statusCode == 200) {
             print(response2.statusCode);
             var result2 = json.decode(response2.body);
             if (result2['status']){
             String getmessage = result2['message'];
             print(getmessage);
             myAlert('OK', response2.statusCode.toString());
             } else {
             print('message = Null');
             }
          } else {
            myAlert('Error', response2.statusCode.toString());
          }



          // MaterialPageRoute materialPageRoute =
          //     MaterialPageRoute(builder: (BuildContext context) => Myservice(uname: emailString.trim()));
          MaterialPageRoute materialPageRoute =
               MaterialPageRoute(builder: (BuildContext context) => Myservice());
          Navigator.of(context).pushAndRemoveUntil(
              materialPageRoute, (Route<dynamic> route) => false);
          
          } else {
            myAlert('Respond Fail', 'Backend Not Reply');
          }
        } else {
          print(result['error']);
        }

    } // End else result.toString() != 'null'
    } else { //check respond = 200
      myAlert('Error', response.statusCode.toString());
    }

    } // End If check emailstring.length
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
          labelText: 'พาสเวิรด์ :',
          hintText: 'More 5 Digits',
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
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'รหัสพนักงาน/OS :',
          hintText: 'Employee Id',
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
      'Timestamp',
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
      duration: Duration(seconds: 15),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
        textColor: Colors.orange,
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget showTitleAlert(String title) {
    return ListTile(
      leading: Icon(
        Icons.add_alert,
        size: 36.0,
        color: Colors.red,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 24.0, color: Colors.red.shade800),
      ),
    );
  }

  void myAlert(String titleString, String messageString) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: showTitleAlert(titleString),
          content: Text(messageString),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
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
                showLogo(),
                showText(),
                emailText(),
                passwordText(),
                myButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
