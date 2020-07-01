import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_app/pages/AttendanceData.dart';
import 'package:flutter_app/pages/defaulter_input.dart';
import 'package:flutter_app/pages/forgotpassword.dart';
import 'package:flutter_app/pages/homepage.dart';
import 'package:flutter_app/pages/parentteacherlist.dart';
import 'package:flutter_app/pages/subject.dart';
import 'package:flutter_app/responsive/Screensize.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'View_attendance.dart';
import 'login_page.dart';
import 'package:marquee/marquee.dart';

class Passcode extends StatefulWidget {
  @override
  _PasscodeState createState() => _PasscodeState();
}

class _PasscodeState extends State<Passcode>
    with SingleTickerProviderStateMixin {
  TabController controller;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  double srating=0,arating=0;
  int rat=0;
  dynamic value;
  int defaulercount;
  var ford = new DateFormat("yyyy_MM_dd");
  Timer _timer;
  DateFormat format = new DateFormat("HH:mm:ss");
  DateTime time;
  bool drop = false, down = true;
  String cur_time;
  String att_cnt = "";
  String classs = 'Class', sub = "Subject", stat = "Status";
  String lec = "";
  int lec_count = 0;
  List<String> classlist = ["Class"], subjectlist = ["Subject"];
  List<String> fclasslist = ["Class"], fsubjectlist = ["Subject"];

  FocusNode focusNode1 = new FocusNode();
  FocusNode focusNode2 = new FocusNode();
  FocusNode focusNode3 = new FocusNode();
  FocusNode focusNode4 = new FocusNode();
  FocusNode focusNode5 = new FocusNode();

  bool enabled = true;
  Map tinfo;

  //var status = ['Status', 'lecture', 'Practical'];
  SharedPreferences prefs;
  final databaseReference = FirebaseDatabase.instance.reference();
  int code = 1000, exdayc = 0, exweekc = 0;
  String str = "";
  Color clr = Colors.white;
  bool isSwitched = false;
  double dist = 5 * SizeConfig.widthMultiplier;
  double txtsize = 2.5 * SizeConfig.textMultiplier;
  Color butclr = Color(0xff996600);
  int _start = 40;
  String card, fclass, fsub;
  bool radio_on = true;
  int group;
  var monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  var weekNames = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday"
  ];

  final TextEditingController _lcontroller = TextEditingController();
  final TextEditingController _ncontroller = TextEditingController();
  final TextEditingController _ccontroller = TextEditingController();
  final TextEditingController _scontroller = TextEditingController();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    controller = new TabController(length: 1, vsync: this);
    //_lcontroller.text = lec;
    _ccontroller.text = " ";
    _scontroller.text = " ";
    //print(DateTime.now().month);
    get();
    super.initState();
  }

  void get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < weekNames.length; i++) {
        if (prefs.getInt(weekNames[i]) == null)
          prefs.setInt(weekNames[i], 0);
        else
          exweekc += prefs.getInt(weekNames[i]);
      }
      int n = DateTime.now().weekday - 1;

      exdayc = prefs.getInt(weekNames[n]);
    });
    Teacher.update();


  }

  void startTimer() {
    enabled = false;
    _start = 40;
    _timer = new Timer.periodic(
      new Duration(milliseconds: 1000),
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            if (card == "front") {
              fclass = _ccontroller.text;
              fsub = _scontroller.text;
            } else {
              fclass = classs;
              fsub = sub;
            }

            enabled = true;
            drop = false;
            clr = Colors.white;
            radio_on = true;
            clock(fclass, fsub);
            _timer.cancel();
            str = "";

            //  workhr(1);
          } else {
            setState(() {
              _start = _start - 1;
            });
          }
        },
      ),
    );
  }

  void clock(String fclass, String fsub) async {
    if (stat == "lecture") {
      databaseReference
          .child("c_teacher")
          .child(Dateinfo.dept)
          .child(fclass)
          .child(stat)
          .child("passcode")
          .set("your code");
    } else {
      databaseReference
          .child("c_teacher")
          .child(Dateinfo.dept)
          .child(fclass)
          .child(stat)
          .child(Alert1.batch)
          .child("passcode")
          .set("your code");
    }
    var now = new DateTime.now();
    time = new DateTime.now();
    cur_time = format.format(time);
    user.count = "0";
    String date = ford.format(now);
    if (stat == "lecture") {
      print("hello");
      await getLUserAmount(fclass, fsub, date);
      await databaseReference
          .child("Attendance")
          .child(Dateinfo.dept)
          .child(fclass)
          .child(fsub.toUpperCase())
          .child(Dateinfo.teachname)
          .child(date)
          .child(stat)
          .child(lec.toString())
          .child("a_total")
          .set(user.count);

      databaseReference
          .child("time_table")
          .child(Dateinfo.dept)
          .child(fclass)
          .child(date)
          .child(cur_time.toString())
          .set({
        "name": Dateinfo.teachname,
        "subject": fsub.toUpperCase(),
        "batch": "",
        "total": user.count
      });
    } else {
      print("hii");
      await getPUserAmount(fclass, fsub, date);
      Fluttertoast.showToast(
          msg: user.count,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      await databaseReference
          .child("Attendance")
          .child(Dateinfo.dept)
          .child(fclass)
          .child(fsub.toUpperCase())
          .child(Dateinfo.teachname)
          .child(date)
          .child(stat)
          .child(Alert1.batch.toUpperCase())
          .child(lec.toString())
          .child("a_total")
          .set(user.count);
      print(user.count);
      databaseReference
          .child("time_table")
          .child(Dateinfo.dept)
          .child(fclass)
          .child(date)
          .child(cur_time.toString())
          .set({
        "name": Dateinfo.teachname,
        "subject": fsub.toUpperCase() + " $stat",
        "batch": Alert1.batch,
        "total": user.count
      });
    }
    setState(() {
      att_cnt = user.count;
    });
  }

  Future<int> getPUserAmount(String fclass, String fsub, String date) async {
    final response = await FirebaseDatabase.instance
        .reference()
        .child("Attendance")
        .child(Dateinfo.dept)
        .child(fclass)
        .child(fsub.toUpperCase())
        .child(Dateinfo.teachname)
        .child(date)
        .child(stat)
        .child(Alert1.batch.toUpperCase())
        .child(lec.toString())
        .once();
    try {
      Map users = response.value;
      var len = [];
      for (final k in users.keys) {
        if (!(k.toString() == "a_total")) len.add(k);
      }
      print(len.length);
      user.count = len.length.toString();
      return len.length;
    } catch (Exception) {
      Fluttertoast.showToast(
          msg: "no one marked",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<int> getLUserAmount(String fclass, String fsub, String date) async {
    print(user.classs);
    print(user.lec);
    final response = await FirebaseDatabase.instance
        .reference()
        .child("Attendance")
        .child(Dateinfo.dept)
        .child(fclass)
        .child(fsub.toUpperCase())
        .child(Dateinfo.teachname)
        .child(date)
        .child(stat)
        .child(lec)
        .once();
    await Future.delayed(Duration(seconds: 3));
    try {
      Map users = response.value;
      print(users);
      var len = [];
      for (final k in users.keys) {
        if (!(k.toString() == "a_total")) {
          len.add(k);
        }
      }
      print(users);
      print(len);
      user.count = len.length.toString();
      return len.length;
    } catch (Exception) {
      Fluttertoast.showToast(
          msg: "No one Marked",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void copy() async {
    prefs = await SharedPreferences.getInstance();
  }

  void init() {
    _ncontroller.text = "";
    _ccontroller.text = "";
    _scontroller.text = "";
    _lcontroller.text = "";
    group = null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
  Future<bool> _onbackpressed(){
    if(enabled==true){
      Navigator. pop(context);
    }

  }
  @override
  Widget build(BuildContext context) {
    copy();
    Color righttxtclr = Color(0xff997a00);
    Color lefttxtclr = Color(0xff00004d);
    double lefttxtsize=2.5*SizeConfig.heightMultiplier;
    ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: " Wait");
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: _onbackpressed,
      child: new Scaffold(
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          appBar: new GradientAppBar(
            title: new Text("Homepage\\Take att",
                style: TextStyle(
                    fontSize: 2.7 * SizeConfig.textMultiplier,
                    fontStyle: FontStyle.italic)),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                _onbackpressed();

              },
            ),
            backgroundColorStart: Color(0xff6d6d46),
            backgroundColorEnd: Color(0xff6d6d46),
            actions: <Widget>[
//              PopupMenuButton<String>(
//                onSelected: handleClick,
//                itemBuilder: (BuildContext context) {
//                  return {'Subject registration', 'Monitor session'}
//                      .map((String choice) {
//                    return PopupMenuItem<String>(
//                      value: choice,
//                      child: Text(choice),
//                    );
//                  }).toList();
//                },
//              ),
            ],
          ),
          body: new Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
//                  stops: [0,0.5,1],
                colors: [Color(0xff000000), Color(0xff000000)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: 4 * SizeConfig.heightMultiplier,
                      bottom: 2 * SizeConfig.heightMultiplier),
                  child: new Text(
                    "Session passcode : " + str,
                    style: TextStyle(
                        color: clr, fontSize: 3 * SizeConfig.textMultiplier),
                  ),
                ),

                new Text(
                  " Countdown: $_start",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 2.8 * SizeConfig.textMultiplier),
                ),
                new Padding(
                    padding: EdgeInsets.only(
                        bottom: 0 * SizeConfig.heightMultiplier)),

                Padding(
                  padding:
                  EdgeInsets.only(top: 0 * SizeConfig.heightMultiplier),
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    key: cardKey,
                    flipOnTouch: false,
                    front: new GradientCard(
                      margin: new EdgeInsets.only(
                        left: 5 * SizeConfig.widthMultiplier,
                        right: 5 * SizeConfig.widthMultiplier,
                        top: 5 * SizeConfig.heightMultiplier,
                      ),
                      elevation: 5.0,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        // stops: [0,0.5,1],
                        colors: [
//                          HexColor.fromHex("#DAD299"),
//                          HexColor.fromHex("#DAD299")
                          Color(0xffDAD299),
                          Color(0xffDAD299)
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 2 * SizeConfig.heightMultiplier,
                                left: 5 * SizeConfig.widthMultiplier,
                                bottom: 2 * SizeConfig.heightMultiplier),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Self",
                                  style: TextStyle(
                                    fontSize: 2.5 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.bold,
                                    color: lefttxtclr,
                                  ),
                                ),
                                Switch(
                                  value: isSwitched,
                                  onChanged: (value) {
                                    setState(() {
                                      if (enabled) {
                                        init();
                                        isSwitched = value;
                                        cardKey.currentState.toggleCard();
                                      }
                                    });
                                  },
                                  activeTrackColor: Colors.black87,
                                  activeColor: Colors.black87,
                                  inactiveThumbColor: Colors.black87,
                                ),
                                Text(
                                  "Adjusted",
                                  style: TextStyle(
                                    fontSize: 2.7 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.bold,
                                    color: lefttxtclr,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SliderTheme(
                            child: Slider(
                                activeColor: Color(0xff999966),
                                inactiveColor: Color(0xffc2c2a3),
                                label: (srating.toInt()).toString(),
                                value: srating,
                                divisions: 8,

                                min: 0,
                                max:8,
                                onChanged: enabled ?(newrating){
                                  setState(() {
                                    srating=newrating;
                                    _ncontroller.text=srating.toInt().toString();
                                    timetable();
                                    workhr(_ccontroller.text,
                                        _scontroller.text);
                                  });
                                }
                                    :null
                            ),
                            data: SliderTheme.of(context).copyWith(
                                trackHeight:3,
                                inactiveTickMarkColor: lefttxtclr,
                                valueIndicatorColor: Colors.blue,
                                activeTickMarkColor: lefttxtclr,
                                valueIndicatorTextStyle: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold)
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 2 * SizeConfig.heightMultiplier),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Enter Work hour :",
                                  style: TextStyle(
                                    fontSize: lefttxtsize,
                                    color: lefttxtclr,
                                    fontWeight: FontWeight.bold,

                                  ),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(
                                      left: 4 * SizeConfig.widthMultiplier),
                                ),
                                new Flexible(
                                  child: Container(
                                    width: 50,
                                    child: TextField(

                                        decoration: new InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.greenAccent, width: 5.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.red, width: 5.0),
                                          ),
                                          disabledBorder:  UnderlineInputBorder(
                                            borderSide: BorderSide(color: lefttxtclr, width: 2.0),
                                          ),
                                        ),
                                        textAlign: TextAlign.center,
                                        focusNode: focusNode3,
                                        enableSuggestions: true,
                                        autofocus: false,
                                        showCursor: true,
                                        controller: _ncontroller,
                                        style: TextStyle(
                                            fontFamily: 'BalooChettan2',
                                            color: righttxtclr,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 2.2 *
                                                SizeConfig.heightMultiplier),
                                        cursorColor: righttxtclr,
                                        keyboardType:
                                        TextInputType.emailAddress,
                                        //validator: validateEmail,
                                        enabled: false,
                                        onChanged: (val) {
                                          setState(() {
                                            srating=double.parse(val);
                                            timetable();
                                            workhr(_ccontroller.text,
                                                _scontroller.text);
                                          });
                                        }),
                                  ),
//
                                )],
                            ),
                          ),
//                          Padding(
//                            padding: EdgeInsets.only(
//                                top: 4 * SizeConfig.heightMultiplier,
//                                left: 13 * SizeConfig.widthMultiplier),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 5 * SizeConfig.heightMultiplier),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Your  class:",
                                  style: TextStyle(
                                      fontSize: lefttxtsize,
                                      color: lefttxtclr,
                                      fontWeight: FontWeight.bold),
                                ),
                                new Padding(
                                    padding: EdgeInsets.only(
                                        left: 6 * SizeConfig.widthMultiplier)),
                                Container(
                                    width: 22 * SizeConfig.widthMultiplier,
                                    child: TextField(
                                      focusNode: focusNode4,
                                      textAlign: TextAlign.center,
                                      enableSuggestions: true,
                                      controller: _ccontroller,
                                      style: TextStyle(
                                          fontFamily: 'BalooChettan2',
                                          color: righttxtclr,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 2.2 *
                                              SizeConfig.heightMultiplier),
                                      cursorColor: righttxtclr,
                                      decoration: new InputDecoration(
                                        disabledBorder:  UnderlineInputBorder(
                                          borderSide: BorderSide(color: lefttxtclr, width: 2.0),
                                        ),
                                      ),
                                      enabled: false,
                                    )),
                              ],
                            ),
                          ),
//
                          Padding(
                            padding: EdgeInsets.only(
                              top: 5 * SizeConfig.heightMultiplier,
                              //    left: 13 * SizeConfig.widthMultiplier
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Your   subject:",
                                  style: TextStyle(
                                      fontSize: lefttxtsize,
                                      color: lefttxtclr,
                                      fontWeight: FontWeight.bold),
                                ),
                                new Padding(
                                    padding: EdgeInsets.only(
                                        left: 6 * SizeConfig.widthMultiplier)),
                                Container(
                                  width: 25 * SizeConfig.widthMultiplier,
                                  child: TextField(
                                    focusNode: focusNode5,
                                    textAlign: TextAlign.center,
                                    enableSuggestions: true,
                                    controller: _scontroller,
                                    style: TextStyle(
                                        fontFamily: 'BalooChettan2',
                                        color: righttxtclr,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                        2.2 * SizeConfig.heightMultiplier),
                                    cursorColor: lefttxtclr,
                                    decoration: new InputDecoration(
                                      disabledBorder:  UnderlineInputBorder(
                                        borderSide: BorderSide(color: lefttxtclr, width: 2.0),
                                      ),
                                    ),
                                    enabled: false,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: dist,
                                top: 4 * SizeConfig.heightMultiplier),
                            child: Column(
                              children: <Widget>[
                                new RaisedButton(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(80.00)),
                                  splashColor: HexColor.fromHex("#ffffff"),
                                  disabledColor: Color(0xffff9999),
                                  onPressed: enabled
                                      ? () async {
                                    prefs = await SharedPreferences
                                        .getInstance();
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    var rng = new Random();
                                    var slot=prefs.getStringList("slot");

                                    code = code +
                                        rng.nextInt(20000) +
                                        rng.nextInt(30000);
                                    if (_ccontroller.text == "Class" ||
                                        _scontroller.text == "Subject" ||
                                        stat == "Status" ||
                                        lec == "") {
                                      Fluttertoast.showToast(
                                          msg: "fill all fields",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }else if((slot.contains(_ncontroller.text+"h"))){
                                      bool click=true;
                                      await Alert(
                                        context: context,
                                        type: AlertType.warning,
                                        title: "Attendance already taken",
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

                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "ok",
                                              style: TextStyle(color: Colors.white, fontSize: 2.5*SizeConfig.textMultiplier),
                                            ),
                                            onPressed:click? (){ Navigator.pop(context);
                                            setState(() {
                                              click=false;
                                            });
                                            }:null,
                                            color: Color.fromRGBO(0, 179, 134, 1.0),
                                          )
                                        ],
                                      ).show();
                                    } else {
                                      radio_on = false;
                                      setState(() {
                                        clr = Color(0xffff9999);
                                        str = code.toString();
                                        card = "front";
                                      });
                                      startTimer();
                                      //var slot=prefs.getStringList("slot");
                                      slot.add(_ncontroller.text+"h");
                                      prefs.setStringList("slot",slot);
                                      var now = new DateTime.now();
                                      String date = ford.format(now);
                                      Dateinfo.classs = _ccontroller.text;
                                      Dateinfo.subject =
                                          _scontroller.text;
                                      Dateinfo.date1 = date;
                                      Dateinfo.stat = stat;
                                      databaseReference
                                          .child('c_teacher')
                                          .child(Dateinfo.dept)
                                          .child(_ccontroller.text)
                                          .child("status")
                                          .set(stat);
                                      setState(() {
                                        user.classs = _ccontroller.text;
                                        user.sub = _scontroller.text
                                            .toUpperCase();
                                        user.date = date;
                                        user.lec = lec.toString();
                                        user.stat = stat;
                                      });
                                      //  workhr(1);
                                      int current = DateTime.utc(
                                          now.year, now.month, 1)
                                          .weekday;
                                      int weekno = 0;
                                      int i = 9 - current;
                                      for (; i < 30; i += 7) {
                                        weekno += 1;
                                        if (now.day < i) {
                                          break;
                                        }
                                      }
                                      int dayc = prefs.getInt("dayc");
                                      int weekc = prefs.getInt("weekc");

                                      if (stat == "lecture") {
                                        dayc += 1;
                                        weekc += 1;
                                        databaseReference
                                            .child("Attendance")
                                            .child(Dateinfo.dept)
                                            .child(_ccontroller.text)
                                            .child(_scontroller.text
                                            .toUpperCase())
                                            .child(Dateinfo.teachname)
                                            .child(date)
                                            .child(stat)
                                            .child("leccount")
                                            .set(lec.toString());
                                        databaseReference
                                            .child("Attendance")
                                            .child(Dateinfo.dept)
                                            .child(_ccontroller.text)
                                            .child(_scontroller.text
                                            .toUpperCase())
                                            .child(Dateinfo.teachname)
                                            .child(date)
                                            .child(stat)
                                            .child(lec.toString())
                                            .child("a_total")
                                            .set("0");

                                        databaseReference
                                            .child("c_teacher")
                                            .child(Dateinfo.dept)
                                            .child(_ccontroller.text)
                                            .child(stat)
                                            .set({
                                          "passcode": str,
                                          "count": lec,
                                          "Subject": _scontroller.text
                                              .toUpperCase(),
                                          "Teacher": Dateinfo.teachname
                                        });

                                        var varcount = prefs
                                            .getString(_ccontroller.text
                                            .toUpperCase() +
                                            "_" +
                                            _scontroller.text
                                                .toUpperCase())
                                            .split(" ");

                                        String val =
                                            (int.parse(varcount[0]) + 1)
                                                .toString() +
                                                " " +
                                                (int.parse(varcount[1]) +
                                                    1)
                                                    .toString();
                                        defaulercount =
                                            int.parse(varcount[0]) + 1;
                                        print(defaulercount);
                                        defaulter(_ccontroller.text,
                                            _scontroller.text);
                                        databaseReference
                                            .child("week_tt")
                                            .child(Dateinfo.dept)
                                            .child(
                                            monthNames[now.month - 1])
                                            .child(weekno.toString())
                                            .child(_ccontroller.text)
                                            .child(weekNames[
                                        now.weekday - 1])
                                            .child(_ncontroller.text +
                                            " " +
                                            "lec")
                                            .set(Dateinfo.teachname +
                                            " class:" +
                                            _ccontroller.text +
                                            " sub:" +
                                            _scontroller.text);

                                        await prefs.setString(
                                            _ccontroller.text
                                                .toUpperCase() +
                                                "_" +
                                                _scontroller.text
                                                    .toUpperCase(),
                                            val.toString());
                                        databaseReference
                                            .child("teach_att")
                                            .child(Dateinfo.dept)
                                            .child(Dateinfo.teachname)
                                            .child(_ccontroller.text
                                            .toUpperCase() +
                                            "_" +
                                            _scontroller.text
                                                .toUpperCase())
                                            .set(val.toString());
                                      } else if (stat == "Practical") {
                                        dayc += 2;
                                        weekc += 2;
                                        databaseReference
                                            .child("c_teacher")
                                            .child(Dateinfo.dept)
                                            .child(_ccontroller.text)
                                            .child(stat)
                                            .child(Alert1.batch
                                          ..toUpperCase())
                                            .set({
                                          "passcode": str,
                                          "count": lec.toString(),
                                          "Subject": _scontroller.text
                                              .toUpperCase(),
                                          "Teacher": Dateinfo.teachname
                                        });
                                        databaseReference
                                            .child("Attendance")
                                            .child(Dateinfo.dept)
                                            .child(_ccontroller.text)
                                            .child(_scontroller.text
                                            .toUpperCase())
                                            .child(Dateinfo.teachname)
                                            .child(date)
                                            .child(stat)
                                            .child(
                                            Alert1.batch.toUpperCase())
                                            .child("practcount")
                                            .set(lec.toString());

                                        databaseReference
                                            .child("Attendance")
                                            .child(Dateinfo.dept)
                                            .child(_ccontroller.text)
                                            .child(_scontroller.text
                                            .toUpperCase())
                                            .child(Dateinfo.teachname)
                                            .child(date)
                                            .child(stat)
                                            .child(
                                            Alert1.batch.toUpperCase())
                                            .child(lec.toString())
                                            .child("a_total")
                                            .set("0");
                                        var varcount = prefs
                                            .getString(_ccontroller.text
                                            .toUpperCase() +
                                            "_" +
                                            _scontroller.text
                                                .toUpperCase() +
                                            "_" +
                                            Alert1.batch.toUpperCase())
                                            .split(" ");
                                        String val =
                                            (int.parse(varcount[0]) + 1)
                                                .toString() +
                                                " " +
                                                (int.parse(varcount[1]) +
                                                    1)
                                                    .toString();
                                        defaulercount =
                                            int.parse(varcount[0]) + 1;
                                        defaulter(_ccontroller.text,
                                            _scontroller.text);
                                        try {
                                          String valu;
                                          await databaseReference
                                              .child("week_tt")
                                              .child(Dateinfo.dept)
                                              .child(monthNames[
                                          now.month - 1])
                                              .child(weekno.toString())
                                              .child(_ccontroller.text)
                                              .child(weekNames[
                                          now.weekday - 1])
                                              .child(_ncontroller.text +
                                              " " +
                                              "lec")
                                              .once()
                                              .then((snap) {
                                            valu = snap.value;
                                          });
                                          databaseReference
                                              .child("week_tt")
                                              .child(Dateinfo.dept)
                                              .child(monthNames[
                                          now.month - 1])
                                              .child(weekno.toString())
                                              .child(_ccontroller.text)
                                              .child(weekNames[
                                          now.weekday - 1])
                                              .child(_ncontroller.text +
                                              " " +
                                              "lec")
                                              .set(valu +
                                              "(" +
                                              Dateinfo.teachname +
                                              " class:" +
                                              _ccontroller.text +
                                              " sub:" +
                                              _scontroller.text +
                                              " batch:" +
                                              Alert1.batch +
                                              ")");
//
                                        } catch (Exception) {
                                          databaseReference
                                              .child("week_tt")
                                              .child(Dateinfo.dept)
                                              .child(monthNames[
                                          now.month - 1])
                                              .child(weekno.toString())
                                              .child(_ccontroller.text)
                                              .child(weekNames[
                                          now.weekday - 1])
                                              .child(_ncontroller.text +
                                              " " +
                                              "lec")
                                              .set("(" +
                                              Dateinfo.teachname +
                                              " class:" +
                                              _ccontroller.text +
                                              " sub:" +
                                              _scontroller.text +
                                              " batch:" +
                                              Alert1.batch +
                                              ")");
                                        }

                                        prefs.setString(
                                            _ccontroller.text
                                                .toUpperCase() +
                                                "_" +
                                                _scontroller.text +
                                                "_" +
                                                Alert1.batch.toUpperCase(),
                                            val.toString());
                                        databaseReference
                                            .child("teach_att")
                                            .child(Dateinfo.dept)
                                            .child(Dateinfo.teachname)
                                            .child(_ccontroller.text
                                            .toUpperCase() +
                                            "_" +
                                            _scontroller.text
                                                .toUpperCase() +
                                            "_" +
                                            Alert1.batch.toUpperCase())
                                            .set(prefs.getString(
                                            _ccontroller.text
                                                .toUpperCase() +
                                                "_" +
                                                _scontroller.text
                                                    .toUpperCase() +
                                                "_" +
                                                Alert1.batch
                                                    .toUpperCase()));
                                      } else {
                                        dayc += 1;
                                        weekc += 1;
                                        databaseReference
                                            .child("c_teacher")
                                            .child(Dateinfo.dept)
                                            .child(_ccontroller.text)
                                            .child(stat)
                                            .child(
                                            Alert1.batch.toUpperCase())
                                            .set({
                                          "passcode": str,
                                          "count": lec.toString(),
                                          "Subject": _scontroller.text
                                              .toUpperCase(),
                                          "Teacher": Dateinfo.teachname
                                        });
                                        databaseReference
                                            .child("Attendance")
                                            .child(Dateinfo.dept)
                                            .child(_ccontroller.text)
                                            .child(_scontroller.text
                                            .toUpperCase())
                                            .child(Dateinfo.teachname)
                                            .child(date)
                                            .child(stat)
                                            .child(
                                            Alert1.batch.toUpperCase())
                                            .child("tutcount")
                                            .set(lec.toString());

                                        databaseReference
                                            .child("Attendance")
                                            .child(Dateinfo.dept)
                                            .child(_ccontroller.text)
                                            .child(_scontroller.text
                                            .toUpperCase())
                                            .child(Dateinfo.teachname)
                                            .child(date)
                                            .child(stat)
                                            .child(
                                            Alert1.batch.toUpperCase())
                                            .child(lec.toString())
                                            .child("a_total")
                                            .set("0");
                                        var varcount = prefs
                                            .getString(_ccontroller.text
                                            .toUpperCase() +
                                            "_" +
                                            _scontroller.text
                                                .toUpperCase() +
                                            "_" +
                                            Alert1.batch
                                                .toUpperCase() +
                                            "_Tutorial")
                                            .split(" ");
                                        String val =
                                            (int.parse(varcount[0]) + 1)
                                                .toString() +
                                                " " +
                                                (int.parse(varcount[1]) +
                                                    1)
                                                    .toString();
                                        defaulercount =
                                            int.parse(varcount[0]) + 1;
                                        defaulter(_ccontroller.text,
                                            _scontroller.text);
                                        try {
                                          String valu;
                                          await databaseReference
                                              .child("week_tt")
                                              .child(Dateinfo.dept)
                                              .child(monthNames[
                                          now.month - 1])
                                              .child(weekno.toString())
                                              .child(_ccontroller.text)
                                              .child(weekNames[
                                          now.weekday - 1])
                                              .child(_ncontroller.text +
                                              " " +
                                              "lec")
                                              .once()
                                              .then((snap) {
                                            if (snap.value == null)
                                              throw Exception;
                                            valu = snap.value;
                                          });
                                          databaseReference
                                              .child("week_tt")
                                              .child(Dateinfo.dept)
                                              .child(monthNames[
                                          now.month - 1])
                                              .child(weekno.toString())
                                              .child(_ccontroller.text)
                                              .child(weekNames[
                                          now.weekday - 1])
                                              .child(_ncontroller.text +
                                              " " +
                                              "lec")
                                              .set(valu +
                                              "(" +
                                              Dateinfo.teachname +
                                              " class:" +
                                              _ccontroller.text +
                                              " sub:" +
                                              _scontroller.text +
                                              " batch:" +
                                              Alert1.batch +
                                              " tut)");
                                        } catch (Exception) {
                                          databaseReference
                                              .child("week_tt")
                                              .child(Dateinfo.dept)
                                              .child(monthNames[
                                          now.month - 1])
                                              .child(weekno.toString())
                                              .child(_ccontroller.text)
                                              .child(weekNames[
                                          now.weekday - 1])
                                              .child(_ncontroller.text +
                                              " " +
                                              "lec")
                                              .set("(" +
                                              Dateinfo.teachname +
                                              " class:" +
                                              _ccontroller.text +
                                              " sub:" +
                                              _scontroller.text +
                                              " batch:" +
                                              Alert1.batch +
                                              " tut)");
                                        }

                                        prefs.setString(
                                            _ccontroller.text
                                                .toUpperCase() +
                                                "_" +
                                                _scontroller.text +
                                                "_" +
                                                Alert1.batch
                                                    .toUpperCase() +
                                                "_Tutorial",
                                            val.toString());
                                        databaseReference
                                            .child("teach_att")
                                            .child(Dateinfo.dept)
                                            .child(Dateinfo.teachname)
                                            .child(_ccontroller.text
                                            .toUpperCase() +
                                            "_" +
                                            _scontroller.text
                                                .toUpperCase() +
                                            "_" +
                                            Alert1.batch
                                                .toUpperCase() +
                                            "_Tutorial")
                                            .set(prefs.getString(
                                            _ccontroller.text
                                                .toUpperCase() +
                                                "_" +
                                                _scontroller.text
                                                    .toUpperCase() +
                                                "_" +
                                                Alert1.batch
                                                    .toUpperCase() +
                                                "_Tutorial"));
                                      }

                                      prefs.setInt("dayc", dayc);
                                      prefs.setInt("weekc", weekc);
                                      databaseReference
                                          .child("week_tt")
                                          .child(Dateinfo.dept)
                                          .child(
                                          monthNames[now.month - 1])
                                          .child(weekno.toString())
                                          .child("teacher_report")
                                          .child(Dateinfo.teachname)
                                          .child(
                                          weekNames[now.weekday - 1])
                                          .set(dayc.toString() +
                                          "/" +
                                          exdayc.toString());
                                      databaseReference
                                          .child("week_tt")
                                          .child(Dateinfo.dept)
                                          .child(
                                          monthNames[now.month - 1])
                                          .child(weekno.toString())
                                          .child("teacher_report")
                                          .child(Dateinfo.teachname)
                                          .child("ztotal")
                                          .set((100 * (weekc / exweekc))
                                          .toStringAsFixed(2) +
                                          "%");
                                      databaseReference
                                          .child("Registration")
                                          .child('Teacher_account')
                                          .child(Dateinfo.email)
                                          .child("work_hr")
                                          .set({
                                        "dayc": dayc,
                                        "weekc": weekc,
                                        "date": date.toString(),
                                        "weekno": weekno
                                      });
                                      databaseReference
                                          .child("Registration")
                                          .child('Teacher_account')
                                          .child(Dateinfo.email)
                                          .child("slot")
                                          .child(_ncontroller.text+"h")
                                          .set(1);
                                    }
                                    // _start=40;
                                  }
                                      : null,
                                  color: butclr,
                                  //Color(0xff996600),
                                  child: new Text("Passcode",
                                      style: TextStyle(
                                          fontFamily: 'BalooChettan2',
                                          color: HexColor.fromHex("#ffffff"),
                                          fontSize:
                                          2.4 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.bold)),
                                ), //For
                                // got password button
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 3 * SizeConfig.heightMultiplier,
                              //  horizontal: 5 * SizeConfig.widthMultiplier),
                            ),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Text("Attendees count:  ",
                                        style: TextStyle(
                                            fontFamily: 'BalooChettan2',
                                            color: lefttxtclr,
                                            fontSize:
                                            2.8 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.bold)),
                                    new Text(
                                      att_cnt,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontFamily: 'BalooChettan2',
                                          color: righttxtclr,
                                          fontSize:
                                          2.8 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    back: new GradientCard(
                      margin: new EdgeInsets.only(
                        left: 5 * SizeConfig.widthMultiplier,
                        right: 5 * SizeConfig.widthMultiplier,
                        top: 1 * SizeConfig.heightMultiplier,
                      ),
                      elevation: 5.0,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        // stops: [0,0.5,1],
                        colors: [
                          //HexColor.fromHex("#DAD299"),
                          // HexColor.fromHex("#B0DAB9"),
                          HexColor.fromHex("#DAD299"),
                          HexColor.fromHex("#DAD299")
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 3 * SizeConfig.widthMultiplier,
                                bottom: 1.2 * SizeConfig.heightMultiplier),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Self",
                                  style: TextStyle(
                                      fontSize: 2.5 * SizeConfig.textMultiplier,
                                      color: HexColor.fromHex("#00004d"),
                                      fontWeight: FontWeight.bold),
                                ),
                                Switch(
                                  value: isSwitched,
                                  onChanged: (value) {
                                    setState(() {
                                      if (enabled) {
                                        isSwitched = value;
                                        cardKey.currentState.toggleCard();
                                      }
                                    });
                                  },
                                  activeTrackColor: Colors.black45,
                                  activeColor: Colors.black87,
                                  inactiveThumbColor: Colors.black87,
                                ),
                                Text(
                                  "Adjusted",
                                  style: TextStyle(
                                      fontSize: 2.5 * SizeConfig.textMultiplier,
                                      color: HexColor.fromHex("#00004d"),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Radio(
                                activeColor: HexColor.fromHex("#996600"),
                                value: 0,
                                groupValue: group,
                                onChanged: _handleRadioValueChange1,
                              ),
                              new Text(
                                'Theory',
                                style: TextStyle(
                                    fontSize: 2.2 * SizeConfig.textMultiplier,
                                    color: HexColor.fromHex("#00004d"),
                                    fontWeight: FontWeight.bold),
                              ),
                              // new Padding(padding: EdgeInsets.only(left: 10)),
                              new Radio(
                                activeColor: HexColor.fromHex("#996600"),
                                value: 1,
                                groupValue: group,
                                onChanged: _handleRadioValueChange1,
                              ),
                              new Padding(
                                  padding: EdgeInsets.only(
                                      left: 2 * SizeConfig.widthMultiplier)),
                              new Text(
                                'Practical',
                                style: TextStyle(
                                    fontSize: 2.2 * SizeConfig.textMultiplier,
                                    color: HexColor.fromHex("#00004d"),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: 2 * SizeConfig.heightMultiplier,
                              //  left: 23 * SizeConfig.widthMultiplier
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Radio(
                                  activeColor: HexColor.fromHex("#996600"),
                                  value: 2,
                                  groupValue: group,
                                  onChanged: _handleRadioValueChange1,
                                ),
                                new Text(
                                  'Tutorial',
                                  style: TextStyle(
                                      fontSize: 2.2 * SizeConfig.textMultiplier,
                                      color: HexColor.fromHex("#00004d"),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                                trackHeight:3,
                                inactiveTickMarkColor: lefttxtclr,
                                valueIndicatorColor: Colors.blue,
                                activeTickMarkColor: lefttxtclr,
                                valueIndicatorTextStyle: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold)
                            ),
                            child: Slider(
                                activeColor: Color(0xff999966),
                                inactiveColor: Color(0xffc2c2a3),
                                // valueIndicatorColor: Colors.blue,
                                label: (arating.toInt()).toString(),
                                value: arating,

                                divisions: 8,
                                min: 0,
                                max:8,
                                onChanged: enabled ?(newrating){
                                  setState(() {
                                    arating=newrating;
                                    _controller.text=arating.toInt().toString();
                                  });
                                }
                                    :null
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 1 * SizeConfig.heightMultiplier,
                              // left: 7 * SizeConfig.widthMultiplier
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Enter work hour:",
                                  style: TextStyle(
                                      fontSize: 2.2 * SizeConfig.textMultiplier,
                                      color: HexColor.fromHex("#00004d"),
                                      fontWeight: FontWeight.bold),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(
                                      left: 4 * SizeConfig.widthMultiplier),
                                ),
                                new Flexible(
                                  child: Container(
                                      width: 22 * SizeConfig.widthMultiplier,
                                      child: TextFormField(
                                          focusNode: focusNode1,
                                          enableSuggestions: true,
                                          controller: _controller,
                                          style: TextStyle(
                                              fontFamily: 'BalooChettan2',
                                              color: righttxtclr,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 2.2 *
                                                  SizeConfig.heightMultiplier),
                                          cursorColor: righttxtclr,
                                          decoration: new InputDecoration(
                                              fillColor: Colors.white,
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                borderSide: BorderSide(
                                                    width: 2,
                                                    color: HexColor.fromHex(
                                                        "#ffffff")),
                                              ),
                                              contentPadding: EdgeInsets.only(
                                                  left: 5 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  right: 5 *
                                                      SizeConfig
                                                          .widthMultiplier),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 2,
                                                      color: HexColor.fromHex(
                                                          "#ffffff")),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      10.00)),
                                              labelText: "Enter",
                                              labelStyle: new TextStyle(
                                                  color: HexColor.fromHex(
                                                      "#00004d"),
                                                  fontSize: 2.2 *
                                                      SizeConfig
                                                          .textMultiplier)),
                                          keyboardType: TextInputType.phone,
                                          //validator: validateEmail,
                                          enabled: enabled,
                                          onChanged: (val) {
                                            setState(() {
                                              if(int.parse(val)>8){
                                                arating=8.0;
                                              }else{
                                                arating=double.parse(val);
                                              }
                                            });

                                          })),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 4 * SizeConfig.heightMultiplier,
                              //  left: 7 * SizeConfig.widthMultiplier
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Select Class:",
                                  style: TextStyle(
                                      fontSize: 2.2 * SizeConfig.textMultiplier,
                                      color: HexColor.fromHex("#00004d"),
                                      fontWeight: FontWeight.bold),
                                ),
                                new Padding(
                                    padding: EdgeInsets.only(
                                        left: 6 * SizeConfig.widthMultiplier)),
                                Container(
                                  height: 4.9 * SizeConfig.heightMultiplier,
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                      3.1 * SizeConfig.widthMultiplier,
                                      vertical:
                                      0.7 * SizeConfig.heightMultiplier),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: new IgnorePointer(
                                    ignoring: drop,
                                    child: DropdownButton<String>(
                                      iconEnabledColor: righttxtclr,
                                      items: classlist.map((String listvalue) {
                                        return DropdownMenuItem<String>(
                                          value: listvalue,
                                          child: Text(
                                            listvalue,
                                            style: TextStyle(
                                                fontSize: 2 *
                                                    SizeConfig.textMultiplier,
                                                color: righttxtclr,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          classs = val;
                                          subjectlist.clear();
                                          sub = "Subject";
                                          subjectlist = ["Subject"];
                                          if (!(stat == "Status" &&
                                              sub == "Subject")) {
                                            subjectlist.addAll(
                                                prefs.getStringList(
                                                    classs + "_" + stat[0]));
                                          }
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                        });
                                      },
                                      value: classs,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 3.5 * SizeConfig.heightMultiplier,
                              // left: 7 * SizeConfig.widthMultiplier
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Select Subject:",
                                  style: TextStyle(
                                      fontSize: 2.2 * SizeConfig.textMultiplier,
                                      color: HexColor.fromHex("#00004d"),
                                      fontWeight: FontWeight.bold),
                                ),
                                new Padding(
                                    padding: EdgeInsets.only(
                                        left: 6 * SizeConfig.widthMultiplier)),
                                Container(
                                  height: 4.9 * SizeConfig.heightMultiplier,
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                      3.1 * SizeConfig.widthMultiplier,
                                      vertical:
                                      0.7 * SizeConfig.heightMultiplier),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: new IgnorePointer(
                                    ignoring: drop,
                                    child: DropdownButton<String>(
                                      iconEnabledColor: righttxtclr,
                                      items:
                                      subjectlist.map((String listvalue) {
                                        return DropdownMenuItem<String>(
                                          value: listvalue,
                                          child: Text(
                                            listvalue,
                                            style: TextStyle(
                                                fontSize: 2 *
                                                    SizeConfig.textMultiplier,
                                                color: righttxtclr,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        setState(() => sub = val);
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                      },
                                      value: sub,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: dist,
                                top: 4 * SizeConfig.heightMultiplier),
                            child: Column(
                              children: <Widget>[
                                new RaisedButton(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(80.00)),
                                  splashColor: HexColor.fromHex("#ffffff"),
                                  disabledColor: Color(0xffff9999),
                                  onPressed: enabled
                                      ? () async {
                                    prefs = await SharedPreferences
                                        .getInstance();
                                    var slot=prefs.getStringList("slot");

                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    var rng = new Random();
                                    code = code +
                                        rng.nextInt(20000) +
                                        rng.nextInt(30000);
                                    if (classs == "Class" ||
                                        sub == "Subject" ||
                                        stat == "Status" ||
                                        _controller.text == "") {
                                      Fluttertoast.showToast(
                                          msg: "fill all fields",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else if((slot.contains(_controller.text+"h"))){
                                      bool click=true;
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

                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "ok",
                                              style: TextStyle(color: Colors.white, fontSize: 2.5*SizeConfig.textMultiplier),
                                            ),
                                            onPressed:click? (){ Navigator.pop(context);
                                            setState(() {
                                              click=false;
                                            });
                                            }:null,
                                            gradient: LinearGradient(colors: [
                                              Color(0xffe63900),
                                              Color(0xffe63900)
                                            ]),
                                          )
                                        ],
                                      ).show();

                                    }else{
                                      radio_on = false;
                                      setState(() {
                                        clr = Color(0xffff9999);
                                        str = code.toString();
                                        card = "back";
                                      });
                                      //var slot=prefs.getStringList("slot");
                                      slot.add(_controller.text+"h");
                                      prefs.setStringList("slot",slot);
                                      startTimer();
                                      drop = true;
                                      var now = new DateTime.now();
                                      String date = ford.format(now);

                                      Dateinfo.classs = classs;
                                      Dateinfo.subject = sub;
                                      Dateinfo.date1 = date;
                                      Dateinfo.stat = stat;
                                      databaseReference
                                          .child('c_teacher')
                                          .child(Dateinfo.dept)
                                          .child(classs)
                                          .child("status")
                                          .set(stat);
                                      setState(() {
                                        user.classs = classs;
                                        user.sub = sub.toUpperCase();
                                        user.date = date;
                                        user.lec = lec.toString();
                                        user.stat = stat;
                                      });
                                      int current = DateTime.utc(
                                          now.year, now.month, 1)
                                          .weekday;
                                      int weekno = 0;
                                      int i = 9 - current;
                                      for (; i < 30; i += 7) {
                                        weekno += 1;
                                        if (now.day < i) {
                                          break;
                                        }
                                      }
                                      int dayc = prefs.getInt("dayc");
                                      int weekc = prefs.getInt("weekc");
                                      if (stat == "lecture") {
                                        dayc += 1;
                                        weekc += 1;
                                        workhr(classs, sub);
                                        databaseReference
                                            .child("Attendance")
                                            .child(Dateinfo.dept)
                                            .child(classs)
                                            .child(sub.toUpperCase())
                                            .child(Dateinfo.teachname)
                                            .child(date)
                                            .child(stat)
                                            .child("leccount")
                                            .set(lec.toString());
                                        databaseReference
                                            .child("Attendance")
                                            .child(Dateinfo.dept)
                                            .child(classs)
                                            .child(sub.toUpperCase())
                                            .child(Dateinfo.teachname)
                                            .child(date)
                                            .child(stat)
                                            .child(lec.toString())
                                            .child("a_total")
                                            .set("0");

                                        databaseReference
                                            .child("c_teacher")
                                            .child(Dateinfo.dept)
                                            .child(classs)
                                            .child(stat)
                                            .set({
                                          "passcode": str,
                                          "count": lec,
                                          "Subject": sub.toUpperCase(),
                                          "Teacher": Dateinfo.teachname
                                        });
                                        var varcount = prefs
                                            .getString(
                                            classs.toUpperCase() +
                                                "_" +
                                                sub.toUpperCase())
                                            .split(" ");

                                        String val =
                                            (int.parse(varcount[0]) + 1)
                                                .toString() +
                                                " " +
                                                (int.parse(varcount[1]) +
                                                    1)
                                                    .toString();
                                        defaulercount =
                                            int.parse(varcount[0]) + 1;
                                        defaulter(classs.toString(),
                                            sub.toString());
                                        databaseReference
                                            .child("week_tt")
                                            .child(Dateinfo.dept)
                                            .child(
                                            monthNames[now.month - 1])
                                            .child(weekno.toString())
                                            .child(classs)
                                            .child(weekNames[
                                        now.weekday - 1])
                                            .child(_controller.text +
                                            " " +
                                            "lec")
                                            .set("Adj " +
                                            Dateinfo.teachname +
                                            " class:" +
                                            classs +
                                            " sub:" +
                                            sub.toUpperCase());

                                        await prefs.setString(
                                            classs.toUpperCase() +
                                                "_" +
                                                sub.toUpperCase(),
                                            val.toString());

                                        databaseReference
                                            .child("teach_att")
                                            .child(Dateinfo.dept)
                                            .child(Dateinfo.teachname)
                                            .child(classs.toUpperCase() +
                                            "_" +
                                            sub.toUpperCase())
                                            .set(val.toString());
                                      } else if (stat == "Practical") {
                                        Alert1.check = true;
                                        Dateinfo.batches.clear();
                                        Dateinfo.batches =
                                            prefs.getStringList(
                                                Dateinfo.subject);
                                        await Alert1.dialog(context);

                                        dayc += 2;
                                        weekc += 2;
                                        workhr(classs, sub);
                                        databaseReference
                                            .child("c_teacher")
                                            .child(Dateinfo.dept)
                                            .child(classs)
                                            .child(stat)
                                            .child(Alert1.batch
                                          ..toUpperCase())
                                            .set({
                                          "passcode": str,
                                          "count": lec.toString(),
                                          "Subject": sub.toUpperCase(),
                                          "Teacher": Dateinfo.teachname
                                        });
                                        databaseReference
                                            .child("Attendance")
                                            .child(Dateinfo.dept)
                                            .child(classs)
                                            .child(sub.toUpperCase())
                                            .child(Dateinfo.teachname)
                                            .child(date)
                                            .child(stat)
                                            .child(
                                            Alert1.batch.toUpperCase())
                                            .child("practcount")
                                            .set(lec.toString());

                                        databaseReference
                                            .child("Attendance")
                                            .child(Dateinfo.dept)
                                            .child(classs)
                                            .child(sub.toUpperCase())
                                            .child(Dateinfo.teachname)
                                            .child(date)
                                            .child(stat)
                                            .child(
                                            Alert1.batch.toUpperCase())
                                            .child(lec.toString())
                                            .child("a_total")
                                            .set("0");
                                        var varcount = prefs
                                            .getString(classs
                                            .toUpperCase() +
                                            "_" +
                                            sub.toUpperCase() +
                                            "_" +
                                            Alert1.batch.toUpperCase())
                                            .split(" ");
                                        String val =
                                            (int.parse(varcount[0]) + 1)
                                                .toString() +
                                                " " +
                                                (int.parse(varcount[1]) +
                                                    1)
                                                    .toString();
                                        defaulercount =
                                            int.parse(varcount[0]) + 1;
                                        defaulter(classs.toString(),
                                            sub.toString());
                                        try {
                                          String valu;
                                          print("df");
                                          await databaseReference
                                              .child("week_tt")
                                              .child(Dateinfo.dept)
                                              .child(monthNames[
                                          now.month - 1]
                                              .toString())
                                              .child(weekno.toString())
                                              .child(classs)
                                              .child(weekNames[
                                          now.weekday - 1]
                                              .toString())
                                              .child(_controller.text
                                              .toString() +
                                              " " +
                                              "lec")
                                              .once()
                                              .then((snap) {
                                            print(snap.value);
                                            valu = snap.value;
                                          });
//                                          if (map.containsKey(_controller.text)) {
//                                            String val = map[_controller.text];
                                          print(val);
                                          databaseReference
                                              .child("week_tt")
                                              .child(Dateinfo.dept)
                                              .child(monthNames[
                                          now.month - 1])
                                              .child(weekno.toString())
                                              .child(classs)
                                              .child(weekNames[
                                          now.weekday - 1])
                                              .child(_controller.text +
                                              " " +
                                              "lec")
                                              .set(valu +
                                              "(Adj " +
                                              Dateinfo.teachname +
                                              " class:" +
                                              classs +
                                              " sub:" +
                                              sub +
                                              " batch:" +
                                              Alert1.batch +
                                              ")");
                                        } catch (Exception) {
                                          databaseReference
                                              .child("week_tt")
                                              .child(Dateinfo.dept)
                                              .child(monthNames[
                                          now.month - 1])
                                              .child(weekno.toString())
                                              .child(classs)
                                              .child(weekNames[
                                          now.weekday - 1])
                                              .child(_controller.text +
                                              " " +
                                              "lec")
                                              .set("(Adj " +
                                              Dateinfo.teachname +
                                              " class:" +
                                              classs +
                                              " sub:" +
                                              sub +
                                              " batch:" +
                                              Alert1.batch +
                                              ")");
                                        }

                                        prefs.setString(
                                            classs.toUpperCase() +
                                                "_" +
                                                sub +
                                                "_" +
                                                Alert1.batch.toUpperCase(),
                                            val.toString());
                                        databaseReference
                                            .child("teach_att")
                                            .child(Dateinfo.dept)
                                            .child(Dateinfo.teachname)
                                            .child(classs.toUpperCase() +
                                            "_" +
                                            sub.toUpperCase() +
                                            "_" +
                                            Alert1.batch.toUpperCase())
                                            .set(prefs.getString(
                                            classs.toUpperCase() +
                                                "_" +
                                                sub.toUpperCase() +
                                                "_" +
                                                Alert1.batch
                                                    .toUpperCase()));
                                      } else {
                                        Alert1.check = true;
                                        Alert1.inputlec = false;
                                        Dateinfo.batches.clear();
                                        Dateinfo.batches =
                                            prefs.getStringList(
                                                Dateinfo.subject + "T");
                                        await Alert1.dialog(context);

                                        dayc += 1;
                                        weekc += 1;
                                        workhr(classs, sub);
                                        databaseReference
                                            .child("c_teacher")
                                            .child(Dateinfo.dept)
                                            .child(classs)
                                            .child(stat)
                                            .child(Alert1.batch
                                          ..toUpperCase())
                                            .set({
                                          "passcode": str,
                                          "count": lec.toString(),
                                          "Subject": sub.toUpperCase(),
                                          "Teacher": Dateinfo.teachname
                                        });
                                        databaseReference
                                            .child("Attendance")
                                            .child(Dateinfo.dept)
                                            .child(classs)
                                            .child(sub.toUpperCase())
                                            .child(Dateinfo.teachname)
                                            .child(date)
                                            .child(stat)
                                            .child(
                                            Alert1.batch.toUpperCase())
                                            .child("tutcount")
                                            .set(lec.toString());

                                        databaseReference
                                            .child("Attendance")
                                            .child(Dateinfo.dept)
                                            .child(classs)
                                            .child(sub.toUpperCase())
                                            .child(Dateinfo.teachname)
                                            .child(date)
                                            .child(stat)
                                            .child(
                                            Alert1.batch.toUpperCase())
                                            .child(lec.toString())
                                            .child("a_total")
                                            .set("0");
                                        var varcount = prefs
                                            .getString(
                                            classs.toUpperCase() +
                                                "_" +
                                                sub.toUpperCase() +
                                                "_" +
                                                Alert1.batch
                                                    .toUpperCase() +
                                                "_Tutorial")
                                            .split(" ");
                                        String val =
                                            (int.parse(varcount[0]) + 1)
                                                .toString() +
                                                " " +
                                                (int.parse(varcount[1]) +
                                                    1)
                                                    .toString();
                                        defaulercount =
                                            int.parse(varcount[0]) + 1;
                                        defaulter(classs.toString(),
                                            sub.toString());
                                        try {
                                          String valu;
                                          print("df");
                                          await databaseReference
                                              .child("week_tt")
                                              .child(Dateinfo.dept)
                                              .child(monthNames[
                                          now.month - 1]
                                              .toString())
                                              .child(weekno.toString())
                                              .child(classs)
                                              .child(weekNames[
                                          now.weekday - 1]
                                              .toString())
                                              .child(_controller.text
                                              .toString() +
                                              " " +
                                              "lec")
                                              .once()
                                              .then((snap) {
                                            print(snap.value);
                                            valu = snap.value;
                                            if (valu == null)
                                              throw Exception;
                                          });
//                                          if (map.containsKey(_controller.text)) {
//                                            String val = map[_controller.text];
                                          print(val);
                                          databaseReference
                                              .child("week_tt")
                                              .child(Dateinfo.dept)
                                              .child(monthNames[
                                          now.month - 1])
                                              .child(weekno.toString())
                                              .child(classs)
                                              .child(weekNames[
                                          now.weekday - 1])
                                              .child(_controller.text +
                                              " " +
                                              "lec")
                                              .set(valu +
                                              "(Adj " +
                                              Dateinfo.teachname +
                                              " class:" +
                                              classs +
                                              " sub:" +
                                              sub +
                                              " batch:" +
                                              Alert1.batch +
                                              " tut)");
                                        } catch (Exception) {
                                          databaseReference
                                              .child("week_tt")
                                              .child(Dateinfo.dept)
                                              .child(monthNames[
                                          now.month - 1])
                                              .child(weekno.toString())
                                              .child(classs)
                                              .child(weekNames[
                                          now.weekday - 1])
                                              .child(_controller.text +
                                              " " +
                                              "lec")
                                              .set("(Adj " +
                                              Dateinfo.teachname +
                                              " class:" +
                                              classs +
                                              " sub:" +
                                              sub +
                                              " batch:" +
                                              Alert1.batch +
                                              " tut)");
                                        }

                                        prefs.setString(
                                            classs.toUpperCase() +
                                                "_" +
                                                sub +
                                                "_" +
                                                Alert1.batch
                                                    .toUpperCase() +
                                                "_Tutorial",
                                            val.toString());
                                        databaseReference
                                            .child("teach_att")
                                            .child(Dateinfo.dept)
                                            .child(Dateinfo.teachname)
                                            .child(classs.toUpperCase() +
                                            "_" +
                                            sub.toUpperCase() +
                                            "_" +
                                            Alert1.batch
                                                .toUpperCase() +
                                            "_Tutorial")
                                            .set(prefs.getString(
                                            classs.toUpperCase() +
                                                "_" +
                                                sub.toUpperCase() +
                                                "_" +
                                                Alert1.batch
                                                    .toUpperCase() +
                                                "_Tutorial"));
//
                                      }
                                      prefs.setInt("dayc", dayc);
                                      prefs.setInt("weekc", weekc);
                                      databaseReference
                                          .child("week_tt")
                                          .child(Dateinfo.dept)
                                          .child(
                                          monthNames[now.month - 1])
                                          .child(weekno.toString())
                                          .child("teacher_report")
                                          .child(Dateinfo.teachname)
                                          .child(
                                          weekNames[now.weekday - 1])
                                          .set(dayc.toString() +
                                          "/" +
                                          exdayc.toString());
                                      databaseReference
                                          .child("week_tt")
                                          .child(Dateinfo.dept)
                                          .child(
                                          monthNames[now.month - 1])
                                          .child(weekno.toString())
                                          .child("teacher_report")
                                          .child(Dateinfo.teachname)
                                          .child("ztotal")
                                          .set((100 * (weekc / exweekc))
                                          .toStringAsFixed(2) +
                                          "%");
                                      databaseReference
                                          .child("Registration")
                                          .child('Teacher_account')
                                          .child(Dateinfo.email)
                                          .child("work_hr")
                                          .set({
                                        "dayc": dayc,
                                        "weekc": weekc,
                                        "date": date.toString(),
                                        "weekno": weekno
                                      });
                                      databaseReference
                                          .child("Registration")
                                          .child('Teacher_account')
                                          .child(Dateinfo.email)
                                          .child("slot")
                                          .child(_controller.text+"h")
                                          .set(1);
                                    }
                                    // _start=40;
                                  }
                                      : null,
                                  color: butclr,
                                  //Color(0xff996600),
                                  child: new Text("Passcode",
                                      style: TextStyle(
                                          fontFamily: 'BalooChettan2',
                                          color: HexColor.fromHex("#ffffff"),
                                          fontSize:
                                          2.4 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.bold)),
                                ), //For
                                // got password button
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 2 * SizeConfig.heightMultiplier),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Text("Attendees count:  ",
                                        style: TextStyle(
                                            fontFamily: 'BalooChettan2',
                                            color: HexColor.fromHex("#00004d"),
                                            fontSize:
                                            2.8 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.bold)),
                                    new Text(
                                      att_cnt,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontFamily: 'BalooChettan2',
                                          color: righttxtclr,
                                          fontSize:
                                          2.8 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //new Padding(padding: EdgeInsets.only(bottom: 60))
                // new Padding(padding: EdgeInsets.only(bottom:8*SizeConfig.heightMultiplier))
              ],
            ),
          )),
    );
  }

  void _handleRadioValueChange1(value) {
    if (radio_on == true) {
      if (value == 0) {
        setState(() {
          group = 0;
          stat = "lecture";
          classlist.clear();
          classlist = ["Class"];
          subjectlist.clear();
          subjectlist = ["Subject"];
          classs = "Class";
          sub = "Subject";
          if (!(stat == "Status") && classs == "Class")
            classlist.addAll(prefs.getStringList(stat));
        });
      } else if (value == 1) {
        setState(() {
          group = 1;
          stat = "Practical";
          classlist.clear();
          classlist = ["Class"];
          subjectlist.clear();
          subjectlist = ["Subject"];
          classs = "Class";
          sub = "Subject";
          if (!(stat == "Status") && classs == "Class")
            classlist.addAll(prefs.getStringList(stat));
        });
      } else {
        setState(() {
          group = 2;
          stat = "Tutorial";
          classlist.clear();
          classlist = ["Class"];
          subjectlist.clear();
          subjectlist = ["Subject"];
          classs = "Class";
          sub = "Subject";
          if (!(stat == "Status") && classs == "Class")
            classlist.addAll(prefs.getStringList(stat));
          print("Tutorial class list:" + classlist.toString());
        });
      }
    }
  }

//  Future<void> handleClick(String value) async {
//    if (enabled) {
//      switch (value) {
//
//        case 'Monitor session':
//          {
//            Dateinfo.fetch = true;
//            Dateinfo.viewmod = false;
//            Navigator.pushReplacement(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => Date(),
//                ));
//
//            break;
//          }
////
//      }
//    }
//  }

  void workhr(String classs, String subject) async {
    try{
      if (stat == "lecture") {
        var varcount = prefs
            .getString(classs.toUpperCase() + "_" + subject.toUpperCase())
            .split(" ");
        setState(() {
          lec = (int.parse(varcount[1]) + 1).toString();
          if (!isSwitched) {
            _lcontroller.text = lec;
          }
        });
        //  }
      } else if (stat == "Practical") {
//
        var varcount = prefs
            .getString(classs.toUpperCase() +
            "_" +
            subject.toUpperCase() +
            "_" +
            Alert1.batch.toUpperCase())
            .split(" ");
        setState(() {
          lec = (int.parse(varcount[1]) + 1).toString();
          if (!isSwitched) {
            _lcontroller.text = lec;
          }
        });
        // }
      } else {
//
        var varcount = prefs
            .getString(classs.toUpperCase() +
            "_" +
            subject.toUpperCase() +
            "_" +
            Alert1.batch.toUpperCase() +
            "_Tutorial")
            .split(" ");
        setState(() {
          lec = (int.parse(varcount[1]) + 1).toString();
          if (!isSwitched) {
            _lcontroller.text = lec;
          }
        });
      }
    }catch(Exception){}
  }

  void defaulter(String cl, String subject) async {
//    print(cl);
//    print(subject);
    if (stat == "lecture") {
      FirebaseDatabase.instance
          .reference()
          .child("defaulter")
          .child(Dateinfo.dept)
          .child(cl)
          .child("AATotal")
          .child(subject.toUpperCase() + "_" + Dateinfo.teachname.toUpperCase())
          .set(defaulercount);
    } else if (stat == "Practical") {
      FirebaseDatabase.instance
          .reference()
          .child("defaulter")
          .child(Dateinfo.dept)
          .child(cl)
          .child("AATotal")
          .child(subject.toUpperCase() +
          "_" +
          Dateinfo.teachname.toUpperCase() +
          "_" +
          Alert1.batch)
          .set(defaulercount);
    } else {
      FirebaseDatabase.instance
          .reference()
          .child("defaulter")
          .child(Dateinfo.dept)
          .child(cl)
          .child("AATotal")
          .child(subject.toUpperCase() +
          "_" +
          Dateinfo.teachname.toUpperCase() +
          "_" +
          Alert1.batch +
          "_Tutorial")
          .set(defaulercount);
    }
  }

  void timetable() async {
    int dayn = DateTime.now().weekday - 1;
    String day = weekNames[dayn];

    try {
      var a = prefs.getString(day + _ncontroller.text + "h").split(" ");
      setState(() {
        _ccontroller.text = a[0];
        _scontroller.text = a[1];
        att_cnt="";
        if (a.length == 2) {
          stat = "lecture";
        } else if (a.length == 3) {
          stat = "Practical";
          Alert1.batch = a[2];
        } else {
          stat = "Tutorial";
          Alert1.batch = a[2];
        }
      });
    } catch (Exception) {
      _ccontroller.text = "Class";
      _scontroller.text = "Subject";
      _lcontroller.text = "";
      lec = "";
    }
  }
}

class thome extends StatefulWidget {
  @override
  _thomeState createState() => _thomeState();
}

class _thomeState extends State<thome> with SingleTickerProviderStateMixin {
  dynamic name, email;
  TabController controller;
  dynamic value;
  SharedPreferences prefs;
  ProgressDialog pr;
  Color txtclr;
  DateTime currentBackPressTime;
  Future<String> getname() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      Dateinfo.teachemail = prefs.getString("email");
      Dateinfo.teachname = prefs.getString("name");
      Dateinfo.dept = prefs.getString("dept");
      name = Dateinfo.teachname;
      email = Dateinfo.teachemail;
      Dateinfo.type = prefs.getString("type");
      var e = Dateinfo.teachemail.split("@");
      Dateinfo.email = e[0].toString().replaceAll(new RegExp(r'\W'), "_");
      Alert1.name = e[0].toString().replaceAll(new RegExp(r'\W'), "");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getname();
    controller = new TabController(length: 1, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();

    super.dispose();
  }
  Future<bool> _onbackpressed()async{
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "double tap to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, type: ProgressDialogType.Normal,isDismissible: false);
    pr.style(message: " Wait");
    txtclr = Colors.black;
    List<String> events = [
      "Take Attendance",
      "View/Modify Attendance",
    ];
    return WillPopScope(
      onWillPop: _onbackpressed,
      child: new Scaffold(
        bottomNavigationBar: FancyBottomNavigation(
          initialSelection: 0,
//          notchedShape: CircularNotchedRectangle(),
          activeIconColor:Colors.white ,
          inactiveIconColor:  HexColor.fromHex("#008080"),
          circleColor:  HexColor.fromHex("#008080"),

          tabs: [
            TabData(iconData: Icons.home, title: "Home",),
            TabData(iconData: Icons.local_parking, title: "Parent Teacher"),
            TabData(iconData: Icons.assignment, title: "Remedial hr")
          ],

          onTabChangedListener: (position) {
            setState(() {
              // currentPage = position;
              try {
                if (position == 1) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Parentteacherlist(),
                      ));
                }
                if (position == 2) {
                  //remedial
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => defaulter(),
                      ));
                }
              }catch(Exception){}
            });
          },
        ),
        drawer: Theme(
            data: Theme.of(context).copyWith(
                canvasColor: Colors.white,
                //This will change the drawer background to blue.
                //other styles
                selectedRowColor: Colors.brown.shade300),
            child: Dateinfo.type == "admin"
                ? admindrawer(context)
                : drawer(context)),
        body: Container(
          padding: EdgeInsets.only(
              top: 3 * SizeConfig.heightMultiplier,
              left: 12 * SizeConfig.widthMultiplier,
              right: 12 * SizeConfig.widthMultiplier),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              //stops: [0,0.5,1],
              colors: [
                txtclr, txtclr
                //              HexColor.fromHex("#4dffb8"),
//              HexColor.fromHex("#fff"),
//              HexColor.fromHex("#4dffb8")
              ],
            ),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: 3.8 * SizeConfig.widthMultiplier,
                vertical: 5 * SizeConfig.heightMultiplier),
            width: 114 * SizeConfig.widthMultiplier,
            child: GridView(
              physics: BouncingScrollPhysics(),
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
              children: events.map((title) {
                return GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.black54,
                            blurRadius: 10.0,
                            spreadRadius: -20)
                      ],
                    ),
                    child: Card(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0)),
                      margin: EdgeInsets.symmetric(
                          vertical: 2.5 * SizeConfig.heightMultiplier,
                          horizontal: 5 * SizeConfig.widthMultiplier),
                      child: getCardByTitle(title),
                    ),
                  ),
                  onTap: () async {
                    if (title == "View/Modify Attendance") {
                      if (prefs.getBool("check") == false) {
                        pr.show();
                        await Teacher.data();
                        pr.hide();
                      }
                      Dateinfo.fetch = true;
                      Dateinfo.viewmod = false;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Date(),
                          ));
                    } else {
                      if (prefs.getBool("check") == false) {
                        pr.show();
                        await Teacher.data();
                        pr.hide();
                      }
                      Dateinfo.fetch = true;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Passcode(),
                          ));
                    }
                  },
                );
              }).toList(),
            ),
          ),
        ),
        appBar: new AppBar(
          title: new Text(
            "Homepage",
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 3 * SizeConfig.textMultiplier),
          ),
          backgroundColor: HexColor.fromHex("#008080"),
        ),
      ),
    );
  }

  Column getCardByTitle(String title) {
    String img = '';
    if (title == "View/Modify Attendance")
      img = "assets/view1.png";
    else if (title == "Take Attendance") img = "assets/view.jpg";
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new Center(
          child: Container(
            child: new Stack(
              children: <Widget>[
                new Image.asset(
                  img,
                  width: 45 * SizeConfig.widthMultiplier,
                  height: 15 * SizeConfig.heightMultiplier,
                )
              ],
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(
              fontSize: 3.1 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.bold,
              color: txtclr),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Widget drawer(BuildContext context) {
    double iconsize = 3 * SizeConfig.heightMultiplier;
    double textsize = 2 * SizeConfig.textMultiplier;
    return (Container(
      width: 64 * SizeConfig.widthMultiplier,
      child: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(
                name.toString(),
                style: TextStyle(fontSize: 2.2 * SizeConfig.textMultiplier),
              ),
              accountEmail: new Text(email.toString(),
                  style: TextStyle(fontSize: 2.1 * SizeConfig.textMultiplier)),
              currentAccountPicture: new CircleAvatar(
                radius: 3 * SizeConfig.heightMultiplier,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 8 * SizeConfig.heightMultiplier,
                  color: Colors.black87,
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: new AssetImage("assets/profile.jpg"),
                  fit: BoxFit.cover,
                ),
                //color: HexColor.fromHex("#6d6d46")
              ),
            ),
            Card(
              child: new ListTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 5.0, 0),
                        child: new Icon(
                          Icons.library_books,
                          size: iconsize,
                        ),
                      ),
                      new Text(
                        "Register subject",
                        style: TextStyle(
                            fontSize: textsize, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_right,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => subject(),
                        ));
                  }),
            ),
            // new Divider(),

            Card(
              child: new ListTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 5.0, 0),
                        child: new Icon(
                          Icons.local_parking,
                          size: 2.5 * SizeConfig.heightMultiplier,
                        ),
                      ),
                      new Text(
                        "Parent Teacher",
                        style: TextStyle(
                            fontSize: textsize, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_right,
                    color: Colors.black,
                  ),
                  onTap: () async {
                    pr.show();
                    await parentteachermap();
                    pr.hide();
                    Navigator.pop(context);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Parentteacherlist(),
                        ));
                  }),
            ),
            Card(
              child: new ListTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 5.0, 0),
                        child: new Icon(
                          Icons.edit,
                          size: iconsize,
                        ),
                      ),
                      new Text(
                        "Remedial hr",
                        style: TextStyle(
                            fontSize: textsize, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_right,
                    color: Colors.black,
                  ),
                  onTap: () async {
                    if (prefs.getBool("check") == false) {
                      pr.show();
                      await Teacher.data();
                      pr.hide();
                    }
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => defaulter(),
                        ));
                  }),
            ),

            //new Divider(),
            Card(
              child: new ListTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 5.0, 0),
                        child: new Icon(
                          Icons.settings,
                          size: iconsize,
                        ),
                      ),
                      new Text(
                        "Settings",
                        style: TextStyle(
                            fontSize: textsize, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_right,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => teachprofile(),
                        ));
                  }),
            ),

//            ),
          ],
        ),
      ),
    ));
  }

  Widget admindrawer(BuildContext context) {
    double iconsize = 3 * SizeConfig.heightMultiplier;
    double textsize = 2 * SizeConfig.textMultiplier;
    Color iconclr = Color(0xff008080);
    return (Container(
      width: 64 * SizeConfig.widthMultiplier,
      child: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(
                name.toString(),
                style: TextStyle(fontSize: 2.2 * SizeConfig.textMultiplier),
              ),
              accountEmail: new Text(email.toString(),
                  style: TextStyle(fontSize: 2.1 * SizeConfig.textMultiplier)),
              currentAccountPicture: new CircleAvatar(
                radius: 4 * SizeConfig.heightMultiplier,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 8 * SizeConfig.heightMultiplier,
                  color: Colors.black87,
                ),
              ),
              decoration: BoxDecoration(
//                image: DecorationImage(
//                  image: new AssetImage("assets/profile.jpg"),
//                  fit: BoxFit.cover,
//                ),
                //color: HexColor.fromHex("#6d6d46")
                  color: Colors.black),
            ),
            Card(
              child: new ListTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 15.0, 0),
                        child: new Icon(
                          Icons.library_books,
                          size: iconsize,
                          color: iconclr,
                        ),
                      ),
                      new Text(
                        "Register subject",
                        style: TextStyle(
                            fontSize: textsize, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_right,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => subject(),
                        ));
                  }),
            ),
//            Card(
//              child: new ListTile(
//                  title: Row(
//                    children: <Widget>[
//                      Padding(
//                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 15.0, 0),
//                        child: new Icon(Icons.local_parking,
//                            size: 2.5 * SizeConfig.heightMultiplier,
//                            color: iconclr),
//                      ),
//                      new Text(
//                        "Parent Teacher",
//                        style: TextStyle(
//                            fontSize: textsize, fontWeight: FontWeight.bold),
//                      ),
//                    ],
//                  ),
//                  trailing: Icon(
//                    Icons.arrow_right,
//                    color: Colors.black,
//                  ),
//                  onTap: () async {
////                    pr.show();
////                    await parentteachermap();
////                    pr.hide();
//                    Navigator.pop(context);
//
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                          builder: (context) => Parentteacherlist(),
//                        ));
//                  }),
//            ),
            Card(
              child: new ListTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 15.0, 0),
                        child: new Icon(
                          Icons.search,
                          size: iconsize,
                          color: iconclr,
                        ),
                      ),
                      new Text(
                        "Monitor day",
                        style: TextStyle(
                            fontSize: textsize, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_right,
                    color: Colors.black,
                  ),
                  onTap: Dateinfo.type == "admin"
                      ? () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Monitor(),
                        ));
                  }
                      : () {
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                        msg: "Only for admins",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 2.2 * SizeConfig.textMultiplier);
                  }),
            ),
            // new Divider(),
            Card(
              child: new ListTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 15.0, 0),
                        child: new Icon(
                          Icons.file_upload,
                          size: iconsize,
                          color: iconclr,
                        ),
                      ),
                      new Text(
                        "generate defaulter",
                        style: TextStyle(
                            fontSize: textsize, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_right,
                    color: Colors.black,
                  ),
                  onTap: Dateinfo.type == "admin"
                      ? () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => gendefaulter(),
                        ));
                  }
                      : () {
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                        msg: "Only for admins",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 2.2 * SizeConfig.textMultiplier);
                  }),
            ),
//            Card(
//              child: new ListTile(
//                  title: Row(
//                    children: <Widget>[
//                      Padding(
//                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 15.0, 0),
//                        child: new Icon(
//                          Icons.edit,
//                          size: iconsize,
//                          color: iconclr,
//                        ),
//                      ),
//                      new Text(
//                        "Remedial hr",
//                        style: TextStyle(
//                            fontSize: textsize, fontWeight: FontWeight.bold),
//                      ),
//                    ],
//                  ),
//                  trailing: Icon(
//                    Icons.arrow_right,
//                    color: Colors.black,
//                  ),
//                  onTap: () async {
//                    if (prefs.getBool("check") == false) {
//                      pr.show();
//                      await Teacher.data();
//                      pr.hide();
//                    }
//
//                    Navigator.pop(context);
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                          builder: (context) => defaulter(),
//                        ));
//                  }),
//            ),
            Card(
              child: new ListTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 15.0, 0),
                        child: new Icon(
                          Icons.settings,
                          size: iconsize,
                          color: iconclr,
                        ),
                      ),
                      new Text(
                        "Settings",
                        style: TextStyle(
                            fontSize: textsize, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_right,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => teachprofile(),
                        ));
                  }),
            ),
//
            // new Divider(),
//            Card(
//              child: new ListTile(
//                  title: Row(
//                    children: <Widget>[
//                      Padding(
//                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 5.0, 0),
//                        child: new Icon(
//                          Icons.thumb_up,
//                          size: iconsize,
//                        ),
//                      ),
//                      new Text(
//                        "Like Us",
//                        style: TextStyle(
//                            fontSize: textsize,
//                            fontWeight: FontWeight.bold),
//                      ),
//                    ],
//                  ),
//                  trailing: Icon(
//                    Icons.arrow_right,
//                    color: Colors.black,
//                  ),
//                  onTap: () {
//                    Navigator.pop(context);
//                    Alert alert = new Alert();
//                    Alert1.displayDialog(context);
//                  }),
//            ),
            //new Divider(),

            //new Divider(),
            // new Divider(),

            // new Divider(),
//            Card(
//              child: new ListTile(
//                  title: Row(
//                    children: <Widget>[
//                      Padding(
//                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 5.0, 0),
//                        child: new Icon(
//                          Icons.phonelink_erase,
//                          size: iconsize,
//                        ),
//                      ),
//                      new Text(
//                        "Log out",
//                        style: TextStyle(
//                            fontSize: textsize,
//                            fontWeight: FontWeight.bold),
//                      ),
//                    ],
//                  ),
//                  trailing: Icon(
//                    Icons.arrow_right,
//                    color: Colors.black,
//                  ),
//                  onTap: () async {
//                    SharedPreferences log = await SharedPreferences.getInstance();
//                    FirebaseAuth.instance.signOut();
//                    Navigator.pushReplacement(
//                        context,
//                        MaterialPageRoute(
//                          builder: (context) => LoginPage(),
//                        ));
//                    // log.clear();
//                    log.setBool("login", false);
//                  }),
//            ),
          ],
        ),
      ),
    ));
  }
}

void parentteachermap() async {
  //Dateinfo.parentteacherstud.addAll({"key": "value"});
  //Dateinfo.studclass.addAll({"key":"value"});
  if (Dateinfo.parentteacherstud.isNotEmpty) Dateinfo.parentteacherstud.clear();
  if (Dateinfo.studclass.isNotEmpty) Dateinfo.studclass.clear();

  if (Dateinfo.parentteacherlist.isNotEmpty) Dateinfo.parentteacherlist.clear();
  if (Dateinfo.ydlist.isNotEmpty) Dateinfo.ydlist.clear();
  Dateinfo.ydlist.add("value");
  try {
    await FirebaseDatabase.instance
        .reference()
        .child("ParentTeacher")
        .child(Dateinfo.teachname)
        .once()
        .then((snap) {
      if (snap.value == null) {
        throw Exception;
      }
      Dateinfo.parentteacherstud = snap.value;
      //print(Dateinfo.parentteacherstud);
      for (final key in Dateinfo.parentteacherstud.keys) {
        Dateinfo.parentteacherclass.add(key.toString());
        Dateinfo.parentteacherlist.add(key.toString());

        Map map = Dateinfo.parentteacherstud[key];
        // print(map);
        for (final k in map.keys) {
          Dateinfo.parentteacherlist.add(k.toString());
          Dateinfo.studclass.addAll({k.toString(): key.toString()});
          Map yd=map[k];
          if(yd.containsKey("Yd")){
            Dateinfo.ydlist.add(k);
          }
        }

      }
    });
    // print(Dateinfo.ydlist.contains("F17111009"));
  } catch (Exception) {
    print("Exception here");
  }
}
