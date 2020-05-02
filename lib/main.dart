import 'dart:async';
import 'package:flutter_app/pages/View_attendance.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/pages/Student.dart';
import 'package:flutter_app/pages/TeacherHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/responsive/Screensize.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Spalsh(),
    );
  }
}
class Spalsh extends StatefulWidget {
  @override
  _SpalshState createState() => _SpalshState();
}

class _SpalshState extends State<Spalsh> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5),()=>check(context));
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          return OrientationBuilder(
              builder:(context,orientation){
                SizeConfig().init(constraints, orientation);
                return new MaterialApp(
                  home: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                              image: new AssetImage("assets/one.jpg"),
                              fit: BoxFit.cover,
                            ),
                              borderRadius: new BorderRadius.circular(10.00),
                            ),

                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding:  EdgeInsets.only(top:8.0*SizeConfig.heightMultiplier, bottom: 2.1*SizeConfig.heightMultiplier),
                                    child: new Image(
                                      image: new AssetImage("assets/college_logo.png"),
                                      alignment: Alignment.topCenter,
                                      height: 30*SizeConfig.heightMultiplier,
                                      width: 45*SizeConfig.widthMultiplier,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }
          );
        }
    );
  }
}

Future<bool> check(BuildContext context) async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool login = prefs.getBool("login");
  String type=prefs.getString("type");
  if (login==true) {
    runApp(MaterialApp(
        home: !(type=="student") ? thome() : shome()));
  } else {
    runApp(MaterialApp(
        home:LoginPage()));
  }
}
//_checkWifi() async {
//  // the method below returns a Future
//  var connectivityResult = await (new Connectivity().checkConnectivity());
//  bool connectedToWifi = (connectivityResult == ConnectivityResult.wifi);
//  if (!connectedToWifi) {
//    _showAlert(context);
//  }
//  if (_tryAgain != !connectedToWifi) {
//    setState(() => _tryAgain = !connectedToWifi);
//  }
//}
