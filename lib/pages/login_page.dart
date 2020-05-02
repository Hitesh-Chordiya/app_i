import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/Signup.dart';
import 'package:flutter_app/pages/Student.dart';
import 'package:flutter_app/pages/TeacherHome.dart';
import 'package:flutter_app/pages/View_attendance.dart';
import 'package:flutter_app/pages/forgotpassword.dart';
import 'package:flutter_app/responsive/Screensize.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AttendanceData.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  FocusNode focusNode1 = new FocusNode();
  FocusNode focusNode2 = new FocusNode();
  String _email;
  final checkemail = FirebaseDatabase.instance.reference();
  String _password;
  bool _autovalidate=false;
  Map data;
  final successSnackBar = new SnackBar(
    duration: Duration(milliseconds: 2000),
    shape:
    RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.00)),
    backgroundColor: HexColor.fromHex("#00004d"),
    elevation: 2.0,
    content:new Row(
      children: <Widget>[
        new CircularProgressIndicator( valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        new Padding(padding: EdgeInsets.only(left: 5.0)),
        new Text("Logging in ",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'BalooChettan2',
                color: Colors.white,
                fontSize: 3*SizeConfig.textMultiplier))
      ],
    ),);
  final errSnackBar = new SnackBar(
      backgroundColor: HexColor.fromHex(" #ff4d4d"),
      content: new Text("Login Failed",
          style: TextStyle(
              fontFamily: 'BalooChettan2',
              color: Colors.white,
              fontSize: 20.00)));
  final incorrectPSnackBar = new SnackBar(
      duration: Duration(milliseconds: 1000),
      shape:
      RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.00)),
      backgroundColor:HexColor.fromHex(" #ff4d4d") ,
      elevation: 2.0,
      content: new Text("Incorrect Password",
          style: TextStyle(
              fontFamily: 'BalooChettan2',
              color: Colors.white,
              fontSize: 20.00)));
  final noUserSnackBar = new SnackBar(
      duration: Duration(milliseconds: 1000),
      shape:
      RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.00)),
      elevation: 2.0,
      backgroundColor: Colors.red,
      content: new Text("User not Found",
          style: TextStyle(
              fontFamily: 'BalooChettan2',
              color: Colors.white,
              fontSize: 20.00)));

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: new Container(
            decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(10.00),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    tileMode: TileMode.clamp,
                    colors: [
                      HexColor.fromHex("#000000"),
                      HexColor.fromHex(" #ff4d4d")
                    ])),
            child: new Stack(
              children: <Widget>[
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding:  EdgeInsets.only(top:7.0*SizeConfig.heightMultiplier, bottom: 2.6*SizeConfig.heightMultiplier),
                      child: new Image(
                        image: new AssetImage("assets/college_logo.png"),
                        alignment: Alignment.topCenter,
                        height: 28*SizeConfig.heightMultiplier,
                        width: 42*SizeConfig.widthMultiplier,
                      ),
                    ),
                    new Card(
                      margin: new EdgeInsets.only(
                          left: 6*SizeConfig.widthMultiplier, right:6*SizeConfig.widthMultiplier , bottom: 5.5*SizeConfig.heightMultiplier, top:5.5*SizeConfig.heightMultiplier ),
                      elevation: 10.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        child: new Form(
                          key: formKey,
                          autovalidate: _autovalidate,
                          child: new Theme(
                              data: new ThemeData(
                                  brightness: Brightness.light,
                                  primarySwatch: Colors.blue,
                                  inputDecorationTheme:
                                  new InputDecorationTheme(
                                      labelStyle: new TextStyle(
                                          color: Colors.blue,
                                          fontSize: 2*SizeConfig.textMultiplier))),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Padding(
                                    padding:  EdgeInsets.only(top:2.8*SizeConfig.heightMultiplier),
                                    child: new Text(
                                      "LOGIN",
                                      style: TextStyle(
                                        // fontStyle: FontStyle.italic,
                                        color: HexColor.fromHex("#00004d"),
                                        fontSize: 3.4*SizeConfig.heightMultiplier,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  new Padding(padding: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier,horizontal:2*SizeConfig.widthMultiplier )),
                                  Padding(
                                    padding:  EdgeInsets.only(
                                        left: 5*SizeConfig.widthMultiplier,right:5*SizeConfig.widthMultiplier),
                                    child: new Column(
                                      children: <Widget>[
                                        new TextFormField(
                                            focusNode: focusNode1,
                                            enableSuggestions: true,
                                            style: TextStyle(
                                                fontFamily: 'BalooChettan2',
                                                color: HexColor.fromHex("#00004d"),
                                                fontWeight: FontWeight.bold,
                                                fontSize:2.2*SizeConfig.heightMultiplier),
                                            cursorColor: HexColor.fromHex("#00004d"),
                                            decoration: new InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  borderSide: BorderSide(width: 1,color: HexColor.fromHex("#800000")),
                                                ),
                                                suffixIcon: Icon(Icons.email,size: 2.5*SizeConfig.heightMultiplier,color: Colors.black54,),
                                                contentPadding: EdgeInsets.only(
                                                    left: 5*SizeConfig.widthMultiplier,right: 5*SizeConfig.widthMultiplier),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10.00)),
                                                labelText: "Enter Email",
                                                labelStyle: new TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: HexColor.fromHex("#800000"),
                                                    fontSize: 2.2*SizeConfig.textMultiplier)),
                                            keyboardType:
                                            TextInputType.emailAddress,
                                            validator: validateEmail,
                                            onSaved: (val) {
                                              setState(() => _email = val);
                                            }),
                                        new Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 4*SizeConfig.widthMultiplier,vertical: 2*SizeConfig.heightMultiplier)),
                                        new TextFormField(
                                            focusNode: focusNode2,
                                            style: TextStyle(
                                                fontFamily: 'BalooChettan2',
                                                color: HexColor.fromHex("#00004d"),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 2.2*SizeConfig.heightMultiplier),
                                            cursorColor: HexColor.fromHex("#00004d"),
                                            decoration: new InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  borderSide: BorderSide(width: 1,color: HexColor.fromHex("#800000")),
                                                ),
                                                suffixIcon: Icon(Icons.lock,size:2.5*SizeConfig.heightMultiplier ,color: Colors.black54,),
                                                contentPadding: EdgeInsets.only(
                                                    left: 5*SizeConfig.widthMultiplier,right:5*SizeConfig.widthMultiplier ),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10.00)),
                                                labelText: "Enter Password",
                                                labelStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: HexColor.fromHex("#800000"),
                                                    fontSize: 2.2*SizeConfig.heightMultiplier)),
                                            keyboardType: TextInputType.text,
                                            validator: validatePassword,
                                            obscureText: true,
                                            onSaved: (val) {

                                              setState(() => _password = val);
                                            }),
                                      ],
                                    ),
                                  ),
                                  new Padding(
                                      padding:
                                      EdgeInsets.only(top:4*SizeConfig.heightMultiplier)),
                                  new SizedBox(
                                    width: 25*SizeConfig.widthMultiplier,
                                    height: 5*SizeConfig.heightMultiplier,
                                    child:RaisedButton(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(80.00)),
                                        splashColor: HexColor.fromHex("#ffffff"),
                                        onPressed: () async {
                                          //  fun(context);
                                          if (formKey.currentState.validate()) {
                                            formKey.currentState.save();
                                            signIn(_email, _password)
                                                .then((user) async {
                                              SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                              prefs.setBool('login', true);
                                              var e;
                                              if (user != null) {
                                                String uemail = user.email;
                                                prefs.setString('email', uemail);
                                                setState(() {
                                                  scaffoldKey.currentState
                                                      .showSnackBar(
                                                      successSnackBar);
                                                });
                                                e = uemail.split('@');
                                                String b = e[0].toString().replaceAll(new RegExp(r'\W'), "_");

                                                if(e[1].toString()=="mescoe.org"){
                                                  Map map;
                                                  await  checkemail.child("Admin").once().then((snap) {
                                                    data = snap.value;
                                                  });
                                                  // await Future.delayed(Duration(seconds: 4));
                                                  bool v=false;
                                                  try{
                                                    if (data.containsKey(b.toString())) {
                                                      v = true;
                                                    }

                                                  }catch(Exception){

                                                  }
                                                  if(v==true){
                                                    prefs.setString("type", "admin");
                                                  }
                                                  else {
                                                    prefs.setString("type", "teacher");
                                                  }
                                                  await checkemail.child('Teacher_account').child(b.toString()).once().then((snap) async {
                                                    map=snap.value;
                                                    //    await Future.delayed(Duration(seconds: 5));
                                                    prefs.setString("name", map["name"]);
                                                    Dateinfo.teachname=map["name"].toString();
                                                    Dateinfo.dept=map["department"].toString();
                                                    Dateinfo.teachemail=uemail;
                                                    prefs.setString("dept", map["department"]);
//                                                    Teacher.classlist();
                                                    prefs.setBool("check", false);
                                                    Teacher.data();
                                                  });
                                                  //  await Future.delayed(Duration(seconds: 3));
                                                  Navigator.pushReplacement(
                                                      context,
                                                      PageTransition(type: PageTransitionType.fade,duration:Duration(seconds: 2), child: thome()));

                                                } else {
                                                  prefs.setString("type", "student");
                                                  Map map;
                                                  await  checkemail.child('Student').child(b.toString()).once().then((snap) async {
                                                    map=snap.value;
                                                    //    await Future.delayed(Duration(seconds: 5));
                                                    Studinfo.name=map["name"];

                                                    prefs.setString("name", map["name"]);
                                                    prefs.setString("branch", map["Branch"]);
                                                    // prefs.setString("roll", map["Serial"]);
                                                    prefs.setString("class", map["Class"]);
                                                    prefs.setString("batch", map["Batch"]);
                                                    prefs.setString("text", " ");
                                                    prefs.setString("roll", map["PRN"]);
                                                    Studinfo.email=uemail;
                                                    prefs.setInt("fetchatt", 0);
                                                  });
                                                  //  await Future.delayed(Duration(seconds: 5));
                                                  Navigator.pushReplacement(
                                                      context,
                                                      PageTransition(type: PageTransitionType.fade,duration:Duration(seconds: 2), child: shome()));
                                                }
                                              } else {
                                                scaffoldKey.currentState
                                                    .showSnackBar(errSnackBar);
                                              }
                                            });
                                          }else{
                                            setState(() {
                                              _autovalidate=true;
                                            });
                                          }
                                          FocusScope.of(context).requestFocus(new FocusNode());
                                        },
                                        elevation: 2.0,
                                        color: HexColor.fromHex("#00004d"),
                                        textColor: Colors.white,
                                        child: new Text("Sign In",
                                          textAlign: TextAlign.center,style: TextStyle(fontSize: 2*SizeConfig.textMultiplier),)),

                                  ),
                                  new Padding(
                                      padding: EdgeInsets.only(bottom: 2*SizeConfig.heightMultiplier))
                                ],
                              )),
                        ),
                      ),
                    ),
                    //new Padding(padding: EdgeInsets.only(top:2.5*SizeConfig.heightMultiplier)),
                    new MaterialButton(
                      onPressed: () => {

                        FocusScope.of(context).requestFocus(new FocusNode()),
                        fun(context),
                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.00)),
                      child: new Text("Forgot Password?",
                          style: TextStyle(
                              fontFamily: 'BalooChettan2',
                              color: HexColor.fromHex("#00004d"),
                              fontSize: 2.8*SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold
                          )),
                    ), //Forgot password button
                    new MaterialButton(
                      onPressed: () => {
                        FocusScope.of(context).requestFocus(new FocusNode()),
                        Navigator.push(
                            context,
                            PageTransition(type: PageTransitionType.rightToLeftWithFade,duration:Duration(seconds: 1), child: Signup())
                        )
                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.00)),
                      child: new Text("Create account",
                          style: TextStyle(
                              fontFamily: 'BalooChettan2',
                              color: HexColor.fromHex("#00004d"),
                              fontSize: 2.8*SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold
                          )),
                    ) //Forgot password button
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Future<FirebaseUser> signIn(String email, String password) async {
    try {
      AuthResult result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      assert(user != null);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await auth.currentUser();
      assert(user.uid == currentUser.uid);
      return user;
    } catch (e) {
      handleError(e);
      return null;
    }
  } //Firebase Sign in

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty || !regex.hasMatch(value))
      return 'Invalid Email';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.trim().isEmpty) {
      return 'Password cannot be empty';
    } else if (value.length < 6) {
      return 'Password too short';
    }
    return null;
  }

  handleError(PlatformException error) {
    switch (error.code) {
      case 'ERROR_USER_NOT_FOUND':
        setState(() {
          scaffoldKey.currentState.showSnackBar(noUserSnackBar);
        });
        break;
      case 'ERROR_WRONG_PASSWORD':
        setState(() {
          scaffoldKey.currentState.showSnackBar(incorrectPSnackBar);
        });
        break;
    }
  } //Sign in Error handling
}
