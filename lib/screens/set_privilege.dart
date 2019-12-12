import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestamp/screens/my_service.dart';

class SetPriv extends StatefulWidget {
  SetPriv() : super();

  @override
  _SetPrivState createState() => _SetPrivState();
}

class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getCompanies() {
    return <Company>[
      Company(1, 'user (พนักงาน/os)'),
      Company(2, 'head (ผจ.ศูนย์/ผช.จังหวัด)'),
      Company(3, 'admin ประจำศูนย์'),
      // Company(4, 'sup'),
    ];
  }
}

class _SetPrivState extends State<SetPriv> {
  // Explicit
  final formKey = GlobalKey<FormState>();
  String nameString, emailString, passwordString, _mySelection, rstoreprv;
  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;

  List data = List(); //edited line

  Future<String> getSWData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tempprv = prefs.getString('sprv');
    String url =
        "http://8a7a08360daf.sn.mynetname.net:2528/api/getdivisions/$tempprv";
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
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    super.initState();
    this.getSWData();
  }

  List<DropdownMenuItem<Company>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Company>> items = List();
    for (Company company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Company selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }

  // Method
  Widget nameText() {
    return TextFormField(
      initialValue: '',
      decoration: InputDecoration(
        labelText: 'รหัสพนักงาน/OS :',
        labelStyle: TextStyle(color: Colors.pink[400]),
        helperText: 'Type Emplyee Id',
        helperStyle: TextStyle(color: Colors.pink[400]),
        icon: Icon(
          Icons.face,
          size: 36.0,
          color: Colors.pink[400],
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Type Emplyee Id';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        nameString = value;
      },
    );
  }

  Widget emailText() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'อีเมล์ :',
        labelStyle: TextStyle(color: Colors.blue),
        helperText: 'Type you@email.com',
        helperStyle: TextStyle(color: Colors.blue),
        icon: Icon(
          Icons.email,
          size: 36.0,
          color: Colors.blue,
        ),
      ),
      validator: (String value) {
        if (!((value.contains('@')) && (value.contains('.')))) {
          return 'Type Email Format';
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
      decoration: InputDecoration(
        labelText: 'พาสเวิร์ด :',
        labelStyle: TextStyle(color: Colors.green),
        helperText: 'More 6 Charactor',
        helperStyle: TextStyle(color: Colors.green),
        icon: Icon(
          Icons.lock,
          size: 36.0,
          color: Colors.green,
        ),
      ),
      validator: (String value) {
        if (value.length <= 5) {
          return 'Password Much More 6 Charactor';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        passwordString = value;
      },
    );
  }

  Widget dropdownButton() {
    return DropdownButton(
      icon: Icon(Icons.arrow_downward),
      hint: Text('กรุณาเลือก ส่วน/ศูนย์'),
      iconSize: 36,
      elevation: 26,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: data.map((item) {
        return new DropdownMenuItem(
          child: new Text(item['sdivisiontwo']),
          value: item['sdivision'].toString(),
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

  Widget dropdownstatic() {
    return DropdownButton(
      icon: Icon(Icons.arrow_downward),
      hint: Text('กรุณาเลือก สิทธิ'),
      iconSize: 36,
      elevation: 26,
      style: TextStyle(
        color: Colors.deepPurple,
        fontSize: 18.0,
      ),
      value: _selectedCompany,
      items: _dropdownMenuItems,
      onChanged: onChangeDropdownItem,
    );
  }

  Widget uploadButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        print('Upload');
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print('Name = $nameString, Drop = ${_selectedCompany.id}');
          uppriv();
        }
      },
    );
  }

  Future<void> uppriv() async {
    // addgroup

    String urlpost = "http://8a7a08360daf.sn.mynetname.net:2528/api/updatepriv";

    var body = {
      "user": nameString.trim(),
      "priv": _selectedCompany.id.toString()
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
        if (result['status']) {
          String getmessage = result['message'];
          myAlert('OK', '$getmessage');
        } else {
          myAlert('Not OK', 'message = Null');
        }
      }
    } else {
      //check respond = 200
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
    Navigator.of(context)
        .pushAndRemoveUntil(serviceRoute, (Route<dynamic> route) => false);
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

  Widget showText1() {
    return Text(
      'รหัสพนักงาน tot/os',
      style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.green[800],
          fontFamily: 'PermanentMarker'),
    );
  }

  Widget showText2() {
    return Text(
      'เลือก ประเภทสิทธิ',
      style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.green[800],
          fontFamily: 'PermanentMarker'),
    );
  }

  Widget mySizeBoxH() {
    return SizedBox(
      height: 25.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text('กำหนดสิทธิให้ User'),
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
                showText1(),
                nameText(),
                mySizeBoxH(),
                showText2(),
                dropdownstatic(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
