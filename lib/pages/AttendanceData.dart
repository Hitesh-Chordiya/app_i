import 'dart:async';
import 'dart:core';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/pages/subject.dart';
import 'package:flutter_app/responsive/Screensize.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceData {
  String subjectName;
  int total_lect;
  int attended_lect;
  int total_pract = 0;
  int attended_pract = 0;
  double total_attendance = 0.0;

  int get total_lectures => total_lect;

  int get attended_lectures => attended_lect;

  int get total_practicals => total_pract;

  int get attended_practicals => attended_pract;

  String get subject_name => subjectName;

  AttendanceData(
      subjectName, total_lect, attended_lect, total_pract, attended_pract) {
    this.attended_pract = attended_pract;
    this.attended_lect = attended_lect;
    this.total_pract = total_pract;
    this.total_lect = total_lect;
    this.subjectName = subjectName;

    if (total_lect == 0 && total_pract == 0) {
      this.total_attendance = 100.0;
    } else {
      this.total_attendance =
          ((attended_lect + attended_pract) / (total_pract + total_lect)) * 100;
    }
  }
}

class user {
  static String classs, sub, stat, date, lec, count="0";
}
class total{
  static String dep,classs;
  static int count;
  static Map studnames;
}
class Dateinfo {
  static Map part1;
  static List<String> list = [" "],prnlist=[" "];
  static String date1,type,
      part,
      classs,
      subject,
      teachname="name",
      teachemail="E-mail",
      lecnumber,
      dept,
      stat,
      email="E-mail";
  static int count;
  static bool viewmod,fetch=false;

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
          .child("Practical")
          .child(Alert.batch)
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
  static String name="name", branch, email="E-mail", roll, classs, batch, prn;
  static bool fetch=false;
}

class Alert {
  static bool check;
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
              data: ThemeData(accentColor: Colors.yellow,
              primaryColor: Colors.yellow,
              textTheme: TextTheme()),
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
                              fontSize: 2.7*SizeConfig.textMultiplier),
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
                                  fontSize: 2.7*SizeConfig.textMultiplier)),
                          onChanged: (val) {
                            review=val;
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
                accentColor: Colors.yellow,
                // optional
                onSubmitPressed: (int rating) {
                  print("onSubmitPressed: rating = $rating");
                  // TODO: open the app's page on Google Play / Apple App Store
                  FirebaseDatabase.instance.reference().child("Reviews").child(name).set({
                    "Rating":rating,
                    "Message": review
                  });
                },
              ),
            ),
          );
        });
  }

  static String batch;

  static dialog(BuildContext context) async {
    final dbref = FirebaseDatabase.instance.reference();
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
                              child: RaisedButton(
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
                                  if (check == true) {
                                    await dbref
                                        .child("Teacher_account")
                                        .child(Dateinfo.email)
                                        .child("class_sub")
                                        .child(Dateinfo.stat)
                                        .child(Dateinfo.classs)
                                        .child(Dateinfo.subject)
                                        .set(Alert.batch);
                                  } else {
                                    await FirebaseDatabase.instance
                                        .reference()
                                        .child("Attendance")
                                        .child(Dateinfo.dept)
                                        .child(Dateinfo.classs)
                                        .child(Dateinfo.subject)
                                        .child(Dateinfo.teachname)
                                        .child(Dateinfo.date1)
                                        .child(Dateinfo.stat)
                                        .child(Alert.batch)
                                        .child("practcount")
                                        .once()
                                        .then((snap) async {
                                      Dateinfo.part = snap.value;
                                    });
                                  }

                                  Navigator.pop(context);
                                },

                                //color: const Color(0xFF1BC0C5),
                              ),
                            ),
                            SizedBox(
                              child: RaisedButton(
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
                                  if (check == true) {
                                    await dbref
                                        .child("Teacher_account")
                                        .child(Dateinfo.email)
                                        .child("class_sub")
                                        .child(Dateinfo.stat)
                                        .child(Dateinfo.classs)
                                        .child(Dateinfo.subject)
                                        .set(Alert.batch);
                                  } else {
                                   await  FirebaseDatabase.instance
                                        .reference()
                                        .child("Attendance")
                                        .child(Dateinfo.dept)
                                        .child(Dateinfo.classs)
                                        .child(Dateinfo.subject)
                                        .child(Dateinfo.teachname)
                                        .child(Dateinfo.date1)
                                        .child(Dateinfo.stat)
                                        .child(Alert.batch)
                                        .child("practcount")
                                        .once()
                                        .then((snap) async {
                                      Dateinfo.part = snap.value;
                                    });
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            SizedBox(
                              child: RaisedButton(
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
                                  if (check == true) {
                                    await dbref
                                        .child("Teacher_account")
                                        .child(Dateinfo.email)
                                        .child("class_sub")
                                        .child(Dateinfo.stat)
                                        .child(Dateinfo.classs)
                                        .child(Dateinfo.subject)
                                        .set(Alert.batch);
                                  } else {
                                    await FirebaseDatabase.instance
                                        .reference()
                                        .child("Attendance")
                                        .child(Dateinfo.dept)
                                        .child(Dateinfo.classs)
                                        .child(Dateinfo.subject)
                                        .child(Dateinfo.teachname)
                                        .child(Dateinfo.date1)
                                        .child(Dateinfo.stat)
                                        .child(Alert.batch)
                                        .child("practcount")
                                        .once()
                                        .then((snap) async {
                                      Dateinfo.part = snap.value;
                                    });
                                  }
                                  Navigator.pop(context);
                                },
                              ),
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
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }
}

class Attendance {
  // ignore: non_constant_identifier_names
  static int k = 0;
  static String subject;
  static String sub_teach,name;
  static bool viewattendance,alect,apract;
  static List<AttendanceData> attendanceDataList = List<AttendanceData>();

  static int attended_lect, total_lect, attended_pract, total_pract;
  static var subjectList = ['Overall'];

  static Future<void> view() async {
    attendanceDataList.clear();
    subjectList.clear();
    viewattendance=false;
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
            if(!(key.toString()=="total")){
              Map subjectData = data[key];
              subject = key.toString();
              attended_lect = 0;
              total_lect = 0;
              attended_pract = 0;
              total_pract = 0;
              for (final key in subjectData.keys) {
                Map TeacherData = subjectData[key];
                name=key.toString();
                alect=false;
                apract=false;
                for (final key in TeacherData.keys) {
                  try {
                    if(!(key.toString()=="total")){
                      Map DateWiseData = TeacherData[key];
                      viewattendance=true;
                      // retriving lecture Attendance
                      if(DateWiseData.containsKey("lecture")){
                        sub_teach=subject+"_"+name;alect=true;
                        try {
                          Map lectureData = DateWiseData['lecture']; // Lecture
                          total_lect += int.parse(lectureData['leccount'].toString());
                          int lect_held =
                          int.parse(lectureData['leccount'].toString());

                          for (int i = 1; i <= lect_held; i++) {
                            String key = i.toString();
                            Map SessionData = lectureData[key]; // Lecture
                            try {
                              if(SessionData.containsKey(Studinfo.roll)){
                                attended_lect=attended_lect+1;
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
                      if(DateWiseData.containsKey("Practical")){
                        try {apract=true;
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
                            if(SessionData.containsKey(Studinfo.roll)){
                              attended_pract=attended_pract+1;
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
                    }

                  } catch (Exception) {
                    print("prac");
                  }

                } //for - per Teacher
                if(alect==true){
                  await FirebaseDatabase.instance.reference().child("defaulter")
                      .child(Studinfo.branch).child(Studinfo.classs)
                      .child(Studinfo.roll).child(sub_teach.toUpperCase()).set(((attended_lect/total_lect)*100).toString()+"%");
                }
                if(apract==true){
                  await FirebaseDatabase.instance.reference().child("defaulter")
                      .child(Studinfo.branch).child(Studinfo.classs)
                      .child(Studinfo.roll).child(sub_teach.toUpperCase()+"L").set(((attended_pract/total_pract)*100).toString()+"%");

                }
              } //for - per Subject
              print(subject + " : ");
              print(
                  attended_lect.toString() + " out of " + total_lect.toString());
              print(attended_pract.toString() +
                  " out of " +
                  total_pract.toString());

              AttendanceData a = new AttendanceData(subject, total_lect,
                  attended_lect, total_pract, attended_pract);
              attendanceDataList.add(a);
              subjectList.add(subject);

            }
          } catch (Exception) {
            print("in");
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
  String subjectName="";
  String batch="";

  Practicals(String sub, String batch) {
    this.subjectName = sub;
    this.batch = batch;
  }
}

class TeacherData {
  String className,total;
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
  TeacherData(className, total){
    this.className=className;
    this.total=total;
  }
}

class Teacher {
  static List<String> sub=["Select Class"],cla=["Select Subject"],lectlist=["Select Class"],practlist=["Select Class"];
  static String className,total;
  static String subjectName = "";
  static String batch = "";
  static Future<void> classlist()async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    sub.clear();
    cla.clear();
    lectlist.clear();
    practlist.clear();
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference
        .child('Teacher_account')
        .child(Dateinfo.email)
        .child('class_sub')
        .child('Practical')
        .once()
        .then((snapshot) {
      try {
        Map data = snapshot.value;
        for(final k in data.keys) {
          cla.add(k.toString());
          practlist.add(k.toString());
          Map classData = data[k];
          List<String> practsub=["Select sub"];
          practsub.clear();
          for (final k in classData.keys) {
            sub.add(k.toString());
            practsub.add(k.toString());
          }
          prefs.setStringList(k.toString()+"_"+"P", practsub);
        }
        prefs.setStringList("Practical", practlist);
      } catch (Exception) {
        print("except");
      }

    });
    await databaseReference
        .child('Teacher_account')
        .child(Dateinfo.email)
        .child('class_sub')
        .child('lecture')
        .once()
        .then((snapshot) {
      try {
        Map data = snapshot.value;
        for (final k in data.keys) {
          cla.add(k.toString());
          lectlist.add(k.toString());
          List<String> lectsub=["Select sub"];
          lectsub.clear();
          Map classData = data[k];
          for (final k in classData.keys){
            sub.add(k.toString());
            lectsub.add(k.toString());
          }
          prefs.setStringList(k.toString()+"_"+"l", lectsub);
        }
        prefs.setStringList("lecture", lectlist);
      } catch (Exception) {
        print("Ecept");
      }
    });
  }
  static Future<void> data() async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    if(prefs.getBool("check")==false){
      classlist();
      prefs.setBool("check", true);
      final databaseReference = FirebaseDatabase.instance.reference();
      await databaseReference.child("teach_att")
          .child(Dateinfo.dept).child(Dateinfo.teachname).once().then((snap){
        try{
          Map map=snap.value;
          List<String> scount=["hisedcv"];
          scount.clear();
          for(final k in map.keys) {
            className = k.toString();
            total = map[k].toString();
            prefs.setString(className, total.toString());
            scount.add(className);
          }
        prefs.setStringList("scount", scount);
        }catch(Exception){
            print("except1");
        }
      });
    }


  }
}
class Internet{
  static Connectivity _connectivity;
  static StreamSubscription<ConnectivityResult> _subscription;

  static Future<void> connect() async {
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.none) {
      print(result);
      Fluttertoast.showToast(
          msg: "Not Connected",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if(result == ConnectivityResult.mobile||result == ConnectivityResult.wifi){
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
class details{
  String teachername="",subject="",batch="",total="",time="";
  details(String teachername,String subject,String total,String time,String batch){
    this.teachername=teachername;
    this.subject=subject;
    this.total=total;
    this.time=time;
    this.batch=batch;

  }
}
class admin{
  static String classs,date;
  List<details>  adminlist =new List<details>();

  Future<void> check() async {
    adminlist.clear();
    final databaseReference = FirebaseDatabase.instance.reference().child("time_table").child(Dateinfo.dept);
    await databaseReference.child(admin.classs)
        .child(admin.date)
        .once().then((snap) async {
      try{
        Map data=snap.value;
        for(final i in data.keys){
          //print(i);
          try{
            Map map=data[i];
            //  print(map);
            this.adminlist.add(new details(map["name"], map["subject"], map["total"], i.toString(),map["batch"]));
          }
          catch(Exception){
            print("map");
          }
        }
      }catch(Exception){
        print("here");
      }
    });
    print(this.adminlist);
  }

}