import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/AttendanceData.dart';
import 'package:flutter_app/responsive/Screensize.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

//import 'parentinfo.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> with SingleTickerProviderStateMixin {
  var cla = [
    'Class',
    'FE1',
    'FE2',
    'FESS',
    'SE1',
    'SE2',
    'SESS',
    'TE1',
    'TE2',
    'TESS',
    'BE1',
    'BE2',
    'BESS'
  ];
  var branch = ["Branch", "Comp", "Entc", "Mech", "FE"];
  bool touch = false,cnfpass=false,confirmvalidate=false;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  final confirmkey = new GlobalKey<FormState>();
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
  FocusNode focusNode8 = new FocusNode();
  FocusNode focusNode9 = new FocusNode();
  FocusNode focusNode11 = new FocusNode();
  FocusNode focusNode21 = new FocusNode();
  FocusNode focusNode31 = new FocusNode();
  FocusNode focusNode41 = new FocusNode();
  FocusNode focusNode51 = new FocusNode();
  FocusNode focusNode61 = new FocusNode();
  FocusNode focusNode71 = new FocusNode();

  dynamic _femail, _bemail, fPRN, bPRN, Roll, Branch, _fpassword, _bpassword,
      _fname, _bname, _batch;
  final dbref = FirebaseDatabase.instance.reference();
  String classs = 'Class',
      fDep = "Branch",
      bDep = "Branch";
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
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.00)),
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

  bool isSwitched = false,
      _autovalidate = false,
      _autotvalidate = false,
      checkBoxValue = false;

  Future<bool> _onBackPressed() {
    if (touch == false) {
      Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
    }
  }


  @override
  Widget build(BuildContext context) {
    ProgressDialog pr = new ProgressDialog(
        context, type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Kindly wait");
    int grp=SizeConfig.grp;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
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
                        padding: grp<4?EdgeInsets.only(
                            top: 1.2 * SizeConfig.heightMultiplier,
                            bottom: 1.5 * SizeConfig.heightMultiplier):EdgeInsets.only(
                            top: 6 * SizeConfig.heightMultiplier,
                            bottom: 1.5 * SizeConfig.heightMultiplier),
                        child: new Image(
                          image: new AssetImage("assets/college_logo.png"),
                          alignment: Alignment.topCenter,
                          height: 25 * SizeConfig.heightMultiplier,
                          width: 35 * SizeConfig.widthMultiplier,
                        ),
                      ),
                      FlipCard(
                        direction: FlipDirection.HORIZONTAL,
                        key: cardKey,
                        flipOnTouch: false,
                        front: new Card(
                          margin: new EdgeInsets.symmetric(
                              vertical: 1.2 * SizeConfig.heightMultiplier,
                              horizontal: 5 * SizeConfig.widthMultiplier),
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
                                              fontSize: 2 * SizeConfig
                                                  .heightMultiplier))),
                                  child: new Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.2 *
                                            SizeConfig.textMultiplier),
                                        child: new Text(
                                          "Student",
                                          style: TextStyle(
                                            color: HexColor.fromHex("#00004d"),
                                            fontSize: 3.5 *
                                                SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration
                                                .underline,
                                          ),

                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 16 *
                                            SizeConfig.widthMultiplier,
                                            bottom: 1.1 *
                                                SizeConfig.heightMultiplier),
                                        child: Row(
                                          children: <Widget>[
                                            Text("Student", style: TextStyle(
                                              fontSize: 2.5 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor.fromHex(
                                                  "#00004d"),),),
                                            Switch(
                                              value: isSwitched,
                                              onChanged: (value) {
                                                setState(() {
                                                  isSwitched = value;
                                                  cardKey.currentState
                                                      .toggleCard();
                                                });
                                              },
                                              activeTrackColor: Colors.black87,
                                              activeColor: Colors.black87,
                                              inactiveThumbColor: Colors
                                                  .black87,
                                            ),
                                            Text("Teacher", style: TextStyle(
                                              fontSize: 2.7 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor.fromHex(
                                                  "#00004d"),),),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 5 *
                                                SizeConfig.widthMultiplier,
                                            right: 5 *
                                                SizeConfig.widthMultiplier),
                                        child: new Column(
                                          children: <Widget>[
                                            new TextFormField(
                                                focusNode: focusNode1,
                                                enableSuggestions: true,
                                                cursorColor: HexColor.fromHex(
                                                    "#00004d"),
                                                style: TextStyle(
                                                    fontFamily: 'BalooChettan2',
                                                    // color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    color: HexColor.fromHex(
                                                        "#00004d"),
                                                    fontSize: 2.2 * SizeConfig
                                                        .textMultiplier),
                                                decoration: new InputDecoration(
                                                    suffixIcon: Icon(
                                                      Icons.email, size: 20,
                                                      color: Colors.black54,),
                                                    contentPadding: EdgeInsets
                                                        .only(
                                                        left: 5 * SizeConfig
                                                            .widthMultiplier,
                                                        right: 5 * SizeConfig
                                                            .widthMultiplier),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10.00)),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius
                                                          .all(
                                                          Radius.circular(10)),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          color: HexColor
                                                              .fromHex(
                                                              "#800000")),
                                                    ),
                                                    labelText: "Enter e-mail",
                                                    labelStyle: new TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        color: HexColor.fromHex(
                                                            "#800000"),
                                                        // fontStyle: ,
                                                        fontSize: 2.5 *
                                                            SizeConfig
                                                                .textMultiplier)),
                                                keyboardType:
                                                TextInputType.emailAddress,
                                                validator: validateEmail,
                                                onChanged: (val) {
                                                  setState(() {
                                                    _femail = val;
                                                  });
                                                }),
                                            new Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 1.2 * SizeConfig
                                                        .heightMultiplier,
                                                    horizontal: 2.8 * SizeConfig
                                                        .widthMultiplier)),

                                            new TextFormField(
                                                focusNode: focusNode2,
                                                enableSuggestions: true,
                                                cursorColor: HexColor.fromHex(
                                                    "#00004d"),
                                                style: TextStyle(
                                                    fontFamily: 'BalooChettan2',
                                                    // color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    color: HexColor.fromHex(
                                                        "#00004d"),
                                                    fontSize: 2.2 * SizeConfig
                                                        .textMultiplier),
                                                decoration: new InputDecoration(
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius
                                                          .all(
                                                          Radius.circular(10)),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          color: HexColor
                                                              .fromHex(
                                                              "#800000")),
                                                    ),
                                                    contentPadding: EdgeInsets
                                                        .only(
                                                        left: 5.5 * SizeConfig
                                                            .widthMultiplier,
                                                        right: 5.5 * SizeConfig
                                                            .widthMultiplier),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10.00)),
                                                    labelText: "Name",
                                                    labelStyle: new TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        //color: HexColor.fromHex("#00004d")
                                                        color: HexColor.fromHex(
                                                            "#800000"),
                                                        fontSize: 2.5 *
                                                            SizeConfig
                                                                .textMultiplier)),
                                                keyboardType: TextInputType
                                                    .text,
                                                validator: validatename,
                                                onChanged: (val) {
                                                  setState(() {
                                                    _fname = val;
                                                    //  FocusScope.of(context).requestFocus(new FocusNode());
                                                  });
                                                }),

                                            new Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0.4 * SizeConfig
                                                        .heightMultiplier,
                                                    horizontal: 0.0)),

                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5 * SizeConfig
                                                        .widthMultiplier),
                                                child: new Row(
                                                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .spaceBetween,
                                                    children: <Widget>[
                                                      new Flexible(child:
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .only(left: 0.0),
                                                        child: new DropdownButton<
                                                            String>(
                                                          focusNode: focusNode7,
                                                          iconEnabledColor: Color(
                                                              0xff00004d),
                                                          items: branch.map((
                                                              String listvalue) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: listvalue,
                                                              child: Text(
                                                                listvalue,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .bold,
                                                                  color: HexColor
                                                                      .fromHex(
                                                                      "#00004d"),),),
                                                            );
                                                          }).toList(),
                                                          onChanged: (val) {
                                                            setState(() =>
                                                            fDep = val);
                                                            FocusScope.of(
                                                                context)
                                                                .requestFocus(
                                                                new FocusNode());
                                                          },
                                                          value: fDep,
                                                        ),
                                                      ),
                                                      ),
                                                      DropdownButton<String>(
                                                        iconEnabledColor: Color(
                                                            0xff00004d),
                                                        items: cla.map((
                                                            String listvalue) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: listvalue,
                                                            child: Text(
                                                              listvalue,
                                                              style: TextStyle(
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                color: HexColor
                                                                    .fromHex(
                                                                    "#00004d"),),),
                                                          );
                                                        }).toList(),
                                                        onChanged: (val) {
                                                          setState(() =>
                                                          classs = val);
                                                        },
                                                        value: classs,
                                                      ),

                                                    ])
                                            ),
                                            new Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 1.4 * SizeConfig
                                                        .heightMultiplier,
                                                    horizontal: 2.8 * SizeConfig
                                                        .widthMultiplier)),

                                            Padding(
                                                padding: EdgeInsets.only(
                                                    right: 5 * SizeConfig
                                                        .widthMultiplier),
                                                child: new Row(
                                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .spaceBetween,
                                                    children: <Widget>[
                                                      new Flexible(child:
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .only(left: 3 *
                                                            SizeConfig
                                                                .widthMultiplier),
                                                        child: new TextFormField(
                                                            maxLength: 9,
                                                            focusNode: focusNode4,
                                                            enableSuggestions: true,
                                                            cursorColor: HexColor
                                                                .fromHex(
                                                                "#00004d"),
                                                            style: TextStyle(
                                                                fontFamily: 'BalooChettan2',
                                                                color: HexColor
                                                                    .fromHex(
                                                                    "#00004d"),
                                                                fontSize: 2.5 *
                                                                    SizeConfig
                                                                        .textMultiplier,
                                                                fontWeight: FontWeight
                                                                    .bold),
                                                            decoration: new InputDecoration(
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius
                                                                      .all(
                                                                      Radius
                                                                          .circular(
                                                                          10)),
                                                                  borderSide: BorderSide(
                                                                      width: 1,
                                                                      color: HexColor
                                                                          .fromHex(
                                                                          "#800000")),
                                                                ),
                                                                counterText: "",
                                                                contentPadding: EdgeInsets
                                                                    .only(
                                                                    left: 5.2 *
                                                                        SizeConfig
                                                                            .widthMultiplier,
                                                                    right: 5.2 *
                                                                        SizeConfig
                                                                            .widthMultiplier),
                                                                border: OutlineInputBorder(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        10.00)),
                                                                labelText: "PRN",
                                                                labelStyle: new TextStyle(
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                    color: HexColor
                                                                        .fromHex(
                                                                        "#800000"),
                                                                    fontSize: 2.5 *
                                                                        SizeConfig
                                                                            .textMultiplier)),
                                                            keyboardType: TextInputType
                                                                .text,
                                                            validator: validatePRN,
                                                            onChanged: (val) {
                                                              setState(() =>
                                                              fPRN = val);
                                                            }),
                                                      ),
                                                      ),
                                                      new Flexible(
                                                        child:
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .only(left: 6.5 *
                                                              SizeConfig
                                                                  .widthMultiplier),
                                                          child: new TextFormField(
                                                              maxLength: 1,
                                                              cursorColor: HexColor
                                                                  .fromHex(
                                                                  "#00004d"),
                                                              focusNode: focusNode8,
                                                              enableSuggestions: true,
                                                              style: TextStyle(
                                                                  fontFamily: 'BalooChettan2',
                                                                  color: HexColor
                                                                      .fromHex(
                                                                      "#00004d"),
                                                                  fontSize: 2.5 *
                                                                      SizeConfig
                                                                          .textMultiplier,
                                                                  fontWeight: FontWeight
                                                                      .bold),
                                                              decoration: new InputDecoration(
                                                                  focusedBorder: OutlineInputBorder(
                                                                    borderRadius: BorderRadius
                                                                        .all(
                                                                        Radius
                                                                            .circular(
                                                                            10)),
                                                                    borderSide: BorderSide(
                                                                        width: 1,
                                                                        color: HexColor
                                                                            .fromHex(
                                                                            "#800000")),
                                                                  ),
                                                                  counterText: "",
                                                                  contentPadding: EdgeInsets
                                                                      .only(
                                                                      left: 5.2 *
                                                                          SizeConfig
                                                                              .widthMultiplier,
                                                                      right: 5.2 *
                                                                          SizeConfig
                                                                              .widthMultiplier),
                                                                  border: OutlineInputBorder(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                          10.00)),
                                                                  labelText: "Batch",
                                                                  labelStyle: new TextStyle(
                                                                      fontWeight: FontWeight
                                                                          .bold,
                                                                      color: HexColor
                                                                          .fromHex(
                                                                          "#800000"),
                                                                      fontSize: 2.5 *
                                                                          SizeConfig
                                                                              .textMultiplier)),
                                                              keyboardType: TextInputType
                                                                  .text,
                                                              validator: validatebatch,
                                                              onChanged: (val) {
                                                                setState(() =>
                                                                _batch = val);
                                                              }),
                                                        ),

                                                      ),

                                                    ])
                                            ),
                                            new Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 1.2 * SizeConfig
                                                        .heightMultiplier,
                                                    horizontal: 2.8 * SizeConfig
                                                        .widthMultiplier)),

                                            new TextFormField(
                                                focusNode: focusNode6,
                                                cursorColor: HexColor.fromHex(
                                                    "#00004d"),
                                                style: TextStyle(
                                                    fontFamily: 'BalooChettan2',
                                                    fontWeight: FontWeight.bold,
                                                    color: HexColor.fromHex(
                                                        "#00004d"),
                                                    fontSize: 2.5 * SizeConfig
                                                        .textMultiplier),
                                                decoration: new InputDecoration(
                                                    suffixIcon: Icon(
                                                      Icons.lock, size: 20,
                                                      color: Colors.black54,),
                                                    contentPadding: EdgeInsets
                                                        .only(
                                                        left: 5.2 * SizeConfig
                                                            .widthMultiplier,
                                                        right: 5.2 * SizeConfig
                                                            .widthMultiplier),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius
                                                          .all(
                                                          Radius.circular(10)),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          color: HexColor
                                                              .fromHex(
                                                              "#800000")),
                                                    ),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10.00)),
                                                    labelText: "Enter Password",
                                                    labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        color: HexColor.fromHex(
                                                            "#800000"),
                                                        fontSize: 2.5 *
                                                            SizeConfig
                                                                .textMultiplier)),
                                                keyboardType: TextInputType
                                                    .text,
                                                obscureText: true,
                                                validator: validatePassword,
                                                onChanged: (val) {
                                                  setState(() =>
                                                  _fpassword = val);
                                                }),
                                            new Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0.7 * SizeConfig
                                                        .heightMultiplier,
                                                    horizontal: 1.6 * SizeConfig
                                                        .widthMultiplier)),
                                          ],
                                        ),
                                      ),
                                      new Padding(
                                          padding:
                                          EdgeInsets.only(top: 0.7 *
                                              SizeConfig.heightMultiplier)),
                                      new SizedBox(
                                          width: 30 *
                                              SizeConfig.widthMultiplier,
                                          height: 5.5 *
                                              SizeConfig.heightMultiplier,
                                          child:
                                          new RaisedButton(
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      100.00)),
                                              splashColor: HexColor.fromHex(
                                                  "#ffffff"),
                                              onPressed: () async {
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                    new FocusNode());
                                                if (classs == "Class" ||
                                                    fDep == "Branch" ||
                                                    _fname == "") {

                                                  Fluttertoast.showToast(
                                                      msg: "Something is missing!!",
                                                      toastLength: Toast
                                                          .LENGTH_SHORT,
                                                      gravity: ToastGravity
                                                          .BOTTOM,
                                                      backgroundColor: Colors
                                                          .red,
                                                      textColor: Colors.white,
                                                      fontSize: 2 * SizeConfig
                                                          .textMultiplier);
                                                }
                                                else {
                                                  setState(() {
                                                    cnfpass=false;
                                                    confirmvalidate=false;
                                                  });
                                                  if (formKey.currentState
                                                      .validate()) {
                                                    pr.show();
                                                    _femail = _femail.toString()
                                                        .toLowerCase();
                                                    // ignore: unrelated_type_equality_checks
                                                    try {
                                                      var a = _femail.split(
                                                          "@");
                                                      String b = a[0]
                                                          .toString()
                                                          .replaceAll(
                                                          new RegExp(r'\W'),
                                                          "_");
                                                      await dbref.child(
                                                          "Registration")
                                                          .child("Student")
                                                          .child(fDep).child(
                                                          b) //.child("Batch")
                                                          .once()
                                                          .then((
                                                          onValue) { //print(onValue.value);
                                                        if (onValue.value ==
                                                            null)
                                                          throw Exception;
                                                      });
                                                      await confirm(_fpassword);
                                                      if(cnfpass) {
                                                        if (await signUp(

                                                            _femail,
                                                            _fpassword) ==
                                                            1) {
                                                          formKey.currentState
                                                              .save();


                                                          Navigator
                                                              .pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (
                                                                    context) =>
                                                                    LoginPage(),
                                                              ));
                                                        }else{
                                                          pr.hide();
                                                        }
                                                      }
                                                    } catch (exception) {
                                                      pr.hide();
                                                      Alert(
                                                        context: context,
                                                        style: AlertStyle(
                                                          animationType: AnimationType.fromTop,
                                                          isCloseButton: false,
                                                          isOverlayTapDismiss: false,
                                                          descStyle: TextStyle(fontWeight: FontWeight.bold),
                                                          animationDuration: Duration(milliseconds: 900),
                                                          alertBorder: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10.0),
                                                            side: BorderSide(
                                                              color: Colors.grey,
                                                            ),
                                                          ),
                                                          titleStyle: TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        type: AlertType.error,
                                                        title: "Access Denied",
                                                        // desc: "Flutter is more awesome with RFlutter Alert.",
                                                        buttons: [
                                                          DialogButton(
                                                            child: Text(
                                                              "COOL",
                                                              style: TextStyle(color: Colors.white, fontSize: 20),
                                                            ),
                                                            onPressed: () => Navigator.pop(context),
                                                            width: 120,
                                                          )
                                                        ],
                                                      ).show();
//
                                                    }
                                                  } else {
                                                    setState(() {
                                                      _autovalidate = true;
                                                    });
                                                  }
                                                }
                                              },
                                              elevation: 2.0,
                                              color: HexColor.fromHex(
                                                  "#00004d"),
                                              textColor: Colors.white,
                                              child: new Text("Sign Up",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 2.3 *
                                                    SizeConfig
                                                        .textMultiplier),))
                                      ),
                                      new Padding(
                                          padding: EdgeInsets.only(bottom: 2.1 *
                                              SizeConfig.heightMultiplier))
                                    ],
                                  )),
                            ),
                          ),
                        ),

                        back: new Card(
                          margin: new EdgeInsets.symmetric(
                              vertical: 4 * SizeConfig.heightMultiplier,
                              horizontal: 5 * SizeConfig.widthMultiplier),
                          elevation: 10.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),

                          child: Container(
                            child: new Form(
                              key: form,
                              autovalidate: _autotvalidate,
                              child: new Theme(
                                  data: new ThemeData(
                                      brightness: Brightness.light,
                                      primarySwatch: Colors.blue,
                                      inputDecorationTheme:
                                      new InputDecorationTheme(
                                          labelStyle: new TextStyle(
                                              color: Colors.blue,
                                              fontSize: 2 * SizeConfig
                                                  .heightMultiplier))),
                                  child: new Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Text(
                                        "Teacher",
                                        style: TextStyle(
                                            color: HexColor.fromHex("#00004d"),
                                            fontFamily: 'BalooChettan2',
                                            fontSize: 3.5 *
                                                SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 20 *
                                            SizeConfig.widthMultiplier,
                                            bottom: 1.2 *
                                                SizeConfig.heightMultiplier),
                                        child: Row(
                                          children: <Widget>[
                                            Text("Student", style: TextStyle(
                                                fontSize: 2.5 *
                                                    SizeConfig.textMultiplier,
                                                color: HexColor.fromHex(
                                                    "#00004d"),
                                                fontWeight: FontWeight.bold),),
                                            Switch(
                                              value: isSwitched,
                                              onChanged: (value) {
                                                setState(() {
                                                  isSwitched = value;
                                                  print(isSwitched);
                                                  cardKey.currentState
                                                      .toggleCard();
                                                });
                                              },
                                              activeTrackColor: Colors.black45,
                                              activeColor: Colors.black87,
                                              inactiveThumbColor: Colors
                                                  .black87,
                                            ),
                                            Text("Teacher", style: TextStyle(
                                                fontSize: 2.5 *
                                                    SizeConfig.textMultiplier,
                                                color: HexColor.fromHex(
                                                    "#00004d"),
                                                fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5 *
                                                SizeConfig.widthMultiplier),
                                        child: new Column(
                                          children: <Widget>[
                                            new TextFormField(
                                                focusNode: focusNode11,
                                                cursorColor: HexColor.fromHex(
                                                    "#00004d"),
                                                enableSuggestions: true,
                                                style: TextStyle(
                                                    fontFamily: 'BalooChettan2',
                                                    color: HexColor.fromHex(
                                                        "#00004d"),
                                                    fontSize: 2.5 * SizeConfig
                                                        .textMultiplier,
                                                    fontWeight: FontWeight
                                                        .bold),
                                                decoration: new InputDecoration(
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius
                                                          .all(
                                                          Radius.circular(10)),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          color: HexColor
                                                              .fromHex(
                                                              "#800000")),
                                                    ),
                                                    suffixIcon: Icon(
                                                      Icons.email, size: 20,
                                                      color: Colors.black54,),
                                                    contentPadding: EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5 *
                                                            SizeConfig
                                                                .widthMultiplier),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10.00)),
                                                    labelText: "Enter Email",
                                                    labelStyle: new TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        color: HexColor.fromHex(
                                                            "#800000"),
                                                        fontSize: 2.5 *
                                                            SizeConfig
                                                                .textMultiplier)),
                                                keyboardType:
                                                TextInputType.emailAddress,
                                                validator: validatetEmail,
                                                onChanged: (val) {
                                                  setState(() => _bemail = val);
                                                }),
                                            new Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 1.8 * SizeConfig
                                                        .heightMultiplier,
                                                    horizontal: 4 * SizeConfig
                                                        .widthMultiplier)),

                                            new TextFormField(
                                                focusNode: focusNode21,
                                                cursorColor: HexColor.fromHex(
                                                    "#00004d"),
                                                enableSuggestions: true,
                                                style: TextStyle(
                                                    fontFamily: 'BalooChettan2',
                                                    color: HexColor.fromHex(
                                                        "#00004d"),
                                                    fontSize: 2.5 * SizeConfig
                                                        .textMultiplier,
                                                    fontWeight: FontWeight
                                                        .bold),
                                                decoration: new InputDecoration(
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius
                                                          .all(
                                                          Radius.circular(10)),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          color: HexColor
                                                              .fromHex(
                                                              "#800000")),
                                                    ),
                                                    contentPadding: EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5 *
                                                            SizeConfig
                                                                .widthMultiplier
                                                    ),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10.00)),
                                                    labelText: "Name",
                                                    labelStyle: new TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        color: HexColor.fromHex(
                                                            "#800000"),
                                                        fontSize: 2.5 *
                                                            SizeConfig
                                                                .textMultiplier)),
                                                keyboardType: TextInputType
                                                    .text,
                                                onChanged: (val) {
                                                  setState(() => _bname = val);
                                                }),

                                            new Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0.7 * SizeConfig
                                                        .heightMultiplier)),

                                            new Padding(
                                              padding: EdgeInsets.only(left: 0,
                                                  right: 2 * SizeConfig
                                                      .widthMultiplier),
                                              child: new Row(
                                                // crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .center,
                                                  children: <Widget>[
                                                    Text("Dept",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            color: HexColor
                                                                .fromHex(
                                                                "#00004d"),
                                                            fontSize: 2.2 *
                                                                SizeConfig
                                                                    .textMultiplier)),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 4.2 * SizeConfig
                                                              .widthMultiplier),
                                                      child: new DropdownButton<
                                                          String>(
                                                        focusNode: focusNode71,
                                                        iconEnabledColor: Color(
                                                            0xff00004d),
                                                        items: branch.map((
                                                            String listvalue) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: listvalue,
                                                            child: Text(
                                                              listvalue,
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .bold,
                                                                  color: HexColor
                                                                      .fromHex(
                                                                      "#00004d"),
                                                                  fontSize: 2.2 *
                                                                      SizeConfig
                                                                          .textMultiplier),),
                                                          );
                                                        }).toList(),
                                                        onChanged: (val) {
                                                          setState(() =>
                                                          bDep = val);
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                              new FocusNode());
                                                        },
                                                        value: bDep,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 2.5 * SizeConfig
                                                              .widthMultiplier),
                                                      child: Theme(
                                                        data: ThemeData(
                                                            unselectedWidgetColor: HexColor
                                                                .fromHex(
                                                                "#00004d")),
                                                        child: new Checkbox(
                                                            value: checkBoxValue,
                                                            activeColor: HexColor
                                                                .fromHex(
                                                                "#008066"),
                                                            onChanged: (
                                                                bool newValue) {
                                                              setState(() {
                                                                checkBoxValue =
                                                                    newValue;
                                                              });
                                                            }),
                                                      ),
                                                    ),
                                                    new Text('Admin',
                                                      style: TextStyle(
                                                          color: HexColor
                                                              .fromHex(
                                                              "#00004d"),
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          fontSize: 2.2 *
                                                              SizeConfig
                                                                  .textMultiplier),),
                                                  ]),
                                            ),

                                            new Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2.5 * SizeConfig
                                                        .widthMultiplier,
                                                    vertical: 1.2 * SizeConfig
                                                        .heightMultiplier)),

                                            new TextFormField(
                                                focusNode: focusNode61,
                                                cursorColor: HexColor.fromHex(
                                                    "#00004d"),
                                                style: TextStyle(
                                                    fontFamily: 'BalooChettan2',
                                                    color: HexColor.fromHex(
                                                        "#00004d"),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 2.5 * SizeConfig
                                                        .textMultiplier),
                                                decoration: new InputDecoration(
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius
                                                          .all(
                                                          Radius.circular(10)),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          color: HexColor
                                                              .fromHex(
                                                              "#800000")),
                                                    ),
                                                    suffixIcon: Icon(
                                                      Icons.lock, size: 20,
                                                      color: Colors.black54,),
                                                    contentPadding: EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5 *
                                                            SizeConfig
                                                                .widthMultiplier),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10.00)),
                                                    labelText: "Enter Password",
                                                    labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        color: HexColor.fromHex(
                                                            "#800000"),
                                                        fontSize: 2.5 *
                                                            SizeConfig
                                                                .textMultiplier)),
                                                keyboardType: TextInputType
                                                    .text,
                                                obscureText: true,
                                                validator: validatePassword,
                                                onChanged: (val) {
                                                  setState(() =>
                                                  _bpassword = val);
                                                }),
                                            new Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 1.2 * SizeConfig
                                                        .widthMultiplier,
                                                    vertical: 0.7 * SizeConfig
                                                        .heightMultiplier)),
                                          ],
                                        ),
                                      ),
                                      new Padding(
                                          padding:
                                          EdgeInsets.only(top: SizeConfig
                                              .heightMultiplier)),
                                      new SizedBox(
                                        width: 30 * SizeConfig.widthMultiplier,
                                        height: 5.5 *
                                            SizeConfig.heightMultiplier,
                                        child:
                                        RaisedButton(
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(100.00)),
                                            splashColor: HexColor.fromHex(
                                                "#00004d"),
                                            onPressed: () async {
                                              //showLoaderDialog(context);
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                  new FocusNode());
                                              if (_bname == "" ||
                                                  bDep.toString() == "Branch") {
                                                Fluttertoast.showToast(
                                                    msg: "Something is missing!!",
                                                    toastLength: Toast
                                                        .LENGTH_SHORT,
                                                    gravity: ToastGravity
                                                        .BOTTOM,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 2 * SizeConfig
                                                        .textMultiplier);
                                              }
                                              else {
                                                setState(() {
                                                  cnfpass=false;
                                                  confirmvalidate=false;
                                                });
                                                if (form.currentState
                                                    .validate()) {
                                                  await confirm(_bpassword);
                                                  if (cnfpass) {
                                                    print("done");
                                                    _bname = _bname.toString()
                                                        .replaceAll(
                                                        new RegExp(r'\W'), "")
                                                        .toUpperCase();
                                                    bDep = bDep;
                                                    setState(() {
                                                      touch = true;
                                                      //  print(touch);
                                                    });
                                                    pr.show();
                                                    _bemail =
                                                        _bemail.toString();
                                                    if (await signUp(
                                                        _bemail, _bpassword) ==
                                                        1) {
                                                      form.currentState.save();
                                                      var a = _bemail.split(
                                                          "@");
                                                      String b = a[0]
                                                          .toString()
                                                          .replaceAll(
                                                          new RegExp(r'\W'),
                                                          "_");
                                                      if (checkBoxValue ==
                                                          true) {
                                                        await dbref.child(
                                                            "Registration")
                                                          ..child(
                                                              'Teacher_account')
                                                              .child(b)
                                                              .set({
                                                            "Name": _bname
                                                                .toString()
                                                                .toUpperCase(),
                                                            "Department": bDep
                                                                .toString(),
                                                            "Admin": 1
                                                          });
                                                      } else {
                                                        await dbref.child(
                                                            "Registration")
                                                            .child(
                                                            'Teacher_account')
                                                            .child(b)
                                                            .set({
                                                          "Name": _bname
                                                              .toString()
                                                              .toUpperCase(),
                                                          "Department": bDep
                                                              .toString()
                                                        });
                                                      }

                                                      pr.hide();
                                                      setState(() {
                                                        touch = false;
                                                        //   print(touch);
                                                      });
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (
                                                                context) =>
                                                                LoginPage(),
                                                          ));
                                                    }else{
                                                      pr.hide();
                                                    }
                                                  }else{
                                                    print("not");
                                                  }
                                                }else {
                                                  //  print("not");
                                                  setState(() {
                                                    _autotvalidate = true;
                                                  });
                                                }
                                              }
                                            },
                                            elevation: 2.0,
                                            color: HexColor.fromHex("#00004d"),
                                            textColor: Colors.white,
                                            child: new Text("Sign Up",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 2.3 *
                                                  SizeConfig.textMultiplier),)),
                                      ),
                                      new Padding(
                                          padding: EdgeInsets.only(bottom: 2 *
                                              SizeConfig.heightMultiplier))
                                    ],
                                  )),
                            ),
                          ),
                        ),),
                      new Padding(
                          padding: EdgeInsets.only(bottom: 2 *
                              SizeConfig.heightMultiplier))
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }

  Future<void> confirm(String password) async {
    String cnfpassword="";
    await Alert(
      context: context,
      type: AlertType.warning,
      style: AlertStyle(
          animationType: AnimationType.fromTop,
          isCloseButton: false,

          isOverlayTapDismiss: false,
          descStyle: TextStyle(fontWeight: FontWeight.bold),
          animationDuration: Duration(milliseconds: 400),
          titleStyle: TextStyle(
              color: Color(0xff00004d)
          ),
          alertBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: Colors.grey,
            ),
          )
      ),
      title: "Confirm Password",
      content: Padding(
        padding:  EdgeInsets.only(top:2*SizeConfig.heightMultiplier),
        child: Container(
          child:Form(
            key: confirmkey,
            //autovalidate: confirmvalidate,
            child: new TextFormField(
                autovalidate: confirmvalidate,
                focusNode: focusNode9,
                cursorColor: Color(0xffb3b300),
                style: TextStyle(
                    fontFamily: 'BalooChettan2',
                    fontWeight: FontWeight.bold,
                    color: Color(0xffb3b300),
                    fontSize: 2.5 * SizeConfig
                        .textMultiplier),
                decoration: new InputDecoration(
                    suffixIcon: Icon(
                      Icons.lock, size: 20,
                      color: Colors.black54,),
                    contentPadding: EdgeInsets
                        .only(
                        left: 5.2 * SizeConfig
                            .widthMultiplier,
                        right: 5.2 * SizeConfig
                            .widthMultiplier),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius
                          .all(
                          Radius.circular(10)),
                      borderSide: BorderSide(
                          width: 1,
                          color: Color(0xffb3b300)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius
                          .all(
                          Radius.circular(10)),
                      borderSide: BorderSide(
                          width: 1,
                          color: Color(0xffb3b300)),
                    ),
                    border: OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(
                            10.00)),
                    labelText: "Enter Password",
                    labelStyle: TextStyle(
                        fontWeight: FontWeight
                            .bold,
                        color: Color(0xffb3b300),
                        fontSize: 2.5 *
                            SizeConfig
                                .textMultiplier)),
                keyboardType: TextInputType
                    .text,
                obscureText: true,
                validator: validatecnf,
                onChanged: (val) {
                  setState(() =>
                  cnfpassword = val);
                }),
          ),

        ),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "Confirm",
            style: TextStyle(color: Colors.white, fontSize: 2.5*SizeConfig.textMultiplier),
          ),
          // ignore: missing_return
          onPressed: () {
            if(confirmkey.currentState.validate()){
              if(cnfpassword==password) {
                Navigator.pop(context);
                setState(() {
                  cnfpass = true;
                });
                return true;
              }else{
                return false;
              }
            }else{
              setState(() {
                confirmvalidate=true;
                // print("sdfv");
              });
            }
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 2.5*SizeConfig.textMultiplier),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: [
            Color(0xffe63900),
            Color(0xffe63900)
          ]),
        )
      ],
    ).show();
  }

  var gridView = SizedBox(child: new SpinKitFadingCircle(
    color: Color(0xff00004d),
    size: 40.0,
    // controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
  ));

  showLoaderDialog(BuildContext context) {
    AlertDialog alert =
    AlertDialog(
      content: Container(
        width: 50,
        height: 50,
        child: new Row(
          children: [
            gridView,
            Container(
                margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
          ],),
      ),
    );
    showDialog(barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<int> signUp(String email, String password) async {
    try {
      AuthResult result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      assert(user != null);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await auth.currentUser();
      assert(user.uid == currentUser.uid);
    }
    catch (e) {
      if (e is PlatformException) {
        if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          /// `foo#bar.com` has alread been registered.
          //de();
          Fluttertoast.showToast(
              msg: "Email already in use",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
          return 0;
        }
      }
    }
    return 1;
  } //Firebase Sign in

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty || !regex.hasMatch(value) || value.length < 9)
      return 'Invalid Email';
    else
      return null;
  }

  String validatetEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(mescoepune\.org))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty || !regex.hasMatch(value) || value.length < 9)
      return 'Invalid Email';
    else
      return null;
  }

//String validatePRN
  String validatePassword(String value) {
    if (value
        .trim()
        .isEmpty) {
      return 'Password cannot be empty';
    } else if (value.length < 6) {
      return 'Password too short';
    }
    return null;
  }
  String validatecnf(String value) {
    String pass="";
    // print("fdg");
    if(isSwitched){
      pass=_bpassword;
    }else{
      pass=_fpassword;
    }
    if (value
        .trim()
        .isEmpty || value!=pass) {
      return 'Password doesn\'t match';
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

  String validatename(String value) {
    if (value.isEmpty)
      return "good name please!!";
    else
      return null;
  }

  String validatebatch(String value) {
    RegExp re = RegExp(r'^[p-rP-R]+$');
    if (value.isEmpty || !re.hasMatch(value) || value.length < 1)
      return "invalid Batch";
    else
      return null;
  }

  String validatePRN(String value) {
    RegExp re = RegExp(r'^F|S[0-9]+$');
    if (value.isEmpty || !re.hasMatch(value) || value.length < 9)
      return "invalid PRN";

    else
      return null;
  }
}