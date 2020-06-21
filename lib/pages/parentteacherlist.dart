import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/pages/TeacherHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/AttendanceData.dart';
import 'package:flutter_app/responsive/Screensize.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'AttendanceData.dart';
import 'defaulter_input.dart';

class Parentteacherlist extends StatefulWidget {
  @override
  _ParentteacherlistState createState() => _ParentteacherlistState();
}

class _ParentteacherlistState extends State<Parentteacherlist> {
  int len = 0;
  bool isloading = false,
      show = true,
      app = true,
      wardfetch = true,
      refreshpage = false;
  String classs;
  var studmap = new Map();
  String subjectName = 'Overall';
  int height;

  Future<bool> _onbackpressed() {
    if (isloading == true) {
      setState(() {
        isloading = false;
        show = true;
        app = false;
        wardfetch = true;
      });
    } else {
      // if(isloading==false && show==true){
      if (refreshpage) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Parentteacherlist(),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => thome(),
            ));
        //}
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    get();
    super.initState();
  }

  Future<void> get() async {
    try {
      await parentteachermap();
      setState(() {
        len = Dateinfo.parentteacherlist.length;
        app = false;
      });
    } catch (Exception) {
      Fluttertoast.showToast(
          msg: "List not generated!!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 2 * SizeConfig.textMultiplier);
    }
  }

  @override
  Widget build(BuildContext context) {
    var info = show
        ? new SpinKitThreeBounce(
            color: Color(0xff999966),
            size: 40.0,
            // controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
                AttendancePieChart(subjectName),
                new Padding(
                    padding: EdgeInsetsDirectional.only(
                        top: 5 * SizeConfig.heightMultiplier)),
                new Swiper(
                    layout: SwiperLayout.TINDER,
                    customLayoutOption:
                        new CustomLayoutOption(startIndex: -1, stateCount: 3)
                            .addRotate(
                                [-45.0 / 180, 0.0, 45.0 / 180]).addTranslate([
                      new Offset(-370.0, -40.0),
                      new Offset(0.0, 0.0),
                      new Offset(370.0, -40.0)
                    ]),
                    onIndexChanged: (int index) {
                      setState(() {
                        subjectName = Teacher.subjectList.elementAt(index);
                      });
                    },
                    itemWidth: 50 * SizeConfig.widthMultiplier,
                    itemHeight: 10 * SizeConfig.heightMultiplier,
                    itemBuilder: (context, index) {
                      return new Container(
//                                          width: 100,
//                                          height: 100,
                        child: Center(
                            child: Text(
                          Teacher.subjectList.elementAt(index),
                          style: TextStyle(
                              fontSize: 4 * SizeConfig.heightMultiplier,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        )),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: new AssetImage("assets/card1.jpg"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: new BorderRadius.circular(30.0),
                          shape: BoxShape.rectangle,
                          border: Border.all(
                              width: 4.0, color: Colors.grey.shade500),
//
//                                            wAccent
//                                                  ])
                        ),
                      );
                    },
                    itemCount: Teacher.subjectList.length),
              ]);
    var parentinfo = wardfetch
        ? new SpinKitThreeBounce(
            color: Color(0xff999966),
            size: 40.0,
            // controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
          )
        : new SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: [
                DataColumn(
                  label: Text(
                    "Subjects",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                  numeric: false,
                  tooltip: "This is  subject",
                ),
                DataColumn(
                  label: Text(
                    "Remedial hours",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.black),
                  ),
                  numeric: true,
                  tooltip: "This is Last work",
                ),
              ],
              rows: warddata.warddatalist
                  .map(
                    (user) => DataRow(cells: [
                      DataCell(
                        Text(user.key),
                      ),
                      DataCell(
                        Text(user.value.toString()),
                      ),
                    ]),
                  )
                  .toList(),
            ),
          );
    return new WillPopScope(
      onWillPop: _onbackpressed,
      child: isloading
          ? DefaultTabController(
              length: 2,
              child: new Scaffold(
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
                  backgroundColor: HexColor.fromHex("#008080"),
                  title: Text('attendance'),
                  bottom: new TabBar(
                    onTap: (index) async {
                      if (index == 1) {
                        if (wardfetch == true) {
                          await warddata.wardinfo(
                              Teacher.studprn, Teacher.studclass);
                          setState(() {
                            wardfetch = false;
                          });
                        }
                      }
                    },
                    tabs: [
                      new Tab(
                        icon: new Icon(Icons.assessment),
                      ),
                      new Tab(
                        icon: new Icon(Icons.grid_on),
                      ),
                    ],
                    //  controller: tabController,
                    indicatorColor: Colors.white,
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.local_hospital,
                        color: Colors.white,
                        size: 10 * SizeConfig.widthMultiplier,
                      ),
                      onPressed: () {
                        _medstud(context);
                        // print("red");
                      },
                    ),
                  ],
                ),
                body: new TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  //controller: tabController,
                  children: [
                    info,
                    parentinfo,
                  ],
                ),
              ),
            )
          : new Scaffold(
              resizeToAvoidBottomPadding: true,
              resizeToAvoidBottomInset: false,
              bottomNavigationBar: FancyBottomNavigation(
                activeIconColor: Colors.white,
                inactiveIconColor: HexColor.fromHex("#008080"),
                circleColor: HexColor.fromHex("#008080"),
                initialSelection: 1,
                tabs: [
                  TabData(iconData: Icons.home, title: "Home"),
                  TabData(
                      iconData: Icons.local_parking, title: "Parent Teacher"),
                  TabData(iconData: Icons.assignment, title: "Remedial hr")
                ],
                onTabChangedListener: (position) {
                  setState(() {
                    // currentPage = position;
                    if (position == 0) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => thome(),
                          ));
                    }
                    if (position == 2) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => defaulter(),
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
                title: new Text("Homepage/Parentteacherlist"),
                backgroundColor: HexColor.fromHex("#008080"),
              ),
              body: app
                  ? new SpinKitThreeBounce(
                      color: Color(0xff999966),
                      size: 40.0,
                      // controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
                    )
                  : Container(
                      //height:0.75*SizeConfig.screenHeight,
                      color: Colors.black,
                      child: (len != 0)
                          ? ListView.builder(
                              padding: kMaterialListPadding,
                              itemCount: len,
                              itemBuilder: (BuildContext context, int index) {
                                if (isPRN(Dateinfo.parentteacherlist
                                    .elementAt(index))) {
                                  return Container(
                                    height: 9 * SizeConfig.heightMultiplier,
                                    child: Card(
                                      elevation: 20,
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(15.0)),
                                      child: ListTile(
                                          onLongPress: () async {
                                            bool cnfchn = false;
                                            String display;
                                            if(Dateinfo.ydlist.contains(Dateinfo
                                                .parentteacherlist
                                                .elementAt(index)
                                                .toString())){
                                              display="Add student";
                                            }
                                            else{
                                              display="Remove student";
                                            }
                                            await Alert(
                                              context: context,
                                              type: AlertType.warning,
                                              style: AlertStyle(
                                                  animationType:
                                                      AnimationType.fromTop,
                                                  isCloseButton: false,
                                                  isOverlayTapDismiss: false,
                                                  descStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  animationDuration: Duration(
                                                      milliseconds: 400),
                                                  titleStyle: TextStyle(
                                                      color: Color(0xff00004d)),
                                                  alertBorder:
                                                      RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    side: BorderSide(
                                                      color: Colors.grey,
                                                    ),
                                                  )),
                                              title: display,
                                              buttons: [
                                                DialogButton(
                                                  child: Text(
                                                    "Confirm",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 2.5 *
                                                            SizeConfig
                                                                .textMultiplier),
                                                  ),
                                                  // ignore: missing_return
                                                  onPressed: () {
                                                    setState(() {
                                                      cnfchn = true;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  color: Color.fromRGBO(
                                                      0, 179, 134, 1.0),
                                                ),
                                                DialogButton(
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 2.5 *
                                                            SizeConfig
                                                                .textMultiplier),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      cnfchn = false;
                                                    });
                                                  },
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Color(0xffe63900),
                                                        Color(0xffe63900)
                                                      ]),
                                                )
                                              ],
                                            ).show();
                                            if (cnfchn) {
                                              String cl;
                                              for (final cla in Dateinfo
                                                  .parentteacherclass) {
                                                Map map = Dateinfo
                                                    .parentteacherstud[cla];
                                                if (map.containsKey(Dateinfo
                                                    .parentteacherlist
                                                    .elementAt(index))) {
                                                  cl = cla;
                                                  break;
                                                }
                                              }
                                              if(Dateinfo.ydlist.contains(Dateinfo.parentteacherlist
                                              .elementAt(index))){
                                                FirebaseDatabase.instance
                                                    .reference()
                                                    .child("ParentTeacher")
                                                    .child(Dateinfo.teachname)
                                                    .child(cl)
                                                    .child(Dateinfo
                                                    .parentteacherlist
                                                    .elementAt(index)
                                                    .toString())
                                                    .child("Yd").remove();
                                              setState(() {
                                                Dateinfo.ydlist.remove(Dateinfo
                                                    .parentteacherlist
                                                    .elementAt(index)
                                                    .toString());
                                                FirebaseDatabase.instance
                                                    .reference()
                                                    .child("defaulter")
                                                    .child("modified")
                                                    .child(Dateinfo
                                                    .parentteacherlist
                                                    .elementAt(index))
                                                    .set(0);
                                              });
                                              }
                                              else{
                                              FirebaseDatabase.instance
                                                  .reference()
                                                  .child("defaulter")
                                                  .child(Dateinfo.dept)
                                                  .child(cl)
                                                  .child(Dateinfo
                                                      .parentteacherlist
                                                      .elementAt(index)
                                                      .toString())
                                                  .remove();
                                              FirebaseDatabase.instance
                                                  .reference()
                                                  .child("ParentTeacher")
                                                  .child(Dateinfo.teachname)
                                                  .child(cl)
                                                  .child(Dateinfo
                                                      .parentteacherlist
                                                      .elementAt(index)
                                                      .toString()
                                                      .toString())
                                                  .child("Yd")
                                                  .set("yes");
                                              setState(() {
                                                Dateinfo.ydlist.add(Dateinfo
                                                    .parentteacherlist
                                                    .elementAt(index)
                                                    .toString()
                                                    .toString());
                                              });
                                              FirebaseDatabase.instance
                                                  .reference()
                                                  .child("Student")
                                                  .child(Dateinfo.dept)
                                                  .child(cl)
                                                  .child(Dateinfo
                                                      .parentteacherstud[
                                                          Dateinfo.studclass[Dateinfo
                                                              .parentteacherlist
                                                              .elementAt(index)]]
                                                          [(Dateinfo
                                                              .parentteacherlist
                                                              .elementAt(index)
                                                              .toString())]
                                                          ["name"]
                                                      .toString()
                                                      .split("_")[1])
                                                  .child(Dateinfo.parentteacherlist.elementAt(index))
                                                  .remove();
                                              FirebaseDatabase.instance
                                                  .reference()
                                                  .child("defaulter")
                                                  .child("modified")
                                                  .child(Dateinfo
                                                      .parentteacherlist
                                                      .elementAt(index))
                                                  .set(-1);
                                              }
                                            }
                                          },
                                          onTap: () async {
                                            try {
                                              print(index);
                                              String cl;
                                              for (final cla in Dateinfo
                                                  .parentteacherclass) {
                                                Map map = Dateinfo
                                                    .parentteacherstud[cla];
                                                if (map.containsKey(Dateinfo
                                                    .parentteacherlist
                                                    .elementAt(index))) {
                                                  cl = cla;
                                                  break;
                                                }
                                              }
                                              setState(() {
                                                isloading = true;
                                              });
                                              await Teacher.getprndata(
                                                  Dateinfo.parentteacherlist
                                                      .elementAt(index),
                                                  cl,
                                                  Dateinfo.parentteacherstud[
                                                          Dateinfo.studclass[
                                                              Dateinfo
                                                                  .parentteacherlist
                                                                  .elementAt(
                                                                      index)]][
                                                          (Dateinfo
                                                              .parentteacherlist
                                                              .elementAt(index)
                                                              .toString())]
                                                          ["name"]
                                                      .toString()
                                                      .split("_")[1]);
                                              setState(() {
                                                Teacher.studprn = Dateinfo
                                                    .parentteacherlist
                                                    .elementAt(index);
                                                Teacher.studclass = cl;
                                                Teacher.studbatch = Dateinfo
                                                    .parentteacherstud[Dateinfo
                                                            .studclass[
                                                        Dateinfo
                                                            .parentteacherlist
                                                            .elementAt(
                                                                index)]][(Dateinfo
                                                        .parentteacherlist
                                                        .elementAt(index)
                                                        .toString())]["name"]
                                                    .toString()
                                                    .split("_")[1];
                                              });
                                              setState(() {
                                                show = false;
                                                app = true;
                                              });
                                            } catch (ex) {
                                              // print(Dateinfo.plist.elementAt(index));
                                              print(Dateinfo.parentteacherstud[
                                                      Dateinfo.studclass[
                                                          Dateinfo
                                                              .parentteacherlist
                                                              .elementAt(
                                                                  index)]][
                                                      (Dateinfo
                                                          .parentteacherlist
                                                          .elementAt(index)
                                                          .toString())]["name"]
                                                  .toString()
                                                  .split("_")[1]);
                                              print(ex);
                                            }
                                          },
                                          isThreeLine: false,
                                          leading: Text(
                                              "  " +
                                                  Dateinfo.parentteacherlist
                                                      .elementAt(index) +
                                                  "    ::   ",
                                              style: TextStyle(
                                                  fontSize: 2.5 *
                                                      SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xffac3973))),
                                          title: Text(
                                            Dateinfo.parentteacherstud[
                                                    Dateinfo.studclass[Dateinfo
                                                        .parentteacherlist
                                                        .elementAt(index)]][
                                                    (Dateinfo.parentteacherlist
                                                        .elementAt(index)
                                                        .toString())]["name"]
                                                .toString()
                                                .split("_")[0],
                                            style: TextStyle(
                                                fontSize: 2.2 *
                                                    SizeConfig.textMultiplier,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          trailing: Dateinfo.ydlist.contains(
                                                  Dateinfo.parentteacherlist
                                                      .elementAt(index)
                                                      .toString())
                                              ?
                                                 FittedBox(
                                                   child: Row(
                                                    children: <Widget>[
                                                      Text("Yd",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                                                      IconButton(
                                                          icon: Icon(
                                                              Icons.chevron_right,
                                                              color: Colors.black),
                                                          onPressed: null,
                                                        ),
                                                    ],
                                                ),
                                                 )
                                              : IconButton(
                                                  icon: Icon(
                                                      Icons.chevron_right,
                                                      color: Colors.black),
                                                  onPressed: null,

                                                  //subtitle: const Text("hiiiii"),
                                                )),
                                    ),
                                  );
                                } else {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal:
                                            SizeConfig.screenWidth / 2 - 30),
                                    child: Text(
                                        Dateinfo.parentteacherlist
                                                .elementAt(index) +
                                            " ",
                                        style: TextStyle(
                                            fontSize:
                                                3 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffffffff))),
                                  );
                                }
                              },
                            )
                          : Align(
                              alignment: FractionalOffset.center,
                              child: new Text("Add students here",
                                  style: TextStyle(
                                      fontSize: 3 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff898989)))),
                    ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Color(0xff008080),
                onPressed: () async {
                  try {
                    _addstud(context);
                    setState(() {
//              len = Dateinfo.parentteacherlist.length - 1;
                    });
                  } catch (Exc) {
                    print(Exc);
                  }
                },
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ),
            ),
    );
  }

  bool isPRN(String prn) {
    try {
      if (Dateinfo.parentteacherclass.contains(prn)) return false;

      for (final cla in Dateinfo.parentteacherclass) {
        Map map = Dateinfo.parentteacherstud[cla];
        if (map.containsKey(prn)) {
          classs = cla;
          break;
        }
      }
    } catch (ex) {
      print("ex");
      print(ex);
    }
    return true;
  }

  _addstud(BuildContext context) async {
    bool pressed = false, autovalidate = false;
    final form = new GlobalKey<FormState>();

    Color dropcolor = Color(0xff996600);
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
    final dbref = FirebaseDatabase.instance.reference();
    ProgressDialog pr = new ProgressDialog(context);
    pr.style(
        message: "wait",
        messageTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 2.7 * SizeConfig.textMultiplier));
    FocusNode focusNode = new FocusNode();
    TextEditingController _studprn = TextEditingController();
    var prn;
    //FocusNode focusNode1 = new FocusNode();
    final databaseReference = FirebaseDatabase.instance.reference();
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return StatefulBuilder(
            builder: (context, setState) {
              return Opacity(
                opacity: a1.value,
                child: WillPopScope(
                  onWillPop: _onbackpressed,
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    title: Text(
                      'Add Student',
                      style: TextStyle(
                          color: HexColor.fromHex("#444422"),
                          fontWeight: FontWeight.bold),
                    ),
                    content: Container(
                      height: 17 * SizeConfig.heightMultiplier,
                      child: Column(
                        children: <Widget>[
                          Form(
                            key: form,
                            child: new TextFormField(
                              controller: _studprn,
                              onChanged: (val) {
                                prn = val;
                              },

                              validator: validatePRN,
                              cursorColor: Colors.black87,
                              autovalidate: autovalidate,
                              focusNode: focusNode,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'BalooChettan2',
                                  color: Colors.black87,
                                  fontSize: 2.5 * SizeConfig.textMultiplier),
                              decoration: new InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        5.5 * SizeConfig.widthMultiplier),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: HexColor.fromHex("#444422")),
                                    borderRadius: BorderRadius.circular(10.00)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),

                                // hintStyle: TextStyle(),
                                labelText: "Enter here",
                                hintText: "F17112016",
                                hintStyle: TextStyle(
                                    color: HexColor.fromHex("d6d6c2"),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                                labelStyle: TextStyle(
                                    color: HexColor.fromHex("#d6d6c2"),
                                    fontSize: 2.3 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.bold),
                                //hintText: "1234",
                              ),
                              //obscureText: true,
                            ),
                          ),
                          SizedBox(height: 10),
                          DropdownButton<String>(
                            iconEnabledColor: dropcolor,
                            items: classlist.map((String listvalue) {
                              return DropdownMenuItem<String>(
                                value: listvalue,
                                child: Text(
                                  listvalue,
                                  style: TextStyle(
                                      fontSize: 2.6 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                      color: dropcolor),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                classs = val;
                              });
                            },
                            value: classs,
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      new FlatButton(
                          child: new Text(
                            'submit',
                            style: TextStyle(
                                color: HexColor.fromHex("#444422"),
                                fontWeight: FontWeight.bold,
                                fontSize: 2.5 * SizeConfig.textMultiplier),
                          ),
                          onPressed: pressed
                              ? null
                              : () async {
                                  pressed = true;
                                  if (classs == "Class" || prn == null) {
                                    Fluttertoast.showToast(
                                        msg: "Fill the details");
                                    //  print(prn);

                                  } else {
                                    refreshpage = true;
                                    if (form.currentState.validate()) {
                                      pr.show();
                                      Map map;
                                      await dbref
                                          .child("Student")
                                          .child(Dateinfo.dept)
                                          .child(classs)
                                          .once()
                                          .then((snap) {
                                        map = snap.value;
                                      });
                                      try {
                                        for (final key in map.keys) {
                                          Map map1 = map[key];
                                          if (map1.containsKey(prn)) {
                                            await dbref
                                                .child("ParentTeacher")
                                                .child(Dateinfo.teachname)
                                                .child(classs)
                                                .child(prn.toString())
                                                .child("name")
                                                .set(map1[prn].toString() +
                                                    "_$key");
                                            break;
                                          }
                                        }
                                      } catch (Ex) {}

                                      await parentteachermap();
                                      pr.hide();
                                    } else {
                                      setState(() {
                                        autovalidate = true;
                                      });
                                    }
                                  }
                                  pressed = false;
                                }),
                      new FlatButton(
                          child: new Text(
                            'cancel',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 2.5 * SizeConfig.textMultiplier),
                          ),
                          onPressed: pressed
                              ? null
                              : () async {
                                  pressed = true;

                                  Navigator.of(context).pop();
                                  if (refreshpage) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Parentteacherlist(),
                                        ));
                                  }
                                })
                    ],
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

Widget AttendancePieChart(String sub) {
  List<PieChartSectionData> _sections = List<PieChartSectionData>();
  double AttendanceCounter = 0;
  int tot = 0, cnt = 0;
  double TotalAttendance = 0;
  int index = 0;
  int total_lect = 0;
  int att_lect = 0;
  int total_pract = 0;
  int att_pract = 0;
  int att_tut = 0;
  int total_tut = 0;
//print(MediaQuery.of(context).size.width);
//print(MediaQuery.of(context).size.height);
  try {
    for (int i = 0; i < Teacher.attendanceDataList.length; i++) {
      TotalAttendance += (Teacher.attendanceDataList[i].total_attendance);
      // print(TotalAttendance);
      total_lect += (Teacher.attendanceDataList[i].total_lect);
      att_lect += (Teacher.attendanceDataList[i].attended_lect);
      total_pract += (Teacher.attendanceDataList[i].total_pract);
      att_pract += (Teacher.attendanceDataList[i].attended_pract);
      att_tut += (Teacher.attendanceDataList[i].attended_tut);
      total_tut += (Teacher.attendanceDataList[i].total_tut);
    }
    TotalAttendance = (att_tut +
            att_lect +
            att_pract +
            Teacher.sports +
            Teacher.other +
            Teacher.medical) /
        (total_lect + total_pract + total_tut) *
        100;
    TotalAttendance = TotalAttendance.toStringAsFixed(2) as double;
    FirebaseDatabase.instance
        .reference()
        .child("defaulter")
        .child(Studinfo.branch)
        .child(Studinfo.classs)
        .child(Studinfo.roll)
        .child("zzTotal")
        .set(TotalAttendance.toStringAsFixed(2) + "%");
  } catch (Exception) {}
  List<Color> c = [
    HexColor.fromHex("#008080"),
    Colors.orange.shade400,
    HexColor.fromHex("#001a33"),
    HexColor.fromHex("#ff4d4d"),
    HexColor.fromHex("#73264d")
  ];
  bool b = false;
  if (sub == 'Overall') {
    b = true;
    for (int i = 0; i < Teacher.attendanceDataList.length; i++) {
      AttendanceCounter += (Teacher.attendanceDataList[i].total_attendance /
          Teacher.attendanceDataList.length);
      PieChartSectionData _item = PieChartSectionData(
        color: c.elementAt(i % 5),
        value: 100 / Teacher.attendanceDataList.length,
        title: '${Teacher.attendanceDataList[i].subjectName}',
        radius: 5 * SizeConfig.heightMultiplier,
        titleStyle: TextStyle(
            color: Colors.white, fontSize: 2.1 * SizeConfig.textMultiplier),
      );
      _sections.add(_item);
      // }
    }
  } else {
    //AttendanceCounter=0;
    for (index; index < Teacher.attendanceDataList.length; index++) {
      if (Teacher.attendanceDataList[index].subjectName == sub) break;
    }

//      for Lectures :
    tot = 0;
    cnt = 0;
    double value;
    if (Teacher.attendanceDataList[index].total_lect != 0) {
      value = (Teacher.attendanceDataList[index].attended_lect /
              Teacher.attendanceDataList[index].total_lect) *
          100;
      tot += Teacher.attendanceDataList[index].total_lect;
      cnt += Teacher.attendanceDataList[index].attended_lect;
    } else {
      value = 100.00;
    }
    if (value != 0) {
      AttendanceCounter += (value / 2);
      PieChartSectionData _item1 = PieChartSectionData(
        color: value > 75 ? Color(0xff155511) : Color(0xffa60c0c),
        value: value / 2,
        title: 'Lec',
        radius: 5 * SizeConfig.heightMultiplier,
        titleStyle: TextStyle(
            color: Colors.white, fontSize: 2 * SizeConfig.textMultiplier),
      );
      _sections.add(_item1);
    }

//    For Practicals :
    if (Teacher.attendanceDataList[index].total_pract != 0) {
      value = (Teacher.attendanceDataList[index].attended_pract /
              Teacher.attendanceDataList[index].total_pract) *
          100;
      tot += Teacher.attendanceDataList[index].total_pract;
      cnt += Teacher.attendanceDataList[index].attended_pract;
    } else {
      value = 100.00;
    }

    AttendanceCounter += (value / 2);
    if (value != 0) {
      PieChartSectionData _item2 = PieChartSectionData(
        color: value > 75 ? Color(0xff155511) : Color(0xffa60c0c),
        value: value / 2,
        title: 'Prac',
        radius: 5 * SizeConfig.heightMultiplier,
        titleStyle: TextStyle(
            color: Colors.white, fontSize: 2.1 * SizeConfig.textMultiplier),
      );
      _sections.add(_item2);
    }
    //for tutorial
    if (Teacher.attendanceDataList[index].total_tut != 0) {
      value = (Teacher.attendanceDataList[index].attended_tut /
              Teacher.attendanceDataList[index].total_tut) *
          100;
      tot += Teacher.attendanceDataList[index].total_tut;
      cnt += Teacher.attendanceDataList[index].attended_tut;
    } else {
      value = 100.00;
    }

    AttendanceCounter += (value / 2);
    if (value != 0) {
      PieChartSectionData _item2 = PieChartSectionData(
        color: value > 75 ? Color(0xff155511) : Color(0xffa60c0c),
        value: value / 2,
        title: 'Tut',
        radius: 5 * SizeConfig.heightMultiplier,
        titleStyle: TextStyle(
            color: Colors.white, fontSize: 2.1 * SizeConfig.textMultiplier),
      );
      _sections.add(_item2);
    }
  }
  if (b == false) {
    if (AttendanceCounter < 100) {
      PieChartSectionData _item = PieChartSectionData(
        color: HexColor.fromHex("#a60c0c"),
        value: (100 - AttendanceCounter),
        title: 'Abs',
        radius: 5 * SizeConfig.heightMultiplier,
        titleStyle: TextStyle(
          color: Colors.white,
          fontSize: 2 * SizeConfig.textMultiplier,
        ),
      );
      _sections.add(_item);
    }
  }
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      //    mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AspectRatio(
            aspectRatio:
                (SizeConfig.widthMultiplier / SizeConfig.heightMultiplier) *
                    3.4,
            child: FlChart(
                chart: PieChart(
              PieChartData(
                sections: _sections,
                borderData: FlBorderData(show: false),
                centerSpaceRadius: 7 * SizeConfig.heightMultiplier,
                sectionsSpace: 5,
              ),
            ))),
        sub == 'Overall'
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        left: 7.7 * SizeConfig.widthMultiplier,
                        top: 2 * SizeConfig.heightMultiplier,
                        bottom: 1 * SizeConfig.heightMultiplier),
                    child: new Row(
                      children: <Widget>[
                        Text('Medical Attendance : ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 2.7 * SizeConfig.textMultiplier)),
                        Text(
                          '${Teacher.medical}',
                          style: TextStyle(
                              fontSize: 2.4 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 7.7 * SizeConfig.widthMultiplier,
                        top: 2 * SizeConfig.heightMultiplier,
                        bottom: 1 * SizeConfig.heightMultiplier),
                    child: new Row(
                      children: <Widget>[
                        Text('Total Attendance : ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 2.7 * SizeConfig.textMultiplier)),
                        Text(
                          '${TotalAttendance.toStringAsFixed(2)} %',
                          style: TextStyle(
                              fontSize: 2.4 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 7.7 * SizeConfig.widthMultiplier,
                        top: 2 * SizeConfig.heightMultiplier),
                    child: new Row(
                      children: <Widget>[
                        Text('lectures  Attended: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 2.7 * SizeConfig.textMultiplier)),
                        Text(
                          '$att_lect' + '/' + '$total_lect',
                          style: TextStyle(
                              fontSize: 2.4 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 7.7 * SizeConfig.widthMultiplier,
                        top: 2 * SizeConfig.heightMultiplier),
                    child: new Row(
                      children: <Widget>[
                        Text('Practicals  Attended: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 2.7 * SizeConfig.textMultiplier)),
                        Text(
                          '$att_pract' + '/' + '$total_pract',
                          style: TextStyle(
                              fontSize: 2.4 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 7.7 * SizeConfig.widthMultiplier,
                        top: 2 * SizeConfig.heightMultiplier),
                    child: new Row(
                      children: <Widget>[
                        Text('Tutorials  Attended: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 2.7 * SizeConfig.textMultiplier)),
                        Text(
                          '$att_tut' + '/' + '$total_tut',
                          style: TextStyle(
                              fontSize: 2.4 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        left: 7.7 * SizeConfig.widthMultiplier,
                        top: 2 * SizeConfig.heightMultiplier,
                        bottom: 1 * SizeConfig.heightMultiplier),
                    child: new Row(
                      children: <Widget>[
                        Text('Total  Attendance: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 2.7 * SizeConfig.textMultiplier)),
                        Text(
                          '${(cnt / tot * 100).toStringAsFixed(2)} %',
                          style: TextStyle(
                              fontSize: 2.4 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 7.7 * SizeConfig.widthMultiplier,
                        top: 2 * SizeConfig.heightMultiplier),
                    child: new Row(
                      children: <Widget>[
                        Text('Attended Lectures : ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 2.7 * SizeConfig.textMultiplier)),
                        Text(
                          '${Teacher.attendanceDataList[index].attended_lect}/${Teacher.attendanceDataList[index].total_lect}',
                          style: TextStyle(
                              fontSize: 2.4 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 7.7 * SizeConfig.widthMultiplier,
                        top: 2 * SizeConfig.heightMultiplier),
                    child: new Row(
                      children: <Widget>[
                        Text('Attended Practicals: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 2.7 * SizeConfig.textMultiplier)),
                        Text(
                          '${Teacher.attendanceDataList[index].attended_pract}/${Teacher.attendanceDataList[index].total_pract}',
                          style: TextStyle(
                              fontSize: 2.4 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 7.7 * SizeConfig.widthMultiplier,
                        top: 2 * SizeConfig.heightMultiplier),
                    child: new Row(
                      children: <Widget>[
                        Text('Tutorials  Attended: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 2.7 * SizeConfig.textMultiplier)),
                        Text(
                          '${Teacher.attendanceDataList[index].attended_tut}/${Teacher.attendanceDataList[index].total_tut}',
                          style: TextStyle(
                              fontSize: 2.4 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              )
      ],
    ),
  );
}

//Progress bar :
_medstud(BuildContext context) async {
  bool pressed = false;
  final dbref = FirebaseDatabase.instance.reference();
  ProgressDialog pr = new ProgressDialog(context);
  pr.style(
      message: "wait",
      messageTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 2.7 * SizeConfig.textMultiplier));
  FocusNode focusNode = new FocusNode();
  TextEditingController _studatt = TextEditingController();
  var prn;
  final databaseReference = FirebaseDatabase.instance.reference();
  return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return StatefulBuilder(
          builder: (context, setState) {
            return Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: Text(
                  'Add medical attendance',
                  style: TextStyle(
                      color: HexColor.fromHex("#444422"),
                      fontWeight: FontWeight.bold),
                ),
                content: Padding(
                  padding:
                      EdgeInsets.only(top: 2 * SizeConfig.heightMultiplier),
                  child: Container(
                    height: 50,
                    child: Column(
                      children: <Widget>[
                        new TextFormField(
                          controller: _studatt,
                          onChanged: (val) {},
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          cursorColor: Colors.black87,
                          focusNode: focusNode,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'BalooChettan2',
                              color: Colors.black87,
                              fontSize: 2.5 * SizeConfig.textMultiplier),
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 5.5 * SizeConfig.widthMultiplier),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: HexColor.fromHex("#444422")),
                                borderRadius: BorderRadius.circular(10.00)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),

                            // hintStyle: TextStyle(),
                            labelText: "Enter here",
                            hintText: "7",
                            hintStyle: TextStyle(
                                color: HexColor.fromHex("d6d6c2"),
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                            labelStyle: TextStyle(
                                color: HexColor.fromHex("#d6d6c2"),
                                fontSize: 2.3 * SizeConfig.textMultiplier,
                                fontWeight: FontWeight.bold),
                            //hintText: "1234",
                          ),
                          //obscureText: true,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                      child: new Text(
                        'submit',
                        style: TextStyle(
                            color: HexColor.fromHex("#444422"),
                            fontWeight: FontWeight.bold,
                            fontSize: 2.3 * SizeConfig.textMultiplier),
                      ),
                      onPressed: () async {
                        databaseReference
                            .child("defaulter")
                            .child(Dateinfo.dept)
                            .child(Teacher.studclass)
                            .child(Teacher.studprn)
                            .child("medical")
                            .set(int.parse(_studatt.text));
                        int att = 0;
                        await databaseReference
                            .child("defaulterlist")
                            .child(Dateinfo.dept)
                            .child(Teacher.studclass)
                            .child(Teacher.studprn)
                            .child("Total")
                            .once()
                            .then((onValue) {
                          att = onValue.value;
                        });
                        await databaseReference
                            .child("defaulterlist")
                            .child(Dateinfo.dept)
                            .child(Teacher.studclass)
                            .child(Teacher.studprn)
                            .child("Total")
                            .set(att + int.parse(_studatt.text));
//                            setState(() {
//                              Teacher.medical=int.parse(_studatt.text);
//                            });
                        Navigator.pop(context);
                      }),
                  new FlatButton(
                    child: new Text(
                      'cancel',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 2.3 * SizeConfig.textMultiplier),
                    ),
                    onPressed: pressed == false
                        ? () {
                            Navigator.of(context).pop();
                          }
                        : null,
                  )
                ],
              ),
            );
          },
        );
      },
      transitionDuration: Duration(milliseconds: 1000),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {});
}

String validatePRN(String value) {
  RegExp re = RegExp(r'^F|S[0-9]+$');
  if (value.isEmpty || !re.hasMatch(value) || value.length < 9)
    return "invalid PRN";
  else
    return null;
}
