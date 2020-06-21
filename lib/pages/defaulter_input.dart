import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/pages/TeacherHome.dart';
import 'package:flutter_app/pages/parentteacherlist.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/AttendanceData.dart';
import 'package:flutter_app/responsive/Screensize.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AttendanceData.dart';

// ignore: camel_case_types
class defaulter extends StatefulWidget {
  @override
  defaulterState createState() => defaulterState();
}

class defaulterState extends State<defaulter> {
  @override
  void initState() {
    // TODO: implement initState
    copy();
    super.initState();
  }

  Map map, dates;
  var s1;
  Color dropcolor = Color(0xff996600);
  Color leftcolor = Color(0xff392613);
  String classs = 'Class',
      _subject = "Subject",
      stat = "Select";
  List<String> classlist = ["Class"],
      subjectlist = ["Subject"];
  int group;
  bool isloading = false,
      show = true;
  final dbref = FirebaseDatabase.instance.reference();
  FocusNode focusNode5 = new FocusNode();
  static SharedPreferences prefs;

  void copy() async {
    classlist.clear();
    prefs = await SharedPreferences.getInstance();

    setState(() {
      subjectlist = prefs.getStringList("scount");
      for (int i = 0; i < subjectlist.length; i++) {
        var a = subjectlist[i].split("_");
        classlist.add((a[0] + "_" + a[1]));
      }
      classlist=classlist.toSet().toList();
      //print(classlist);
    });
  }

  String date = "Select Date";
  dynamic value;
  bool mark;
  String map1;
  var myFormat = DateFormat('yyyy_MM_dd');

  Future<bool> _onbackpressed() {
    if (isloading == true) {
      setState(() {
        isloading = false;
        show = true;
      });
    } else {
      // if(isloading==false && show==true){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => thome(),
          ));
      //}
    }
  }

  @override
  Widget build(BuildContext context) {
    // copy();
    //print(classlist);
    ProgressDialog pr = new ProgressDialog(context);
    pr.style(message: "wait");
    return WillPopScope(
      onWillPop: _onbackpressed,
      child: new Scaffold(
        body: isloading
            ? show
            ? new SpinKitThreeBounce(
          color: Color(0xff8a8a5c),
          size: 40.0,
          // controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
        )
            : Container(
          //   height: 50*SizeConfig.heightMultiplier,
          color: Colors.black,
          child: ListView.builder(
            padding: kMaterialListPadding,
            itemCount: Dateinfo.prnlist.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 18 * SizeConfig.heightMultiplier,
                child: Card(
                  elevation: 50,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0)),
                  child: ListTile(
                    //isThreeLine: false,
                    title: RichText(
                      text: TextSpan(
                          text: "   PRN : ",
                          style: TextStyle(
                              color: Color(0xffcc0052),
                              fontFamily: "Roboto",
                              fontSize:
                              2.3 * SizeConfig.heightMultiplier,
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                                text: Dateinfo.prnlist
                                    .elementAt(index)
                                    .toString() +
                                    "\t\t",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ]),
                    ),
                    subtitle: RichText(
//                      textAlign: TextAlign.justify,

                      text: TextSpan(
                        text: "           Name : ",
                        style: TextStyle(
                            color: Color(0xffcc0052),
                            fontFamily: "Roboto",
                            fontSize: 2.3 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: obj.studmap[(Dateinfo.prnlist
                                  .elementAt(index)
                                  .toString())]["name"]
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(text: "\n   Remedial hr : "),
                          TextSpan(
                              text: obj.studmap[(Dateinfo.prnlist
                                  .elementAt(index)
                                  .toString())]["work load"]
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: "\n           subject att : "),
                          TextSpan(
                              text: obj.studmap[(Dateinfo.prnlist
                                  .elementAt(index)
                                  .toString())]["att"]
                                  .toStringAsFixed(2),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(text: "\n   Total att: "),
                          TextSpan(
                              text: obj.studmap[(Dateinfo.prnlist
                                  .elementAt(index)
                                  .toString())]["total"]
                                  .toStringAsFixed(2),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    //subtitle:
                    // const Text("hiiiii"),
                    trailing: obj.studmap[(Dateinfo.prnlist
                        .elementAt(index)
                        .toString())]["work load"] ==
                        0
                        ? Padding(
                      padding: EdgeInsets.only(
                          top: 2 * SizeConfig.heightMultiplier,
                          right:
                          5 * SizeConfig.widthMultiplier),
                      child: IconButton(
                        icon: Icon(
                          Icons.mood,
                          color: Colors.green,
                          size: 5 * SizeConfig.heightMultiplier,
                        ),
                      ),
                    )
                        : Padding(
                      padding: EdgeInsets.only(
                          top: 2 * SizeConfig.heightMultiplier,
                          right:
                          5 * SizeConfig.widthMultiplier),
                      child: IconButton(
                        icon: Icon(
                          Icons.mood_bad,
                          color: Colors.red,
                          size: 5 * SizeConfig.heightMultiplier,
                        ),
                        onPressed: () async {

                          bool cnfchn = false;
                          try {
                            List<String> batches =
                            new List<String>();
                            batches=prefs.getStringList(_subject);
                            if (batches!=null){
                              if((batches.contains(obj.studmap[(Dateinfo.prnlist
                                  .elementAt(index)
                                  .toString())]["batch"]))) {
                                throw Exception;
                              }
                            }
                            int totalatt = 0;
                            await Alert(
                              context: context,
                              type: AlertType.warning,
                              style: AlertStyle(
                                  animationType: AnimationType.fromTop,
                                  isCloseButton: false,

                                  isOverlayTapDismiss: false,
                                  descStyle: TextStyle(
                                      fontWeight: FontWeight.bold),
                                  animationDuration: Duration(
                                      milliseconds: 400),
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
                              title: "Confirm  Change",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(color: Colors.white,
                                        fontSize: 2.5 *
                                            SizeConfig.textMultiplier),
                                  ),
                                  // ignore: missing_return
                                  onPressed: () {
                                    setState(() {
                                      cnfchn = true;
                                    });
                                    Navigator.pop(context);
                                  },
                                  color: Color.fromRGBO(0, 179, 134, 1.0),
                                ),
                                DialogButton(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.white,
                                        fontSize: 2.5 *
                                            SizeConfig.textMultiplier),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      cnfchn = false;
                                    });
                                  },
                                  gradient: LinearGradient(colors: [
                                    Color(0xffe63900),
                                    Color(0xffe63900)
                                  ]),
                                )
                              ],
                            ).show();
                            if (cnfchn) {
//                              print("sd");
                              await dbref
                                  .child("defaulterlist")
                                  .child(Dateinfo.dept)
                                  .child(classs)
                                  .child(Dateinfo.prnlist
                                  .elementAt(index)
                                  .toString())
                                  .child("Total")
                                  .once()
                                  .then((onValue) {
                                totalatt = onValue.value;
                              });
                              //  print(totalatt);
                              dbref
                                  .child("defaulterlist")
                                  .child(Dateinfo.dept)
                                  .child(classs)
                                  .child(Dateinfo.prnlist
                                  .elementAt(index)
                                  .toString())
                                  .child("Total")
                                  .set(totalatt +
                                  obj.studmap[(Dateinfo
                                      .prnlist
                                      .elementAt(index)
                                      .toString())]
                                  ["work load"]);
                              int subtt = 0;
                              await dbref
                                  .child("defaulterlist")
                                  .child(Dateinfo.dept)
                                  .child(classs)
                                  .child(Dateinfo.prnlist
                                  .elementAt(index)
                                  .toString())
                                  .child(_subject)
                                  .once()
                                  .then((onValue) {
                                subtt = onValue.value;
                              });
                              dbref
                                  .child("defaulterlist")
                                  .child(Dateinfo.dept)
                                  .child(classs)
                                  .child(Dateinfo.prnlist
                                  .elementAt(index)
                                  .toString())
                                  .child(_subject)
                                  .set(subtt +
                                  obj.studmap[(Dateinfo
                                      .prnlist
                                      .elementAt(index)
                                      .toString())]
                                  ["work load"]);
                              List<String> sub =
                              new List<String>();

                              try {
                                sub = prefs
                                    .getStringList(classs + "_l");
                                sub.add("value");
                              } catch (Exception) {}
                              List<String> subp =
                              new List<String>();

                              try {
                                subp = prefs
                                    .getStringList(classs + "_P");
                                subp.add("value");
                              } catch (Exception) {}
                              List<String> subt =
                              new List<String>();
                              try {
                                subt = prefs
                                    .getStringList(classs + "_T");
                                subt.add("value");
                              } catch (Exception) {}

                              String key;
                              if (sub.contains(_subject)) {
                                key = _subject +
                                    "_" +
                                    Dateinfo.teachname;
                              } else if (subp
                                  .contains(_subject)) {
                                key = _subject +
                                    "_" +
                                    Dateinfo.teachname +
                                    "_" +
                                    obj.studmap[(Dateinfo.prnlist
                                        .elementAt(index)
                                        .toString())]["batch"];
                              } else if (subt
                                  .contains(_subject)) {
                                key = _subject +
                                    "_" +
                                    Dateinfo.teachname +
                                    "_" +
                                    obj.studmap[(Dateinfo.prnlist
                                        .elementAt(index)
                                        .toString())]["batch"];
                              } else {
                                throw Exception;
                              }
                              int count = 0;
                              await dbref
                                  .child("defaulter")
                                  .child(Dateinfo.dept)
                                  .child(classs)
                                  .child(Dateinfo.prnlist
                                  .elementAt(index)
                                  .toString())
                                  .child(key)
                                  .once()
                                  .then((onValue) {
                                if (onValue.value == null)
                                  count = 0;
                                else
                                  count = onValue.value;
                              });
                              dbref
                                  .child("defaulter")
                                  .child("modified")
                                  .child(Dateinfo.prnlist
                                  .elementAt(index)
                                  .toString())
                                  .set(1);
                              dbref
                                  .child("defaulter")
                                  .child(Dateinfo.dept)
                                  .child(classs)
                                  .child(Dateinfo.prnlist
                                  .elementAt(index)
                                  .toString())
                                  .child(key)
                                  .set(count +
                                  obj.studmap[(Dateinfo
                                      .prnlist
                                      .elementAt(index)
                                      .toString())]
                                  ["work load"]);
                              setState(() {
                                obj.studmap[(Dateinfo.prnlist
                                    .elementAt(index)
                                    .toString())]
                                ["work load"] = 0;
                              });
                            }
                          } catch (Exception) {
                            Fluttertoast.showToast(
                                msg: "you can't modify!!",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 2 *
                                    SizeConfig.textMultiplier);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ) :

        Container(
          color: Colors.black87,
          child: ListView.builder(
            padding: kMaterialListPadding,
            itemCount: classlist.length,
            itemBuilder: (BuildContext context, int index) {
              List<Color> cl1 = [
                Color(0xffffd966),
                Color(0xffadad85),
                Color(0xffff8080),
                Color(0xffccffff)
              ];
              double leftsize = 2.5 * SizeConfig.heightMultiplier,
                  rightsize = 2.2 * SizeConfig.heightMultiplier;
              List<Color> cl2 = [
                Color(0xffcc0052),
                Color(0xffcc0052),
                Color(0xffcc0052),
                Color(0xffcc0052)
              ];
              return Padding(
                padding: EdgeInsets.all(2 * SizeConfig.heightMultiplier),
                child: Container(
                  height: 18 * SizeConfig.heightMultiplier,
                  child: GradientCard(
                    elevation: 50,
                    gradient: LinearGradient(
                      colors: [
                        cl1[index % 4],
                        cl1[index % 4]
                      ],
                    ),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15.0)),
                    child: ListTile(
                      //isThreeLine: false,
                      title: RichText(
                        text: TextSpan(
                            text: "\n       Class : ",
                            style: TextStyle(
                                color: cl2[index % 4],
                                fontFamily: "Roboto",
                                fontSize:
                                leftsize,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text: classlist
                                      .elementAt(index)
                                      .toString().split("_")[0] +
                                      "\t\t",
                                  style: TextStyle(
                                      fontSize: rightsize,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ]),
                      ),
                      subtitle: RichText(
//                      textAlign: TextAlign.justify,

                        text: TextSpan(
                          text: "\n               Subject : ",
                          style: TextStyle(
                              color: cl2[index % 3],
                              fontFamily: "Roboto",
                              fontSize: leftsize,
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                                text: classlist.
                                elementAt(index)
                                    .toString().split("_")[1]
                                ,
                                style: TextStyle(
                                    fontSize: rightsize,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      onTap: () async {
                        setState(() {
                          isloading = true;
                        });
                        classs = classlist
                            .elementAt(index)
                            .toString().split("_")[0];
                        _subject = classlist
                            .elementAt(index)
                            .toString().split("_")[1];
                        try {
                          await attendanceCalculator(classs, _subject);
//                          pr.hide();
                          setState(() {
                            show = false;
                          });
                        } catch (Ex) {
                          // isloading=true;

                          Fluttertoast.showToast(
                              msg: "Generate defaulter list first!!",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 2 * SizeConfig.textMultiplier);
                          setState(() {
                            isloading = false;
                            show = true;
                          });
                        }
                      },

                    ),
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: FancyBottomNavigation(
          initialSelection: 2,
          activeIconColor: Colors.white,
          inactiveIconColor: HexColor.fromHex("#008080"),
          circleColor: HexColor.fromHex("#008080"),
          tabs: [
            TabData(iconData: Icons.home, title: "Home"),
            TabData(iconData: Icons.local_parking, title: "Parent Teacher"),
            TabData(iconData: Icons.assignment, title: "Remedial hr")
          ],
          onTabChangedListener: (position) {
            setState(() {
              // currentPage = position;
              if (position == 1) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Parentteacherlist(),
                    ));
              }
              if (position == 0) {
                //remedial
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => thome(),
                    ));
              }
            });
          },
        ),
        appBar: new AppBar(
          leading: IconButton(
              onPressed: () {
                // Navigator.pop(context);
                _onbackpressed();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          title: new Text("Homepage\\check att"),
          backgroundColor: Color(0xff008080),
        ),
      ),
    );
  }

  //Map emoji=new Map();
  Future<void> attendanceCalculator(String classs, String subject) async {
    final dbref = FirebaseDatabase.instance.reference();

    Dateinfo.prnlist.add("hello");
    Dateinfo.prnlist.clear();
    var studbatch_name = new Map();
    try {
      await dbref
          .child("Student")
          .child(Dateinfo.dept)
          .child(classs)
          .once()
          .then((snap) {
        Map allbatches = snap.value;
        // print(allbatches);
        for (final batch in allbatches.keys) {
          Map onebatch = allbatches[batch];
          for (final studprn in onebatch.keys) {
            Dateinfo.prnlist.add(studprn.toString());
          }
          studbatch_name.addAll({batch.toString(): onebatch});
        }
      });
    } catch (Exception) {
      print("caught you");
    }

    var totalt = new Map();
    Map batchwisename1 = studbatch_name["P"];
    Map batchwisename2 = studbatch_name["Q"];
    Map batchwisename3 = studbatch_name["R"];
    try {
      await dbref
          .child("defaulterlist")
          .child(Dateinfo.dept)
          .child(classs)
          .child("Total")
          .once()
          .then((onValue) {
        Map map = onValue.value;

        totalt.addAll(map);
      });
    } catch (Exception) {
      throw Exception;
    }

    try {
      await dbref
          .child("defaulterlist")
          .child(Dateinfo.dept)
          .child(classs)
          .once()
          .then((onValue) {
        Map map = onValue.value;
        //  print(map);
        for (final k in map.keys) {
          var att = new Map();
          try {
            Map stud;
            if (k.toString() != "Total") {
              //print(k);
              stud = map[k];
              int attlect = 0;
              String batch;
              if (batchwisename1.containsKey(k.toString())) {
                batch = "P";
              } else if (batchwisename2.containsKey(k.toString())) {
                batch = "Q";
              } else {
                batch = "R";
              }
//            print(studbatch_name[batch][k.toString()]);
//            print(100*(stud["Total"] ~/totalt[batch]));
              if ((100 * (stud["Total"] / totalt[batch])) >= 75) {
                //print(k);
                // print("rrr");
                obj.studmap.addAll({
                  k.toString(): {
                    "name": studbatch_name[batch][k.toString()],
                    "att": (stud[subject] / totalt[subject][batch]) * 100,
                    "work load": 0,
                    "total": (stud["Total"] ~/ totalt[batch]) * 100
                  }
                });
                print(studbatch_name[batch][k.toString()]);
                continue;
              } else {
                //print("got");
                for (final key in stud.keys) {
                  if (key.toString() != "Total") {
//                  print("got");
//                  print(studbatch_name[batch][k.toString()]);
                    // print(totalt);
                    //print(k);print(key);print(stud[key]);print(totalt[key][batch]);print((100*(stud[key] / totalt[key][batch])));
                    if ((100 * (stud[key] / totalt[key][batch])) >= 75) {
                      obj.studmap.addAll({
                        k.toString(): {
                          "name": studbatch_name[batch][k.toString()],
                          "att": (stud[subject] / totalt[subject][batch]) * 100,
                          "work load": 0,
                          "total": (stud["Total"] / totalt[batch]) * 100
                        }
                      });
                      continue;
                    } else {
                      //print("done");
                      att.addAll({
                        key.toString(): totalt[key][batch] * 0.75 - stud[key]
                      });
                    }
                  }
                }
              }
              int work = 0;
              if ((att.containsKey(subject))) {
//              print(k);
//              print(subject);
                int tot = 0;
//                    attended = 0;
                for (final k in totalt.keys) {
                  if (k.toString() == "P" ||
                      k.toString() == "Q" ||
                      k.toString() == "R")
                    continue;
                  else
                    tot += totalt[k][batch];
                  //print(k);
                }
                //  tot=totalt[subject][batch];
                //     print(tot);
//                for (final k in stud.keys) {
//                  //  print(k);
//                  if (k.toString() == "Total")
//                    continue;
//                  else
//                    attended += (stud[k]);
//                }
                double totalworkhour = 0.75 * tot - stud["Total"];
                double x = 0;
                //  print(att);
                for (final k in att.values) {
                  x += k;
                }
                work = (((totalworkhour / x) * att[subject]).ceil());
              }
              ;
              //print("edfg");
              // print(obj.studmap);
              obj.studmap.addAll({
                k.toString(): {
                  "name": studbatch_name[batch][k.toString()],
                  "att": (stud[subject] / totalt[subject][batch]) * 100,
                  "work load": work,
                  "total": (stud["Total"] / totalt[batch]) * 100,
                  "batch": batch
                }
              });
            }
//          print("obj.studmap");
            // print(obj.studmap);
          } catch (Exception) {
            print(Exception);
          }
        }
      });
    } catch (Exception) {
      throw Exception;
    }
//  print(obj.studmap);
  }

  total obj = new total();
}

class gendefaulter extends StatefulWidget {
  @override
  _gendefaulterState createState() => _gendefaulterState();
}

class _gendefaulterState extends State with TickerProviderStateMixin {
  var classlist = [" "];
  var spin, check;

  bool isloading = false,
      show = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    classlist.clear();
    if (Dateinfo.dept == "Comp") {
      classlist = [
        "FE1",
        "FE2",
        "FESS",
        "SE1",
        "SE2",
        "SESS",
        "TE1",
        "TE2",
        "TESS",
        "BE1",
        "BE2",
        "BESS"
      ];
    } else {
      classlist = ["FE1", "FE2", "SE1", "SE2", "TE1", "TE2", "BE1", "BE2"];
    }
    spin = new List.filled(classlist.length, false);
    check = new List.filled(classlist.length, true);
    // print(check);
  }

  generator(String classs) async {
    final dbref = FirebaseDatabase.instance.reference();
    int totallect = 0,
        P = 0,
        Q = 0,
        R = 0;
    var pract = new Map();
    var sub = [" "];
    try {
      await dbref
          .child("defaulter")
          .child(Dateinfo.dept)
          .child(classs)
          .child("AATotal")
          .once()
          .then((snap) {
        Map map = snap.value;
        sub.clear();
        for (final key in map.keys) {
          var a = key.toString().split("_");
          sub.add(a[0].toString());
        }
        sub = sub.toSet().toList();
        for (int i = 0; i < sub.length; i++) {
          P = Q = R = totallect = 0;
          for (final k in map.keys) {
            var a = k.toString().split("_");
            if (!(a[0] == sub[i])) {
              continue;
            } else {
              if (a.length == 2) {
                totallect += map[k];
              } else {
                if (a[2] == "P") {
                  P += map[k];
                } else if (a[2] == "Q") {
                  Q += map[k];
                } else {
                  R += map[k];
                }
              }
            }
          }
          pract.addAll({
            sub[i]: {"P": P + totallect, "Q": Q + totallect, "R": R + totallect}
          });
        }
      });
    } catch (Exception) {
      print("total");
    }
    int pt = 0,
        qt = 0,
        rt = 0;
    for (final k in pract.keys) {
      Map map = pract[k];
      pt += map["P"];
      qt += map["Q"];
      rt += map["R"];
    }
    pract.addAll({"P": pt, "Q": qt, "R": rt});

    var data = new Map();
    try {
      await dbref
          .child("defaulter")
          .child(Dateinfo.dept)
          .child(classs)
          .once()
          .then((onValue) {
        Map map = onValue.value;
        map.remove("AATotal");
        for (final k in map.keys) {
          var prn = new Map();
          Map stud;
          int overall = 0;
          try {
            stud = map[k];
            for (int i = 0; i < sub.length; i++) {
              //print(i);
              int attlect = 0;
              for (final key in stud.keys) {
                try {
                  var a = key.toString().split("_");
                  if (a.length == 1) throw Exception;
                  if (!(a[0] == sub[i])) {
                    continue;
                  } else {
                    attlect += stud[key];
                  }
                } catch (Exception) {
                  overall += stud[key];
                  stud[key] = 0;
                }
              }
              prn.addAll({sub[i]: attlect});
              overall += attlect;
            }
          } catch (Exception) {
            print(Exception);
          }
          prn.addAll({"Total": overall});
          data.addAll({k.toString(): prn});
        }
        data.addAll({"Total": pract});
        dbref
            .child("defaulterlist")
            .child(Dateinfo.dept)
            .child(classs)
            .set(data);
      });
    } catch (Exception) {
      print("stud");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: new AppBar(
        title: new Text(
          "Homepage\\gen_def",
          style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 2.7 * SizeConfig.textMultiplier),
        ),
        backgroundColor: HexColor.fromHex("#008080"),
      ),
      body: Container(
        child: ListView.builder(
          padding: kMaterialListPadding,
          itemCount: classlist.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 9 * SizeConfig.heightMultiplier,
              child: Card(
                elevation: 50,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0)),
                child: ListTile(
                    isThreeLine: false,
                    leading: Text(classlist.elementAt(index).toString(),
                        style: TextStyle(
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffac3973))),
                    title: Text(
                      "Defaulter",
                      style: TextStyle(
                          fontSize: 2.2 * SizeConfig.textMultiplier,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: SizedBox(
                      width: 30 * SizeConfig.widthMultiplier,
                      height: 7 * SizeConfig.heightMultiplier,
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            spin[index]
                                ? check[index]
                                ? SizedBox(
                                width: 7.5 * SizeConfig.widthMultiplier,
                                child: new IconButton(
                                    color: Colors.black,
                                    icon: new Icon(Icons.check),
                                    onPressed: null))
                                : Text(" ")
                                : check[index]
                                ? new Text(" ")
                                : new SpinKitCircle(
                              color: Colors.green,
                              size: 20.0,
                              // controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(4.0),
                            ),
                            ButtonTheme(
                              minWidth: 10 * SizeConfig.widthMultiplier,
                              child: new RaisedButton(
                                child: Text("generate"),
                                onPressed: () async {
                                  setState(() {
                                    check[index] = false;
                                  });
                                  await generator(
                                      classlist.elementAt(index).toString());
                                  setState(() {
                                    spin[index] = true;
                                    check[index] = true;
                                  });
                                  //ht(index);
                                },
                                color: Color(0xfffffc266),
                                textColor: Colors.black,
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                splashColor: Colors.grey,
                                shape: new RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.00)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  //subtitle: const Text("hiiiii"),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
