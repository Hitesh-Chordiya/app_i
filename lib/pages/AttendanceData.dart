import 'dart:async';
import 'dart:core';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/responsive/Screensize.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}



class AttendanceData {
  String subjectName;
  int total_lect;
  int attended_lect;
  int total_pract = 0;
  int attended_pract = 0;
  int attended_tut=0;
  int total_tut=0;
  double total_attendance = 0.0;
  int get attended_tutorial => attended_tut;
  int get total_tutorial => total_tut;

  int get total_lectures => total_lect;

  int get attended_lectures => attended_lect;

  int get total_practicals => total_pract;

  int get attended_practicals => attended_pract;

  String get subject_name => subjectName;

  AttendanceData(subjectName, total_lect, attended_lect, total_pract,
      attended_pract,total_tut,attended_tut) {
    this.attended_pract = attended_pract;
    this.attended_lect = attended_lect;
    this.total_pract = total_pract;
    this.total_lect = total_lect;
    this.subjectName = subjectName;
    this.attended_tut=attended_tut;
    this.total_tut=total_tut;

    if (total_lect == 0 && total_pract == 0) {
      this.total_attendance = 100.0;
    } else {
      this.total_attendance =
          ((attended_lect + attended_pract) / (total_pract + total_lect)) * 100;
    }
  }
}

class user {
  static String classs,
      sub,
      stat,
      date,
      lec,
      count = "0";
}

class total {
  static String dep, classs;
  static int count;
  static var studnames = new Map();
  var studmap=new Map();
// static List<String> namelist=[" "];

}

class Dateinfo {
  static Map part1;
  static var parentteacherstud=new Map();

  static var studclass=new Map();
  static List<String> list = List<String>();
  static List<String> ydlist = ["hi"],
      prnlist = List<String>(),
      batches = List<String>(),parentteacherclass=List<String>(),
      parentteacherlist=List<String>();
  static String date1,
      type,
      part,
      classs,
      subject,
      teachname = "name",
      teachemail = "E-mail",
      lecnumber,
      dept,
      stat,
      email = "E-mail";
  static int count;
  static bool viewmod,
      fetch = false;

  static Future<void> info() async {
    final dbref = await FirebaseDatabase.instance.reference();
    list.clear();
    if (stat == "lecture") {
      await dbref
          .child("Attendance")
          .child(Dateinfo.dept)
          .child(Dateinfo.classs)
          .child(Dateinfo.subject)
          .child(Dateinfo.teachname.toString())
          .child(Dateinfo.date1)
          .child("lecture")
          .child(Dateinfo.lecnumber)
          .once()
          .then((snap) {
        part1 = snap.value;
      });
    } else {
      await dbref
          .child("Attendance")
          .child(Dateinfo.dept)
          .child(Dateinfo.classs)
          .child(Dateinfo.subject)
          .child(Dateinfo.teachname.toString())
          .child(Dateinfo.date1)
          .child(stat)
          .child(Alert1.batch)
          .child(Dateinfo.lecnumber)
          .once()
          .then((snap) {
        part1 = snap.value;
      });
    }
    //await Future.delayed(Duration(seconds: 3));

    for (final i in part1.keys) {
      list.add((i));
    }
    //  list.sort();
  }
}

class Studinfo {
  static String name = "name",
      branch,
      email = "E-mail",
      roll,
      classs,
      batch,parentname,
      prn;
  static bool fetch = false;
  static List<Studinfo> remediallist=List<Studinfo>();
  String subjectname;
  int workload;
  static var datamap=new Map();
  static Future<void> data()async{
    datamap.clear();
    await FirebaseDatabase.instance.reference().
    child("ParentTeacher").
    child(Studinfo.parentname).child(
        Studinfo.classs).child(Studinfo.roll).once()
        .then((onValue){
          if(onValue.value==null){
            throw Exception;
          }
      datamap=onValue.value;
    });
  }

  Studinfo(String subjectname,int workload){
    this.subjectname=subjectname;
    this.workload=workload;
  }
  static void relist()async{
    remediallist.clear();
    SharedPreferences prefs =await SharedPreferences.getInstance();
    List<String> a=((prefs.getStringList("remedial")));//as List<Studinfo>;
    if(a==null) {throw Exception;}

    for (int i=0;i<a.length;i++){
      var b=a[i].split(" ");
      Studinfo s = new Studinfo(b[0], int.parse(b[1]));
      remediallist.add(s);
    }
  }
  static Future<void> remedial()async{
    var remap=new Map();
    var retotal=new Map();
    List<String> dummy=List<String>();


    try{
      int value;
      await     FirebaseDatabase.instance.reference()
          .child("defaulterlist")
          .child(Studinfo.branch)
          .child(Studinfo.classs)
          .child("Total")
          .child(Studinfo.batch)
          .once()
          .then((onValue) {
        value=onValue.value;
      });
      int stotal;
      await FirebaseDatabase.instance.reference()
          .child("defaulterlist")
          .child(Studinfo.branch)
          .child(Studinfo.classs)
          .child(Studinfo.roll)
          .child("Total")
          .once()
          .then((onValue) {
        stotal=onValue.value;
      });

      if(stotal==null || value==null){
        throw Exception;
      }

      try {
        await     FirebaseDatabase.instance.reference()
            .child("defaulterlist")
            .child(Studinfo.branch)
            .child(Studinfo.classs)
            .child("Total")
            .once()
            .then((onValue) {
          Map map = onValue.value;

          retotal.addAll(map);
        });
      } catch (Exception) {
      }

      try {
        await FirebaseDatabase.instance.reference()
            .child("defaulterlist")
            .child(Studinfo.branch)
            .child(Studinfo.classs)
            .child(Studinfo.roll)
            .once()
            .then((onValue) {
          Map map = onValue.value;
          //  print(map);
          var att = new Map();
          for (final k in map.keys) {
            try {
              if (k.toString() != "Total") {

                String batch = Studinfo.batch;
                if ((100 * (map[k] / retotal[k][batch])) >= 75) {
                  dummy.add(k.toString()+" "+"0");
                  continue;
                } else {
                  att.addAll({
                    k.toString(): retotal[k][batch] * 0.75 - map[k]
                  });
                }
              }
            } catch (Exception) {
              print(Exception);
            }
          }
          int work = 0;
          double x = 0;
          for (final k in att.values) {
            x += k;
          }
          for(final k in att.keys) {
            int tot = 0;
//                    attended = 0;
            for (final k in retotal.keys) {
              if (k.toString() == "P" ||
                  k.toString() == "Q" ||
                  k.toString() == "R")
                continue;
              else
                tot += retotal[k][batch];
            }

            double totalworkhour = 0.75 * tot - map["Total"];

            work = (((totalworkhour / x) * att[k]).ceil());
            dummy.add(k.toString()+" "+'$work');
          };

        });
        SharedPreferences prefs =await SharedPreferences.getInstance();

        prefs.setStringList("remedial", dummy.toSet().toList());
      } catch (Exception) {
        print("remedial");
      }
    } catch (Exception) {
      Fluttertoast.showToast(
          msg: "Defaulter is not generated!!",
          toastLength: Toast
              .LENGTH_LONG,
          gravity: ToastGravity
              .BOTTOM,
          backgroundColor: Colors
              .red,
          textColor: Colors
              .white,
          fontSize: 2 *
              SizeConfig
                  .textMultiplier);
    }

  }

}


class Alert1 {
  static bool check,inputlec;
  static String name;
  String review;

  displayDialog(BuildContext context) async {
    TextEditingController _controller = TextEditingController();
    return showDialog(
        context: context,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (context) {
          return FittedBox(
            child: Theme(
//              data: ThemeData(accentColor: Color(0xff666699),
//                  primaryColor: Color(0xff666699),

//                  TextTheme(
//
//                    body1: TextStyle(color: Colors.black),
//                     button:TextStyle(color: Colors.black)
//                  )),
          data:ThemeData(
          accentColor: Color(0xff666699),
          buttonTheme: ButtonThemeData(
          buttonColor: Colors.black87,
          shape: RoundedRectangleBorder(),
          textTheme: ButtonTextTheme.accent,
          )),
              child: RatingDialog(
                icon: Column(
                  children: <Widget>[
                    Container(
                      width: 200,
                      child: new TextFormField(
                          controller: _controller,
                          enableSuggestions: true,
                          cursorColor: Colors.black87,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(
                              fontFamily: 'BalooChettan2',
                              color: Colors.black87,
                              fontSize: 2.7 * SizeConfig.textMultiplier),
                          decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black87),
                                borderRadius: BorderRadius.circular(10.00),
                              ),
                              contentPadding:
                              EdgeInsets.only(left: 20.00, right: 20.00),
                              border: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.black87),
                                  borderRadius: BorderRadius.circular(10.00)),
                              labelText: "Review",
                              labelStyle: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  fontSize: 2.7 * SizeConfig.textMultiplier)),
                          onChanged: (val) {
                            review = val;
                          }),
                    ),
                  ],
                ),
                title: "What would you rate this app?",

                description: "Tap a star to rate us.",
                submitButton: "SUBMIT",
                // optional
                positiveComment: "We are so happy to hear :)",
                // optional
                negativeComment: "We're sad to hear :(",
                // optional
               // accentColor: Colors.yellow,
                // optional
                onSubmitPressed: (int rating) {
                  print("onSubmitPressed: rating = $rating");
                  // TODO: open the app's page on Google Play / Apple App Store
                  FirebaseDatabase.instance.reference().child("Reviews").child(
                      name).set({
                    "Rating": rating,
                    "Message": review
                  });
                },
              ),
            ),
          );
        });
  }
  static yd(BuildContext context) async {
    TextEditingController _controller = TextEditingController();
    return showDialog(
        context: context,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (context) {
          return FittedBox(
            child: Theme(
              data: ThemeData(accentColor: Colors.yellow,
                  primaryColor: Colors.yellow,
                  textTheme: TextTheme()),
              child:Text("sorry")
            ),
          );
        });
  }

  static String batch;

  static dialog(BuildContext context) async {
    bool pcheck = false,
        qcheck = false,
        rcheck = false;
    print(Dateinfo.batches);
    if (check) {
      for (int i = 0; i < Dateinfo.batches.length; i++) {
        if (Dateinfo.batches[i] == "P") {
          pcheck = true;
        } else if (Dateinfo.batches[i] == "Q") {
          qcheck = true;
        } else {
          rcheck = true;
        }
      }
    } else {
      pcheck = qcheck = rcheck = true;
    }
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text("select batch"),
                content: new FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      children: [
                        new Row(
                          children: <Widget>[
                            SizedBox(
                              child: pcheck ? RaisedButton(
                                shape: CircleBorder(),
                                color: Colors.blue,
                                splashColor: Colors.red,
                                child: SizedBox(
                                    child: Text(
                                      "P",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    )),

                                onPressed: () async {
                                  batch = "P";
                                  if (inputlec == true) {
                                    String cnt;
                                    if(Dateinfo.stat=="Practical"){
                                      cnt="practcount";
                                    }else{
                                      cnt="tutcount";
                                    }
                                    await FirebaseDatabase.instance
                                        .reference()
                                        .child("Attendance")
                                        .child(Dateinfo.dept)
                                        .child(Dateinfo.classs)
                                        .child(Dateinfo.subject)
                                        .child(Dateinfo.teachname)
                                        .child(Dateinfo.date1)
                                        .child(Dateinfo.stat)
                                        .child(Alert1.batch)
                                        .child(cnt)
                                        .once()
                                        .then((snap) async {
                                      Dateinfo.part = snap.value;
                                    });
                                  }

                                  Navigator.pop(context);
                                },

                                //color: const Color(0xFF1BC0C5),
                              ) : SizedBox(),
                            ),
                            SizedBox(
                              child: qcheck ? RaisedButton(
                                shape: CircleBorder(),
                                color: Colors.blue,
                                // button color
                                splashColor: Colors.red,
                                // inkwell color
                                child: SizedBox(
                                    child: Text(
                                      "Q",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    )),
                                onPressed: () async {
                                  batch = "Q";
                                  if (inputlec == true) {
                                    String cnt;
                                    if(Dateinfo.stat=="Practical"){
                                      cnt="practcount";
                                    }else{
                                      cnt="tutcount";
                                    }

                                    await FirebaseDatabase.instance
                                        .reference()
                                        .child("Attendance")
                                        .child(Dateinfo.dept)
                                        .child(Dateinfo.classs)
                                        .child(Dateinfo.subject)
                                        .child(Dateinfo.teachname)
                                        .child(Dateinfo.date1)
                                        .child(Dateinfo.stat)
                                        .child(Alert1.batch)
                                        .child(cnt)
                                        .once()
                                        .then((snap) async {
                                      Dateinfo.part = snap.value;
                                    });
                                  }
                                  Navigator.pop(context);
                                },
                              ) : SizedBox(),
                            ),
                            SizedBox(
                              child: rcheck ? RaisedButton(
                                shape: CircleBorder(),
                                color: Colors.blue,

                                // button color
                                splashColor: Colors.red,
                                // inkwell color
                                child: SizedBox(
                                    child: Text(
                                      "R",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    )),
                                onPressed: () async {
                                  batch = "R";
                                  if (inputlec == true) {
                                    String cnt;
                                    if(Dateinfo.stat=="Practical"){
                                      cnt="practcount";
                                    }else{
                                      cnt="tutcount";
                                    }

                                    await FirebaseDatabase.instance
                                        .reference()
                                        .child("Attendance")
                                        .child(Dateinfo.dept)
                                        .child(Dateinfo.classs)
                                        .child(Dateinfo.subject)
                                        .child(Dateinfo.teachname)
                                        .child(Dateinfo.date1)
                                        .child(Dateinfo.stat)
                                        .child(Alert1.batch)
                                        .child(cnt)
                                        .once()
                                        .then((snap) async {
                                      Dateinfo.part = snap.value;
                                    });
                                  }
                                  Navigator.pop(context);
                                },
                              ) : SizedBox(),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 1000),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }
}

class Attendance {
  // ignore: non_constant_identifier_names
  static int k = 0;
  static String subject;
  static String sub_teach, name;
  static Map studmap;
  static bool viewattendance = false,
      alect = false,
      apract = false,atut=false;
  static List<AttendanceData> attendanceDataList = List<AttendanceData>();

  static int attended_lect, total_lect, attended_pract, total_pract,attended_tut,total_tut,others,medical,sports;
  static var subjectList = ['Overall'];

  static Future<void> displayatt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    alect=false;
    apract=false;
    atut=false;
    subjectList.clear();
    subjectList.add("Overall");
    await FirebaseDatabase.instance
        .reference()
        .child('defaulter')
        .child(Studinfo.branch)
        .child(Studinfo.classs)
        .child("AATotal")
        .once()
        .then((snapshot) async {
      Map data = snapshot.value;
      List<String> lectlist = [" "];
      lectlist.clear();
      List<String> practlist = [" "];
      practlist.clear();
      List<String> tlectlist = [" "];
      tlectlist.clear();
      List<String> tpractlist = [" "];
      tpractlist.clear();
      List<String> tutlist = [" "];
      tutlist.clear();
      List<String> ttutlist = [" "];
      ttutlist.clear();

      for (final key in data.keys) {
        if (!(key.toString() == "Total")) {
          Studinfo.fetch = true;
          var a = key.toString().split("_");
          String subject = a[0];
          if (a.length == 2) {
            alect=true;
            subjectList.add(subject);
            tlectlist.add("t" + a[0].toString());
            lectlist.add(a[0].toString());
            // print("lol");
            try {
              List<String>tteacher = prefs.getStringList(
                  "t" + a[0].toString());
              tteacher.add("t" + a[1].toString());
              prefs.setStringList(
                  "t" + a[0].toString(), tteacher.toSet().toList());
              List<String>teacher = prefs.getStringList(a[0].toString());
              teacher.add(a[1].toString());
              prefs.setStringList(a[0].toString(), teacher.toSet().toList());
            } catch (Exception) {
              List<String>tteacher = [" "];
              tteacher.clear();
              tteacher.add("t" + a[1].toString());
              prefs.setStringList(
                  "t" + a[0].toString(), tteacher.toSet().toList());
              List<String>teacher = [" "];
              teacher.clear();
              teacher.add(a[1].toString());
              prefs.setStringList(a[0].toString(), teacher.toSet().toList());
            }
            prefs.setInt("t" + a[0].toString() + a[1].toString(), data[key]);
            try {
              if(!(prefs.containsKey(a[0].toString() + a[1].toString()))) {
                throw Exception;
              }
              // print(prefs.getInt(a[0].toString() + a[1].toString()));
            }
            catch
            (Exception) {
              prefs.setInt(a[0].toString() + a[1].toString(), 0);
              // print("saved");
            }
          } else {
            if (a.length == 3){
              if (a[2] == Studinfo.batch) {
                apract = true;
                subjectList.add(subject);
                tpractlist.add("t" + a[0].toString() + "L");
                practlist.add(a[0].toString() + "L");
                try {
                  List<String>tteacher = prefs.getStringList("t" +
                      a[0].toString() + "L");
                  tteacher.add("t" + a[1].toString() + "L");
                  prefs.setStringList(
                      "t" + a[0].toString() + "L", tteacher.toSet().toList());

                  List<String>teacher = prefs.getStringList(
                      a[0].toString() + "L");
                  teacher.add(a[1].toString() + "L");
                  prefs.setStringList(
                      a[0].toString() + "L", teacher.toSet().toList());
                } catch (Exception) {
                  List<String>tteacher = [" "];
                  tteacher.clear();
                  tteacher.add("t" + a[1].toString() + "L");
                  prefs.setStringList(
                      "t" + a[0].toString() + "L", tteacher.toSet().toList());

                  List<String>teacher = [" "];
                  teacher.clear();
                  teacher.add(a[1].toString() + "L");

                  prefs.setStringList(
                      a[0].toString() + "L", teacher.toSet().toList());
                }
                prefs.setInt(
                    "t" + a[0].toString() + a[1].toString() + "L", data[key]);
                try {
                  if (!(prefs.containsKey(
                      a[0].toString() + a[1].toString() + "L"))) {
                    throw Exception;
                  }
                } catch (Exception) {
                  prefs.setInt(a[0].toString() + a[1].toString() + "L", 0);
                }
              }
            }else{
              if (a[2] == Studinfo.batch) {
                atut = true;
                subjectList.add(subject);
                ttutlist.add("t" + a[0].toString() + "T");
                tutlist.add(a[0].toString() + "T");
                try {
                  List<String>tteacher = prefs.getStringList("t" +
                      a[0].toString() + "T");
                  tteacher.add("t" + a[1].toString() + "T");
                  prefs.setStringList(
                      "t" + a[0].toString() + "T", tteacher.toSet().toList());

                  List<String>teacher = prefs.getStringList(
                      a[0].toString() + "T");
                  teacher.add(a[1].toString() + "T");
                  prefs.setStringList(
                      a[0].toString() + "T", teacher.toSet().toList());
                } catch (Exception) {
                  List<String>tteacher = [" "];
                  tteacher.clear();
                  tteacher.add("t" + a[1].toString() + "T");
                  prefs.setStringList(
                      "t" + a[0].toString() + "T", tteacher.toSet().toList());

                  List<String>teacher = [" "];
                  teacher.clear();
                  teacher.add(a[1].toString() + "T");

                  prefs.setStringList(
                      a[0].toString() + "T", teacher.toSet().toList());
                }
                prefs.setInt(
                    "t" + a[0].toString() + a[1].toString() + "T", data[key]);
                try {
                  if (!(prefs.containsKey(
                      a[0].toString() + a[1].toString() + "T"))) {
                    throw Exception;
                  }
                } catch (Exception) {
                  prefs.setInt(a[0].toString() + a[1].toString() + "T", 0);
                }
              }
            }
          }
        }
      }
      if(alect==true||apract==true || atut==true){
        prefs.setStringList("tlecture", tlectlist.toSet().toList());
        prefs.setStringList("tPractical", tpractlist.toSet().toList());
        prefs.setStringList("lecture", lectlist.toSet().toList());
        prefs.setStringList("Practical", practlist.toSet().toList());
        prefs.setStringList("ttutlist", ttutlist.toSet().toList());
        prefs.setStringList("tutlist", tutlist.toSet().toList());
        prefs.setStringList("subjectlist", subjectList.toSet().toList());
      }
      else{
        throw Exception;
      }
//      } catch (Exception) {
//        print("goooot");
//      }
    });
  }
  static void owndata()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    await FirebaseDatabase.instance
        .reference()
        .child('defaulter')
        .child(Studinfo.branch)
        .child(Studinfo.classs)
        .child(Studinfo.roll)
        .once()
        .then((snapshot) async {
      try {
        Map data = snapshot.value;
        try {
          for (final key in data.keys) {
            if (!(key.toString() == "Total")) {
              try{
                var a = key.toString().split("_");

                if (a.length == 2) {
                  prefs.setInt(a[0].toString() + a[1].toString(), data[key]);
                } else {
                  if (a.length == 3) {
                    prefs.setInt(
                        a[0].toString() + a[1].toString() + "L", data[key]);
                  } else {
                    prefs.setInt(
                        a[0].toString() + a[1].toString() + "T", data[key]);
                  }
                }
              }catch(Exception){
                prefs.setInt(key.toString(), data[key]);
                print(data[key]);
              }
            }
          }
        } catch (Exception) {
          print("inside");
        }
      } catch (Exception) {
        print("object");
      }
      // getlist();
    });
  }

  static void getlist() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
//    print(prefs.getKeys());
    List<String> subject = prefs.getStringList("subjectlist");
    List<String> lecttList = prefs.getStringList("lecture");
    List<String> practList = prefs.getStringList("Practical");
    List<String> tutlist = prefs.getStringList("tutlist");

    attendanceDataList.clear();
    subjectList.clear();
//    print(subject);
    subjectList.addAll(subject);
//    print(subject.length);
    for (int i = 1; i < subject.length; i++) {
      attended_lect = 0;
      total_lect = 0;
      attended_pract = 0;
      total_pract = 0;
      attended_tut=0;
      total_tut=0;
      if (lecttList.contains(subject[i])) {
        List<String> Adata = prefs.getStringList(subject[i]);
        List<String>Tdata = prefs.getStringList("t" + subject[i]);
        for (int j = 0; j < Adata.length; j++) {
          // print(subject[i]+Adata[j]);
          attended_lect += prefs.getInt(subject[i] + Adata[j]);
          total_lect += prefs.getInt("t" + subject[i] + Adata[j]);
        }
      }
      if (practList.contains(subject[i] + "L")) {
        List<String> Adata = prefs.getStringList(subject[i] + "L");
        List<String>Tdata = prefs.getStringList("t" + subject[i] + "L");
        //print(Adata);
        for (int j = 0; j < Adata.length; j++) {
          attended_pract += prefs.getInt(subject[i] + Adata[j]);
          total_pract += prefs.getInt("t" + subject[i] + Adata[j]);
        }
      }
      if (tutlist.contains(subject[i] + "T")) {
        List<String> Adata = prefs.getStringList(subject[i] + "T");
        List<String>Tdata = prefs.getStringList("t" + subject[i] + "T");
        //print(Adata);
        for (int j = 0; j < Adata.length; j++) {
          attended_tut += prefs.getInt(subject[i] + Adata[j]);
          total_tut += prefs.getInt("t" + subject[i] + Adata[j]);
        }
      }
      AttendanceData a = new AttendanceData(subject[i], total_lect,
          attended_lect, total_pract, attended_pract,total_tut,attended_tut);
      attendanceDataList.add(a);
    }
    if(prefs.getInt("other")==null){
      others=0;
    }else{
      others=prefs.getInt("other");
    }
    if(prefs.getInt("sports")==null){
      sports=0;
    }else{
      sports=prefs.getInt("sports");
    }
    if(prefs.getInt("medical")==null){
      medical=0;
    }else{
      medical=prefs.getInt("medical");
    }
  }

  static Future<void> view() async {
    attendanceDataList.clear();
    subjectList.clear();
    viewattendance = false;
    subjectList.add("Overall");
    await FirebaseDatabase.instance
        .reference()
        .child('Attendance')
        .child(Studinfo.branch)
        .child(Studinfo.classs)
        .once()
        .then((snapshot) async {
      try {
        Map data = snapshot.value;
        for (final key in data.keys) {
          try {
            if (!(key.toString() == "total")) {
              Map subjectData = data[key];
              subject = key.toString();
              attended_lect = 0;
              total_lect = 0;
              attended_pract = 0;
              total_pract = 0;
              for (final key in subjectData.keys) {
                print("caught");
                Map TeacherData = subjectData[key];
                name = key.toString();
                alect = false;
                apract = false;
                for (final key in TeacherData.keys) {
                  try {
                    if (!(key.toString() == "total")) {
                      Map DateWiseData = TeacherData[key];
                      // print(DateWiseData);
                      viewattendance = true;
                      sub_teach = subject + "_" + name;
                      // retriving lecture Attendance
                      if (DateWiseData.containsKey("lecture")) {
                        alect = true;
                        try {
                          Map lectureData = DateWiseData['lecture']; // Lecture
                          total_lect += int.parse(lectureData['leccount']
                              .toString());
                          int lect_held =
                          int.parse(lectureData['leccount'].toString());

                          for (int i = 1; i <= lect_held; i++) {
                            String key = i.toString();
                            Map SessionData = lectureData[key]; // Lecture
                            try {
                              if (SessionData.containsKey(Studinfo.roll)) {
                                attended_lect = attended_lect + 1;
                              }
                            } catch (Exception) {
                              print("lecsession");
                            }
                          } // for - per Session
                        } //try
                        catch (Exception) {
                          print("lecture");
                        }
                      }
                      //retriving Pract Attendance
                      if (DateWiseData.containsKey("Practical")) {
                        try {
                          apract = true;
                          print("unser");
                          Map PracticalData =
                          DateWiseData['Practical'][Studinfo.batch]; // Lecture
                          total_pract +=
                              int.parse(PracticalData['practcount'].toString());
                          int pract_held =
                          int.parse(PracticalData['practcount'].toString());
                          for (int i = 1; i <= pract_held; i++) {
                            String key = i.toString();
                            Map SessionData = PracticalData[key]; // Lecture
                            try {
                              if (SessionData.containsKey(Studinfo.roll)) {
                                attended_pract = attended_pract + 1;
                              }
                            } catch (Exception) {
                              print("Session");
                            }
                          } // for - per Session
                        } //try
                        catch (Exception) {
                          print("count");
                        }
                      }
                      print("end");
                    }
                  } catch (Exception) {
                    print("prac");
                  }
                } //for - per Teacher
                //print(attended_lect);

                if (alect == true) {
                  print("inside");
                  await FirebaseDatabase.instance.reference().child("defaulter")
                      .child(Studinfo.branch).child(Studinfo.classs)
                      .child(Studinfo.roll).child(sub_teach.toUpperCase()).set(
                      ((attended_lect / total_lect) * 100).toString() + "%");
                }
                print(alect);
                print(apract);
                if (apract) {
                  print(Studinfo.roll + Studinfo.branch + Studinfo.classs +
                      sub_teach);
                  await FirebaseDatabase.instance.reference().child("defaulter")
                      .child(Studinfo.branch).child(Studinfo.classs)
                      .child(Studinfo.roll)
                      .child(sub_teach.toUpperCase() + "L")
                      .set(
                      ((attended_pract / total_pract) * 100).toString() + "%");
                }
              } //for - per Subject
              print(subject + " : ");
              print(
                  attended_lect.toString() + " out of " +
                      total_lect.toString());
              print(attended_pract.toString() +
                  " out of " +
                  total_pract.toString());
              print("set");
              AttendanceData a = new AttendanceData(subject, total_lect,
                  attended_lect, total_pract, attended_pract,total_tut,attended_tut);
              attendanceDataList.add(a);
              subjectList.add(subject);
            }
          } catch (Exception) {
            print("defa");
            //viewattendance=true;
          }
          subjectList = subjectList.toSet().toList();
        } //all data
      } catch (Exception) {
        print("innnn");
        //viewattendance=true;
      }
    });
  }
}

class Practicals {
  String subjectName = "";
  String batch = "";

  Practicals(String sub, String batch) {
    this.subjectName = sub;
    this.batch = batch;
  }
}

class TeacherData {
  String className, total;
  List<String> lectures = List<String>();
  List<String> practicals = List<String>();
  int leccount = 0;
  int practcount = 0;

  List<String> getLectures() {
    return lectures;
  }

  List<String> getPracticals() {
    return practicals;
  }

  TeacherData(className, total) {
    this.className = className;
    this.total = total;
  }
}
class warddata{
  String key;
  String value;
  warddata(String key,String value){
    this.key=key;
    this.value=value;
  }
  static List<warddata>warddatalist=List<warddata>();
  static void wardinfo(String prn,String classs)async{
    warddatalist.clear();
    await FirebaseDatabase.instance.reference()
        .child("ParentTeacher")
        .child(Dateinfo.teachname)
        .child(classs)
        .child(prn)
        .once().then((onValue){
      Map map=onValue.value;
      for (final k in map.keys){
        warddata obj=new warddata(k.toString(), map[k].toString());
        warddatalist.add(obj);
      }
    });
  }

}
class Teacher {
  static List<String> lectlist = ["Select Class"],
      practlist = ["Select Class"],Tutlist=["Select"];
  static String className, total;
  static String subjectName = "";
  static String batch = "";
  static List<AttendanceData> attendanceDataList = List<AttendanceData>();
  static bool alect,apract,atut;
  static int attended_lect, total_lect, attended_pract, total_pract,sports,other,medical,attended_tut,total_tut;
  static var subjectList = ['Overall'];
  static String studprn,studclass,studbatch;



  static Future<void> classlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lectlist.clear();
    practlist.clear();
    Tutlist.clear();
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("personal_tt")
        .child(Dateinfo.dept)
        .child(Dateinfo.teachname)
        .once().then((snap) {
      try {
        Map days = snap.value;
        //int tot=0;
        for (final k in days.keys) {
          try {
            String dname = k.toString();
            int cnt=0;
            Map data = days[k];
            String value;
            for (final key in data.keys) {
              prefs.setString(dname + key.toString(), data[key]);
              value = data[key];
              var a = value.split(" ");
              if (a.length == 2) {
                cnt+=1;
                lectlist.add(a[0].toString());
                try {
                  List<String>lectsub = prefs.getStringList(
                      a[0].toString() + "_" + "l");
                  lectsub.add(a[1].toString());
                  prefs.setStringList(
                      a[0].toString() + "_" + "l", lectsub.toSet().toList());
                } catch (Exception) {
                  List<String> lectsub = ["Select sub"];
                  lectsub.clear();
                  lectsub.add(a[1].toString());
                  prefs.setStringList(
                      a[0].toString() + "_" + "l", lectsub.toSet().toList());
                }
              } else if(a.length==3){
                practlist.add(a[0].toString());
                cnt+=2;

                try {
                  List<String> practsub = prefs.getStringList(
                      a[0].toString() + "_" + "P");
                  practsub.add(a[1].toString());
                  prefs.setStringList(
                      a[0].toString() + "_" + "P", practsub.toSet().toList());
                  try {
                    List<String> batch = prefs.getStringList(a[1].toString());
                    batch.add(a[2].toString());
                    prefs.setStringList(a[1].toString(), batch);
                  } catch (Exception) {
                    List<String> batch = ["Select sub"];
                    batch.clear();
                    batch.add(a[2].toString());
                    prefs.setStringList(a[1].toString(), batch);
                  }
                } catch (Exception) {
                  List<String> practsub = ["Select sub"];
                  practsub.clear();
                  practsub.add(a[1].toString());
                  print(a[0] + practsub.toString());
                  prefs.setStringList(
                      a[0].toString() + "_" + "P", practsub.toSet().toList());
                  List<String> batch = ["Select sub"];
                  batch.clear();
                  batch.add(a[2].toString());
                  prefs.setStringList(a[1].toString(), batch);
                }
              } else {
                Tutlist.add(a[0].toString());
                cnt+=1;
                try {
                  List<String> tutsub = prefs.getStringList(
                      a[0].toString() + "_" + "T");
                  tutsub.add(a[1].toString());
                  prefs.setStringList(
                      a[0].toString() + "_" + "T", tutsub.toSet().toList());
                  try {
                    List<String> batch = prefs.getStringList(a[1].toString()+"T");
                    batch.add(a[2].toString());
                    prefs.setStringList(a[1].toString()+"T", batch);
                  } catch (Exception) {
                    List<String> batch = ["Select sub"];
                    batch.clear();
                    batch.add(a[2].toString());
                    prefs.setStringList(a[1].toString()+"T", batch);
                  }
                } catch (Exception) {
                  List<String> tutsub = ["Select sub"];
                  tutsub.clear();
                  tutsub.add(a[1].toString());
                  print(a[0] + tutsub.toString());
                  prefs.setStringList(
                      a[0].toString() + "_" + "T", tutsub.toSet().toList());
                  List<String> batch = ["Select sub"];
                  batch.clear();
                  batch.add(a[2].toString());
                  prefs.setStringList(a[1].toString()+"T", batch);
                }
              }
            }
            prefs.setInt(dname, cnt); //tot+=cnt;
          } catch (Exception) {
            print("inside");
          }
        }
//        prefs.setInt("", tot);
        prefs.setStringList("lecture", lectlist.toSet().toList());
        prefs.setStringList("Practical", practlist.toSet().toList());
        prefs.setStringList("Tutorial", Tutlist.toSet().toList());

      } catch (Exception) {
        print("outside");
      }
    });
  }





  static Future<void> getprndata(String prn,String classs,String batch) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> lectlist = [" "];
    List<String> practlist = [" "];
    List<String> tlectlist = [" "];
    List<String> tpractlist = [" "];
    List<String> ttutlist = [" "];
    List<String> tutlist = [" "];

    var tmap = new Map();
    var map = new Map();
    var tvalues = new Map();
    var values = new Map();

    alect = false;
    apract = false;
    atut=false;
    subjectList.clear();
    subjectList.add("Overall");



    await FirebaseDatabase.instance
        .reference()
        .child('defaulter')
        .child(Dateinfo.dept)
        .child(classs)
        .child(prn)
        .once()
        .then((snapshot) async {
      try {
        Map data = snapshot.value;
        try {
          for (final key in data.keys) {
            if (!(key.toString() == "Total")) {
              try {
                var a = key.toString().split("_");
                if(a.length==1) throw Exception;
                if (a.length == 2) {
//                  prefs.setInt(a[0].toString() + a[1].toString(), data[key]);
                  values.addAll({a[0].toString() + a[1].toString(): data[key]});
                } else {
//                  prefs.setInt(
//                      a[0].toString() + a[1].toString() + "L", data[key]);
                  if(a.length==3) {
                    values.addAll(
                        {a[0].toString() + a[1].toString() + "L": data[key]});
                  }else{
                    values.addAll(
                        {a[0].toString() + a[1].toString() + "T": data[key]});
                  }
                }
              }catch(Exception){
                values.addAll({key.toString():data[key]});
              }
            }
          }
        } catch (Exception) {
          print("inside");
        }
      } catch (Exception) {
        print("object");
      }
      // getlist();
    });


    try {
      await FirebaseDatabase.instance
          .reference()
          .child('defaulter')
          .child(Dateinfo.dept)
          .child(classs)
          .child("AATotal")
          .once()
          .then((snapshot) async {
        Map data = snapshot.value;
        lectlist.clear();
        practlist.clear();
        tlectlist.clear();
        tpractlist.clear();
        ttutlist.clear();
        tutlist.clear();
        for (final key in data.keys) {
          if (!(key.toString() == "Total")) {
            var a = key.toString().split("_");
            String subject = a[0];
            if (a.length == 2) {
              alect = true;
              subjectList.add(subject);
              tlectlist.add("t" + a[0].toString());
              lectlist.add(a[0].toString());
              // print("lol");
              try {
                List<String>tteacher = prefs.getStringList(
                    "t" + a[0].toString());
                tteacher.add("t" + a[1].toString());
//                prefs.setStringList(
//                    "t" + a[0].toString(), tteacher.toSet().toList());
                tmap.addAll({"t" + a[0].toString(): tteacher.toSet().toList()});
                List<String>teacher = prefs.getStringList(a[0].toString());
                teacher.add(a[1].toString());
//                prefs.setStringList(a[0].toString(), teacher.toSet().toList());
                map.addAll({a[0].toString(): teacher.toSet().toList()});
              } catch (Exception) {
                List<String>tteacher = [" "];
                tteacher.clear();
                tteacher.add("t" + a[1].toString());
//                prefs.setStringList(
//                    "t" + a[0].toString(), tteacher.toSet().toList());
                tmap.addAll({"t" + a[0].toString(): tteacher.toSet().toList()});

                List<String>teacher = [" "];
                teacher.clear();
                teacher.add(a[1].toString());
//                prefs.setStringList(a[0].toString(), teacher.toSet().toList());
                map.addAll({a[0].toString(): teacher.toSet().toList()});
              }
//              prefs.setInt("t" + a[0].toString() + a[1].toString(), data[key]);
              tvalues.addAll(
                  {"t" + a[0].toString() + a[1].toString(): data[key]});
              try {
                if (!(values.containsKey(a[0].toString() + a[1].toString()))) {
                  throw Exception;
                }
//                if (!(prefs.containsKey(a[0].toString() + a[1].toString()))) {
//                  throw Exception;
//                }
                // print(prefs.getInt(a[0].toString() + a[1].toString()));
              }
              catch
              (Exception) {
//                prefs.setInt(a[0].toString() + a[1].toString(), 0);
                values.addAll({a[0].toString() + a[1].toString(): 0});
                // print("saved");
              }
            } else {
              if (a.length == 3){
                if (a[2] == batch) {
                  apract = true;
                  subjectList.add(subject);
                  tpractlist.add("t" + a[0].toString() + "L");
                  practlist.add(a[0].toString() + "L");
                  try {
                    List<String>tteacher = prefs.getStringList("t" +
                        a[0].toString() + "L");
                    tteacher.add("t" + a[1].toString() + "L");
//                  prefs.setStringList(
//                      "t" + a[0].toString() + "L", tteacher.toSet().toList());
                    tmap.addAll(
                        {
                          "t" + a[0].toString() + "L": tteacher.toSet().toList()
                        });
                    List<String>teacher = prefs.getStringList(
                        a[0].toString() + "L");
                    teacher.add(a[1].toString() + "L");
//                  prefs.setStringList(
//                      a[0].toString() + "L", teacher.toSet().toList());
                    map.addAll(
                        {a[0].toString() + "L": teacher.toSet().toList()});
                  } catch (Exception) {
                    List<String>tteacher = [" "];
                    tteacher.clear();
                    tteacher.add("t" + a[1].toString() + "L");
//                  prefs.setStringList(
//                      "t" + a[0].toString() + "L", tteacher.toSet().toList());
                    tmap.addAll(
                        {
                          "t" + a[0].toString() + "L": tteacher.toSet().toList()
                        });

                    List<String>teacher = [" "];
                    teacher.clear();
                    teacher.add(a[1].toString() + "L");

//                  prefs.setStringList(
//                      a[0].toString() + "L", teacher.toSet().toList());
                    map.addAll(
                        {a[0].toString() + "L": teacher.toSet().toList()});
                  }
//                prefs.setInt(
//                    "t" + a[0].toString() + a[1].toString() + "L", data[key]);
                  tvalues.addAll(
                      {
                        "t" + a[0].toString() + a[1].toString() + "L": data[key]
                      });

                  try {
                    if (!(values.containsKey(
                        a[0].toString() + a[1].toString() + "L"))) {
                      throw Exception;
                    }
//                  if (!(prefs.containsKey(
//                      a[0].toString() + a[1].toString() + "L"))) {
//                    throw Exception;
//                  }
                  } catch (Exception) {
//                  prefs.setInt(a[0].toString() + a[1].toString() + "L", 0);
                    values.addAll({a[0].toString() + a[1].toString() + "L": 0});
                  }
                }
              }else{
                if (a[2] == batch) {
                  atut = true;
                  subjectList.add(subject);
                  ttutlist.add("t" + a[0].toString() + "T");
                  tutlist.add(a[0].toString() + "T");
                  try {
                    List<String>tteacher = prefs.getStringList("t" +
                        a[0].toString() + "T");
                    tteacher.add("t" + a[1].toString() + "T");
//                  prefs.setStringList(
//                      "t" + a[0].toString() + "L", tteacher.toSet().toList());
                    tmap.addAll(
                        {
                          "t" + a[0].toString() + "T": tteacher.toSet().toList()
                        });
                    List<String>teacher = prefs.getStringList(
                        a[0].toString() + "T");
                    teacher.add(a[1].toString() + "T");
//                  prefs.setStringList(
//                      a[0].toString() + "L", teacher.toSet().toList());
                    map.addAll(
                        {a[0].toString() + "T": teacher.toSet().toList()});
                  } catch (Exception) {
                    List<String>tteacher = [" "];
                    tteacher.clear();
                    tteacher.add("t" + a[1].toString() + "T");
//                  prefs.setStringList(
//                      "t" + a[0].toString() + "L", tteacher.toSet().toList());
                    tmap.addAll(
                        {
                          "t" + a[0].toString() + "T": tteacher.toSet().toList()
                        });

                    List<String>teacher = [" "];
                    teacher.clear();
                    teacher.add(a[1].toString() + "T");

//                  prefs.setStringList(
//                      a[0].toString() + "L", teacher.toSet().toList());
                    map.addAll(
                        {a[0].toString() + "T": teacher.toSet().toList()});
                  }
//                prefs.setInt(
//                    "t" + a[0].toString() + a[1].toString() + "L", data[key]);
                  tvalues.addAll(
                      {
                        "t" + a[0].toString() + a[1].toString() + "T": data[key]
                      });

                  try {
                    if (!(values.containsKey(
                        a[0].toString() + a[1].toString() + "T"))) {
                      throw Exception;
                    }
//                  if (!(prefs.containsKey(
//                      a[0].toString() + a[1].toString() + "L"))) {
//                    throw Exception;
//                  }
                  } catch (Exception) {
//                  prefs.setInt(a[0].toString() + a[1].toString() + "L", 0);
                    values.addAll({a[0].toString() + a[1].toString() + "T": 0});
                  }
                }
              }
            }
          }
        }
        if (alect == true || apract == true|| atut==true) {
//          prefs.setStringList("tlecture", tlectlist.toSet().toList());
//          prefs.setStringList("tPractical", tpractlist.toSet().toList());
//          prefs.setStringList("lecture", lectlist.toSet().toList());
//          prefs.setStringList("Practical", practlist.toSet().toList());
//          prefs.setStringList("subjectlist", subjectList.toSet().toList());
          subjectList = subjectList.toSet().toList();
          tlectlist = tlectlist.toSet().toList();
          tpractlist = tpractlist.toSet().toList();
          practlist = practlist.toSet().toList();
          lectlist = lectlist.toSet().toList();
          ttutlist=ttutlist.toSet().toList();
          tutlist=tutlist.toSet().toList();
        }
        else {
          throw Exception;
        }
      });
    }catch(Exception){
      print("sdc");
    }
    attendanceDataList.clear();
    sports=0;
    medical=0;
    other=0;
    for (int i = 1; i < subjectList.length; i++) {
      attended_lect = 0;
      total_lect = 0;
      attended_pract = 0;
      total_pract = 0;
      attended_tut=0;
      total_tut=0;

      if (lectlist.contains(subjectList[i])) {
        List<String> Adata = map[subjectList[i]];
        List<String>Tdata = tmap["t" + subjectList[i]];
        for (int j = 0; j < Adata.length; j++) {
          print(subjectList[i]+Adata[j]);
          attended_lect += values[subjectList[i] + Adata[j]];
          total_lect += tvalues["t" + subjectList[i] + Adata[j]];
        }
      }
      if (practlist.contains(subjectList[i] + "L")) {
        List<String> Adata = map[subjectList[i] + "L"];
        List<String>Tdata = tmap["t" + subjectList[i] + "L"];
        //print(Adata);
        for (int j = 0; j < Adata.length; j++) {
          attended_pract += values[subjectList[i] + Adata[j]];
          total_pract += tvalues["t" + subjectList[i] + Adata[j]];
        }
      }
      if (tutlist.contains(subjectList[i] + "T")) {
        List<String> Adata = map[subjectList[i] + "T"];
        List<String>Tdata = tmap["t" + subjectList[i] + "T"];
        //print(Adata);
        for (int j = 0; j < Adata.length; j++) {
          attended_tut += values[subjectList[i] + Adata[j]];
          total_tut += tvalues["t" + subjectList[i] + Adata[j]];
        }
      }
      AttendanceData a = new AttendanceData(subjectList[i], total_lect,
          attended_lect, total_pract, attended_pract,total_tut,attended_tut);
      attendanceDataList.add(a);
    }
    if(values.containsKey("medical")){
      medical=values["medical"];
    }
    if(values.containsKey("sports")){
      sports=values["sports"];
    }
    if(values.containsKey("other")){
      other=values["other"];
    }
  }
//    await databaseReference.child("Registration")
//        .child('Teacher_account')
//        .child(Dateinfo.email)
//        .child('class_sub')
//        .child('Practical')
//        .once()
//        .then((snapshot) {
//      try {
//        Map data = snapshot.value;
//        for(final k in data.keys) {
//        //  cla.add(k.toString());
//          practlist.add(k.toString());
//          List<String> practsub=["Select sub"];
//          practsub.clear();
//          Map classData = data[k];
//          for (final k in classData.keys) {
//          //  sub.add(k.toString());
//            practsub.add(k.toString());
//          }
//          prefs.setStringList(k.toString()+"_"+"P", practsub);
//        }
//        prefs.setStringList("Practical", practlist);
//      } catch (Exception) {
//        print("practical");
//      }
//
//    });
//    await databaseReference.child("Registration")
//        .child('Teacher_account')
//        .child(Dateinfo.email)
//        .child('class_sub')
//        .child('lecture')
//        .once()
//        .then((snapshot) {
//      try {
//        Map data = snapshot.value;
//        for (final k in data.keys) {
//         // cla.add(k.toString());
//          lectlist.add(k.toString());
//          List<String> lectsub=["Select sub"];
//          lectsub.clear();
//          Map classData = data[k];
//          for (final k in classData.keys){
//          //  sub.add(k.toString());
//            lectsub.add(k.toString());
//          }
//          prefs.setStringList(k.toString()+"_"+"l", lectsub);
//        }
//        prefs.setStringList("lecture", lectlist);
//      } catch (Exception) {
//        print("Ecept");
//      }
//    });


  static Future<void> data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("check") == false) {
      classlist();
      prefs.setBool("check", true);
      final databaseReference = FirebaseDatabase.instance.reference();
      await databaseReference.child("teach_att")
          .child(Dateinfo.dept).child(Dateinfo.teachname).once().then((snap) {
        try {
          Map map = snap.value;
          List<String> scount = ["hisedcv"];
          scount.clear();
          for (final k in map.keys) {
            className = k.toString();
            total = map[k].toString();
            prefs.setString(className, total.toString());
            scount.add(className);
          }
          prefs.setStringList("scount", scount);
          //print(scount);
        } catch (Exception) {
          print("except1");
        }
      });
    }
  }
  static void update()async{
    var ford = new DateFormat("yyyy_MM_dd");
    var now = new DateTime.now();
    String date = ford.format(now);
    int current = DateTime.utc(now.year, now.month, 1).weekday;
    int weekno = 0;
    int i = 9 - current;
    for (; i < 30; i += 7) {
      weekno += 1;
      if (now.day < i) {
        break;
      }
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      if (prefs.getInt("week_no") == weekno) {
        prefs.setBool("reset_week", false);
      } else {
        prefs.setInt("week_no", weekno);
        prefs.setBool("reset_week", true);
        prefs.setInt("weekc", 0);
      }
//      print(date);
//      print(prefs.getString("today_date"));
      //print(date);
      if ((prefs.getString("today_date") == date)) {
        prefs.setBool("reset", false);
      } else {
        prefs.setString("today_date", date);
        prefs.setBool("reset", true);
        prefs.setInt("dayc", 0);


        if (prefs.getStringList("scount") != null) {
          // print("get");
          List<String> scount = prefs.getStringList("scount");
          for (int i = 0; i < scount.length; i++) {
            //print("kk");
            var dummy = prefs.getString(scount[i]).split(" ");
            prefs.setString(scount[i], dummy[0].toString() + " " + "0");
          }
        }
      }
    } catch (exception) {
      print("wedf");
      prefs.setBool("reset", true);
      prefs.setBool("reset_week", true);
    }
  }
}

class Internet {
  static Connectivity _connectivity;
  static StreamSubscription<ConnectivityResult> _subscription;

  static Future<void> connect() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      print(result);
      Fluttertoast.showToast(
          msg: "Not Connected",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      print(result);
      Fluttertoast.showToast(
          msg: "Connected",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print(DataConnectionChecker().lastTryResults);
    }
  }

}

class details {
  String teachername = "",
      subject = "",
      batch = "",
      total = "",
      time = "";

  details(String teachername, String subject, String total, String time,
      String batch) {
    this.teachername = teachername;
    this.subject = subject;
    this.total = total;
    this.time = time;
    this.batch = batch;
  }
}

class admin {
  static String classs, date;
  List<details> adminlist = new List<details>();

  Future<void> check() async {
    adminlist.clear();
    final databaseReference = FirebaseDatabase.instance.reference().child(
        "time_table").child(Dateinfo.dept);
    await databaseReference.child(admin.classs)
        .child(admin.date)
        .once().then((snap) async {
      try {
        Map data = snap.value;
        for (final i in data.keys) {
          //print(i);
          try {
            Map map = data[i];
            //  print(map);
            this.adminlist.add(new details(
                map["name"], map["subject"], map["total"], i.toString(),
                map["batch"]));
          }
          catch (Exception) {
            print("map");
          }
        }
      } catch (Exception) {
        print("here");
      }
    });
    print(this.adminlist);
  }

}