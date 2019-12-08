import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timestamp/screens/my_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Explicit
  final formKey = GlobalKey<FormState>();
  String nameStringf, nameStringl, emailString, passwordString, _mySelection;
  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String _myStatic;
  List<Map> _myJson = [{"id":0,"name":"<New>"},{"id":1,"name":"Test Practice"}];

  // final String url = "http://webmyls.com/php/getdata.php";
  final String url = "http://8a7a08360daf.sn.mynetname.net:2528/api/getprovince";

  List data = List(); //edited line

  Future<String> getSWData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
    });

    print(resBody);

    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    this.getSWData();
  }

  // Method
  Widget nameTextf() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'ชื่อ :',
        labelStyle: TextStyle(color: Colors.orange),
        helperText: 'Type Firstname',
        helperStyle: TextStyle(color: Colors.orange),
        icon: Icon(
          Icons.face,
          size: 36.0,
          color: Colors.orange,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Type Firstname';
        } else {
            return null;
        }
      },
      onSaved: (String value) {
        nameStringf = value;
      },
    );
  }

  Widget nameTextl() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'นามสกุล :',
        labelStyle: TextStyle(color: Colors.pink[400]),
        helperText: 'Type Lastname',
        helperStyle: TextStyle(color: Colors.pink[400]),
        icon: Icon(
          Icons.face,
          size: 36.0,
          color: Colors.pink[400],
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Type Lastname';
        } else {
            return null;
        }
      },
      onSaved: (String value) {
        nameStringl = value;
      },
    );
  }

  Widget emailText() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'รหัสพนักงานTOT/OS :',
        labelStyle: TextStyle(color: Colors.blue),
        helperText: 'TOT Employee Id/OS Id',
        helperStyle: TextStyle(color: Colors.blue),
        icon: Icon(
          Icons.email,
          size: 36.0,
          color: Colors.blue,
        ),
      ),
      validator: (String value) {
        // if (!((value.contains('@')) && (value.contains('.')))) {
        if (value.length <= 5) {
          return 'Type Employee Id';
        } else {
            return null;
        }
      },
      onSaved: (String value) {
        emailString = value;
      },
    );
  }

  Widget passwordText() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: 'พาสเวิร์ด :',
        labelStyle: TextStyle(color: Colors.green),
        helperText: 'MoreThan 6 Digits',
        helperStyle: TextStyle(color: Colors.green),
        icon: Icon(
          Icons.lock,
          size: 36.0,
          color: Colors.green,
        ),
      ),
      validator: (String value) {
        if (value.length <= 5) {
          return 'Password Much More 6 Digits';
        } else {
            return null;
        }
      },
      onSaved: (String value) {
        passwordString = value;
      },
    );
  }

  Widget dropdownButton(){
    return DropdownButton(
        icon: Icon(Icons.arrow_downward),
        hint: Text('กรุณาเลือก จังหวัด'),
        iconSize: 36,
        elevation: 26,
        style: TextStyle(
          color: Colors.deepPurple,
          fontSize: 18.0,
        ),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
          items: data.map((item) {
            return new DropdownMenuItem(
              child: new Text(item['province']),
              value: item['EN'],
            );
          }).toList(),
          onChanged: (newVal) {
            setState(() {
              _mySelection = newVal;
            });
          },
          value: _mySelection,
        );

  }

  Widget dropdownstatic(){
    return DropdownButton(
            isDense: true,
            hint: new Text("Select"),
            value: _myStatic,
            onChanged: (String newValue) {

              setState(() {
                _mySelection = newValue;
              });

              print (_mySelection);
            },
            items: _myJson.map((Map map) {
              return new DropdownMenuItem<String>(
                value: map["id"].toString(),
                child: new Text(
                  map["name"],
                ),
              );
            }).toList(),
        );

  }

  Widget uploadButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        print('Upload');
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print(
              'Namef = $nameStringf, Namel = $nameStringl, Email = $emailString, Pass = $passwordString, Drop = $_mySelection');
          register();
        }
      },
    );
  }

  Future<void> register() async {
    // http://8a7a08360daf.sn.mynetname.net:2528/api/getprovince";
    String urlpost = "http://8a7a08360daf.sn.mynetname.net:2528/api/signup";
    String fullname = '$nameStringf $nameStringl';
    var body = {
          "fullname": fullname,
          "username": emailString.trim(),
          "password": passwordString.trim(),
          "province": _mySelection.trim(),
          "fname": nameStringf.trim()
        };
      //setUpDisplayName();
    // var response = await get(urlString);
    var response = await http.post(urlpost, body: body);

    if (response.statusCode == 200) {
    print(response.statusCode);
    var result = json.decode(response.body);
    // print('result = $result');

    if (result.toString() == 'null') {
      myAlert('Not Insert', 'No Create in my Database');
    } else {
      if (result['status']){
      String getmessage = result['message'];
      myAlert('OK', '$getmessage');
      } else {
      myAlert('Not OK', 'message = Null');
      }
    }

    } else { //check respond = 200
      myAlert('Error', response.statusCode.toString());
    }
    
  }

  Future<void> setUpDisplayName() async {
    // await firebaseAuth.currentUser().then((response) {
    //   UserUpdateInfo updateInfo = UserUpdateInfo();
    //   updateInfo.displayName = nameString;
    //   response.updateProfile(updateInfo);

      var serviceRoute =
          MaterialPageRoute(builder: (BuildContext context) => Myservice());
          Navigator.of(context).pushAndRemoveUntil(serviceRoute, (Route<dynamic> route) => false);
    // });
  }

  void myAlert(String titleString, String messageString) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            titleString,
            style: TextStyle(color: Colors.red),
          ),
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
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text('ลงทะเบียน User'),
        actions: <Widget>[uploadButton()],
      ),
      body: Form(
        key: formKey,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 60.0),
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.8),
            ),
            width: 300.0,
            height: 700.0,
            child: Column(
              children: <Widget>[
                nameTextf(),
                nameTextl(),
                emailText(),
                passwordText(),
                dropdownButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
