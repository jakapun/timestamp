import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestamp/screens/show_qr.dart';

class CreateQr extends StatefulWidget {
  @override
  _CreateQrState createState() => _CreateQrState();
}

class _CreateQrState extends State<CreateQr> {
  //explicit
  final formKey = GlobalKey<FormState>();
  String qrString, _mySelection, tempprv;
  double lat, lng;
  int randInt;

  List data = List(); //edited line

  Future<String> getSWData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tempprv = prefs.getString('sprv');

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

  // Method
  @override
  void initState() {
    // เริ่มทำงานตรงนี้ก่อนที่อื่น
    super.initState();
    findLatLng();
    this.getSWData();
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
        randInt = Random().nextInt(100000);
        lat = currentLocation.latitude;
        lng = currentLocation.longitude;
      });
    }
  }

  Future<void> register() async {
    // addgroup

    String urlpost = "http://8a7a08360daf.sn.mynetname.net:2528/api/addpoint";
    // String qrone = '$tempprv\_$_mySelection\_$randInt\_$lng\_$lat';
    String qrmini = '$tempprv\_$_mySelection\_$randInt';
    var body = {
      "qrtext": qrmini,
      "glati": lat.toString(),
      "glong": lng.toString(),
      "ndivision": _mySelection,
      "prov": tempprv
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
          // String getmessage = result['message'];
          myAlert('OK', '$qrmini');
          var addChildrenRoute = MaterialPageRoute(
              builder: (BuildContext context) => ShowQr(qrdata: qrmini));
          Navigator.of(context).pop();
          Navigator.of(context).push(addChildrenRoute);
        } else {
          myAlert('Not OK', 'message = Null');
        }
      }
    } else {
      //check respond = 200
      myAlert('Error', response.statusCode.toString());
    }
  }

  Widget nameText() {
    return TextFormField(
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
        // qrString = '$tempprv/_$value/_$randInt';
        qrString = value;
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
          // _mySelection = '$tempprv $newVal $randInt';
          _mySelection = newVal;
        });
      },
      value: _mySelection,
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

  Widget uploadButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        print('Upload');
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print('qrcodetext = $_mySelection, Lat = $lat, lng = $lng');
          register();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text('สร้าง QRCode ลงเวลา'),
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
                // nameText(),
                // emailText(),
                // passwordText(),
                dropdownButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
