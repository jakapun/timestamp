import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:timestamp/screens/my_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'dart:io';

class StampIn extends StatefulWidget {
  @override
  _StampInState createState() => _StampInState();
}

class _StampInState extends State<StampIn> {
  // explicit

  File file;
  double lat, lng;
  bool imageBool = false;
  final formKey = GlobalKey<FormState>();
  String name, detail, code, urlPicture;

  // method

  @override
  void initState() {
    // เริ่มทำงานตรงนี้ก่อนที่อื่น
    super.initState();
    findLatLng();
    createCode();
  }

  void createCode() {
    int randInt = Random().nextInt(10000);
    code = 'code$randInt';
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

  Future<LocationData> findLocationData() async {
    var location = Location();

    try {
      return await location.getLocation();
    } catch (e) {
      print('Error = $e');
      return null;
    }
  }

  Widget nameText() {
    return Container(
      margin: EdgeInsets.only(left: 50.0, right: 50.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Name:',
          helperText: 'Text Your Display Name',
          hintText: 'English Only',
          icon: Icon(Icons.face),
        ),
        onSaved: (String value) {
          name = value.trim();
        },
      ),
    );
  }

  Widget detailText() {
    return Container(
      margin: EdgeInsets.only(left: 50.0, right: 50.0),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: 'Detail:',
          helperText: 'Text Your Detail',
          hintText: 'English Only',
          icon: Icon(Icons.details),
        ),
        onSaved: (String value) {
          detail = value.trim();
        },
      ),
    );
  }

  Widget showImage() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      height: 200.0,
      child: file == null ? Image.asset('images/pic.png') : Image.file(file),
    );
  }

  Widget showButton() {
    return Container(
      width: 200.0,
      // color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[cameraButton(), galleryButton()],
      ),
    );
  }

  Widget cameraButton() {
    return IconButton(
      icon: Icon(
        Icons.add_a_photo,
        size: 48.0,
        color: Colors.pink.shade300,
      ),
      onPressed: () {
        cameraThread();
      },
    ); // Iconbutton == Click
  }

  // thread
  Future<void> cameraThread() async {
    var imageObject = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 1200.0, maxHeight: 1200.0);
    setState(() {
      file = imageObject;
      imageBool = true;
    });
  }

  Widget galleryButton() {
    return IconButton(
      icon: Icon(
        Icons.add_photo_alternate,
        size: 48.0,
        color: Colors.green,
      ),
      onPressed: () {
        galleryThread();
      },
    ); // Iconbutton == Click
  }

  Future<void> galleryThread() async {
    var imageObject = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = imageObject;
      imageBool = true;
    });
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

  Widget uploadValueButton() {
    // return IconButton(
    //   icon: Icon(Icons.cloud_upload),
    //   onPressed: () {},
    // );
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton(
          child: Icon(Icons.cloud_upload),
          onPressed: () {
            if (imageBool) {
              formKey.currentState.save();
              if ((name.isEmpty) || (detail.isEmpty)) {
                myAlert('Have Space', 'Please Fill Every Blank');
              } else {
                // check name,detail
                print(
                    'name = $name, detail = $detail, lat = $lat, lng = $lng, code = $code');
                uploadFileToStorage();
              }
            } else {
              myAlert(
                  'No Choose Image', 'Please Choose Image From Camera/Gallery');
            }
          },
        ),
      ],
    );
  }

  Future uploadFileToStorage() async {

    String nodeEndPoint = 'http://101.109.115.27:2522/image';
    String namePicture = '$code.jpg';
    print('filename pic = $namePicture');
    // create instance
      // updateValueToFireStore();

    //   FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    // StorageReference storageReference =
    //     firebaseStorage.ref().child('Picture/$namePicture');
    // StorageUploadTask storageUploadTask = storageReference.putFile(file);

    if (file == null) return;
   String base64Image = base64Encode(file.readAsBytesSync());
   String fileName = file.path.split("/").last;

   http.post(nodeEndPoint, body: {
     "image": base64Image,
     "name": fileName,
   }).then((res) {
     print(res.statusCode);
   }).catchError((err) {
     print(err);
   });
    
  }

  Future<void> updateValueToFireStore() async {
    // create instance
      print('Test upload');

      // add instance
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => Myservice());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    
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
    return Form(
      key: formKey,
      child: ListView(
        padding: EdgeInsets.only(
          bottom: 50.0,
          right: 10.0,
          left: 10.0,
        ),
        children: <Widget>[
          showImage(),
          showButton(),
          nameText(),
          detailText(),
          SizedBox(
            height: 10.0,
          ),
          showLat(),
          showLng(),
          uploadValueButton(),
        ],
      ),
    );
  }
}
