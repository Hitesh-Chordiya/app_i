//import 'dart:html';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_app/pages/homepage.dart';
import 'package:flutter_app/pages/login_page.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> with SingleTickerProviderStateMixin {
  AnimationController _cardAnimationController;
  Animation<double> _loginCard;
  Animation<double> _signUpCard;
  var cla=['Select Class','FE1','FE2','FESS','SE1','SE2','SESS','TE1','TE2','TESS','BE1','BE2','BESS'];
  var branch=["Select Branch","Computer","ENTC","Mechanical","FE"];
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  final form = new GlobalKey<FormState>();
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  FocusNode focusNode1 = new FocusNode();
  FocusNode focusNode2 = new FocusNode();
  FocusNode focusNode3 = new FocusNode();
  FocusNode focusNode4 = new FocusNode();
  FocusNode focusNode5 = new FocusNode();
  FocusNode focusNode6 = new FocusNode();
  FocusNode focusNode7 = new FocusNode();

  FocusNode focusNode11 = new FocusNode();
  FocusNode focusNode21 = new FocusNode();
  FocusNode focusNode31 = new FocusNode();
  FocusNode focusNode41 = new FocusNode();
  FocusNode focusNode51 = new FocusNode();
  FocusNode focusNode61 = new FocusNode();
  FocusNode focusNode71 = new FocusNode();

  dynamic _femail,_bemail, fPRN,bPRN, Roll,Branch,_fpassword,_bpassword,_fname,_bname;
  final dbref=FirebaseDatabase.instance.reference();
  String classs='Select Class',fDep="Select Branch",bDep="Select Branch";
  final successSnackBar = new SnackBar(
      duration: Duration(milliseconds: 1000),
      shape:
      RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.00)),
      backgroundColor: Colors.lightGreen,
      elevation: 2.0,
      content: new Text("Logged in ",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'BalooChettan2',
              color: Colors.white,
              fontSize: 20.00)));
  final errSnackBar = new SnackBar(
      backgroundColor: Colors.red,
      content: new Text("Login Failed",
          style: TextStyle(
              fontFamily: 'BalooChettan2',
              color: Colors.white,
              fontSize: 20.00)));
  final incorrectPSnackBar = new SnackBar(
      duration: Duration(milliseconds: 1000),
      shape:
      RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.00)),
      backgroundColor: Colors.red,
      elevation: 2.0,
      content: new Text("Incorrect Password",
          style: TextStyle(
              fontFamily: 'BalooChettan2',
              color: Colors.white,
              fontSize: 20.00)));
  final noUserSnackBar = new SnackBar(
      duration: Duration(milliseconds: 1000),
      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.00)),
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
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: true,
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
                    stops: [
                      0,
                      0.5,
                      0.8
                    ],
                    colors: [
                      Colors.blueAccent,
                      Colors.lightBlue,
                      const Color.fromARGB(255, 255, 255, 255)
                    ])),
            child: new Stack(
              children: <Widget>[
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 50.00, bottom: 20.00),
                      child: new Image(
                        image: new AssetImage("assets/college_logo.png"),
                        alignment: Alignment.topCenter,
                        height: 200,
                        width: 150,
                      ),
                    ),

                    FlipCard(
                      direction: FlipDirection.HORIZONTAL,
                      key:cardKey,
                      flipOnTouch: false,
                      front:new Card(
                        margin: new EdgeInsets.only(
                            left: 25.00, right: 25.00, bottom: 20.00, top: 20.00),
                        elevation: 10.0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),

                        child: Container(
                          child: new Form(
                            key:formKey,
                            autovalidate: true,
                            child: new Theme(
                                data: new ThemeData(
                                    brightness: Brightness.light,
                                    primarySwatch: Colors.blue,
                                    inputDecorationTheme:
                                    new InputDecorationTheme(
                                        labelStyle: new TextStyle(
                                            color: Colors.blue,
                                            fontSize: 15.00))),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[

                                    new Text(
                                      "Student",
                                      style: TextStyle(
                                          fontFamily: 'BalooChettan2',
                                          color: Colors.black54,
                                          fontSize: 40.00,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2.0),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left:70.0,bottom: 10.0),
                                      child: Row(
                                        children: <Widget>[
                                          Text("Student",style: TextStyle(fontSize: 20,),),
                                          Switch(
                                            value: isSwitched,
                                            onChanged: (value) {
                                              setState(() {
                                                isSwitched = value;
                                                cardKey.currentState.toggleCard();
                                              });
                                            },
                                            activeTrackColor: Colors.black45,
                                            activeColor: Colors.black54,
                                            inactiveThumbColor:Colors.black54,
                                          ),
                                          Text("Teacher",style: TextStyle(fontSize: 20,),),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.only(
                                          left:20.0, right: 20.0),
                                      child: new Column(
                                        children: <Widget>[
                                          new TextFormField(
                                              focusNode: focusNode1,
                                              enableSuggestions: true,
                                              style: TextStyle(
                                                  fontFamily: 'BalooChettan2',
                                                  color: Colors.black54,
                                                  fontSize: 20.00),
                                              decoration: new InputDecoration(
                                                  contentPadding: EdgeInsets.only(
                                                      left: 20.00, right: 20.00),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10.00)),
                                                  labelText: "Enter Email",
                                                  labelStyle: new TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.blue,
                                                      fontSize: 15.00)),
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              validator: validateEmail,
                                              onChanged: (val) {
                                                setState(() => _femail = val);
                                              }),
                                          new Padding(
                                              padding: EdgeInsets.all(15.00)),

                                          new TextFormField(
                                              focusNode: focusNode2,
                                              enableSuggestions: true,
                                              style: TextStyle(
                                                  fontFamily: 'BalooChettan2',
                                                  color: Colors.black54,
                                                  fontSize: 20.00),
                                              decoration: new InputDecoration(
                                                  contentPadding: EdgeInsets.only(
                                                      left: 20.00, right: 20.00),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10.00)),
                                                  labelText: "Name",
                                                  labelStyle: new TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.blue,
                                                      fontSize: 15.00)),
                                              keyboardType: TextInputType.text,
                                              onChanged: (val) {
                                                setState(() => _fname = val);
                                              }),

                                          new Padding(
                                              padding: EdgeInsets.all(10.0)),

                                          Padding(
                                              padding:const  EdgeInsets.only(
                                                  right: 15),

                                              child: new Row(
                                                // crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    new Flexible(
                                                        child:Text("Department",style:TextStyle(color: Colors.black87,fontSize: 16))
                                                    ),
                                                    new Flexible(child:
                                                    Padding(
                                                      padding: const EdgeInsets.only(left:12.0),
                                                      child: new DropdownButton<String>(
                                                        focusNode: focusNode7,
                                                        items: branch.map((String listvalue) {
                                                          return DropdownMenuItem<String>(
                                                            value: listvalue,
                                                            child: Text(listvalue),
                                                          );
                                                        }).toList(),
                                                        onChanged: (val){
                                                          setState(() =>fDep=val);
                                                        },
                                                        value: fDep,
                                                      ),
                                                    ),
                                                    ),

                                                  ])
                                          ),
                                          new Padding(
                                              padding: EdgeInsets.all(10.0)),
                                          Padding(
                                              padding:const  EdgeInsets.only(
                                                  right: 15),

                                              child: new Row(
                                                // crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    new Flexible(child:
                                                    DropdownButton<String>(
                                                      items: cla.map((String listvalue) {
                                                        return DropdownMenuItem<String>(
                                                          value: listvalue,
                                                          child: Text(listvalue),
                                                        );
                                                      }).toList(),
                                                      onChanged: (val){
                                                        setState(() =>classs=val);
                                                      },
                                                      value: classs,
                                                    ),),
                                                    new Flexible(child:
                                                    new TextFormField(

                                                        focusNode: focusNode5,
                                                        enableSuggestions: true,
                                                        style: TextStyle(
                                                            fontFamily: 'BalooChettan2',
                                                            color: Colors.black54,
                                                            fontSize: 20.00),
                                                        decoration: new InputDecoration(
                                                            contentPadding: EdgeInsets.only(
                                                                left: 20.00, right: 20.00),
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    10.00)),
                                                            labelText: "Serial_no",
                                                            labelStyle: new TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.blue,
                                                                fontSize: 15.00)),
                                                        keyboardType: TextInputType.text,
                                                        onChanged: (val) {
                                                          setState(() => Roll = val);
                                                        }),),
                                                  ])
                                          ),
                                          new Padding(
                                              padding: EdgeInsets.all(15.00)),
                                          new TextFormField(
                                              focusNode: focusNode4,
                                              enableSuggestions: true,
                                              style: TextStyle(
                                                  fontFamily: 'BalooChettan2',
                                                  color: Colors.black54,
                                                  fontSize: 20.00),
                                              decoration: new InputDecoration(
                                                  contentPadding: EdgeInsets.only(
                                                      left: 20.00, right: 20.00),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10.00)),
                                                  labelText: "PRN",
                                                  labelStyle: new TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.blue,
                                                      fontSize: 15.00)),
                                              keyboardType: TextInputType.text,
                                              onChanged: (val) {
                                                setState(() => fPRN = val);
                                              }),
                                          new Padding(
                                              padding: EdgeInsets.all(15.00)),

                                          new TextFormField(
                                              focusNode: focusNode6,
                                              style: TextStyle(
                                                  fontFamily: 'BalooChettan2',
                                                  color: Colors.black54,
                                                  fontSize: 20.00),
                                              decoration: new InputDecoration(
                                                  contentPadding: EdgeInsets.only(
                                                      left: 20.00, right: 20.00),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10.00)),
                                                  labelText: "Enter Password",
                                                  labelStyle: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.blue,
                                                      fontSize: 15.00)),
                                              keyboardType: TextInputType.text,
                                              obscureText: true,
                                              validator: validatePassword,
                                              onChanged: (val) {
                                                setState(() => _fpassword = val);
                                              }),
                                          new Padding(
                                              padding: EdgeInsets.all(15.00)),
                                        ],
                                      ),
                                    ),
                                    new Padding(
                                        padding:
                                        const EdgeInsets.only(top: 30.00)),
                                    new RaisedButton(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(100.00)),
                                        splashColor: Colors.blue,
                                        onPressed: () async {
                                          if (formKey.currentState.validate()) {
                                            signUp(_femail, _fpassword);
                                            formKey.currentState.save();
                                            var a=_femail.split("@");

                                            dbref.child('Student').child(a[0]).set({
                                              "Class":classs,
                                              "PRN":fPRN.toString(),
                                              "Name":_fname,
                                              "Serial":Roll.toString(),
                                              "Branch":fDep

                                            });
                                          }
                                          await Future.delayed(Duration(seconds: 3));
                                          Fluttertoast.showToast(
                                              msg: "Sign up Successful",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                              fontSize:  16.0
                                          );
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage(),
                                              ));

                                        },
                                        elevation: 2.0,
                                        padding: EdgeInsets.only(
                                            left: 50.00,
                                            right: 50.00,
                                            top: 15.00,
                                            bottom: 15.00),
                                        color: Color.fromARGB(255, 52, 127, 228),
                                        textColor: Colors.white,
                                        child: new Text("Sign Up",
                                            textAlign: TextAlign.center)),
                                    new Padding(
                                        padding: EdgeInsets.only(bottom: 15.00))
                                  ],
                                )),
                          ),
                        ),
                      ),

                      back: new Card(
                        margin: new EdgeInsets.only(
                            left: 25.00, right: 25.00, bottom: 20.00, top: 20.00),
                        elevation: 10.0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),

                        child: Container(
                          child: new Form(
                            key: form,
                            autovalidate: true,
                            child: new Theme(
                                data: new ThemeData(
                                    brightness: Brightness.light,
                                    primarySwatch: Colors.blue,
                                    inputDecorationTheme:
                                    new InputDecorationTheme(
                                        labelStyle: new TextStyle(
                                            color: Colors.blue,
                                            fontSize: 15.00))),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Text(
                                      "Teacher",
                                      style: TextStyle(
                                          fontFamily: 'BalooChettan2',
                                          color: Colors.black54,
                                          fontSize: 30.00,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2.0),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left:70.0,bottom: 10.0),
                                      child: Row(
                                        children: <Widget>[
                                          Text("Student",style: TextStyle(fontSize: 20,),),
                                          Switch(
                                            value: isSwitched,
                                            onChanged: (value) {
                                              setState(() {
                                                isSwitched = value;
                                                cardKey.currentState.toggleCard();
                                              });
                                            },
                                            activeTrackColor: Colors.black45,
                                            activeColor: Colors.black54,
                                            inactiveThumbColor:Colors.black54,
                                          ),
                                          Text("Teacher",style: TextStyle(fontSize: 20,),),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.only(
                                          left:20.0, right: 20.0),
                                      child: new Column(
                                        children: <Widget>[
                                          new TextFormField(
                                              focusNode: focusNode11,
                                              enableSuggestions: true,
                                              style: TextStyle(
                                                  fontFamily: 'BalooChettan2',
                                                  color: Colors.black54,
                                                  fontSize: 20.00),
                                              decoration: new InputDecoration(
                                                  contentPadding: EdgeInsets.only(
                                                      left: 20.00, right: 20.00),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10.00)),
                                                  labelText: "Enter Email",
                                                  labelStyle: new TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.blue,
                                                      fontSize: 15.00)),
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              validator: validateEmail,
                                              onChanged: (val) {
                                                setState(() => _bemail = val);
                                              }),
                                          new Padding(
                                              padding: EdgeInsets.all(15.00)),

                                          new TextFormField(
                                              focusNode: focusNode21,
                                              enableSuggestions: true,
                                              style: TextStyle(
                                                  fontFamily: 'BalooChettan2',
                                                  color: Colors.black54,
                                                  fontSize: 20.00),
                                              decoration: new InputDecoration(
                                                  contentPadding: EdgeInsets.only(
                                                      left: 20.00, right: 20.00),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10.00)),
                                                  labelText: "Name",
                                                  labelStyle: new TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.blue,
                                                      fontSize: 15.00)),
                                              keyboardType: TextInputType.text,
                                              onChanged: (val) {
                                                setState(() => _bname = val);
                                              }),

                                          new Padding(
                                              padding: EdgeInsets.all(10.0)),

                                          Padding(
                                              padding:const  EdgeInsets.only(
                                                  right: 15),

                                              child: new Row(
                                                // crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    new Flexible(
                                                        child:Text("Department",style:TextStyle(color: Colors.black87,fontSize: 16))
                                                    ),
                                                    new Flexible(child:
                                                    Padding(
                                                      padding: const EdgeInsets.only(left:12.0),
                                                      child: new DropdownButton<String>(
                                                        focusNode: focusNode71,
                                                        items: branch.map((String listvalue) {
                                                          return DropdownMenuItem<String>(
                                                            value: listvalue,
                                                            child: Text(listvalue),
                                                          );
                                                        }).toList(),
                                                        onChanged: (val){
                                                          setState(() =>bDep=val);
                                                        },
                                                        value: bDep,
                                                      ),
                                                    ),
                                                    ),

                                                  ])
                                          ),
                                          new Padding(
                                              padding: EdgeInsets.all(15.00)),
                                          new TextFormField(
                                              focusNode: focusNode41,
                                              enableSuggestions: true,
                                              style: TextStyle(
                                                  fontFamily: 'BalooChettan2',
                                                  color: Colors.black54,
                                                  fontSize: 20.00),
                                              decoration: new InputDecoration(
                                                  contentPadding: EdgeInsets.only(
                                                      left: 20.00, right: 20.00),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10.00)),
                                                  labelText: "ID",
                                                  labelStyle: new TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.blue,
                                                      fontSize: 15.00)),
                                              keyboardType: TextInputType.text,
                                              onChanged: (val) {
                                                setState(() => bPRN = val);
                                              }),
                                          new Padding(
                                              padding: EdgeInsets.all(15.00)),

                                          new TextFormField(
                                              focusNode: focusNode61,
                                              style: TextStyle(
                                                  fontFamily: 'BalooChettan2',
                                                  color: Colors.black54,
                                                  fontSize: 20.00),
                                              decoration: new InputDecoration(
                                                  contentPadding: EdgeInsets.only(
                                                      left: 20.00, right: 20.00),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10.00)),
                                                  labelText: "Enter Password",
                                                  labelStyle: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.blue,
                                                      fontSize: 15.00)),
                                              keyboardType: TextInputType.text,
                                              obscureText: true,
                                              validator: validatePassword,
                                              onChanged: (val) {
                                                setState(() => _bpassword = val);
                                              }),
                                          new Padding(
                                              padding: EdgeInsets.all(15.00)),
                                        ],
                                      ),
                                    ),
                                    new Padding(
                                        padding:
                                        const EdgeInsets.only(top: 30.00)),
                                    new RaisedButton(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(100.00)),
                                        splashColor: Colors.blue,
                                        onPressed: () async {
                                          if (form.currentState.validate()) {
                                            signUp(_bemail, _bpassword);
                                            form.currentState.save();
                                            var a=_bemail.split("@");

                                            dbref.child('Teacher_account').child(a[0]).set({
                                              "PRN":bPRN,
                                              "name":_bname,
                                              "Branch":bDep

                                            });
                                          }
                                          await Future.delayed(Duration(seconds: 3));
                                          Fluttertoast.showToast(
                                              msg: "Sign up Successful",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                              fontSize:  16.0
                                          );
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage(),
                                              ));

                                        },
                                        elevation: 2.0,
                                        padding: EdgeInsets.only(
                                            left: 50.00,
                                            right: 50.00,
                                            top: 15.00,
                                            bottom: 15.00),
                                        color: Color.fromARGB(255, 52, 127, 228),
                                        textColor: Colors.white,
                                        child: new Text("Sign Up",
                                            textAlign: TextAlign.center)),
                                    new Padding(
                                        padding: EdgeInsets.only(bottom: 15.00))
                                  ],
                                )),
                          ),
                        ),
                      ),),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Future signUp(String email, String password) async {
    try {
      AuthResult result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      assert(user != null);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await auth.currentUser();
      assert(user.uid == currentUser.uid);

    }
    catch(e ) {
      if(e is PlatformException) {
        if(e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          /// `foo#bar.com` has alread been registered.
          Fluttertoast.showToast(
              msg: "Email already in use",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize:  16.0
          );
        }
      }
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
  }
//Sign in Error handling
}