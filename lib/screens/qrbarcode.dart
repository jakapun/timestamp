import 'package:flutter/material.dart';

class QrBarcode extends StatefulWidget {
  @override
  _QrBarcodeState createState() => _QrBarcodeState();
}

class _QrBarcodeState extends State<QrBarcode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Qr_Barcode'),
      ),
    );
  }
}