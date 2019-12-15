import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:http/http.dart' as http;
import 'package:timestamp/screens/my_service.dart';

class Absent extends StatefulWidget {
  @override
  _AbsentState createState() => _AbsentState();
}

class _AbsentState extends State<Absent> {

  // Explicit

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String tempprv, temprela, tempfull, token = '', tempuid = '', radiovalue;
  double lat = 0, lng = 0;
  bool _isButtonDisabled = false;

  // method

  @override
  void initState() {
    // เริ่มทำงานตรงนี้ก่อนที่อื่น
    super.initState();
    _isButtonDisabled = true;
    findLatLng();
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString('srelate', result['relate']);
    // await prefs.setString('sfulln', result['fulln']);
    tempprv = prefs.getString('sprv');
    temprela = prefs.getString('srelate');
    tempfull = prefs.getString('sfulln');
    // await prefs.setString('stoken', token);
    token = prefs.getString('stoken');
    // await prefs.setString('suid', result['uid']);
    tempuid = prefs.getString('suid');

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

  Future<void> sendabsent() async {
    // addgroup

    String urlpost = "http://8a7a08360daf.sn.mynetname.net:2528/api/absent";
    
    var body = {
      "chkuid": tempuid.trim(),
      "chkfna": tempfull.trim(),
      "glati": lat.toString(),
      "glong": lng.toString(),
      "ndivision": temprela.trim(),
      "reason": radiovalue.trim()
    };
    
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
          myShowSnackBar('_isButtonDisabled = false');
        }
        if (result['status']) {
          String getmessage = result['message'];
          // myAlert('OK', '$getmessage');
          myShowSnackBar('$getmessage');
          var addChildrenRoute = MaterialPageRoute(
              builder: (BuildContext context) => Myservice());
          // Navigator.of(context).pop();
          Navigator.of(context).push(addChildrenRoute);
        } else {
          String getmessage = result['message'];
          // myAlert('Not OK', '$getmessage');
          myShowSnackBar('$getmessage');
        }
      }
    } else {
      //check respond = 200
      myAlert('Error', response.statusCode.toString());
    }
  }

  Widget showTextOne() {
    return Text(
      'ลาวันนี้ \r\n (เพื่อแสดงข้อมูล ในระบบ)',
      style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          color: Colors.brown[800],
          fontFamily: 'PermanentMarker'),
    );
  }

  void myAlert(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget mySizeBox() {
    return SizedBox(
      width: 8.0,
      height: 100.0,
    );
  }

  Widget mySizeBoxH() {
    return SizedBox(
      height: 25.0,
    );
  }

  Widget radiocheck() {
    return Container(
      width: 220.0,
      child: RadioButtonGroup(
          labels: [
            "ลากิจ",
            "ลาป่วย",
          ],
          disabled: [
            // "In Area"
          ],
          onChange: (String label, int index) => print("label: $label index: $index"),
          onSelected: (String label) => radiovalue = label,
        ),
      // onSaved: (String value) {
      //     passwordString = value;
      //   },
    );
  }

  Widget showTextnull() {
    return Container(
      alignment: Alignment.center,
      child: SelectableText(
        // '$qrCodeString',
        'ไม่มีข้อมูล Location \r\n หรือเคยลงเวลาแล้ว \r\n จะไม่มีปุ่ม upload',
        style: TextStyle(fontSize: 24.0, color: Colors.red[700]),
      ),
    );
  }

  Widget uploadValueButton() {
    // return IconButton(
    //   icon: Icon(Icons.cloud_upload),
    //   onPressed: () {},
    // );
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // จัดตำแหน่ง FloatingActionButton
      children: <Widget>[
        FloatingActionButton(
          elevation: 15.0,
          // foregroundColor: Colors.green[900],
          tooltip: 'กดเพื่อ Upload ข้อมูล',
          child: Icon(Icons.cloud_upload, size: 40.0,),
          
          onPressed: () {
            if (lat.toString().isEmpty) {
              myAlert('มีข้อผิดพลาด',
                  'กรุณาเปิดการใช้ Location อีกรอบ \r\n ก่อนกด Upload');
            } else {
              print('lat = $lat, lng = $lng, prv = $tempprv, full = $tempfull, nvision = $temprela, absent = $radiovalue');
              (_isButtonDisabled) ? sendabsent() : myShowSnackBar('User Press Button > 1 Click');
              // sendabsent();
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          showTextOne(),
          //mySizeBox(),
          mySizeBoxH(),
          radiocheck(),
          mySizeBoxH(),
          mySizeBoxH(),
          mySizeBoxH(),
          // uploadValueButton()
          ((lat.toString().isEmpty) || (_isButtonDisabled == false)) ? showTextnull() : uploadValueButton(),
        
        ],
      ),
      
    );
  }
}