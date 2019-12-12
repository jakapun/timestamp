import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:location/location.dart';

// QrBarcode

class QrBarcode extends StatefulWidget {
  @override
  _QrBarcodeState createState() => _QrBarcodeState();
}

class _QrBarcodeState extends State<QrBarcode> {
  // Explicit
  // String qrCodeString = 'ก๊อปปี้ code จากการสแกน';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String qrCodeString;
  double lat, lng;

  // method

  @override
  void initState() {
    // เริ่มทำงานตรงนี้ก่อนที่อื่น
    super.initState();
    findLatLng();
  }

  Widget showTextOne() {
    return Text(
      'ลงเวลาด้วย Qrcode',
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
      icon: Icon(Icons.android),
      label: Text('ลงเวลาออกด้วย Qrcode/Barcode'),
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
          tooltip: 'กดเพื่อ Upload ข้อมูล',
          child: Icon(Icons.cloud_upload),
          onPressed: () {
            if ((lat.toString().isEmpty) || (qrCodeString.isEmpty)) {
              myAlert('มีข้อผิดพลาด',
                  'กรุณาเปิดการใช้ Location และแสกน \r\n Barcode/QRcode อีกรอบ \r\n ก่อนกด Upload');
            } else {
              print('lat = $lat, lng = $lng, qrtxt = $qrCodeString');
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
          showText(),
          uploadValueButton(),
        ],
      ),
    );
  }
}
