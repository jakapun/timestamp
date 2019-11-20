import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShowQr extends StatefulWidget {

  final String qrdata;

  ShowQr({
    Key key,
    @required this.qrdata,
  }) : super(key: key);

  
  @override
  _ShowQrState createState() => _ShowQrState();
}

class _ShowQrState extends State<ShowQr> {

  String getqrdata;

  @override
  void initState() {
    super.initState();
    getqrdata = widget.qrdata;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Container(
                    width: 320,
                    child: QrImage(
                      data: getqrdata,
                      gapless: false,
                      size: 320,
                      foregroundColor: Color(0xff03291c),
                      embeddedImage: AssetImage('images/logo_embed3.jpg'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40)
                    .copyWith(bottom: 40),
                child: Text('create qrcode already'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}