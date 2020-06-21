import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/AttendanceData.dart';
//import 'package:slimy_card/slimy_card.dart';
import 'package:flutter_app/responsive/Screensize.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class subject extends StatefulWidget {
  @override
  _subjectState createState() => _subjectState();
}

class _subjectState extends State<subject> {
  dynamic value;
  var s1;
  int group;
  double lefttextsize = 2.5 * SizeConfig.textMultiplier;
  Color lefttextclr = Color(0xff00004d);
  static const Color radioactivecolor = Color(0xff996600);

  static String Dep = "Select Branch", _subject = "", sub = "Subject";
  FocusNode focusNode = new FocusNode();
  TextEditingController _controller = TextEditingController();
  bool mark;
  static String classs = ' Class', status = "Select Status";
  List<String> lectlist;
  var classlist = [
    ' Class',
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
  ProgressDialog pr;
  Color righttxtclr = Color(0xff997a00);
  void get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lectlist = prefs.getStringList("list");
  }

  var stat = ["Select Status", "lecture", "Practical"];
  final dbref = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    return MaterialApp(
        home: new Scaffold(
          resizeToAvoidBottomInset: false,
          // resizeToAvoidBottomPadding: false,
          appBar: new AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: new Text("Homepage\\register sub.",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 2.7 * SizeConfig.textMultiplier)),
            backgroundColor: Color(0xff6d6d46),
            elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
          ),
          body: new Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    HexColor.fromHex("#000000"),
                    HexColor.fromHex("#000000"),
                    //HexColor.fromHex("#BA8B02")
                  ]),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                //    vertical: 5 * SizeConfig.heightMultiplier,
                  horizontal: 5 * SizeConfig.widthMultiplier),
              child: Card(
                margin: new EdgeInsets.symmetric(
                    horizontal: 3 * SizeConfig.widthMultiplier,
                    vertical: 12.5 * SizeConfig.heightMultiplier),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Color(0xffDAD299),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                        padding:
                        EdgeInsets.only(top: 2 * SizeConfig.heightMultiplier)),
                    Expanded(
                      child: Marquee(
                        text: "  (Register your subject here)  ",
                        style: TextStyle(fontSize: 2.8 * SizeConfig.textMultiplier,fontWeight: FontWeight.bold,color: lefttextclr),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 3 * SizeConfig.heightMultiplier,
                        //    left: 10 * SizeConfig.widthMultiplier
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Radio(
                            activeColor: radioactivecolor,
                            value: 0,
                            groupValue: group,
                            onChanged: _handleRadioValueChange1,
                          ),
                          new Text(
                            'Theory',
                            style: TextStyle(
                                fontSize: lefttextsize,
                                color: lefttextclr,
                                fontWeight: FontWeight.bold),
                          ),
                          new Radio(
                            activeColor: radioactivecolor,
                            value: 1,
                            groupValue: group,
                            onChanged: _handleRadioValueChange1,
                          ),
                          new Text(
                            'Practical',
                            style: TextStyle(
                                fontSize: lefttextsize,
                                color: lefttextclr,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 2 * SizeConfig.heightMultiplier,
                          top: 1 * SizeConfig.heightMultiplier
                        //  left: 23 * SizeConfig.widthMultiplier
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Radio(
                            activeColor: radioactivecolor,
                            value: 2,
                            groupValue: group,
                            onChanged: _handleRadioValueChange1,
                          ),
                          new Text(
                            'Tutorial',
                            style: TextStyle(
                                fontSize: lefttextsize,
                                color: lefttextclr,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    // new Padding(padding: EdgeInsets.only(left: 10)),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 5 * SizeConfig.heightMultiplier,
                        //    left: 7 * SizeConfig.widthMultiplier
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Select Class:",
                            style: TextStyle(
                                fontSize: 2.7 * SizeConfig.textMultiplier,
                                color: lefttextclr,
                                fontWeight: FontWeight.bold),
                          ),
                          new Padding(
                              padding: EdgeInsets.only(
                                  left: 6 * SizeConfig.widthMultiplier)),
                          Container(
                            height: 4.9 * SizeConfig.heightMultiplier,
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.1 * SizeConfig.widthMultiplier,
                                vertical: 0.7 * SizeConfig.heightMultiplier),
                            decoration: BoxDecoration(
                                border: Border.all(color: lefttextclr),
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.circular(10)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                iconEnabledColor: righttxtclr,
                                //underline: ,
                                items: classlist.map((String listvalue) {
                                  return DropdownMenuItem<String>(
                                    value: listvalue,
                                    child: Text(
                                      listvalue,
                                      style: TextStyle(
                                          color: righttxtclr,
                                          fontSize: 2.4 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() => classs = val);
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
                        bottom: 6 * SizeConfig.heightMultiplier,
                        //    left: 7 * SizeConfig.widthMultiplier
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Enter Subject:",
                            style: TextStyle(
                                fontSize: 2.7 * SizeConfig.textMultiplier,
                                color: lefttextclr,
                                fontWeight: FontWeight.bold),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(
                                left: 4 * SizeConfig.widthMultiplier),
                          ),
                          new Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              width: 30 * SizeConfig.widthMultiplier,
                              child: TextFormField(
                                //  focusNode: focusNode1,
                                  textCapitalization: TextCapitalization.characters,
                                  controller: _controller,
                                  enabled: true,
                                  cursorColor:righttxtclr,
                                  enableSuggestions: true,
                                  style: TextStyle(
                                      fontFamily: 'BalooChettan2',
                                      color: righttxtclr,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 2.2 * SizeConfig.heightMultiplier),
                                  decoration: new InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: lefttextclr),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(
                                            width: 1, color: lefttextclr),
                                      ),
                                      contentPadding: EdgeInsets.only(
                                          left: 5 * SizeConfig.widthMultiplier,
                                          right: 5 * SizeConfig.widthMultiplier),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(10.00)),
                                      labelText: "Enter..",
                                      labelStyle: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: righttxtclr,
                                          fontSize:
                                          2.2 * SizeConfig.textMultiplier)),
                                  //validator: validateEmail,
                                  onChanged: (val) {
                                    setState(() => _subject = val);
                                    _subject = _subject.toUpperCase();
                                    _subject = _subject
                                        .toString()
                                        .replaceAll(new RegExp(r'\W'), "");
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(top: 2 * SizeConfig.heightMultiplier),
                      child: Column(
                        children: <Widget>[
                          new RaisedButton(
                            onPressed: () async {
                              FocusScope.of(context).requestFocus(new FocusNode());
                              if (classs == " Class" ||
                                  status == "Select Status" ||
                                  _subject == "") {
                                Fluttertoast.showToast(
                                    msg: "Fill all the fields",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 2.2 * SizeConfig.textMultiplier);
                              } else {
                                pr.style(message: "wait");
                                pr.show();
                                Map exist;
                                await dbref
                                    .child("Attendance")
                                    .child(Dateinfo.dept)
                                    .child(classs)
                                    .child(_subject.toUpperCase())
                                    .once()
                                    .then((snap) {
                                  exist = snap.value;
                                });
                                if (exist == null) {
                                  await dbref
                                      .child("Attendance")
                                      .child(Dateinfo.dept)
                                      .child(classs)
                                      .child(_subject.toUpperCase())
                                      .child(Dateinfo.teachname)
                                      .child("total")
                                      .set(1);
                                } else {
                                  if (!(exist.containsKey(Dateinfo.teachname))) {
                                    await dbref
                                        .child("Attendance")
                                        .child(Dateinfo.dept)
                                        .child(classs)
                                        .child(_subject.toUpperCase())
                                        .child(Dateinfo.teachname)
                                        .child("total")
                                        .set(1);
                                  }
                                }
                                SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                                pr.hide();
                                if (status == "lecture") {
                                  await timetable(context);
                                  prefs.setString(
                                      classs.toUpperCase() +
                                          "_" +
                                          _subject.toUpperCase(),
                                      "0 0");
                                  await dbref
                                      .child("teach_att")
                                      .child(Dateinfo.dept)
                                      .child(Dateinfo.teachname)
                                      .child(classs.toUpperCase() +
                                      "_" +
                                      _subject.toUpperCase())
                                      .set(prefs.getString((classs.toUpperCase() +
                                      "_" +
                                      _subject.toUpperCase())
                                      .toString()));

                                  prefs.setBool("check", false);
                                } else if (status == "Practical") {
                                  setState(() {
                                    Dateinfo.classs = classs;
                                    Dateinfo.stat = status;
                                    Dateinfo.subject = _subject.toUpperCase();
                                    Alert1.check = false;
                                  });

                                  await Alert1.dialog(context);
                                  //pr.hide();
                                  await timetable(context);
//                                  Future.delayed(Duration(seconds: 2)).then((value){
//                                    pr.update(
//                                        message: "Done");
//                                  });
//                                  Future.delayed(Duration(seconds: 3)).then((onValue){
//                                    pr.hide();
//                                  });
                                  prefs.setString(
                                      classs.toUpperCase() +
                                          "_" +
                                          _subject.toUpperCase() +
                                          "_" +
                                          Alert1.batch.toUpperCase(),
                                      "0 0");
                                  dbref
                                      .child("teach_att")
                                      .child(Dateinfo.dept)
                                      .child(Dateinfo.teachname)
                                      .child(classs.toUpperCase() +
                                      "_" +
                                      _subject.toUpperCase() +
                                      "_" +
                                      Alert1.batch.toUpperCase())
                                      .set(prefs.getString(classs.toUpperCase() +
                                      "_" +
                                      _subject.toUpperCase() +
                                      "_" +
                                      Alert1.batch.toUpperCase()));
                                  prefs.setBool("check", false);
                                } else {
                                  setState(() {
                                    Dateinfo.classs = classs;
                                    Dateinfo.stat = status;
                                    Dateinfo.subject = _subject.toUpperCase();
                                    Alert1.check = false;
                                  });

                                  await Alert1.dialog(context);
                                  await timetable(context);
//                              Future.delayed(Duration(seconds: 2)).then((value){
//                              pr.update(
//                              message: "Done");
//                              });
//                              Future.delayed(Duration(seconds: 3)).then((onValue){
//                              pr.hide();
//                              });
                                  prefs.setString(
                                      classs.toUpperCase() +
                                          "_" +
                                          _subject.toUpperCase() +
                                          "_" +
                                          Alert1.batch.toUpperCase() +
                                          "_Tutorial",
                                      "0 0");
                                  dbref
                                      .child("teach_att")
                                      .child(Dateinfo.dept)
                                      .child(Dateinfo.teachname)
                                      .child(classs.toUpperCase() +
                                      "_" +
                                      _subject.toUpperCase() +
                                      "_" +
                                      Alert1.batch.toUpperCase() +
                                      "_Tutorial")
                                      .set(prefs.getString(classs.toUpperCase() +
                                      "_" +
                                      _subject.toUpperCase() +
                                      "_" +
                                      Alert1.batch.toUpperCase() +
                                      "_Tutorial"));
                                  prefs.setBool("check", false);
                                }

                                Dateinfo.fetch = false;
                              }
                            },
                            color: Color(0xff996600),
                            shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.00)),
                            child: new Text(" Save Details",
                                style: TextStyle(
                                    fontFamily: 'BalooChettan2',
                                    color: Colors.white,
                                    fontSize: 2.8 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.bold)),
                          ),
                          new Padding(
                              padding: EdgeInsets.only(
                                  top: 5 * SizeConfig.heightMultiplier))
                        ],
                      ),
                    ),
                    // new Padding(padding: EdgeInsets.all(10.00)),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _handleRadioValueChange1(int value) {
    if (value == 0) {
      setState(() {
        group = 0;
        status = "lecture";
      });
    } else if (value == 1) {
      setState(() {
        group = 1;
        status = "Practical";
      });
    } else {
      setState(() {
        group = 2;
        status = "Tutorial";
      });
    }
  }
  Decoration _decoration = new BoxDecoration(
    border: new Border(
      top: new BorderSide(
        style: BorderStyle.solid,
        color: Colors.black26,
      ),
      bottom: new BorderSide(
        style: BorderStyle.solid,
        color: Colors.black26,
      ),
    ),
  );
  timetable(BuildContext context) async {
    int rating =0;
    final theme = Theme.of(context);
    List<String> daylist = [
      "    day",
      "monday",
      "tuesday",
      "wednesday",
      "thursday",
      "friday",
      "saturday"
    ];
    List<String> daylistcopy = [
      "Day",
      "Mon",
      "Tues",
      "Wed",
      "Thur",
      "Fri",
      "Sat"
    ];
    String day1="Day",day = "Day", hr;
    final dbref = FirebaseDatabase.instance.reference();
    bool drop = false;
    /// final TextEditingController _lcontroller = TextEditingController();
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return StatefulBuilder(
            builder: (context, setState) {
              return Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  //title: Text("Enter Timetable",style: TextStyle(fontWeight: FontWeight.bold,color: lefttextclr,fontSize: 2.8*SizeConfig.heightMultiplier),),
                  content: new FittedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Select Day:",
                              style: TextStyle(
                                  fontSize: 1.8 * SizeConfig.textMultiplier,
                                  color: HexColor.fromHex("#00004d"),
                                  fontWeight: FontWeight.bold),
                            ),
                            new Padding(
                                padding: EdgeInsets.only(
                                    left: 4 * SizeConfig.widthMultiplier)),
                            new IgnorePointer(
                              ignoring: drop,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  iconEnabledColor: righttxtclr,
                                  items: daylistcopy.map((String listvalue) {
                                    return DropdownMenuItem<String>(
                                      value: listvalue,
                                      child: Text(
                                        listvalue,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize:
                                            1.8 * SizeConfig.textMultiplier,
                                            color: righttxtclr,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    int i=daylistcopy.indexOf(val);
                                    day = daylist[i];
                                    day1=val;
                                  },
                                  value: day1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Theme(
                          data: theme.copyWith(
                            accentColor: righttxtclr,// highlted color
                          ),
                          child: new NumberPicker.horizontal(
                              initialValue: rating,
                              minValue: 0,
                              maxValue: 8,
                              listViewHeight: 35,
                              decoration: _decoration,
                              onChanged: (val){
                                setState(() {
                                  hr=val.toString();
                                  rating=val;
                                });

                              }),
                        ),
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: [
//                          Text(
//                            "Work hour:",
//                            style: TextStyle(
//                                fontSize: 2.2 * SizeConfig.textMultiplier,
//                                color: HexColor.fromHex("#00004d"),
//                                fontWeight: FontWeight.bold),
//                          ),
//                          new Padding(
//                              padding: EdgeInsets.only(
//                                  left: 4 * SizeConfig.widthMultiplier)),
//                          Container(
//                              width: 20 * SizeConfig.widthMultiplier,
//                              height: 4 * SizeConfig.heightMultiplier,
//                              child: TextField(
//                                //  focusNode: focusNode1,
//                                  enableSuggestions: true,
//                                  controller: _lcontroller,
//                                  style: TextStyle(
//                                      fontFamily: 'BalooChettan2',
//                                      color: righttxtclr,
//                                      fontWeight: FontWeight.bold,
//                                      fontSize:
//                                      2.2 * SizeConfig.heightMultiplier),
//                                  cursorColor: righttxtclr,
//                                  decoration: new InputDecoration(
//                                      border: UnderlineInputBorder(
//                                        borderSide: BorderSide(
//                                            width: 1,
//                                            color: lefttextclr),
//                                      ),
//                                      contentPadding: EdgeInsets.only(
//                                          left: 5 * SizeConfig.widthMultiplier,
//                                          right:
//                                          5 * SizeConfig.widthMultiplier),
//                                      labelStyle: new TextStyle(
//                                          color: HexColor.fromHex("#00004d"),
//                                          fontSize:
//                                          2.2 * SizeConfig.textMultiplier)),
//                                  onChanged: (val) {
//                                    hr = val;
//                                    print(hr + day);
//                                  })),
//                        ],
//                      ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new SizedBox(
                              width: 16 * SizeConfig.widthMultiplier,
                              height: 3 * SizeConfig.heightMultiplier,
                              child: RaisedButton(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.00)),
                                  splashColor: HexColor.fromHex("#ffffff"),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                  },
                                  elevation: 2.0,
                                  color: HexColor.fromHex("#00004d"),
                                  textColor: Colors.white,
                                  child: new Text(
                                    "Done",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize:
                                        1.6 * SizeConfig.textMultiplier),
                                  )),
                            ),
                            new Padding(
                                padding: EdgeInsets.only(
                                    left: 2 * SizeConfig.widthMultiplier)),
                            new SizedBox(
                              width: 16 * SizeConfig.widthMultiplier,
                              height: 3 * SizeConfig.heightMultiplier,
                              child: RaisedButton(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.00)),
                                  splashColor: HexColor.fromHex("#ffffff"),
                                  onPressed: () async {
                                    if (day == "Day" ||
                                        hr == null ||
                                        hr == "0") {
                                      Fluttertoast.showToast(
                                          msg: "Fill the details");
                                    } else {
                                      pr.style(message: "wait");
                                      pr.show();
                                      SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                      if (status == "lecture") {
                                        prefs.setString(
                                            day + hr + "h",
                                            classs.toUpperCase() +
                                                " " +
                                                _subject.toUpperCase());
                                        await dbref
                                            .child("personal_tt")
                                            .child(Dateinfo.dept)
                                            .child(Dateinfo.teachname)
                                            .child(day.toString())
                                            .child(hr.toString() + "h")
                                            .set(classs.toUpperCase() +
                                            " " +
                                            _subject.toUpperCase());
                                      } else if (status == "Practical") {
                                        prefs.setString(
                                            day + hr + "h",
                                            classs.toUpperCase() +
                                                " " +
                                                _subject.toUpperCase() +
                                                " " +
                                                Alert1.batch);

                                        await dbref
                                            .child("personal_tt")
                                            .child(Dateinfo.dept)
                                            .child(Dateinfo.teachname)
                                            .child(day.toString())
                                            .child(hr.toString() + "h")
                                            .set(classs.toUpperCase() +
                                            " " +
                                            _subject.toUpperCase() +
                                            " " +
                                            Alert1.batch);
                                      } else {
                                        prefs.setString(
                                            day + hr + "h",
                                            classs.toUpperCase() +
                                                " " +
                                                _subject.toUpperCase() +
                                                " " +
                                                Alert1.batch +
                                                " " +
                                                "Tutorial");

                                        await dbref
                                            .child("personal_tt")
                                            .child(Dateinfo.dept)
                                            .child(Dateinfo.teachname)
                                            .child(day.toString())
                                            .child(hr.toString() + "h")
                                            .set(classs.toUpperCase() +
                                            " " +
                                            _subject.toUpperCase() +
                                            " " +
                                            Alert1.batch +
                                            " " +
                                            "Tutorial");
                                      }
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      Future.delayed(Duration(seconds: 3))
                                          .then((onValue) {
                                        pr.hide();
                                      });
                                    }
                                  },
                                  elevation: 2.0,
                                  color: HexColor.fromHex("#00004d"),
                                  textColor: Colors.white,
                                  child: new Text(
                                    "save",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize:
                                        1.6 * SizeConfig.textMultiplier),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        transitionDuration: Duration(milliseconds: 1000),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }
}

class Monitor extends StatefulWidget {
  @override
  _MonitorState createState() => _MonitorState();
}

class _MonitorState extends State<Monitor> {
  String date = "Select date";
  int len = 1;

  admin obj = new admin();
  var myFormat = DateFormat('yyyy_MM_dd');
  String classs = 'Class';
  List<String> classlist = [
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

  @override
  Widget build(BuildContext context) {
    ProgressDialog pr =
    ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: " Wait");
    return MaterialApp(
        home: Scaffold(
          body: Container(
            color: Colors.black,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 7 * SizeConfig.widthMultiplier,
                  vertical: 11 * SizeConfig.heightMultiplier),
              child: GradientCard(
                elevation: 5.0,
                gradient: LinearGradient(
                  colors: [Color(0xff77773c), Color(0xffffffff)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 5 * SizeConfig.heightMultiplier,
                          ),
                      child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Select Class:",
                            style: TextStyle(
                                fontSize: 2.7 * SizeConfig.textMultiplier,
                                color: HexColor.fromHex("#4d1919"),
                                fontWeight: FontWeight.bold),
                          ),
                          new Padding(
                              padding: EdgeInsets.only(
                                  left: 3 * SizeConfig.widthMultiplier)),
                          DropdownButton<String>(
                            iconEnabledColor: Color(0xff006666),
                            items: classlist.map((String listvalue) {
                              return DropdownMenuItem<String>(
                                value: listvalue,
                                child: Text(
                                  listvalue,
                                  style: TextStyle(
                                      color: Color(0xff006666),
                                      fontSize: 2.5 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() => classs = val);
                            },
                            value: classs,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(top: 3 * SizeConfig.heightMultiplier),
                      child: Container(
                        width: 35 * SizeConfig.widthMultiplier,
                        height: 5 * SizeConfig.heightMultiplier,
                        child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.00)),
                            //   splashColor: HexColor.fromHex("#ffffff"),
                            onPressed: () async {
                              DateTime newDateTime = await showRoundedDatePicker(
                                context: context,
                                theme: ThemeData.light(),
                                background: Colors.black,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                                borderRadius: 16,
                              );
                              setState(() {
                                date = myFormat.format(newDateTime);
                              });
                            },
                            elevation: 2.0,
                            color: HexColor.fromHex("#4d1919"),
                            textColor: Colors.white,
                            child: new Text(
                              date,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 2.3 * SizeConfig.textMultiplier),
                            )),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(top: 4 * SizeConfig.heightMultiplier),
                      child: Container(
                        width: 28 * SizeConfig.widthMultiplier,
                        height: 4.5 * SizeConfig.heightMultiplier,
                        child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.00)),
                            //  splashColor: HexColor.fromHex("#ffffff"),
                            onPressed: () async {
                              if (classs == "Class" || date == "Select date") {
                                Fluttertoast.showToast(
                                    msg: "fill all fields",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                pr.show();
                                admin.date = date;
                                admin.classs = classs;
                                await obj.check();
                                pr.hide();
                                print(obj.adminlist);
                                if (obj.adminlist.length != 0) {
                                  setState(() {
                                    len = obj.adminlist.length;
                                  });
                                }
                                for (final i in obj.adminlist) {
                                  print(i.teachername);
                                  print(i.time);
                                  print(i.batch);
                                  print(i.subject);
                                  print(i.total);
                                }
                              }
                            },
                            elevation: 2.0,
                            color: HexColor.fromHex("#4d1919"),
                            textColor: Colors.white,
                            child: new Text(
                              "View",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 2.3 * SizeConfig.textMultiplier),
                            )),
                      ),
                    ),
                    Padding(
                        padding:
                        EdgeInsets.only(top: 1 * SizeConfig.heightMultiplier,left: 3*SizeConfig.widthMultiplier),
                        child: Container(
                          child: new Swiper(
                              layout: SwiperLayout.STACK,
                              customLayoutOption: new CustomLayoutOption(
                                  startIndex: 0, stateCount: 3)
                                  .addRotate([-45.0 / 180, 0.0, 45.0 / 180]),
                              itemWidth: 58 * SizeConfig.widthMultiplier,
                              itemHeight: 28 * SizeConfig.heightMultiplier,
                              itemBuilder: (context, index) {
                                return new GestureDetector(
                                    onLongPress: () async {
                                      pr.show();
                                      if (obj.adminlist[index].batch == "") {
                                        String attendance = "";
                                        final dbref =
                                        FirebaseDatabase.instance.reference();
                                        await dbref
                                            .child("teach_att")
                                            .child(Dateinfo.dept)
                                            .child(obj.adminlist[index].teachername)
                                            .child(classs.toUpperCase() +
                                            "_" +
                                            obj.adminlist[index].subject)
                                            .once()
                                            .then((snap) {
                                          attendance = snap.value.toString();
                                        });
                                        var att = attendance.split(" ");
                                        pr.hide();
                                        Fluttertoast.showToast(
                                            msg: att[0].toString(),
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      } else {
                                        String attendance = "";
                                        final dbref =
                                        FirebaseDatabase.instance.reference();
                                        await dbref
                                            .child("teach_att")
                                            .child(Dateinfo.dept)
                                            .child(obj.adminlist[index].teachername)
                                            .child(classs.toUpperCase() +
                                            "_" +
                                            obj.adminlist[index].subject +
                                            "_" +
                                            obj.adminlist[index].batch
                                                .toUpperCase())
                                            .once()
                                            .then((snap) {
                                          attendance = snap.value.toString();
                                        });
                                        var att = attendance.split(" ");

                                        pr.hide();
                                        Fluttertoast.showToast(
                                            msg: att[0].toString(),
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 7 * SizeConfig.heightMultiplier),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xff666633), width: 3),
                                            borderRadius:
                                            new BorderRadius.circular(30.0),
                                            gradient: LinearGradient(colors: [
//                                                  HexColor.fromHex("#F37335"),
//                                                  HexColor.fromHex("#FDC830")
                                              Color(0xffffffff),
                                              Color(0xff77773c)
                                            ])),
                                        child: obj.adminlist.isEmpty
                                            ? Center(
                                            child: new Text(
                                              "Nothing to show here",
                                              style: TextStyle(
                                                  fontSize: 2.8 *
                                                      SizeConfig.textMultiplier,
                                                  color: Color(0xff4d1919),
                                                  fontWeight: FontWeight.bold),
                                            ))
                                            : new Center(
                                          child: Column(
                                            children: <Widget>[
                                              new Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 1.0 *
                                                          SizeConfig
                                                              .heightMultiplier)),
                                              swipe(index)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                              },
                              itemCount: len),
                        ))
                  ],
                ),
              ),
            ),
          ),
          appBar: new AppBar(
            title: new Text("Homepage\\monitor day"),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            backgroundColor: Color(0xff6d6d46),
          ),
        ));
  }

  Widget swipe(int index) {
    if (obj.adminlist[index].batch == "") {
      return new Text(
        "lecture\n" +
            "Time:" +
            obj.adminlist[index].time +
            "\n" +
            "Prof.:" +
            obj.adminlist[index].teachername +
            "\n" +
            "Subject:" +
            obj.adminlist[index].subject +
            "\nTotal:" +
            obj.adminlist[index].total,
        style: TextStyle(
            fontSize: 2.5 * SizeConfig.heightMultiplier,
            fontWeight: FontWeight.bold,
            color: Color(0xff4d1919)),
      );
    } else {
      return new Text(
        "practical\n" +
            "Batch:" +
            obj.adminlist[index].batch +
            "\nTime:" +
            obj.adminlist[index].time +
            "\n" +
            "Prof.:" +
            obj.adminlist[index].teachername +
            "\n" +
            "Subject:" +
            obj.adminlist[index].subject +
            "\nTotal:" +
            obj.adminlist[index].total,
        style: TextStyle(
            fontSize: 2.5 * SizeConfig.heightMultiplier,
            fontWeight: FontWeight.bold,
            color: Color(0xff4d1919)),
      );
    }
  }
}
