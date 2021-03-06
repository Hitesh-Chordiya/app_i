////import 'package:firebase_database/firebase_database.dart';
////import 'package:firebase_messaging/firebase_messaging.dart';
////import 'package:flutter/cupertino.dart';
////import 'package:flutter/material.dart';
////import 'package:firebase_auth/firebase_auth.dart';
////import 'package:flutter/services.dart';
////import 'package:flutter_app/pages/Signup.dart';
////import 'package:flutter_app/pages/Student.dart';
////import 'package:flutter_app/pages/TeacherHome.dart';
////import 'package:flutter_app/pages/demo.dart';
////
//////import 'package:flutter_app/pages/parentinfo.dart';
////import 'package:flutter_app/responsive/Screensize.dart';
////import 'package:fluttertoast/fluttertoast.dart';
////import 'package:intl/intl.dart';
////import 'package:page_transition/page_transition.dart';
////import 'package:progress_dialog/progress_dialog.dart';
////import 'package:shared_preferences/shared_preferences.dart';
////import 'AttendanceData.dart';
////import 'demo.dart';
////import 'forgotpassword.dart';
////
////class LoginPage extends StatefulWidget {
////  @override
////  _LoginPageState createState() => _LoginPageState();
////}
////
////class _LoginPageState extends State<LoginPage>
////    with SingleTickerProviderStateMixin {
////  final scaffoldKey = new GlobalKey<ScaffoldState>();
////  final formKey = new GlobalKey<FormState>();
////  Color comp = Color(0xff898989),
////      mech = Color(0xff898989),
////      entc = Color(0xff898989);
////  String dept = "";
////  bool checktype,pressed=false;
////  static int snacktime = 0;
////  final FirebaseAuth auth = FirebaseAuth.instance;
////  FocusNode focusNode1 = new FocusNode();
////  FocusNode focusNode2 = new FocusNode();
////  String _email;
////  final checkemail = FirebaseDatabase.instance.reference();
////  String _password;
////  bool _autovalidate = false;
////  Map data;
////  final successSnackBar = new SnackBar(
////    duration: Duration(days: 1),
////    shape:
////    RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.00)),
////    backgroundColor: HexColor.fromHex("#00004d"),
////    elevation: 2.0,
////    content: new Row(
////      children: <Widget>[
////        new CircularProgressIndicator(
////          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
////        ),
////        new Padding(padding: EdgeInsets.only(left: 5.0)),
////        new Text("Logging in ",
////            textAlign: TextAlign.center,
////            style: TextStyle(
////                fontFamily: 'BalooChettan2',
////                color: Colors.white,
////                fontSize: 3 * SizeConfig.textMultiplier))
////      ],
////    ),
////  );
////  final successSnackBar1 = new SnackBar(
////    duration: Duration(days: 1),
////    shape:
////    RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.00)),
////    backgroundColor: HexColor.fromHex("#00004d"),
////    elevation: 2.0,
////    content: new Row(
////      children: <Widget>[
////        new CircularProgressIndicator(
////          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
////        ),
////        new Padding(padding: EdgeInsets.only(left: 5.0)),
////        new Text("Logging in ",
////            textAlign: TextAlign.center,
////            style: TextStyle(
////                fontFamily: 'BalooChettan2',
////                color: Colors.white,
////                fontSize: 3 * SizeConfig.textMultiplier))
////      ],
////    ),
////  );
////  final errSnackBar = new SnackBar(
////      backgroundColor: HexColor.fromHex(" #ff4d4d"),
////      content: new Text("Login Failed",
////          style: TextStyle(
////              fontFamily: 'BalooChettan2',
////              color: Colors.white,
////              fontSize: 20.00)));
////  final incorrectPSnackBar = new SnackBar(
////      duration: Duration(milliseconds: 1000),
////      shape:
////      RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.00)),
////      backgroundColor: HexColor.fromHex(" #ff4d4d"),
////      elevation: 2.0,
////      content: new Text("Incorrect Password",
////          style: TextStyle(
////              fontFamily: 'BalooChettan2',
////              color: Colors.white,
////              fontSize: 20.00)));
////  final noUserSnackBar = new SnackBar(
////      duration: Duration(milliseconds: 1000),
////      shape:
////      RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.00)),
////      elevation: 2.0,
////      backgroundColor: Colors.red,
////      content: new Text("User not Found",
////          style: TextStyle(
////              fontFamily: 'BalooChettan2',
////              color: Colors.white,
////              fontSize: 20.00)));
////
////  @override
////  void initState() {
////    super.initState();
////  }
////
////  @override
////  Widget build(BuildContext context) {
////    int grp = SizeConfig.grp;
////    return new Scaffold(
////        resizeToAvoidBottomInset: true,
////        resizeToAvoidBottomPadding: true,
////        key: scaffoldKey,
////        backgroundColor: Colors.white,
////        body: SingleChildScrollView(
////          child: new Container(
////            decoration: new BoxDecoration(
////                borderRadius: new BorderRadius.circular(10.00),
////                gradient: LinearGradient(
////                    begin: Alignment.topCenter,
////                    end: Alignment.bottomCenter,
////                    tileMode: TileMode.clamp,
////                    colors: [
////                      HexColor.fromHex("#000000"),
////                      HexColor.fromHex(" #ff4d4d")
////                    ])),
////            child: new Stack(
////              children: <Widget>[
////                new Column(
////                  crossAxisAlignment: CrossAxisAlignment.center,
////                  //   mainAxisSize: MainAxisSize.max,
////                  mainAxisAlignment: MainAxisAlignment.center,
////                  children: <Widget>[
////                    Padding(
////                      padding: grp == 1
////                          ? EdgeInsets.only(
////                          top: 0 * SizeConfig.heightMultiplier,
////                          bottom: 0.4 * SizeConfig.heightMultiplier)
////                          : grp == 2
////                          ? EdgeInsets.only(
////                          top: 0.5 * SizeConfig.heightMultiplier,
////                          bottom: 0.5 * SizeConfig.heightMultiplier)
////                          : grp == 3
////                          ? EdgeInsets.only(
////                          top: 1 * SizeConfig.heightMultiplier,
////                          bottom: 1 * SizeConfig.heightMultiplier)
////                          : grp == 4
////                          ? EdgeInsets.only(
////                          top: 2 * SizeConfig.heightMultiplier,
////                          bottom:
////                          1 * SizeConfig.heightMultiplier)
////                          : grp == 5
////                          ? EdgeInsets.only(
////                          top: 6 *
////                              SizeConfig.heightMultiplier,
////                          bottom: 1 *
////                              SizeConfig.heightMultiplier)
////                          : EdgeInsets.only(
////                          top: 8 *
////                              SizeConfig.heightMultiplier,
////                          bottom: 1 *
////                              SizeConfig.heightMultiplier),
////                      child: new Image(
////                        image: new AssetImage("assets/college_logo.png"),
////                        alignment: Alignment.topCenter,
////                        height: 28 * SizeConfig.heightMultiplier,
////                        width: 42 * SizeConfig.widthMultiplier,
////                      ),
////                    ),
////                    new Card(
////                      margin: new EdgeInsets.symmetric(
////                          horizontal: 6 * SizeConfig.widthMultiplier,
////                          vertical: 3 * SizeConfig.heightMultiplier),
////                      elevation: 10.0,
////                      color: Colors.white,
////                      shape: RoundedRectangleBorder(
////                        borderRadius: BorderRadius.circular(10.0),
////                      ),
////                      child: Container(
////                        child: new Form(
////                          key: formKey,
////                          autovalidate: _autovalidate,
////                          child: new Theme(
////                              data: new ThemeData(
////                                  brightness: Brightness.light,
////                                  primarySwatch: Colors.blue,
////                                  inputDecorationTheme:
////                                  new InputDecorationTheme(
////                                      labelStyle: new TextStyle(
////                                          color: Colors.blue,
////                                          fontSize: 2 *
////                                              SizeConfig.textMultiplier))),
////                              child: new Column(
////                                crossAxisAlignment: CrossAxisAlignment.center,
////                                mainAxisAlignment: MainAxisAlignment.center,
////                                children: <Widget>[
////                                  Padding(
////                                    padding: EdgeInsets.only(
////                                        top: 2 * SizeConfig.heightMultiplier,
////                                        bottom:
////                                        1 * SizeConfig.heightMultiplier),
////                                    child: new Text(
////                                      "LOGIN",
////                                      style: TextStyle(
////                                        // fontStyle: FontStyle.italic,
////                                        color: HexColor.fromHex("#00004d"),
////                                        fontSize:
////                                        3.4 * SizeConfig.heightMultiplier,
////                                        fontWeight: FontWeight.bold,
////                                        decoration: TextDecoration.underline,
////                                      ),
////                                    ),
////                                  ),
////                                  Row(
////                                    mainAxisAlignment: MainAxisAlignment.center,
////                                    crossAxisAlignment:
////                                    CrossAxisAlignment.center,
////                                    children: <Widget>[
////                                      Text(
////                                        "Department:",
////                                        style: TextStyle(
////                                          color: HexColor.fromHex("#800000"),
////                                          fontSize:
////                                          2.5 * SizeConfig.heightMultiplier,
////                                          fontWeight: FontWeight.bold,
////                                        ),
////                                      ),
////                                      new Padding(
////                                          padding: EdgeInsets.only(
////                                              left: 2 *
////                                                  SizeConfig.widthMultiplier)),
////                                      IconButton(
////                                        icon: Icon(Icons.settings, color: mech),
////                                        onPressed: () {
////                                          setState(() {
////                                            mech = Color(0xff00004d);
////                                            dept = "MECH";
////                                            comp = Color(0xff898989);
////                                            entc = Color(0xff898989);
////                                          });
////                                        },
////                                      ),
////                                      new Padding(
////                                          padding: EdgeInsets.only(
////                                              left: 2 *
////                                                  SizeConfig.widthMultiplier)),
////                                      IconButton(
////                                          icon: Icon(Icons.laptop_mac,
////                                              color: comp),
////                                          onPressed: () {
////                                            setState(() {
////                                              comp = Color(0xff00004d);
////                                              mech = Color(0xff898989);
////                                              entc = Color(0xff898989);
////                                              dept = "COMP";
////                                            });
////                                          }),
////                                      new Padding(
////                                          padding: EdgeInsets.only(
////                                              left: 2 *
////                                                  SizeConfig.widthMultiplier)),
////                                      IconButton(
////                                          icon: Icon(Icons.tap_and_play,
////                                              color: entc),
////                                          onPressed: () {
////                                            setState(() {
////                                              entc = Color(0xff00004d);
////                                              dept = "ENTC";
////                                              comp = Color(0xff898989);
////                                              mech = Color(0xff898989);
////                                            });
////                                          }),
////                                    ],
////                                  ),
////                                  new Padding(
////                                      padding: EdgeInsets.symmetric(
////                                          vertical: SizeConfig.heightMultiplier,
////                                          horizontal:
////                                          2 * SizeConfig.widthMultiplier)),
////                                  Padding(
////                                    padding: EdgeInsets.only(
////                                        left: 5 * SizeConfig.widthMultiplier,
////                                        right: 5 * SizeConfig.widthMultiplier),
////                                    child: new Column(
////                                      children: <Widget>[
////                                        new TextFormField(
////                                            focusNode: focusNode1,
////                                            enableSuggestions: true,
////                                            style: TextStyle(
////                                                fontFamily: 'BalooChettan2',
////                                                color:
////                                                HexColor.fromHex("#00004d"),
////                                                fontWeight: FontWeight.bold,
////                                                fontSize: 2.2 *
////                                                    SizeConfig
////                                                        .heightMultiplier),
////                                            cursorColor:
////                                            HexColor.fromHex("#00004d"),
////                                            decoration: new InputDecoration(
////                                                focusedBorder:
////                                                OutlineInputBorder(
////                                                  borderRadius:
////                                                  BorderRadius.all(
////                                                      Radius.circular(10)),
////                                                  borderSide: BorderSide(
////                                                      width: 1,
////                                                      color: HexColor.fromHex(
////                                                          "#800000")),
////                                                ),
////                                                suffixIcon: Icon(
////                                                  Icons.person,
////                                                  size: 2.5 *
////                                                      SizeConfig
////                                                          .heightMultiplier,
////                                                  color: Colors.black54,
////                                                ),
////                                                contentPadding: EdgeInsets.only(
////                                                    left: 5 *
////                                                        SizeConfig
////                                                            .widthMultiplier,
////                                                    right: 5 *
////                                                        SizeConfig
////                                                            .widthMultiplier),
////                                                border: OutlineInputBorder(
////                                                    borderRadius:
////                                                    BorderRadius.circular(
////                                                        10.00)),
////                                                labelText: "Enter Username",
////                                                // hintText: "username",
////                                                labelStyle: new TextStyle(
////                                                    fontWeight: FontWeight.bold,
////                                                    color: HexColor.fromHex(
////                                                        "#800000"),
////                                                    fontSize: 2.2 *
////                                                        SizeConfig
////                                                            .textMultiplier)),
////                                            keyboardType:
////                                            TextInputType.emailAddress,
////                                            validator: validateEmail,
////                                            onSaved: (val) {
////                                              setState(() => _email = val);
////                                            }),
////                                        new Padding(
////                                            padding: EdgeInsets.symmetric(
////                                                horizontal: 4 *
////                                                    SizeConfig.widthMultiplier,
////                                                vertical: 2 *
////                                                    SizeConfig
////                                                        .heightMultiplier)),
////                                        new TextFormField(
////                                            focusNode: focusNode2,
////                                            style: TextStyle(
////                                                fontFamily: 'BalooChettan2',
////                                                color:
////                                                HexColor.fromHex("#00004d"),
////                                                fontWeight: FontWeight.bold,
////                                                fontSize: 2.2 *
////                                                    SizeConfig
////                                                        .heightMultiplier),
////                                            cursorColor:
////                                            HexColor.fromHex("#00004d"),
////                                            decoration: new InputDecoration(
////                                                focusedBorder:
////                                                OutlineInputBorder(
////                                                  borderRadius:
////                                                  BorderRadius.all(
////                                                      Radius.circular(10)),
////                                                  borderSide: BorderSide(
////                                                      width: 1,
////                                                      color: HexColor.fromHex(
////                                                          "#800000")),
////                                                ),
////                                                suffixIcon: Icon(
////                                                  Icons.lock,
////                                                  size: 2.5 *
////                                                      SizeConfig
////                                                          .heightMultiplier,
////                                                  color: Colors.black54,
////                                                ),
////                                                contentPadding: EdgeInsets.only(
////                                                    left: 5 *
////                                                        SizeConfig
////                                                            .widthMultiplier,
////                                                    right: 5 *
////                                                        SizeConfig
////                                                            .widthMultiplier),
////                                                border: OutlineInputBorder(
////                                                    borderRadius:
////                                                    BorderRadius.circular(
////                                                        10.00)),
////                                                labelText: "Enter Password",
////                                                labelStyle: TextStyle(
////                                                    fontWeight: FontWeight.bold,
////                                                    color: HexColor.fromHex(
////                                                        "#800000"),
////                                                    fontSize: 2.2 *
////                                                        SizeConfig
////                                                            .heightMultiplier)),
////                                            keyboardType: TextInputType.text,
////                                            validator: validatePassword,
////                                            obscureText: true,
////                                            onSaved: (val) {
////                                              setState(() => _password = val);
////                                            }),
////                                      ],
////                                    ),
////                                  ),
////                                  new Padding(
////                                      padding: EdgeInsets.only(
////                                          top:
////                                          4 * SizeConfig.heightMultiplier)),
////                                  new SizedBox(
////                                    width: 25 * SizeConfig.widthMultiplier,
////                                    height: 5 * SizeConfig.heightMultiplier,
////                                    child: RaisedButton(
////                                        shape: new RoundedRectangleBorder(
////                                            borderRadius:
////                                            BorderRadius.circular(80.00)),
////                                        splashColor:
////                                        HexColor.fromHex("#ffffff"),
////                                        onPressed: pressed?null:() async {
////                                          bool show=false;
////                                          ProgressDialog pr = new ProgressDialog(context);
////                                          pr.style(
////                                              message: "wait");
////                                          //fun(context);
////                                          setState(() {
////                                            pressed=true;
////                                          });
////                                          Map map;
////                                          String prn;
////                                          if (formKey.currentState.validate()) {
////                                            formKey.currentState.save();
////                                            try {
////                                              pr.show();
////                                              if (!checktype) {
////
////                                                _email = _email.toLowerCase();
////                                              } else {
////
////                                                _email = _email.toUpperCase();
////                                                await checkemail
////                                                    .child("Registration")
////                                                    .child("Student")
////                                                    .child(dept)
////                                                    .child(_email)
////                                                    .once()
////                                                    .then((onValue) {
////                                                  if (onValue.value == null){
////                                                    throw Exception;
////                                                  }
////                                                  map = onValue.value;
////                                                  prn = _email;
////                                                  _email = map["Email"];
////                                                });
////                                              }
////                                              setState(() {
////                                                show=true;
////                                              });
////                                              signIn(_email, _password)
////                                                  .then((user) async {
////                                                SharedPreferences prefs =
////                                                await SharedPreferences
////                                                    .getInstance();
////                                                prefs.clear();
////                                                //var e;
////                                                if (user != null) {
////                                                  String uemail = _email;
////                                                  prefs.setString(
////                                                      'email', uemail);
////                                                  if (!checktype) {
////                                                    try {
////                                                      var e = _email.split("@");
////                                                      String b = e[0]
////                                                          .toString()
////                                                          .replaceAll(
////                                                          new RegExp(r'\W'),
////                                                          "_")
////                                                          .toLowerCase();
////                                                      Map map;
////                                                      await checkemail
////                                                          .child("Registration")
////                                                          .child(
////                                                          'Teacher_account')
////                                                          .child(b.toString())
////                                                          .once()
////                                                          .then((snap) async {
////                                                        map = snap.value;
////                                                        if (map == null) {
////                                                          throw Exception;
////                                                        }
////
////                                                        prefs.setString("name",
////                                                            map["Name"]);
////                                                        Dateinfo.teachname =
////                                                            map["Name"]
////                                                                .toString();
////                                                        prefs.setString("dept",
////                                                            map["Department"]);
////                                                        Dateinfo.dept =
////                                                            map["Department"]
////                                                                .toString();
////                                                        Dateinfo.teachemail =
////                                                            uemail;
////                                                        var e = Dateinfo
////                                                            .teachemail
////                                                            .split("@");
////                                                        Dateinfo.email = e[0]
////                                                            .toString()
////                                                            .replaceAll(
////                                                            new RegExp(
////                                                                r'\W'),
////                                                            "_");
////                                                        Map days;
////                                                        prefs.setBool(
////                                                            'login', true);
////
////                                                        prefs.setBool(
////                                                            "check", false);
////                                                        if (map.containsKey(
////                                                            "Admin")) {
////                                                          prefs.setString(
////                                                              "type", "admin");
////                                                        } else {
////                                                          prefs.setString(
////                                                              "type",
////                                                              "teacher");
////                                                        }
////                                                        checkemail
////                                                            .child(
////                                                            "Registration")
////                                                            .child(
////                                                            'Teacher_account')
////                                                            .child(
////                                                            Dateinfo.email)
////                                                            .child("slot")
////                                                            .once()
////                                                            .then((snapshot) {
////                                                          try {
////                                                            Map data =
////                                                                snapshot.value;
////                                                            if (data == null) {
////                                                              throw Exception;
////                                                            }
////                                                            List<String> slot =
////                                                            new List<
////                                                                String>();
////                                                            for (final key
////                                                            in data.keys) {
////                                                              slot.add(
////                                                                  key.toString() +
////                                                                      "h");
////                                                            }
////                                                            prefs.setStringList(
////                                                                "slot", slot);
////                                                          } catch (Exception) {
////                                                            List<String> slot =
////                                                            new List<
////                                                                String>();
////                                                            prefs.setStringList(
////                                                                "slot", slot);
////                                                          }
////                                                        });
////
////                                                        checkemail
////                                                            .child(
////                                                            "Registration")
////                                                            .child(
////                                                            'Teacher_account')
////                                                            .child(
////                                                            Dateinfo.email)
////                                                            .child("work_hr")
////                                                            .once()
////                                                            .then((snapshot) {
////                                                          try {
////                                                            Map data =
////                                                                snapshot.value;
////                                                            if (data == null)
////                                                              throw Exception;
////                                                            else {
////                                                              prefs.setString(
////                                                                  "today_date",
////                                                                  data["date"]);
////                                                              // print(prefs.getString("today_date"));
////                                                              prefs.setInt(
////                                                                  "week_no",
////                                                                  data[
////                                                                  "weekno"]);
////
////                                                              prefs.setInt(
////                                                                  "dayc",
////                                                                  data["dayc"]);
////
////                                                              prefs.setInt(
////                                                                  "weekc",
////                                                                  data[
////                                                                  "weekc"]);
////                                                            }
////                                                          } catch (Exception) {
////                                                            print("work");
////                                                            var now =
////                                                            new DateTime
////                                                                .now();
////                                                            var ford =
////                                                            new DateFormat(
////                                                                "yyyy_MM_dd");
////
////                                                            String date = ford
////                                                                .format(now);
////
////                                                            int current =
////                                                                DateTime.utc(
////                                                                    now.year,
////                                                                    now.month,
////                                                                    1)
////                                                                    .weekday;
////                                                            int weekno = 0;
////                                                            int i = 9 - current;
////                                                            for (;
////                                                            i < 30;
////                                                            i += 7) {
////                                                              weekno += 1;
////                                                              if (now.day < i) {
////                                                                break;
////                                                              }
////                                                            }
////                                                            prefs.setString(
////                                                                "today_date",
////                                                                date);
////                                                            prefs.setInt(
////                                                                "dayc", 0);
////                                                            prefs.setInt(
////                                                                "week_no",
////                                                                weekno);
////                                                            prefs.setInt(
////                                                                "weekc", 0);
////                                                          }
////
////                                                          //  checkemail.child("")
////                                                        });
////                                                        try {
////                                                          checkemail
////                                                              .child("cdate")
////                                                              .once()
////                                                              .then((val) {
////                                                            if (val.value ==
////                                                                null)
////                                                              throw Exception;
////
////                                                            prefs.setString(
////                                                                "cdate",
////                                                                val.value
////                                                                    .toString());
////                                                          });
////                                                        } catch (Exception) {}
////                                                        await Teacher.data();
////                                                      });
////                                                      setState(() {
////                                                        show=false;
////                                                      });
////                                                      //  await Future.delayed(Duration(seconds: 3));
////                                                      Navigator.pushReplacement(
////                                                          context,
////                                                          PageTransition(
////                                                              type:
////                                                              PageTransitionType
////                                                                  .fade,
////                                                              duration:
////                                                              Duration(
////                                                                  seconds:
////                                                                  2),
////                                                              child: thome()));
////                                                    } catch (Exception) {
////                                                      pr.hide();
////                                                      Fluttertoast.showToast(
////                                                        msg: "No data Found",
////                                                        toastLength: Toast
////                                                            .LENGTH_SHORT,
////                                                        gravity: ToastGravity
////                                                            .BOTTOM,
////                                                        backgroundColor:
////                                                        Colors.red,
////                                                        textColor:
////                                                        Colors.white,
////                                                        fontSize: 16.0);}
////                                                  } else {
////                                                    try {
////                                                      prefs.setString(
////                                                          "type", "student");
////                                                      if (dept.isEmpty) {
////                                                        pr.hide();
////                                                        Fluttertoast.showToast(
////                                                            msg:
////                                                            "Select Department",
////                                                            toastLength: Toast
////                                                                .LENGTH_SHORT,
////                                                            gravity:
////                                                            ToastGravity
////                                                                .BOTTOM,
////                                                            backgroundColor:
////                                                            Colors.red,
////                                                            textColor:
////                                                            Colors.white,
////                                                            fontSize: 16.0);
////                                                      } else {
////                                                        await checkemail
////                                                            .child(
////                                                            "Registration")
////                                                            .child('Student')
////                                                            .child(dept)
////                                                            .child(prn)
////                                                            .once()
////                                                            .then((snap) async {
////                                                          map = snap.value;
////                                                          if (map == null)
////                                                            throw Exception;
//////                                                          print(map);
////                                                          //    await Future.delayed(Duration(seconds: 5));
////                                                          Studinfo.name =
////                                                          map["Name"];
////                                                          Studinfo.roll =
////                                                          map["Prn"];
////                                                          prefs.setString(
////                                                              "name",
////                                                              map["Name"]);
////                                                          prefs.setString(
////                                                              "branch", dept);
////                                                          Studinfo.branch =
////                                                              dept;
////                                                          Studinfo.classs =
////                                                          map["Class"];
////                                                          Studinfo.batch =
////                                                          map["Batch"];
////                                                          try {
////                                                            prefs.setString(
////                                                                "text",
////                                                                map["text"]);
////                                                          } catch (Exception) {
////                                                            prefs.setString(
////                                                                "text", "");
////                                                          }
////                                                          prefs.setBool(
////                                                              'login', true);
////
////                                                          // prefs.setString("roll", map["Serial"]);
////                                                          prefs.setString(
////                                                              "class",
////                                                              map["Class"]);
////                                                          prefs.setString(
////                                                              "batch",
////                                                              map["Batch"]);
//////                                                        prefs.setString(
//////                                                            "text", " ");
////                                                          prefs.setString(
////                                                              "roll",
////                                                              map["Prn"]);
////                                                          Studinfo.email =
////                                                              uemail;
////                                                          print(Studinfo.email +
////                                                              " email");
////                                                          prefs.setInt(
////                                                              "fetchatt", 1);
////                                                        });
////                                                        if (map.containsKey(
////                                                            "Parent")) {
////                                                          Studinfo.parentname =
////                                                          map["Parent"];
////                                                          prefs.setString(
////                                                              "parent",
////                                                              map["Parent"]);
////                                                        }
////                                                        await FirebaseDatabase
////                                                            .instance
////                                                            .reference()
////                                                            .child("defaulter")
////                                                            .child("modified")
////                                                            .child(
////                                                            Studinfo.roll)
////                                                            .once()
////                                                            .then((onValue) {
////                                                          if (onValue.value ==
////                                                              -1)
////                                                            throw Exception;
////                                                        });
////                                                        final FirebaseMessaging
////                                                        firebaseMessaging =
////                                                        FirebaseMessaging();
////                                                        firebaseMessaging
////                                                            .subscribeToTopic(
////                                                            Studinfo.roll);
////
////                                                        try {
////                                                          await Attendance
////                                                              .owndata();
////                                                          FirebaseDatabase
////                                                              .instance
////                                                              .reference()
////                                                              .child(
////                                                              "defaulter")
////                                                              .child("modified")
////                                                              .child(
////                                                              Studinfo.roll)
////                                                              .set(0);
////                                                        } catch (Exception) {
////                                                          pr.hide();
////                                                        }
////      pr.hide();
////      pr.hide();
////                                                        Navigator.pushReplacement(
////                                                            context,
////                                                            PageTransition(
////                                                                type:
////                                                                PageTransitionType
////                                                                    .fade,
////                                                                duration:
////                                                                Duration(
////                                                                    seconds:
////                                                                    2),
////                                                                child:
////                                                                shome()));
////                                                      }
////                                                    } catch (Exception) {
//////                                                      print(Exception);
////                                                    pr.hide();
////                                                      Fluttertoast.showToast(
////                                                          msg: "No data Found",
////                                                          toastLength: Toast
////                                                              .LENGTH_SHORT,
////                                                          gravity: ToastGravity
////                                                              .BOTTOM,
////                                                          backgroundColor:
////                                                          Colors.red,
////                                                          textColor:
////                                                          Colors.white,
////                                                          fontSize: 16.0);
////                                                    }
////                                                  }
////                                                } else {
////                                                  pr.hide();
////                                                  scaffoldKey.currentState
////                                                      .showSnackBar(
////                                                      errSnackBar);
////                                                }
////                                              });
////                                            } catch (Exception) {
////                                              pr.hide();
////                                              Fluttertoast.showToast(
////                                                  msg: "No data Found",
////                                                  toastLength:
////                                                  Toast.LENGTH_SHORT,
////                                                  gravity: ToastGravity.BOTTOM,
////                                                  backgroundColor: Colors.red,
////                                                  textColor: Colors.white,
////                                                  fontSize: 16.0);
////                                            }
////                                          } else {
////                                            setState(() {
////                                              _autovalidate = true;
////                                            });
////                                          }
////
////                                          setState(() {
////                                            pressed=false;
////                                          });
////                                          FocusScope.of(context)
////                                              .requestFocus(new FocusNode());
////                                        },
////                                        elevation: 2.0,
////                                        color: HexColor.fromHex("#00004d"),
////                                        textColor: Colors.white,
////                                        child: new Text(
////                                          "Sign In",
////                                          textAlign: TextAlign.center,
////                                          style: TextStyle(
////                                              fontSize: 2 *
////                                                  SizeConfig.textMultiplier),
////                                        )),
////                                  ),
////                                  new Padding(
////                                      padding: EdgeInsets.only(
////                                          bottom:
////                                          2 * SizeConfig.heightMultiplier))
////                                ],
////                              )),
////                        ),
////                      ),
////                    ),
////                    //new Padding(padding: EdgeInsets.only(top:2.5*SizeConfig.heightMultiplier)),
////                    Column(
////                      children: <Widget>[
////                        new MaterialButton(
////                          onPressed: () => {
////                            FocusScope.of(context)
////                                .requestFocus(new FocusNode()),
////                            fun(context),
////                          },
////                          shape: new RoundedRectangleBorder(
////                              borderRadius: BorderRadius.circular(50.00)),
////                          child: new Text("Forgot Password?",
////                              style: TextStyle(
////                                  fontFamily: 'BalooChettan2',
////                                  color: HexColor.fromHex("#00004d"),
////                                  fontSize: 2.8 * SizeConfig.textMultiplier,
////                                  fontWeight: FontWeight.bold)),
////                        ),
////                        new MaterialButton(
////                          onPressed: () => {
////                            FocusScope.of(context)
////                                .requestFocus(new FocusNode()),
////                            Navigator.pushReplacement(
////                                context,
////                                PageTransition(
////                                    type:
////                                    PageTransitionType.rightToLeftWithFade,
////                                    duration: Duration(seconds: 1),
////                                    child: Signup()))
////                          },
////                          shape: new RoundedRectangleBorder(
////                              borderRadius: BorderRadius.circular(50.00)),
////                          child: new Text("Create account",
////                              style: TextStyle(
////                                  fontFamily: 'BalooChettan2',
////                                  color: HexColor.fromHex("#00004d"),
////                                  fontSize: 2.8 * SizeConfig.textMultiplier,
////                                  fontWeight: FontWeight.bold)),
////                        )
////                      ],
////                    ),
////                    //Forgot password button
////
////                    //Forgot password button
////                  ],
////                )
////              ],
////            ),
////          ),
////        ));
////  }
////
////  Future<FirebaseUser> signIn(String email, String password) async {
////    try {
////      AuthResult result = await auth.signInWithEmailAndPassword(
////          email: email, password: password);
////      FirebaseUser user = result.user;
//////      if(user.isEmailVerified){
////      if (true) {
////        assert(user != null);
////        assert(await user.getIdToken() != null);
////
////        final FirebaseUser currentUser = await auth.currentUser();
////        assert(user.uid == currentUser.uid);
////        return user;
////      } else {
////        Fluttertoast.showToast(
////            msg: "Verify your email first",
////            toastLength: Toast.LENGTH_SHORT,
////            gravity: ToastGravity.BOTTOM,
////            backgroundColor: Colors.red,
////            textColor: Colors.white,
////            fontSize: 16.0);
////      }
////    } catch (e) {
////      handleError(e);
////      return null;
////    }
////  } //Firebase Sign in
////
////  String validateEmail(String value) {
////    Pattern pattern =
////        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(mescoepune\.org))$';
////    RegExp regex = new RegExp(pattern);
////    if (value.isEmpty || !regex.hasMatch(value)) {
////      RegExp re = RegExp(r'^F|S[0-9]+$');
////      if (value.isEmpty || !re.hasMatch(value) || value.length < 9)
////        return "invalid username";
////      else {
////        setState(() {
////          snacktime = 4500;
////        });
////        checktype = true;
////        return null;
////      }
////    } else {
////      setState(() {
////        snacktime = 2500;
////      });
////      checktype = false;
////      return null;
////    }
////  }
////
////  String validatePassword(String value) {
////    if (value.trim().isEmpty) {
////      return 'Password cannot be empty';
////    } else if (value.length < 6) {
////      return 'Password too short';
////    }
////    return null;
////  }
////
////  handleError(PlatformException error) {
////    switch (error.code) {
////      case 'ERROR_USER_NOT_FOUND':
////        setState(() {
////          scaffoldKey.currentState.showSnackBar(noUserSnackBar);
////        });
////        break;
////      case 'ERROR_WRONG_PASSWORD':
////        setState(() {
////          scaffoldKey.currentState.showSnackBar(incorrectPSnackBar);
////        });
////        break;
////    }
////  } //Sign in Error handling
////}
//import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/services.dart';
//import 'package:flutter_app/pages/Signup.dart';
//import 'package:flutter_app/pages/Student.dart';
//import 'package:flutter_app/pages/TeacherHome.dart';
//import 'package:flutter_app/pages/demo.dart';
//
////import 'package:flutter_app/pages/parentinfo.dart';
//import 'package:flutter_app/responsive/Screensize.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:intl/intl.dart';
//import 'package:page_transition/page_transition.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'AttendanceData.dart';
//import 'demo.dart';
//import 'forgotpassword.dart';
//
//class LoginPage extends StatefulWidget {
//  @override
//  _LoginPageState createState() => _LoginPageState();
//}
//
//class _LoginPageState extends State<LoginPage>
//    with SingleTickerProviderStateMixin {
//  final scaffoldKey = new GlobalKey<ScaffoldState>();
//  final formKey = new GlobalKey<FormState>();
//  Color comp = Color(0xff898989),
//      mech = Color(0xff898989),
//      entc = Color(0xff898989);
//  String dept = "";
//  bool checktype,pressed=false;
//  static int snacktime = 0;
//  final FirebaseAuth auth = FirebaseAuth.instance;
//  FocusNode focusNode1 = new FocusNode();
//  FocusNode focusNode2 = new FocusNode();
//  String _email;
//  final checkemail = FirebaseDatabase.instance.reference();
//  String _password;
//  bool _autovalidate = false;
//  Map data;
//  final successSnackBar = new SnackBar(
//    duration: Duration(days: 1),
//    shape:
//    RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.00)),
//    backgroundColor: HexColor.fromHex("#00004d"),
//    elevation: 2.0,
//    content: new Row(
//      children: <Widget>[
//        new CircularProgressIndicator(
//          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
//        ),
//        new Padding(padding: EdgeInsets.only(left: 5.0)),
//        new Text("Logging in ",
//            textAlign: TextAlign.center,
//            style: TextStyle(
//                fontFamily: 'BalooChettan2',
//                color: Colors.white,
//                fontSize: 3 * SizeConfig.textMultiplier))
//      ],
//    ),
//  );
//  final successSnackBar1 = new SnackBar(
//    duration: Duration(days: 1),
//    shape:
//    RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.00)),
//    backgroundColor: HexColor.fromHex("#00004d"),
//    elevation: 2.0,
//    content: new Row(
//      children: <Widget>[
//        new CircularProgressIndicator(
//          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
//        ),
//        new Padding(padding: EdgeInsets.only(left: 5.0)),
//        new Text("Logging in ",
//            textAlign: TextAlign.center,
//            style: TextStyle(
//                fontFamily: 'BalooChettan2',
//                color: Colors.white,
//                fontSize: 3 * SizeConfig.textMultiplier))
//      ],
//    ),
//  );
//  final errSnackBar = new SnackBar(
//      backgroundColor: HexColor.fromHex(" #ff4d4d"),
//      content: new Text("Login Failed",
//          style: TextStyle(
//              fontFamily: 'BalooChettan2',
//              color: Colors.white,
//              fontSize: 20.00)));
//  final incorrectPSnackBar = new SnackBar(
//      duration: Duration(milliseconds: 1000),
//      shape:
//      RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.00)),
//      backgroundColor: HexColor.fromHex(" #ff4d4d"),
//      elevation: 2.0,
//      content: new Text("Incorrect Password",
//          style: TextStyle(
//              fontFamily: 'BalooChettan2',
//              color: Colors.white,
//              fontSize: 20.00)));
//  final noUserSnackBar = new SnackBar(
//      duration: Duration(milliseconds: 1000),
//      shape:
//      RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.00)),
//      elevation: 2.0,
//      backgroundColor: Colors.red,
//      content: new Text("User not Found",
//          style: TextStyle(
//              fontFamily: 'BalooChettan2',
//              color: Colors.white,
//              fontSize: 20.00)));
//
//  @override
//  void initState() {
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    int grp = SizeConfig.grp;
//    return new Scaffold(
//        resizeToAvoidBottomInset: true,
//        resizeToAvoidBottomPadding: true,
//        key: scaffoldKey,
//        backgroundColor: Colors.white,
//        body: SingleChildScrollView(
//          child: new Container(
//            decoration: new BoxDecoration(
//                borderRadius: new BorderRadius.circular(10.00),
//                gradient: LinearGradient(
//                    begin: Alignment.topCenter,
//                    end: Alignment.bottomCenter,
//                    tileMode: TileMode.clamp,
//                    colors: [
//                      HexColor.fromHex("#000000"),
//                      HexColor.fromHex(" #ff4d4d")
//                    ])),
//            child: new Stack(
//              children: <Widget>[
//                new Column(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  //   mainAxisSize: MainAxisSize.max,
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Padding(
//                      padding: grp == 1
//                          ? EdgeInsets.only(
//                          top: 0 * SizeConfig.heightMultiplier,
//                          bottom: 0.4 * SizeConfig.heightMultiplier)
//                          : grp == 2
//                          ? EdgeInsets.only(
//                          top: 0.5 * SizeConfig.heightMultiplier,
//                          bottom: 0.5 * SizeConfig.heightMultiplier)
//                          : grp == 3
//                          ? EdgeInsets.only(
//                          top: 1 * SizeConfig.heightMultiplier,
//                          bottom: 1 * SizeConfig.heightMultiplier)
//                          : grp == 4
//                          ? EdgeInsets.only(
//                          top: 2 * SizeConfig.heightMultiplier,
//                          bottom:
//                          1 * SizeConfig.heightMultiplier)
//                          : grp == 5
//                          ? EdgeInsets.only(
//                          top: 6 *
//                              SizeConfig.heightMultiplier,
//                          bottom: 1 *
//                              SizeConfig.heightMultiplier)
//                          : EdgeInsets.only(
//                          top: 8 *
//                              SizeConfig.heightMultiplier,
//                          bottom: 1 *
//                              SizeConfig.heightMultiplier),
//                      child: new Image(
//                        image: new AssetImage("assets/college_logo.png"),
//                        alignment: Alignment.topCenter,
//                        height: 28 * SizeConfig.heightMultiplier,
//                        width: 42 * SizeConfig.widthMultiplier,
//                      ),
//                    ),
//                    new Card(
//                      margin: new EdgeInsets.symmetric(
//                          horizontal: 6 * SizeConfig.widthMultiplier,
//                          vertical: 3 * SizeConfig.heightMultiplier),
//                      elevation: 10.0,
//                      color: Colors.white,
//                      shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(10.0),
//                      ),
//                      child: Container(
//                        child: new Form(
//                          key: formKey,
//                          autovalidate: _autovalidate,
//                          child: new Theme(
//                              data: new ThemeData(
//                                  brightness: Brightness.light,
//                                  primarySwatch: Colors.blue,
//                                  inputDecorationTheme:
//                                  new InputDecorationTheme(
//                                      labelStyle: new TextStyle(
//                                          color: Colors.blue,
//                                          fontSize: 2 *
//                                              SizeConfig.textMultiplier))),
//                              child: new Column(
//                                crossAxisAlignment: CrossAxisAlignment.center,
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                children: <Widget>[
//                                  Padding(
//                                    padding: EdgeInsets.only(
//                                        top: 2 * SizeConfig.heightMultiplier,
//                                        bottom:
//                                        1 * SizeConfig.heightMultiplier),
//                                    child: new Text(
//                                      "LOGIN",
//                                      style: TextStyle(
//                                        // fontStyle: FontStyle.italic,
//                                        color: HexColor.fromHex("#00004d"),
//                                        fontSize:
//                                        3.4 * SizeConfig.heightMultiplier,
//                                        fontWeight: FontWeight.bold,
//                                        decoration: TextDecoration.underline,
//                                      ),
//                                    ),
//                                  ),
//                                  Row(
//                                    mainAxisAlignment: MainAxisAlignment.center,
//                                    crossAxisAlignment:
//                                    CrossAxisAlignment.center,
//                                    children: <Widget>[
//                                      Text(
//                                        "Department:",
//                                        style: TextStyle(
//                                          color: HexColor.fromHex("#800000"),
//                                          fontSize:
//                                          2.5 * SizeConfig.heightMultiplier,
//                                          fontWeight: FontWeight.bold,
//                                        ),
//                                      ),
//                                      new Padding(
//                                          padding: EdgeInsets.only(
//                                              left: 2 *
//                                                  SizeConfig.widthMultiplier)),
//                                      IconButton(
//                                        icon: Icon(Icons.settings, color: mech),
//                                        onPressed: () {
//                                          setState(() {
//                                            mech = Color(0xff00004d);
//                                            dept = "MECH";
//                                            comp = Color(0xff898989);
//                                            entc = Color(0xff898989);
//                                          });
//                                        },
//                                      ),
//                                      new Padding(
//                                          padding: EdgeInsets.only(
//                                              left: 2 *
//                                                  SizeConfig.widthMultiplier)),
//                                      IconButton(
//                                          icon: Icon(Icons.laptop_mac,
//                                              color: comp),
//                                          onPressed: () {
//                                            setState(() {
//                                              comp = Color(0xff00004d);
//                                              mech = Color(0xff898989);
//                                              entc = Color(0xff898989);
//                                              dept = "COMP";
//                                            });
//                                          }),
//                                      new Padding(
//                                          padding: EdgeInsets.only(
//                                              left: 2 *
//                                                  SizeConfig.widthMultiplier)),
//                                      IconButton(
//                                          icon: Icon(Icons.tap_and_play,
//                                              color: entc),
//                                          onPressed: () {
//                                            setState(() {
//                                              entc = Color(0xff00004d);
//                                              dept = "ENTC";
//                                              comp = Color(0xff898989);
//                                              mech = Color(0xff898989);
//                                            });
//                                          }),
//                                    ],
//                                  ),
//                                  new Padding(
//                                      padding: EdgeInsets.symmetric(
//                                          vertical: SizeConfig.heightMultiplier,
//                                          horizontal:
//                                          2 * SizeConfig.widthMultiplier)),
//                                  Padding(
//                                    padding: EdgeInsets.only(
//                                        left: 5 * SizeConfig.widthMultiplier,
//                                        right: 5 * SizeConfig.widthMultiplier),
//                                    child: new Column(
//                                      children: <Widget>[
//                                        new TextFormField(
//                                            focusNode: focusNode1,
//                                            enableSuggestions: true,
//                                            style: TextStyle(
//                                                fontFamily: 'BalooChettan2',
//                                                color:
//                                                HexColor.fromHex("#00004d"),
//                                                fontWeight: FontWeight.bold,
//                                                fontSize: 2.2 *
//                                                    SizeConfig
//                                                        .heightMultiplier),
//                                            cursorColor:
//                                            HexColor.fromHex("#00004d"),
//                                            decoration: new InputDecoration(
//                                                focusedBorder:
//                                                OutlineInputBorder(
//                                                  borderRadius:
//                                                  BorderRadius.all(
//                                                      Radius.circular(10)),
//                                                  borderSide: BorderSide(
//                                                      width: 1,
//                                                      color: HexColor.fromHex(
//                                                          "#800000")),
//                                                ),
//                                                suffixIcon: Icon(
//                                                  Icons.person,
//                                                  size: 2.5 *
//                                                      SizeConfig
//                                                          .heightMultiplier,
//                                                  color: Colors.black54,
//                                                ),
//                                                contentPadding: EdgeInsets.only(
//                                                    left: 5 *
//                                                        SizeConfig
//                                                            .widthMultiplier,
//                                                    right: 5 *
//                                                        SizeConfig
//                                                            .widthMultiplier),
//                                                border: OutlineInputBorder(
//                                                    borderRadius:
//                                                    BorderRadius.circular(
//                                                        10.00)),
//                                                labelText: "Enter Username",
//                                                // hintText: "username",
//                                                labelStyle: new TextStyle(
//                                                    fontWeight: FontWeight.bold,
//                                                    color: HexColor.fromHex(
//                                                        "#800000"),
//                                                    fontSize: 2.2 *
//                                                        SizeConfig
//                                                            .textMultiplier)),
//                                            keyboardType:
//                                            TextInputType.emailAddress,
//                                            validator: validateEmail,
//                                            onSaved: (val) {
//                                              setState(() => _email = val);
//                                            }),
//                                        new Padding(
//                                            padding: EdgeInsets.symmetric(
//                                                horizontal: 4 *
//                                                    SizeConfig.widthMultiplier,
//                                                vertical: 2 *
//                                                    SizeConfig
//                                                        .heightMultiplier)),
//                                        new TextFormField(
//                                            focusNode: focusNode2,
//                                            style: TextStyle(
//                                                fontFamily: 'BalooChettan2',
//                                                color:
//                                                HexColor.fromHex("#00004d"),
//                                                fontWeight: FontWeight.bold,
//                                                fontSize: 2.2 *
//                                                    SizeConfig
//                                                        .heightMultiplier),
//                                            cursorColor:
//                                            HexColor.fromHex("#00004d"),
//                                            decoration: new InputDecoration(
//                                                focusedBorder:
//                                                OutlineInputBorder(
//                                                  borderRadius:
//                                                  BorderRadius.all(
//                                                      Radius.circular(10)),
//                                                  borderSide: BorderSide(
//                                                      width: 1,
//                                                      color: HexColor.fromHex(
//                                                          "#800000")),
//                                                ),
//                                                suffixIcon: Icon(
//                                                  Icons.lock,
//                                                  size: 2.5 *
//                                                      SizeConfig
//                                                          .heightMultiplier,
//                                                  color: Colors.black54,
//                                                ),
//                                                contentPadding: EdgeInsets.only(
//                                                    left: 5 *
//                                                        SizeConfig
//                                                            .widthMultiplier,
//                                                    right: 5 *
//                                                        SizeConfig
//                                                            .widthMultiplier),
//                                                border: OutlineInputBorder(
//                                                    borderRadius:
//                                                    BorderRadius.circular(
//                                                        10.00)),
//                                                labelText: "Enter Password",
//                                                labelStyle: TextStyle(
//                                                    fontWeight: FontWeight.bold,
//                                                    color: HexColor.fromHex(
//                                                        "#800000"),
//                                                    fontSize: 2.2 *
//                                                        SizeConfig
//                                                            .heightMultiplier)),
//                                            keyboardType: TextInputType.text,
//                                            validator: validatePassword,
//                                            obscureText: true,
//                                            onSaved: (val) {
//                                              setState(() => _password = val);
//                                            }),
//                                      ],
//                                    ),
//                                  ),
//                                  new Padding(
//                                      padding: EdgeInsets.only(
//                                          top:
//                                          4 * SizeConfig.heightMultiplier)),
//                                  new SizedBox(
//                                    width: 25 * SizeConfig.widthMultiplier,
//                                    height: 5 * SizeConfig.heightMultiplier,
//                                    child: RaisedButton(
//                                        shape: new RoundedRectangleBorder(
//                                            borderRadius:
//                                            BorderRadius.circular(80.00)),
//                                        splashColor:
//                                        HexColor.fromHex("#ffffff"),
//                                        onPressed: pressed?null:() async {
//                                          bool show=true;
//                                          //fun(context);
//                                          setState(() {
//                                            pressed=true;
//                                          });
//                                          Map map;
//                                          String prn;
//                                          if (formKey.currentState.validate()) {
//                                            formKey.currentState.save();
//                                            try {
////                                              setState(() {
////                                                show=true;
////                                              });
//                                              if (!checktype) {
//                                                scaffoldKey.currentState
//                                                    .showSnackBar(
//                                                    successSnackBar1);
//                                                _email = _email.toLowerCase();
//                                              } else {
//
//                                                scaffoldKey.currentState
//                                                    .showSnackBar(
//                                                    successSnackBar);
//                                                _email = _email.toUpperCase();
//                                                await checkemail
//                                                    .child("Registration")
//                                                    .child("Student")
//                                                    .child(dept)
//                                                    .child(_email)
//                                                    .once()
//                                                    .then((onValue) {
//                                                  if (onValue.value == null)
//                                                    throw Exception;
//                                                  map = onValue.value;
//                                                  prn = _email;
//                                                  _email = map["Email"];
//                                                });
//                                              }
//
//                                              signIn(_email, _password)
//                                                  .then((user) async {
//                                                SharedPreferences prefs =
//                                                await SharedPreferences
//                                                    .getInstance();
//                                                prefs.clear();
//                                                //var e;
//                                                if (user != null) {
//                                                  String uemail = _email;
//
//
//                                                  prefs.setString(
//                                                      'email', uemail);
//                                                  if (!checktype) {
//                                                    try {
//                                                      var e = _email.split("@");
//                                                      String b = e[0]
//                                                          .toString()
//                                                          .replaceAll(
//                                                          new RegExp(r'\W'),
//                                                          "_")
//                                                          .toLowerCase();
//                                                      Map map;
//                                                      await checkemail
//                                                          .child("Registration")
//                                                          .child(
//                                                          'Teacher_account')
//                                                          .child(b.toString())
//                                                          .once()
//                                                          .then((snap) async {
//                                                        map = snap.value;
//                                                        if (map == null) {
//                                                          throw Exception;
//                                                        }
//
//                                                        prefs.setString("name",
//                                                            map["Name"]);
//                                                        Dateinfo.teachname =
//                                                            map["Name"]
//                                                                .toString();
//                                                        prefs.setString("dept",
//                                                            map["Department"]);
//                                                        Dateinfo.dept =
//                                                            map["Department"]
//                                                                .toString();
//                                                        Dateinfo.teachemail =
//                                                            uemail;
//                                                        var e = Dateinfo
//                                                            .teachemail
//                                                            .split("@");
//                                                        Dateinfo.email = e[0]
//                                                            .toString()
//                                                            .replaceAll(
//                                                            new RegExp(
//                                                                r'\W'),
//                                                            "_");
//                                                        Map days;
//                                                        prefs.setBool(
//                                                            'login', true);
//
//                                                        prefs.setBool(
//                                                            "check", false);
//                                                        if (map.containsKey(
//                                                            "Admin")) {
//                                                          prefs.setString(
//                                                              "type", "admin");
//                                                        } else {
//                                                          prefs.setString(
//                                                              "type",
//                                                              "teacher");
//                                                        }
//                                                        checkemail
//                                                            .child(
//                                                            "Registration")
//                                                            .child(
//                                                            'Teacher_account')
//                                                            .child(
//                                                            Dateinfo.email)
//                                                            .child("slot")
//                                                            .once()
//                                                            .then((snapshot) {
//                                                          try {
//                                                            Map data =
//                                                                snapshot.value;
//                                                            if (data == null) {
//                                                              throw Exception;
//                                                            }
//                                                            List<String> slot =
//                                                            new List<
//                                                                String>();
//                                                            for (final key
//                                                            in data.keys) {
//                                                              slot.add(
//                                                                  key.toString() +
//                                                                      "h");
//                                                            }
//                                                            prefs.setStringList(
//                                                                "slot", slot);
//                                                          } catch (Exception) {
//                                                            List<String> slot =
//                                                            new List<
//                                                                String>();
//                                                            prefs.setStringList(
//                                                                "slot", slot);
//                                                          }
//                                                        });
//
//                                                        checkemail
//                                                            .child(
//                                                            "Registration")
//                                                            .child(
//                                                            'Teacher_account')
//                                                            .child(
//                                                            Dateinfo.email)
//                                                            .child("work_hr")
//                                                            .once()
//                                                            .then((snapshot) {
//                                                          try {
//                                                            Map data =
//                                                                snapshot.value;
//                                                            if (data == null)
//                                                              throw Exception;
//                                                            else {
//                                                              prefs.setString(
//                                                                  "today_date",
//                                                                  data["date"]);
//                                                              // print(prefs.getString("today_date"));
//                                                              prefs.setInt(
//                                                                  "week_no",
//                                                                  data[
//                                                                  "weekno"]);
//
//                                                              prefs.setInt(
//                                                                  "dayc",
//                                                                  data["dayc"]);
//
//                                                              prefs.setInt(
//                                                                  "weekc",
//                                                                  data[
//                                                                  "weekc"]);
//                                                            }
//                                                          } catch (Exception) {
//                                                            print("work");
//                                                            var now =
//                                                            new DateTime
//                                                                .now();
//                                                            var ford =
//                                                            new DateFormat(
//                                                                "yyyy_MM_dd");
//
//                                                            String date = ford
//                                                                .format(now);
//
//                                                            int current =
//                                                                DateTime.utc(
//                                                                    now.year,
//                                                                    now.month,
//                                                                    1)
//                                                                    .weekday;
//                                                            int weekno = 0;
//                                                            int i = 9 - current;
//                                                            for (;
//                                                            i < 30;
//                                                            i += 7) {
//                                                              weekno += 1;
//                                                              if (now.day < i) {
//                                                                break;
//                                                              }
//                                                            }
//                                                            prefs.setString(
//                                                                "today_date",
//                                                                date);
//                                                            prefs.setInt(
//                                                                "dayc", 0);
//                                                            prefs.setInt(
//                                                                "week_no",
//                                                                weekno);
//                                                            prefs.setInt(
//                                                                "weekc", 0);
//                                                          }
//
//                                                          //  checkemail.child("")
//                                                        });
//                                                        try {
//                                                          checkemail
//                                                              .child("cdate")
//                                                              .once()
//                                                              .then((val) {
//                                                            if (val.value ==
//                                                                null)
//                                                              throw Exception;
//
//                                                            prefs.setString(
//                                                                "cdate",
//                                                                val.value
//                                                                    .toString());
//                                                          });
//                                                        } catch (Exception) {}
//                                                        await Teacher.data();
//                                                      });
//                                                      if(show)
//                                                        scaffoldKey.currentState.hideCurrentSnackBar();
//                                                      setState(() {
//                                                        show=false;
//                                                      });
//
//                                                      //  await Future.delayed(Duration(seconds: 3));
//                                                      Navigator.pushReplacement(
//                                                          context,
//                                                          PageTransition(
//                                                              type:
//                                                              PageTransitionType
//                                                                  .fade,
//                                                              duration:
//                                                              Duration(
//                                                                  seconds:
//                                                                  2),
//                                                              child: thome()));
//                                                    } catch (Exception) {Fluttertoast.showToast(
//                                                        msg: "No data Found",
//                                                        toastLength: Toast
//                                                            .LENGTH_SHORT,
//                                                        gravity: ToastGravity
//                                                            .BOTTOM,
//                                                        backgroundColor:
//                                                        Colors.red,
//                                                        textColor:
//                                                        Colors.white,
//                                                        fontSize: 16.0);
//                                                    if(show)
//                                                      scaffoldKey.currentState.hideCurrentSnackBar();
//                                                    setState(() {
//                                                      show=false;
//                                                    });
//                                                    }
//                                                  } else {
//                                                    try {
//                                                      prefs.setString(
//                                                          "type", "student");
//                                                      Map map;
//                                                      if (dept.isEmpty) {
//                                                        print(show);
//                                                        if(show)
//                                                          scaffoldKey.currentState.hideCurrentSnackBar();
//                                                        setState(() {
//                                                          show=false;
//                                                        });
//                                                        Fluttertoast.showToast(
//                                                            msg:
//                                                            "Select Department",
//                                                            toastLength: Toast
//                                                                .LENGTH_SHORT,
//                                                            gravity:
//                                                            ToastGravity
//                                                                .BOTTOM,
//                                                            backgroundColor:
//                                                            Colors.red,
//                                                            textColor:
//                                                            Colors.white,
//                                                            fontSize: 16.0);
//                                                      } else {
//                                                        await checkemail
//                                                            .child(
//                                                            "Registration")
//                                                            .child('Student')
//                                                            .child(dept)
//                                                            .child(prn)
//                                                            .once()
//                                                            .then((snap) async {
//                                                          map = snap.value;
//                                                          if (map == null)
//                                                            throw Exception;
////                                                          print(map);
//                                                          //    await Future.delayed(Duration(seconds: 5));
//                                                          Studinfo.name =
//                                                          map["Name"];
//                                                          Studinfo.roll =
//                                                          map["Prn"];
//                                                          prefs.setString(
//                                                              "name",
//                                                              map["Name"]);
//                                                          prefs.setString(
//                                                              "branch", dept);
//                                                          Studinfo.branch =
//                                                              dept;
//                                                          Studinfo.classs =
//                                                          map["Class"];
//                                                          Studinfo.batch =
//                                                          map["Batch"];
//                                                          try {
//                                                            prefs.setString(
//                                                                "text",
//                                                                map["text"]);
//                                                          } catch (Exception) {
//                                                            prefs.setString(
//                                                                "text", "");
//                                                          }
//                                                          prefs.setBool(
//                                                              'login', true);
//
//                                                          // prefs.setString("roll", map["Serial"]);
//                                                          prefs.setString(
//                                                              "class",
//                                                              map["Class"]);
//                                                          prefs.setString(
//                                                              "batch",
//                                                              map["Batch"]);
////                                                        prefs.setString(
////                                                            "text", " ");
//                                                          prefs.setString(
//                                                              "roll",
//                                                              map["Prn"]);
//                                                          Studinfo.email =
//                                                              uemail;
//                                                          print(Studinfo.email +
//                                                              " email");
//                                                          prefs.setInt(
//                                                              "fetchatt", 1);
//                                                        });
//                                                        if (map.containsKey(
//                                                            "Parent")) {
//                                                          Studinfo.parentname =
//                                                          map["Parent"];
//                                                          prefs.setString(
//                                                              "parent",
//                                                              map["Parent"]);
//                                                        }
//                                                        await FirebaseDatabase
//                                                            .instance
//                                                            .reference()
//                                                            .child("defaulter")
//                                                            .child("modified")
//                                                            .child(
//                                                            Studinfo.roll)
//                                                            .once()
//                                                            .then((onValue) {
//                                                          if (onValue.value ==
//                                                              -1)
//                                                            throw Exception;
//                                                        });
//                                                        final FirebaseMessaging
//                                                        firebaseMessaging =
//                                                        FirebaseMessaging();
//                                                        firebaseMessaging
//                                                            .subscribeToTopic(
//                                                            Studinfo.roll);
//
//                                                        try {
//                                                          await Attendance
//                                                              .owndata();
//                                                          FirebaseDatabase
//                                                              .instance
//                                                              .reference()
//                                                              .child(
//                                                              "defaulter")
//                                                              .child("modified")
//                                                              .child(
//                                                              Studinfo.roll)
//                                                              .set(0);
//                                                        } catch (Exception) {}
//                                                        if(show)
//                                                          scaffoldKey.currentState.hideCurrentSnackBar();
//                                                        setState(() {
//                                                          show=false;
//                                                        });
//                                                        //  await Future.delayed(Duration(seconds: 5));
//                                                        Navigator.pushReplacement(
//                                                            context,
//                                                            PageTransition(
//                                                                type:
//                                                                PageTransitionType
//                                                                    .fade,
//                                                                duration:
//                                                                Duration(
//                                                                    seconds:
//                                                                    2),
//                                                                child:
//                                                                shome()));
//                                                      }
//                                                    } catch (Exception) {
////                                                      print(Exception);
//                                                      print(show);
//                                                      if(show)
//                                                        scaffoldKey.currentState.hideCurrentSnackBar();
//                                                      setState(() {
//                                                        show=false;
//                                                      });
//
//                                                      Fluttertoast.showToast(
//                                                          msg: "No data Found",
//                                                          toastLength: Toast
//                                                              .LENGTH_SHORT,
//                                                          gravity: ToastGravity
//                                                              .BOTTOM,
//                                                          backgroundColor:
//                                                          Colors.red,
//                                                          textColor:
//                                                          Colors.white,
//                                                          fontSize: 16.0);
//                                                    }
//                                                  }
//                                                } else {
//                                                  if(show)
//                                                    scaffoldKey.currentState.hideCurrentSnackBar();
//                                                  setState(() {
//                                                    show=false;
//                                                  });
//                                                  scaffoldKey.currentState
//                                                      .showSnackBar(
//                                                      errSnackBar);
//                                                }
//                                              });
//                                            } catch (Exception) {
//                                              print("kk");
//                                              print(show);
//                                              if(show)
//                                                scaffoldKey.currentState.hideCurrentSnackBar();
//                                              setState(() {
//                                                show=false;
//                                              });
//                                              Fluttertoast.showToast(
//                                                  msg: "No data Found",
//                                                  toastLength:
//                                                  Toast.LENGTH_SHORT,
//                                                  gravity: ToastGravity.BOTTOM,
//                                                  backgroundColor: Colors.red,
//                                                  textColor: Colors.white,
//                                                  fontSize: 16.0);
//                                            }
//                                          } else {
//                                            setState(() {
//                                              _autovalidate = true;
//                                            });
//                                          }
////                                          if(show){
////                                          scaffoldKey.currentState.removeCurrentSnackBar();
////
////                                          }
//                                          setState(() {
//                                            pressed=false;
//                                          });
//                                          FocusScope.of(context)
//                                              .requestFocus(new FocusNode());
//                                        },
//                                        elevation: 2.0,
//                                        color: HexColor.fromHex("#00004d"),
//                                        textColor: Colors.white,
//                                        child: new Text(
//                                          "Sign In",
//                                          textAlign: TextAlign.center,
//                                          style: TextStyle(
//                                              fontSize: 2 *
//                                                  SizeConfig.textMultiplier),
//                                        )),
//                                  ),
//                                  new Padding(
//                                      padding: EdgeInsets.only(
//                                          bottom:
//                                          2 * SizeConfig.heightMultiplier))
//                                ],
//                              )),
//                        ),
//                      ),
//                    ),
//                    //new Padding(padding: EdgeInsets.only(top:2.5*SizeConfig.heightMultiplier)),
//                    Column(
//                      children: <Widget>[
//                        new MaterialButton(
//                          onPressed: () => {
//                            FocusScope.of(context)
//                                .requestFocus(new FocusNode()),
//                            fun(context),
//                          },
//                          shape: new RoundedRectangleBorder(
//                              borderRadius: BorderRadius.circular(50.00)),
//                          child: new Text("Forgot Password?",
//                              style: TextStyle(
//                                  fontFamily: 'BalooChettan2',
//                                  color: HexColor.fromHex("#00004d"),
//                                  fontSize: 2.8 * SizeConfig.textMultiplier,
//                                  fontWeight: FontWeight.bold)),
//                        ),
//                        new MaterialButton(
//                          onPressed: () => {
//                            FocusScope.of(context)
//                                .requestFocus(new FocusNode()),
//                            Navigator.pushReplacement(
//                                context,
//                                PageTransition(
//                                    type:
//                                    PageTransitionType.rightToLeftWithFade,
//                                    duration: Duration(seconds: 1),
//                                    child: Signup()))
//                          },
//                          shape: new RoundedRectangleBorder(
//                              borderRadius: BorderRadius.circular(50.00)),
//                          child: new Text("Create account",
//                              style: TextStyle(
//                                  fontFamily: 'BalooChettan2',
//                                  color: HexColor.fromHex("#00004d"),
//                                  fontSize: 2.8 * SizeConfig.textMultiplier,
//                                  fontWeight: FontWeight.bold)),
//                        )
//                      ],
//                    ),
//                    //Forgot password button
//
//                    //Forgot password button
//                  ],
//                )
//              ],
//            ),
//          ),
//        ));
//  }
//
//  Future<FirebaseUser> signIn(String email, String password) async {
//    try {
//      AuthResult result = await auth.signInWithEmailAndPassword(
//          email: email, password: password);
//      FirebaseUser user = result.user;
////      if(user.isEmailVerified){
//      if (true) {
//        assert(user != null);
//        assert(await user.getIdToken() != null);
//
//        final FirebaseUser currentUser = await auth.currentUser();
//        assert(user.uid == currentUser.uid);
//        return user;
//      } else {
//        Fluttertoast.showToast(
//            msg: "Verify your email first",
//            toastLength: Toast.LENGTH_SHORT,
//            gravity: ToastGravity.BOTTOM,
//            backgroundColor: Colors.red,
//            textColor: Colors.white,
//            fontSize: 16.0);
//      }
//    } catch (e) {
//      handleError(e);
//      return null;
//    }
//  } //Firebase Sign in
//
//  String validateEmail(String value) {
//    Pattern pattern =
//        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(mescoepune\.org))$';
//    RegExp regex = new RegExp(pattern);
//    if (value.isEmpty || !regex.hasMatch(value)) {
//      RegExp re = RegExp(r'^F|S[0-9]+$');
//      if (value.isEmpty || !re.hasMatch(value) || value.length < 9)
//        return "invalid username";
//      else {
//        setState(() {
//          snacktime = 4500;
//        });
//        checktype = true;
//        return null;
//      }
//    } else {
//      setState(() {
//        snacktime = 2500;
//      });
//      checktype = false;
//      return null;
//    }
//  }
//
//  String validatePassword(String value) {
//    if (value.trim().isEmpty) {
//      return 'Password cannot be empty';
//    } else if (value.length < 6) {
//      return 'Password too short';
//    }
//    return null;
//  }
//
//  handleError(PlatformException error) {
//    switch (error.code) {
//      case 'ERROR_USER_NOT_FOUND':
//        setState(() {
//          scaffoldKey.currentState.showSnackBar(noUserSnackBar);
//        });
//        break;
//      case 'ERROR_WRONG_PASSWORD':
//        setState(() {
//          scaffoldKey.currentState.showSnackBar(incorrectPSnackBar);
//        });
//        break;
//    }
//  } //Sign in Error handling
//}
