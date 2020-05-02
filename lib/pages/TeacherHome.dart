import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/AttendanceData.dart';
import 'package:flutter_app/pages/forgotpassword.dart';
import 'package:flutter_app/pages/homepage.dart';
import 'package:flutter_app/pages/subject.dart';
import 'package:flutter_app/responsive/Screensize.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'View_attendance.dart';
import 'login_page.dart';
import 'package:marquee/marquee.dart';

class Passcode extends StatefulWidget {
  @override
  _PasscodeState createState() => _PasscodeState();
}

class _PasscodeState extends State<Passcode>
    with SingleTickerProviderStateMixin {
  TabController controller;
  dynamic value;
  Timer _timer;
  DateFormat format = new DateFormat("HH:mm:ss");
  DateTime time;
  bool drop=false;
  String cur_time;
  String att_cnt="";
  String classs = 'Class', sub = "Subject", stat = "Status";
  String lec="";
  List<String> classlist = ["Class"], subjectlist = ["Subject"];
  FocusNode focusNode1 = new FocusNode();
  FocusNode focusNode2 = new FocusNode();
  bool enabled=true;
  Map tinfo;
  var status = ['Status', 'lecture', 'Practical'];
  SharedPreferences prefs;
  final databaseReference = FirebaseDatabase.instance.reference();
  TextEditingController _controller = TextEditingController();
  int code = 1000;
  String str =" (Look for your code here) ";
  Color clr=Colors.white;
  double dist=5 * SizeConfig.widthMultiplier;
  double txtsize=2.5 * SizeConfig.textMultiplier;
  Color butclr=Color(0xff996600);
  int _start=40;
  bool radio_on=true;
  int group;

  @override
  void initState() {
    // TODO: implement initState
    controller = new TabController(length: 1, vsync: this);
    super.initState();
  }
  void startTimer() async{
    enabled=false;
    _start=40;
    _timer = new Timer.periodic(
      new Duration(milliseconds: 1000),
          (Timer timer) => setState(
            () async {
          if (_start < 1) {
            enabled=true;
            drop=false;
            clr=Colors.white;
            radio_on=true;
            _timer.cancel();
           str=" (Look for your code here) ";
            if (stat == "lecture") {

              databaseReference
                  .child("c_teacher")
                  .child(Dateinfo.dept)
                  .child(classs)
                  .child(stat)
                  .child("passcode").set("your code");


            } else {
              databaseReference
                  .child("c_teacher")
                  .child(Dateinfo.dept)
                  .child(classs)
                  .child(stat)
                  .child(Alert.batch).child("passcode").set("your code");
            }
            var now = new DateTime.now();
            String day, month;
            if (now.day < 10) {
              day = "0" + now.day.toString();
            } else
              day = now.day.toString();

            if (now.month < 10) {
              month = "0" + now.month.toString();
            } else
              month = now.month.toString();

            String date =
                (now.year).toString() + "_" + month + "_" + day;
            if (stat == "lecture") {
              print("hello");
              await getLUserAmount();
              databaseReference
                  .child("Attendance")
                  .child(Dateinfo.dept)
                  .child(classs)
                  .child(sub.toUpperCase())
                  .child(Dateinfo.teachname)
                  .child(date)
                  .child(stat).child(lec.toString())
                  .child("a_total")
                  .set(user.count);
              databaseReference.child("time_table").child(Dateinfo.dept).child(classs).
              child(date).child(cur_time.toString()).child("total").set(user.count);
            } else {
              print("hii");
              await getPUserAmount();
              Fluttertoast.showToast(
                  msg: user.count,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              databaseReference
                  .child("Attendance")
                  .child(Dateinfo.dept)
                  .child(classs)
                  .child(sub.toUpperCase())
                  .child(Dateinfo.teachname)
                  .child(date)
                  .child(stat)
                  .child(Alert.batch.toUpperCase()).child(lec.toString())
                  .child("a_total")
                  .set(user.count);
              print(user.count);
              databaseReference.child("time_table").child(Dateinfo.dept).child(classs).
              child(date).child(cur_time.toString()).child("total").set(user.count);
            }
            setState(() {
              att_cnt=user.count;
            });
          }
          else {
            setState(() {
              //   _start = _start - 1;
            });
            _start=_start-1;
          }
        },

      ),
    );

  }
  static Future<int> getPUserAmount() async {
    final response = await FirebaseDatabase.instance
        .reference()
        .child("Attendance")
        .child(Dateinfo.dept)
        .child(user.classs)
        .child(user.sub.toUpperCase())
        .child(Dateinfo.teachname)
        .child(user.date)
        .child(user.stat)
        .child(Alert.batch.toUpperCase())
        .child(user.lec)
        .once();
    try{
      Map users = response.value;
      var len = [];
      for (final k in users.keys) {
        if(!(k.toString()=="a_total"))
          len.add(k);
      }
      print(len.length);
      user.count = len.length.toString();
      return users.length;
    }catch(Exception){

      Fluttertoast.showToast(
          msg: "no one marked",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

  }

  static Future<int> getLUserAmount() async {
    print(user.classs);
    final response = await FirebaseDatabase.instance
        .reference()
        .child("Attendance")
        .child(Dateinfo.dept)
        .child(user.classs)
        .child(user.sub.toUpperCase())
        .child(Dateinfo.teachname)
        .child(user.date)
        .child(user.stat)
        .child(user.lec)
        .once();
    await Future.delayed(Duration(seconds: 3));
    try{
      Map users = response.value;
      var len = [];
      for (final k in users.keys) {
        if(!(k.toString()=="a_total"))
          len.add(k);
      }
      print(len.length);
      user.count = len.length.toString();
      return len.length;
    }catch(Exception){

      Fluttertoast.showToast(
          msg: "No one Marked",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

  }

  void copy() async{
    prefs=await SharedPreferences.getInstance();
//    classlist.addAll(Teacher.cla);
//    classlist = classlist.toSet().toList();
//    subjectlist.addAll(Teacher.sub);
//    subjectlist = subjectlist.toSet().toList();
    print(stat);
    print(classs);
  }

  @override
  void dispose() {
    // TODO: implement dispose
   // _timer.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    copy();
    //const Color clr=Color(0xffffffff);
    ProgressDialog pr =  ProgressDialog(context,type: ProgressDialogType.Normal,isDismissible: true);
    pr.style(message: " Wait");
    final theme = Theme.of(context);
    return MaterialApp(
      home: new Scaffold(
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          appBar: new AppBar(
            title: new Text("Homepage\\Take att"),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,color: Colors.white,
              ),
              onPressed: (){
                Navigator.pop(context);
              }
              ,
            ),
            backgroundColor:  HexColor.fromHex("#6d6d46"),
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Profile','Subject registration','Logout'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          body: new Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
//                  stops: [0,0.5,1],
                colors: [
                  Colors.black,
                  Colors.black
                  //HexColor.fromHex("#4dffb8")
                ],
              ),

            ),

            child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
              //  new Padding(padding: EdgeInsets.only(bottom: 3*SizeConfig.heightMultiplier)),

                Expanded(
                  child: radio_on==true? Marquee(
                    text: str,
                    style: TextStyle(fontSize: txtsize,
                        color: clr,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center , blankSpace: 5.0,
              velocity: 20.0,
              pauseAfterRound: Duration(seconds: 1),
              startPadding: 10.0,
                    accelerationDuration: Duration(seconds: 1),
              accelerationCurve: Curves.linear,
              decelerationDuration: Duration(milliseconds: 2000),
              decelerationCurve: Curves.easeOut,):
                      Padding(
                        padding:  EdgeInsets.only(top:10*SizeConfig.heightMultiplier),
                        child: new Text(
                          str,style: TextStyle(color: clr,fontSize:3.3*SizeConfig.textMultiplier),
                        ),
                      )
                  ),
                new Text(" Countdown: $_start",style: TextStyle(color:Colors.white,fontSize: 2.8*SizeConfig.textMultiplier),),
                new Padding(padding: EdgeInsets.only(bottom: 3*SizeConfig.heightMultiplier)),

                Padding(
                  padding:  EdgeInsets.only(bottom: 3*SizeConfig.heightMultiplier),
                  child: GradientCard(
                    margin: new EdgeInsets.only(
                      left: 5*SizeConfig.widthMultiplier,
                      right: 5*SizeConfig.widthMultiplier,

                      top: 1*SizeConfig.heightMultiplier,
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
                      children: <Widget>[
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Radio(
                              activeColor:HexColor.fromHex ("#996600"),
                              value: 0,
                              groupValue: group,
                              onChanged:  _handleRadioValueChange1,
                            ),
                            new Text(
                              'Theory' ,
                                style: TextStyle(
                                    fontSize: 2.2 * SizeConfig.textMultiplier,
                                    color: HexColor.fromHex("#00004d"),
                                    fontWeight: FontWeight.bold),
                            ),
                           // new Padding(padding: EdgeInsets.only(left: 10)),
                            new Radio(
                              activeColor:HexColor.fromHex ("#996600"),
                              value: 1,
                              groupValue: group,
                              onChanged:  _handleRadioValueChange1,
                            ),
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
                              top: 4 * SizeConfig.heightMultiplier,
                              left: 7 * SizeConfig.widthMultiplier),
                          child: Row(
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
                                height: 4.9*SizeConfig.heightMultiplier,
                                padding:
                                EdgeInsets.symmetric(horizontal:3.1*SizeConfig.widthMultiplier , vertical:0.7*SizeConfig.heightMultiplier),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: new IgnorePointer(
                                  ignoring: drop,
                                  child: DropdownButton<String>(
                                    iconEnabledColor: HexColor.fromHex("#00004d"),
                                    items: classlist.map((String listvalue) {
                                      return DropdownMenuItem<String>(
                                        value: listvalue,
                                        child: Text(listvalue,style: TextStyle(
                                            fontSize: 2 * SizeConfig.textMultiplier,
                                            color: HexColor.fromHex("#00004d"),
                                            fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        classs=val;
                                        subjectlist.clear();
                                        sub="Subject";
                                        subjectlist=["Subject"];
                                        if(!(stat=="Status"&& sub=="Subject")){
                                          subjectlist.addAll(prefs.getStringList(classs+"_"+stat[0]));

                                        }
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
                              top: 2.6 * SizeConfig.heightMultiplier,
                              left: 7 * SizeConfig.widthMultiplier),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Work hour of day:",
                                style: TextStyle(
                                    fontSize: 2.2 * SizeConfig.textMultiplier,
                                    color:HexColor.fromHex("#00004d"),
                                    fontWeight: FontWeight.bold),
                              ),
                              new Padding(
                                padding: EdgeInsets.only(
                                    left: 4 * SizeConfig.widthMultiplier),
                              ),
                              new Flexible(
                                child: Container(
                                    width: 24*SizeConfig.widthMultiplier,
                                    child:TextFormField(
                                        focusNode: focusNode1,
                                        enableSuggestions: true,
                                        style: TextStyle(
                                            fontFamily: 'BalooChettan2',
                                            color: HexColor.fromHex("#00004d"),
                                            fontWeight: FontWeight.bold,
                                            fontSize:2.2*SizeConfig.heightMultiplier),
                                        cursorColor: HexColor.fromHex("#00004d"),
                                        decoration: new InputDecoration(
                                          fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              borderSide: BorderSide(width: 2,color: HexColor.fromHex("#ffffff")),
                                            ),
                                            contentPadding: EdgeInsets.only(
                                                left: 5*SizeConfig.widthMultiplier,right: 5*SizeConfig.widthMultiplier),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(width: 2,color: HexColor.fromHex("#ffffff")),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10.00)),
                                           // hintText: "Enter here",
                                            labelText: "Enter..",
                                            labelStyle: new TextStyle(
                                                color: HexColor.fromHex("#00004d"),
                                                fontSize: 2.2*SizeConfig.textMultiplier)),
                                        keyboardType:
                                        TextInputType.emailAddress,
                                        validator: validateEmail,
                                        onChanged: (val) {
                                          setState(() => lec = val);
                                        })
//                                  child:TextField(
//                                    style: TextStyle(color: Color(0xff00004d),fontWeight: FontWeight.bold),
//                                    controller: _controller,
//                                    keyboardType:TextInputType.phone,
//                                    cursorColor: HexColor.fromHex("#00004d"),
//                                    focusNode: focusNode1,
//
//                                    decoration: const InputDecoration(
//
//                                      hintText: "Enter here",
//                                      hintStyle: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize:17),
//                                      enabledBorder: UnderlineInputBorder(
//                                        borderSide: BorderSide(color: Color(0xffffffff)),
//                                      ),
//                                      focusedBorder: UnderlineInputBorder(
//                                        borderSide: BorderSide(color: Color(0xffffffff)),
//                                      ),
//                                    ),
//                                    enabled: true,
//                                    onChanged: (val) {
//                                      lec = val;
//                                    },)
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 3.5* SizeConfig.heightMultiplier,
                              left: 7 * SizeConfig.widthMultiplier),
                          child: Row(
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
                                height: 4.9*SizeConfig.heightMultiplier,
                                padding:
                                EdgeInsets.symmetric(horizontal:3.1*SizeConfig.widthMultiplier, vertical: 0.7*SizeConfig.heightMultiplier),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: new IgnorePointer(
                                  ignoring: drop,
                                  child: DropdownButton<String>(
                                    iconEnabledColor: HexColor.fromHex("#00004d"),
                                    items: subjectlist.map((String listvalue) {
                                      return DropdownMenuItem<String>(
                                        value: listvalue,
                                        child: Text(listvalue,style: TextStyle(
                                            fontSize: 2 * SizeConfig.textMultiplier,
                                            color: HexColor.fromHex("#00004d"),
                                            fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() => sub = val);
                                      FocusScope.of(context).requestFocus(new FocusNode());
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
                                onPressed: enabled? () async {
                                  prefs=await SharedPreferences.getInstance();
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                  var rng = new Random();
                                  code = code + rng.nextInt(20000) + rng.nextInt(30000);
                                  if (classs == "Class" ||
                                      sub == "Subject" ||
                                      stat == "Status" ||
                                      lec == "") {
                                    Fluttertoast.showToast(
                                        msg: "fill all fields",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  } else {
                                    radio_on=false;
                                    setState(() {
                                      clr=Color(0xffff9999);
                                      str = code.toString();
                                    });
                                    startTimer();
                                    drop=true;
                                    var now = new DateTime.now();
                                    String day, month;
                                    if (now.day < 10) {
                                      day = "0" + now.day.toString();
                                    } else
                                      day = now.day.toString();

                                    if (now.month < 10) {
                                      month = "0" + now.month.toString();
                                    } else
                                      month = now.month.toString();

                                    String date = (now.year).toString() +
                                        "_" +
                                        month +
                                        "_" +
                                        day;
                                    Dateinfo.classs=classs;
                                    Dateinfo.subject=sub;
                                    Dateinfo.date1=date;
                                    Dateinfo.stat=stat;
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

                                    if (stat == "lecture") {
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
                                          .child(stat).child(lec.toString())
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
                                      time=  new DateTime.now();
                                      cur_time=format.format(time);
                                      databaseReference.child("time_table").child(Dateinfo.dept).child(classs).
                                      child(date).child(cur_time.toString()).set({
                                        "name":Dateinfo.teachname,
                                        "subject":sub.toUpperCase(),
                                        "batch":""
                                      });
                                      // print(prefs.getString("TE1_IOT"));
                                      int val= int.parse(prefs.getString(classs.toUpperCase()+"_"+sub.toUpperCase()))+1;
                                      await  prefs.setString(classs.toUpperCase()+"_"+sub.toUpperCase(),val.toString());
                                      databaseReference.child("teach_att").child(Dateinfo.dept)
                                          .child(Dateinfo.teachname).child(classs.toUpperCase()+"_"+sub.toUpperCase()).set(val.toString());
                                    } else {
                                      await Alert.dialog(context);
                                      databaseReference
                                          .child("c_teacher")
                                          .child(Dateinfo.dept)
                                          .child(classs)
                                          .child(stat)
                                          .child(Alert.batch..toUpperCase())
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
                                          .child(Alert.batch.toUpperCase())
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
                                          .child(Alert.batch.toUpperCase()).child(lec.toString())
                                          .child("a_total")
                                          .set("0");
                                      int val= int.parse(prefs.getString(classs.toUpperCase()+"_"+sub.toUpperCase()+"_"+Alert.batch.toUpperCase())) +1;
                                      prefs.setString(classs.toUpperCase()+"_"+sub+"_"+Alert.batch.toUpperCase(),val.toString());
                                      databaseReference.child("teach_att").child(Dateinfo.dept)
                                          .child(Dateinfo.teachname).child(classs.toUpperCase()+"_"+sub.toUpperCase()+"_"+Alert.batch.toUpperCase()).
                                      set(prefs.getString(classs.toUpperCase()+"_"+sub.toUpperCase()+"_"+Alert.batch.toUpperCase()));
                                      time=  new DateTime.now();
                                      cur_time=format.format(time);
                                      databaseReference.child("time_table").child(Dateinfo.dept).child(classs).
                                      child(date).child(cur_time.toString()).set({
                                        "batch":Alert.batch,
                                        "name":Dateinfo.teachname,
                                        "subject":sub.toUpperCase()
                                      });
                                    }
                                  }
                                  // _start=40;
                                }:null,
                                color: butclr,//Color(0xff996600),
                                child: new Text("Passcode",
                                    style: TextStyle(
                                        fontFamily: 'BalooChettan2',
                                        color: HexColor.fromHex("#ffffff"),
                                        fontSize: 2.4 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.bold)),
                              ), //For
                              // got password button



                            ],
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(vertical:4.4*SizeConfig.heightMultiplier,horizontal: 5*SizeConfig.widthMultiplier),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  new Text("Attendees count:  ",
                                      style: TextStyle(
                                          fontFamily: 'BalooChettan2',
                                          color: HexColor.fromHex("#00004d"),
                                          fontSize: 2.8*SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.bold

                                      )),
                                  new Text(
                                    att_cnt,style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontFamily: 'BalooChettan2',
                                      color: HexColor.fromHex("#00004d"),
                                      fontSize: 2.8*SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.bold
                                  ),
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
                //new Padding(padding: EdgeInsets.only(bottom: 60))
              
              ],
            ),

          )),
    );
  }
  Widget _buildComplexMarquee() {
    return Marquee(
      text: str,
      style: TextStyle(fontSize: txtsize,
          color: clr,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold),
      scrollAxis: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      blankSpace: 5.0,
      velocity: 100.0,
      pauseAfterRound: Duration(seconds: 1),
      startPadding: 10.0,
      accelerationDuration: Duration(seconds: 1),
      accelerationCurve: Curves.linear,
      decelerationDuration: Duration(milliseconds: 500),
      decelerationCurve: Curves.easeOut,
    );
//
//    );
  }
  void _handleRadioValueChange1(value) {
    if(radio_on==true){
      if(value==0){
        setState(() {
          group=0;
          stat="lecture";
          classlist.clear();
          classlist=["Class"];
          subjectlist.clear();
          subjectlist=["Subject"];
          classs="Class";
          sub="Subject";
          if(!(stat=="Status") && classs=="Class")
            classlist.addAll(prefs.getStringList(stat));
        });
      }
      else{
        setState(() {
          group=1;
          stat="Practical";
          classlist.clear();
          classlist=["Class"];
          subjectlist.clear();
          subjectlist=["Subject"];
          classs="Class";
          sub="Subject";
          if(!(stat=="Status") && classs=="Class")
            classlist.addAll(prefs.getStringList(stat));
        });
      }
    }

  }

  Future<void> handleClick(String value) async {
    switch(value){
      case 'Profile':{
        if(prefs.getBool("check")==false){
         ProgressDialog pr= ProgressDialog(context,type: ProgressDialogType.Normal);
          pr.show();
          await  Teacher.data();
          await Future.delayed(Duration(seconds: 5));
          //  print(Teacher.DataList);
          pr.hide();
        }
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => teachprofile(),
            ));
     break;
      }
      case 'Subject registration':{
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => subject(),
            ));
        break;
      }
      case 'Logout':{
        SharedPreferences log =
        await SharedPreferences.getInstance();
        log.setBool("login", false);
        FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));
      }

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

  Future<String> getname() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      Dateinfo.teachemail = prefs.getString("email");
      Dateinfo.teachname = prefs.getString("name");
      Dateinfo.dept = prefs.getString("dept");
      name = Dateinfo.teachname;
      email = Dateinfo.teachemail;
      Dateinfo.type=prefs.getString("type");
      var e =Dateinfo.teachemail.split("@");
      Dateinfo.email=e[0].toString().replaceAll(new RegExp(r'\W'), "_");
      Alert.name=e[0].toString().replaceAll(new RegExp(r'\W'), "_");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    controller = new TabController(length: 1, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pr =  ProgressDialog(context,type: ProgressDialogType.Normal);
    pr.style(message: " Wait");
    getname();
    List<String> events = [
      "Take Attendance",
      "View/Modify Attendance",
    ];
    return new Scaffold(
      drawer: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
            //This will change the drawer background to blue.
            //other styles
            selectedRowColor: Colors.brown.shade300),
        child: Container(
          width: 76 * SizeConfig.widthMultiplier,
          child: new Drawer(
            child: new ListView(
              children: <Widget>[
                new UserAccountsDrawerHeader(
                  accountName: new Text(
                    name.toString(),
                    style: TextStyle(fontSize: 2.2 * SizeConfig.textMultiplier),
                  ),
                  accountEmail: new Text(email.toString(),
                      style:
                      TextStyle(fontSize: 2.1 * SizeConfig.textMultiplier)),
                  currentAccountPicture: new CircleAvatar(
                    radius: 4 * SizeConfig.heightMultiplier,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 8 * SizeConfig.heightMultiplier,
                      color: Colors.black87,
                    ),
                  ),
                  decoration:BoxDecoration(
                    image: DecorationImage(
                      image: new AssetImage("assets/profile.jpg"),
                      fit: BoxFit.cover,
                    ),
                    //color: HexColor.fromHex("#6d6d46")
                  ),
                ),
                new ListTile(
                    title: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 0.0, 5.0, 0),
                          child: new Icon(
                            Icons.person,
                            size: 4 * SizeConfig.heightMultiplier,
                          ),
                        ),
                        new Text(
                          "Profile",
                          style: TextStyle(
                              fontSize: 2.4 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Colors.black,
                    ),
                    onTap: () async {
                      if(prefs.getBool("check")==false){
                        pr.show();
                        await  Teacher.data();
                        pr.hide();
                      }

                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => teachprofile(),
                          ));
                    }),
                new Divider(),
                new ListTile(
                    title: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 0.0, 5.0, 0),
                          child: new Icon(
                            Icons.library_books,
                            size: 4 * SizeConfig.heightMultiplier,
                          ),
                        ),
                        new Text(
                          "Subject registration",
                          style: TextStyle(
                              fontSize: 2.4 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold),
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
                new Divider(),
                new ListTile(
                    title: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 0.0, 5.0, 0),
                          child: new Icon(
                            Icons.thumb_up,
                            size: 4 * SizeConfig.heightMultiplier,
                          ),
                        ),
                        new Text(
                          "Like Us",
                          style: TextStyle(
                              fontSize: 2.4 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Alert alert = new Alert();
                      alert.displayDialog(context);
                    }),
                new Divider(),
                new ListTile(
                    title: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 0.0, 5.0, 0),
                          child: new Icon(
                            Icons.search,
                            size: 4 * SizeConfig.heightMultiplier,
                          ),
                        ),
                        new Text(
                          "Monitor day",
                          style: TextStyle(
                              fontSize: 2.4 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Colors.black,
                    ),
                    onTap:  Dateinfo.type=="admin"?(){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Monitor(),
                          ));

                    }:(){Navigator.pop(context);
                    Fluttertoast.showToast(
                        msg: "Only for admins",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 2.2*SizeConfig.textMultiplier);}),
                new Divider(),
                new ListTile(
                    title: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 0.0, 5.0, 0),
                          child: new Icon(
                            Icons.phonelink_erase,
                            size: 4 * SizeConfig.heightMultiplier,
                          ),
                        ),
                        new Text(
                          "Log out",
                          style: TextStyle(
                              fontSize: 2.4 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Colors.black,
                    ),
                    onTap: () async {
                      SharedPreferences log =
                      await SharedPreferences.getInstance();
                      log.setBool("login", false);
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ));
                    }),
              ],
            ),
          ),
        ),
      ),
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
            HexColor.fromHex("#14141f"),
              HexColor.fromHex("#14141f"),
//              HexColor.fromHex("#4dffb8"),
//              HexColor.fromHex("#fff"),
//              HexColor.fromHex("#4dffb8")
            ],
          ),
        ),
        child: Container(
          margin:EdgeInsets.symmetric(horizontal: 3.8*SizeConfig.widthMultiplier,vertical:5*SizeConfig.heightMultiplier ),
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
                    margin: EdgeInsets.symmetric(vertical: 2.5*SizeConfig.heightMultiplier,horizontal: 5*SizeConfig.widthMultiplier),
                    child: getCardByTitle(title),
                  ),
                ),
                onTap: () async {
                  if (title == "View/Modify Attendance") {
                    if(prefs.getBool("check")==false){
                      pr.show();
                      await Teacher.data();
                      pr.hide();
                    }
                    Dateinfo.fetch=true;
                    Dateinfo.viewmod=false;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Date(),
                        ));
                  } else {
                    if(prefs.getBool("check")==false){
                      pr.show();
                      await Teacher.data();
                      pr.hide();
                    }
                    Dateinfo.fetch=true;
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
        title: new Text("Homepage"),
        backgroundColor: HexColor.fromHex("#6d6d46"),
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
              fontSize: 3.1*SizeConfig.textMultiplier, fontWeight: FontWeight.bold,color: HexColor.fromHex("#32324e")
              ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
