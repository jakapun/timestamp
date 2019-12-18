import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:timestamp/screens/my_success.dart';

class StampOut extends StatefulWidget {
  @override
  _StampOutState createState() => _StampOutState();
}

class _StampOutState extends State<StampOut> {
  // Explicit
  // String qrCodeString = 'ก๊อปปี้ code จากการสแกน';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String qrCodeString = '', tempprv, temprela, tempfull, token = '', tempuid = '';
  double lat = 0, lng = 0;
  bool _isButtonDisabled = false;
  SharedPreferences prefs;

  // method

  @override
  void initState() {
    // เริ่มทำงานตรงนี้ก่อนที่อื่น
    super.initState();
    _isButtonDisabled = true;
    findLatLng();
  }

  Widget showTextOne() {
    return Text(
      'ลงเวลาออก',
      style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          color: Colors.brown[800],
          fontFamily: 'PermanentMarker'),
    );
  }

  Widget showText() {
    return Container(
      alignment: Alignment.center,
      child: SelectableText(
        // '$qrCodeString',
        '$lat',
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }

  Widget showButton() {
    return RaisedButton.icon(
      // icon: Icon(Icons.android),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      icon: Icon(Icons.crop_free),
      label: Text('สแกน Qrcode/Barcode'),
      onPressed: () {
        qrProcess();
        // print('lat = $lat, lng = $lng, qrtxt = $qrCodeString');
      },
    );
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

    prefs = await SharedPreferences.getInstance();
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

  Future<void> qrProcess() async {
    try {
      String codeString = await BarcodeScanner.scan();

      if (codeString.length != 0) {
        setState(() {
          qrCodeString = codeString;
        });
        // myShowSnackBar('$codeString');
        // print('lat = $lat, lng = $lng, qrtxt = $qrCodeString');
      }
    } catch (e) {}
  }

  Future<void> sendstamp() async {
    // addgroup

    String urlpost = "http://8a7a08360daf.sn.mynetname.net:2528/api/stampouto";
    
    var body = {
      "chkuid": tempuid.trim(),
      "chkfna": tempfull.trim(),
      "glati": lat.toString(),
      "glong": lng.toString(),
      "ndivision": temprela.trim(),
      "qrtext": qrCodeString.trim()
    };
    
    var response = await http.post(urlpost, headers: {HttpHeaders.authorizationHeader: "JWT $token"}, body: body);

    if (response.statusCode == 200) {
      print(response.statusCode);
      var result = json.decode(response.body);

      if (result.toString() == 'null') {
        myAlert('Not Stampin', 'No Stampin,put data in my Database');
      } else {
        if (_isButtonDisabled == true){
        setState(() {
          _isButtonDisabled = false;
        });
        }else{
          print('_isButtonDisabled = false');
        }
        if ((result['status']) && (result['success'])) {
          String getmessage = result['message'];
      
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

  Widget showLat() {
    return Column(
      children: <Widget>[
        Text(
          'Latitude',
          style: TextStyle(fontSize: 20.0),
        ),
        Text('$lat')
      ],
    );
  }

  Widget showLng() {
    return Column(
      children: <Widget>[
        Text(
          'Longitude',
          style: TextStyle(fontSize: 20.0),
        ),
        Text('$lng')
      ],
    );
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

  Widget showTextnull() {
    return Container(
      alignment: Alignment.center,
      child: SelectableText(
        // '$qrCodeString',
        'ยังไม่ Scan Qrcode \r\n หรือเคยลงเวลาแล้ว \r\n จะไม่มีปุ่ม upload',
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
          // foregroundColor: Colors.red[900],
          tooltip: 'กดเพื่อ Upload ข้อมูล',
          child: Icon(Icons.cloud_upload, size: 40.0,),
          onPressed: () {
            if ((lat.toString().isEmpty) || (qrCodeString.isEmpty)) {
              myAlert('มีข้อผิดพลาด',
                  'กรุณาเปิดการใช้ Location และแสกน \r\n Barcode/QRcode อีกรอบ \r\n ก่อนกด Upload');
            } else {
              print('lat = $lat, lng = $lng, qrtxt = $qrCodeString, prv = $tempprv, full = $tempfull, nvision = $temprela');
              //(_isButtonDisabled) ? sendstamp() : myShowSnackBar('User Press Button > 1 Click');
              sendstamp();
            }
          },
        ),
      ],
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


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          showTextOne(),
          mySizeBox(),
          showButton(),
          mySizeBoxH(),
          showText(),
          mySizeBoxH(),
          mySizeBoxH(),
          mySizeBoxH(),
          ((qrCodeString.isEmpty) || (lat.toString().isEmpty) || (_isButtonDisabled == false)) ? showTextnull() : uploadValueButton(),
        ],
      ),
      
    );
  }
}