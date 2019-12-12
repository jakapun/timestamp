import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timestamp/screens/admin.dart';
import 'package:timestamp/screens/my_home.dart';
import 'package:timestamp/screens/qrbarcode.dart';
// import 'package:timestamp/screens/stamp_in.dart';
import 'package:timestamp/screens/stamp_in2.dart';
import 'package:timestamp/screens/stamp_out.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Myservice extends StatefulWidget {
  // final String uname;

  // Myservice({
  //   Key key,
  //   @required this.uname,
  // }) : super(key: key);

  @override
  _MyserviceState createState() => _MyserviceState();
}

class _MyserviceState extends State<Myservice> {
  String getuname, temps;
  int temppriv = 0;
  Widget currentWidget = MyHome();

  Widget menuFormPage() {
    return ListTile(
      leading: Icon(
        Icons.alarm_add,
        size: 36.0,
        color: Colors.green[400],
      ),
      title: Text(
        'ลงเวลาเข้า',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          currentWidget = StampIn2();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  Widget menuListViewPage() {
    return ListTile(
      leading: Icon(
        Icons.alarm_off,
        size: 36.0,
        color: Colors.red,
      ),
      title: Text(
        'ลงเวลาออก',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          currentWidget = StampOut();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  Widget menuQRcode() {
    return ListTile(
      leading: Icon(
        Icons.crop_free,
        size: 36.0,
        color: Colors.purple,
      ),
      title: Text(
        'สแกน Qrcode/Barcode',
        style: TextStyle(fontSize: 18.0),
      ),
      onTap: () {
        setState(() {
          currentWidget = QrBarcode();
          Navigator.of(context).pop();
        });
      },
    );
  }

  Widget menuAdmin() {
    return ListTile(
      leading: Icon(
        Icons.android,
        size: 36.0,
        color: Colors.purple,
      ),
      title: Text(
        'Admin เซคชั่น',
        style: TextStyle(fontSize: 18.0),
      ),
      // onTap: () {
      //   setState(() {
      //     currentWidget = AdminSec();
      //     Navigator.of(context).pop();
      //   });
      // },
      onTap: () {
        var addChildrenRoute =
            MaterialPageRoute(builder: (BuildContext context) => AdminSec());
        Navigator.of(context).pop();
        Navigator.of(context).push(addChildrenRoute);
      },
    );
  }

  // add_to_photos
  // cake
  Widget signOutAnExit() {
    return ListTile(
      leading: Icon(
        Icons.exit_to_app,
        size: 36.0,
        color: Colors.red,
      ),
      title: Text(
        'เลิกการใช้งาน App',
        style: TextStyle(fontSize: 18.0),
      ),
      onTap: () {
        mySignOut();
      },
    );
  }

  Future<void> mySignOut() async {
    _onBackPressed();
    // clearSharePreferance(context);
    exit(0);
  }

  Widget showLogo() {
    return Container(
      width: 80.0,
      height: 80.0,
      child: Image.asset(
          'images/logo.png'), // https://www.iconfinder.com/search/?q=travel&price=free&maximum=512
    );
  }

  Widget myHead() {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.white, Colors.yellow[900]],
          radius: 1.5,
          center: Alignment.center,
        ),
      ),
      child: Column(
        children: <Widget>[
          showLogo(),
          Text(
            'Timestamp',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.blue[900],
            ),
          ),
          Text('Login: $getuname'),
        ],
      ),
    );
  }

  Widget mySizeBoxH() {
    return SizedBox(
      height: 25.0,
    );
  }

  Widget myDrawer() {
    return Drawer(
        child: (temps != 'xxx')
            ? ListView(
                children: <Widget>[
                  myHead(),
                  menuListViewPage(),
                  Divider(),
                  menuFormPage(),
                  Divider(),
                  // menuQRcode(),
                  (temppriv > 2) ? menuAdmin() : mySizeBoxH(),
                  Divider(),
                  signOutAnExit(),
                ],
              )
            : ListView(
                children: <Widget>[
                  myHead(),
                  Divider(),
                  signOutAnExit(),
                ],
              ));
  }

  @override
  void initState() {
    super.initState();
    findDisplayName();
  }

  Future<void> findDisplayName() async {
    // FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      getuname = prefs.getString('suid');
      temps = prefs.getString('srelate');
      // temppriv = prefs.getInt('spriv');
      temppriv = (prefs.getInt('spriv') ?? 0);
      if (temps == 'xxx') {
        print(temppriv.toString());
      } else {
        print('relateid is not xxx');
      }
    });
    print('name =$getuname');
  }

  void clearSharePreferance(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.clear();
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text('$getuname ต้องการ ออกจากระบบหรือไม่?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('No',
                      style: TextStyle(fontSize: 17.0, color: Colors.red[800])),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                    child: Text('Yes',
                        style: TextStyle(fontSize: 17.0, color: Colors.blue)),
                    onPressed: () {
                      clearSharePreferance(context);
                      Navigator.pop(context, true);
                    })
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
          // backgroundColor: Colors.transparent,
          // backgroundColor: Colors.white,
          // appBar: new AppBar(
          //       title: new Text('My Service'),
          //       backgroundColor: Colors.transparent,
          //       elevation: 0.0,
          // ),
          // appBar: AppBar(
          //   title: Text('My Service'),
          // ),
          appBar: AppBar(
            title: Text('My id/username is $getuname',
                style: TextStyle(color: Colors.white),
                textDirection: TextDirection.ltr),
            flexibleSpace: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      const Color(0xFF2255EE),
                      const Color(0xFF00DDDD),
                    ],
                    begin: const FractionalOffset(0.0, 0.1),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
            iconTheme: new IconThemeData(color: Colors.yellow[900]),
          ),
          body: currentWidget,
          drawer: myDrawer(), // call drawer
        ));
  }
}
