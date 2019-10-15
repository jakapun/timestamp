import 'package:flutter/material.dart';
import 'package:timestamp/screens/section.dart';

class AdminSec extends StatefulWidget {
  @override
  _AdminSecState createState() => _AdminSecState();
}

class _AdminSecState extends State<AdminSec> {
  int _cIndex = 0;

  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
    });
  }

  Widget showLogo() {
    return Image.asset('images/icon_admin2.png');
  }

  // App Name

  Widget showText() {
    return Text(
      'Admin เซคชั่น',
      style: TextStyle(
          fontFamily: 'Pridi',
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent[100]),
    );
  }

  Widget oneButton(BuildContext context1) {
    //สร้างตัวแปรชื่อ context
    return RaisedButton(
      color: Colors.blue,
      child: Text('Call one'),
      onPressed: () {
        print('You Click SignUp');
        var registerRoute = new MaterialPageRoute(
            builder: (BuildContext context) => DefSection());
        Navigator.of(context1).push(registerRoute);
      },
    );
  }

  Widget twoButton(BuildContext context1) {
    //สร้างตัวแปรชื่อ context
    return RaisedButton(
      color: Colors.blue,
      child: Text('Call two'),
      onPressed: () {
        print('You Click SignUp');
        var registerRoute = new MaterialPageRoute(
            builder: (BuildContext context) => DefSection());
        Navigator.of(context1).push(registerRoute);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        // body: Text('Home',style: TextStyle(fontSize: 50.0),),
        body: Form(
            child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.yellow, Colors.white],
                  begin: Alignment(-1, -1))),
          padding: EdgeInsets.only(top: 100.0),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              showLogo(),
              Container(
                //ครอบ container เพื่อจัด margin ของ text
                margin: EdgeInsets.only(top: 20.0),
                child: showText(),
              ),
              Container(
                margin: EdgeInsets.only(left: 48.0, right: 48.0),
                child: Row(
                  children: <Widget>[
                    new Expanded(
                      child: oneButton(context),
                    ),
                    new Expanded(
                      child: twoButton(context), //goto line 63
                    )
                  ],
                ),
              )
            ],
          ),
        )),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _cIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              // icon: Icon(Icons.ac_unit,color: Color.fromRGBO(r, g, b, opacity)),
              icon: Icon(Icons.settings),
              title: Text('Setting'),
            ),
            BottomNavigationBarItem(
              // icon: Icon(Icons.ac_unit,color: Color.fromARGB(255, 0, 0, 0)),
              icon: Icon(Icons.person),
              title: Text('Profile'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              title: Text('New Page'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Goto Page'),
            )
          ],
          onTap: (index) {
            print('$index');
            _incrementTab(index);
            if (index == 0) { 
            Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return new DefSection();
            })); 
            } else if (index == 1) {
            Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return new DefSection();
            })); 
            } else if (index == 2) {
            Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return new DefSection();
            })); 
            } else if (index == 3) {
            Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return new DefSection();
            })); 
            } else {
            Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return new DefSection();
            })); 
            }   
            
          },
        ));
  }
}
