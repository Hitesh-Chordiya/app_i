import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app/pages/Signup.dart';
import 'package:flutter_app/pages/View_attendance.dart';
import 'package:flutter_app/pages/homepage.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/pages/Student.dart';
import 'package:flutter_app/pages/TeacherHome.dart';
import 'package:flutter/material.dart';
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
    // Timer(Duration(seconds:5),()=> check(context));
  }
//  void foo(){
//    sleep(const Duration(seconds:4));
//  }
  @override
  Widget build(BuildContext context) {
    check(context);
    return new Scaffold(
//      body: Stack(
//        fit: StackFit.expand,
//        children: <Widget>[
//          Container(
//            decoration: BoxDecoration(color: Colors.redAccent),
//
//          ),
//          Column(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//              Expanded(
//                flex: 2,
//                child: Container(
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                        CircleAvatar(
//                          backgroundColor: Colors.white,
//                          radius: 50.0,
//                          child: Icon(
//                            Icons.satellite,
//                            color: Colors.blueAccent,
//                            size: 50.0,
//                          ),
//                        ),
//                      Padding(
//                        padding: EdgeInsets.only(top:10.0),
//                      ),
//                      Text(
//                        "MESCOE",style: TextStyle(color: Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold),
//                      )
//                    ],
//                  ),
//                ),
//              ),
//              Expanded(
//                flex: 1,
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    CircularProgressIndicator(),
//                    Padding(
//                      padding: EdgeInsets.only(top:10.0),
//                    ),
//                    Text(
//                      "MOTO",style: TextStyle(color: Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold),
//                    )
//                  ],
//                ) ,
//              )
//            ],
//          )
//        ],
//      ),
    );
  }
}

Future<bool> check(BuildContext context) async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool login = prefs.getBool("login");
  String email= prefs.getString('email');
  var e;

  bool v=false;
  if (login==true) {
    final checkemail=FirebaseDatabase.instance.reference();
    checkemail.child("Teacher_account").once().then((snap){
      e=email.split('@');
      Map data = snap.value;
      for (final key in data.keys) {
        if(e[0].toString()==key.toString()){
          v=true;
          break;
        }
      }

    });
    await Future.delayed(Duration(seconds: 3));

    runApp(MaterialApp(
        home: v == true ? stud() : Student()));
  } else {
    runApp(MaterialApp(
        home:Date()));
  }
}
