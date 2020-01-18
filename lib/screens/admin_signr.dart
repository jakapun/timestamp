import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestamp/screens/my_service.dart';
import 'package:location/location.dart';
import 'package:timestamp/screens/my_success.dart';

class AdminSign extends StatefulWidget {

  AdminSign() : super();

  @override
  _AdminSignState createState() => _AdminSignState();
}

class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getCompanies() {
    return <Company>[
      Company(1, 'Apple'),
      Company(2, 'Google'),
      Company(3, 'Samsung'),
      Company(4, 'Sony'),
      Company(5, 'LG'),
    ];
  }
}

class _AdminSignState extends State<AdminSign> {

  // Explicit
  final formKey = GlobalKey<FormState>();
  String nameString, emailString, passwordString, _mySelection, rstoreprv;
  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;
  String tempprv, temprela, tempfull, token = '', tempuid = '', radiovalue = '';
  double lat = 0, lng = 0;
  SharedPreferences prefs;
  bool _isButtonDisabled = false;

  List data = List(); //edited line

  Future<String> getSWData() async {
    prefs = await SharedPreferences.getInstance();

    tempprv = prefs.getString('sprv');
    temprela = prefs.getString('srelate');
    token = prefs.getString('stoken');
    tempuid = prefs.getString('suid');
    // await prefs.setString('sfulln', result['fullname']);
    tempfull = prefs.getString('sfulln');

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
    findLatLng();
    _isButtonDisabled = true;
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

  Future<LocationData> findLocationData() async {
    var location = Location();

    try {
      return await location.getLocation();
    } catch (e) {
      print('Error = $e');
      return null;
    }
  }

  Future<void> findLatLng() async {

    var currentLocation = await findLocationData();

    if (currentLocation == null) {
      myAlert('Location Error', 'Please Open GPS&Allow use Location');
    } else {
      setState(() {
        lat = currentLocation.latitude;
        lng = currentLocation.longitude;
        
      });
    }
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
        nameString = value.toUpperCase();
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
          print('Name = $nameString, nvision = $_mySelection, lat = $lat, lng = $lng, prv = $tempprv');
          register();
        }
      },
    );
  }

  Widget mySizeBoxH() {
    return SizedBox(
      height: 25.0,
    );
  }

  Widget showTextnull() {
    return Container(
      alignment: Alignment.center,
      child: SelectableText(
        // '$qrCodeString',
        'ไม่มีข้อมูล Location \r\n หรือเคยบันทึกแล้ว \r\n จะไม่มีปุ่ม upload',
        style: TextStyle(fontSize: 24.0, color: Colors.red[700]),
      ),
    );
  }

  Future<void> register() async {
    // addgroup

    String urlpost = "http://8a7a08360daf.sn.mynetname.net:2528/api/admsignr";
    String areaone = "adm ลงเวลาแทน";

    var body = {"chkuid": nameString.trim(), 
                "ndivision": _mySelection.trim(),
                "glati": lat.toString(),
                "glong": lng.toString(),
                "area": areaone
                };
    // var body = {
    //   "chkuid": tempuid.trim(),
    //   "chkfna": tempfull,
    //   "glati": lat.toString(),
    //   "glong": lng.toString(),
    //   "ndivision": temprela.trim(),
    //   "area": radiovalue.trim()
    // };

    //setUpDisplayName();
    // var response = await get(urlString);
    // var response = await http.post(urlpost, body: body);
    var response = await http.post(urlpost, headers: {HttpHeaders.authorizationHeader: "JWT $token"}, body: body);


    if (response.statusCode == 200) {
      print(response.statusCode);
      var result = json.decode(response.body);
      // print('result = $result');

      if (result.toString() == 'null') {
        myAlert('Not Stampin', 'No Stampin,put data in my Database');
      } else {
        if (_isButtonDisabled == true){
        setState(() {
          _isButtonDisabled = false; // disable ปุ่ม
        });
        }else{
          print('_isButtonDisabled = false');
        }
        if ((result['status']) && (result['success'])) {
          String getmessage = '  admin ลงเวลาแทน เรียบร้อย';
          
          var addChildrenRoute = MaterialPageRoute(
              builder: (BuildContext context) => Mysuccess(successtxt: getmessage));
          Navigator.of(context).push(addChildrenRoute);

        } else {
          String getmessage = result['message'];
          myAlert('Not OK', '$getmessage');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text('Admin ลงเวลาแทน พนง.'),
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
                nameText(),
                mySizeBoxH(),
                // emailText(),
                // passwordText(),
                dropdownButton(),
                mySizeBoxH(),
                // ((lat.toString().isEmpty) || (_isButtonDisabled == false)) ? showTextnull() : uploadButton(),
                
                // dropdownstatic(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}