import 'package:flutter/material.dart';
import 'package:timestamp/screens/my_service.dart';
import 'package:timestamp/screens/register.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    if (emailString.length <= 5 && passwordString.length <= 5){
       print('email = $emailString, password = $passwordString');
       myShowSnackBar('username && password ต้องไม่เท่ากับ ว่าง');
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
    */

    String urlString = 'http://101.109.115.27:2500/api/signin';

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
          String sValue = prefs.getString('stoken');
          // sValue.replaceAll('JWT ', '');
          print(sValue);

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
          hintText: 'More 5 Charactor',
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
          labelText: 'รหัสพนักงาน/OS :',
          hintText: 'TOT Employee Id',
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
      duration: Duration(seconds: 8),
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
