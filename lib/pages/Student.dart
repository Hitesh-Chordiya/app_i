// ignore: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/pages/forgotpassword.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/pages/parentinfo.dart';
import 'package:flutter_app/responsive/Screensize.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AttendanceData.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'login_page.dart';

class shome extends StatefulWidget {
  @override
  _shomestate createState() => _shomestate();
}

class _shomestate extends State<shome> with TickerProviderStateMixin {
  @override
  dynamic name, email;
  TabController tabController;

//  bool on = true,off=true;
  bool isloading = false,
      showatt = true,
      showrem = true,
      gen = false,
      defgen = false;
  SwiperController controller;
  Map info;
  Timer _timer;
  Color attcolr = Colors.white;
  bool checkyd = false, clicked = false;
  String subjectName = 'Overall';
  int height, index = 0, ht = 5, _start = 3;
  Color color = Colors.black87;
  FocusNode focusNode1 = new FocusNode();
  final dbref = FirebaseDatabase.instance.reference();
  SharedPreferences prefs;

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    if (mounted)
      setState(() {
        _timer.cancel();
      });
    super.dispose();
  }

  Future<String> getname() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      Studinfo.email = prefs.getString("email");
      Studinfo.name = prefs.getString("name");
      Studinfo.classs = prefs.getString("class");
      Studinfo.branch = prefs.getString("branch");
      Studinfo.roll = prefs.getString("roll");
      Studinfo.batch = prefs.getString("batch");
      // Studinfo.prn = prefs.getString("prn");
    });
    var e = Studinfo.email.split("@");
    Alert1.name = e[0].toString().replaceAll(new RegExp(r'\W'), "_");
    // await  Studinfo.remedial();
//    await Future.delayed(Duration(seconds: 3));
//    setState(() {
//      ht=0;
//    });
  }

  @override
  void initState() {
    // TODO: implement initState
    controller = new SwiperController();
    getname();
    super.initState();
    // startTimer();
    tabController = new TabController(length: 2, vsync: this);
    retrieveMessage();
  }

  Future<Map<String, dynamic>> retrieveMessage() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

    firebaseMessaging.configure(
      //onBackgroundMessage: Platform.isIOS?null:myBackgroundMessageHandler,
      onMessage: (Map<String, dynamic> message) async {
        Fluttertoast.showToast(
            msg: "Attendance modified",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      },
      onResume: (Map<String, dynamic> message) async {},
      onLaunch: (Map<String, dynamic> message) async {},
    );
    // Or do other work.
  }

  int time1 = 0;

  void startTimer() {
    _start = 3;
    _timer = new Timer.periodic(
      new Duration(milliseconds: 1000),
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            setState(() {
              ht = 0;
            });
          } else {
            setState(() {
              _start = _start - 1;
            });
          }
          time1 += 1;
        },
      ),
    );
  }

  void call() async {
    setState(() {
      ht = 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    tabController = new TabController(length: 2, vsync: this);
    double iconsize = 3 * SizeConfig.heightMultiplier;
    double textsize = 2 * SizeConfig.textMultiplier;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "wait");
    var view = showatt
        ? new SpinKitThreeBounce(
      color: Color(0xff000000),
      size: 6 * SizeConfig.heightMultiplier,
      // controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
    )
        : !gen
        ? Center(
        child: Text(
          "No data",
          style: TextStyle(
              fontSize: 3 * SizeConfig.heightMultiplier,
              fontWeight: FontWeight.bold),
        ))
        : Container(
      color: Colors.black,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AttendancePieChart(subjectName),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.grp <= 4
                      ? 1 * SizeConfig.heightMultiplier
                      : 2 * SizeConfig.heightMultiplier,
                  horizontal: 4 * SizeConfig.widthMultiplier),
              child: new Swiper(
                  scrollDirection: Axis.vertical,
                  controller: controller,
                  layout: SwiperLayout.CUSTOM,
                  customLayoutOption: new CustomLayoutOption(
                      startIndex: -1, stateCount: 3)
                      .addRotate([
                    -45.0 / 180,
                    0.0,
                    0.0 / 180
                  ]).addTranslate([
                    new Offset(-370.0, -40.0),
                    new Offset(0.0, 0.0),
                    new Offset(370.0, -40.0)
                  ]),
                  onIndexChanged: (int index) {
                    setState(() {
                      subjectName =
                          Attendance.subjectList.elementAt(index);
                    });
                  },
                  itemWidth: 55 * SizeConfig.widthMultiplier,
                  itemHeight: 13 * SizeConfig.heightMultiplier,
                  itemBuilder: (context, index) {
                    return new Container(
//                                          width: 100,
//                                          height: 100,
                      child: Center(
                          child: RichText(
                              text: TextSpan(
                                  text: Attendance.subjectList
                                      .elementAt(index)
                                      .endsWith(Studinfo.branch)
                                      ? Attendance.subjectList
                                      .elementAt(index)
                                      .substring(
                                      0,
                                      Attendance.subjectList
                                          .elementAt(
                                          index)
                                          .length -
                                          4)
                                      : Attendance.subjectList
                                      .elementAt(index),
                                  style: TextStyle(
                                      fontSize: 4 *
                                          SizeConfig.heightMultiplier,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                      index == 0 ? "\n     swipe up" : "",
                                      style: TextStyle(
                                          fontSize:
                                          2 * SizeConfig.heightMultiplier,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                    )
                                  ]))),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: new AssetImage("assets/card1.jpg"),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: new BorderRadius.circular(30.0),
                        shape: BoxShape.rectangle,
                        border: Border.all(
                            width: 4.0, color: Colors.grey),
                      ),
                    );
                  },
                  itemCount: Attendance.subjectList.length),
            ),
          ]),
    );
    var gridView = showrem
        ? new SpinKitThreeBounce(
      color: Color(0xff000000),
      size: 6 * SizeConfig.heightMultiplier,
      // controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
    )
        : !defgen
        ? Container(
        color: Colors.black,
        child: Center(
            child: Text(
              "Nothing to show",
              style: TextStyle(fontSize: 3 * SizeConfig.heightMultiplier),
            )))
        : Container(
        color: Colors.black,
        child: new SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Theme(
            data: Theme.of(context)
                .copyWith(dividerColor: Colors.black12),
            child: DataTable(
              columns: [
                DataColumn(
                  label: Text(
                    "Subjects",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 2.5 * SizeConfig.heightMultiplier,
                        color: Color(0xffBA8B02)),
                  ),
                  numeric: false,
                  tooltip: "This is  subject",
                ),
                DataColumn(
                  label: Text(
                    "Remedial hr",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 2.5 * SizeConfig.heightMultiplier,
                        color: Color(0xffBA8B02)),
                  ),
                  numeric: true,
                  tooltip: "This is Last work",
//
                ),
              ],
              rows: Studinfo.remediallist
                  .map(
                    (user) => DataRow(cells: [
                  DataCell(
                    Padding(
                      padding: EdgeInsets.only(
                          left: 2.2 * SizeConfig.widthMultiplier),
                      child: Text(
                        user.subjectname.endsWith(Studinfo.branch)
                            ? user.subjectname.substring(
                            0, user.subjectname.length - 4)
                            : user.subjectname,
                        style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize:
                            2.2 * SizeConfig.heightMultiplier,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataCell(
                    Center(
                      child: Text(
                        user.workload.toString(),
                        style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize:
                            2.2 * SizeConfig.heightMultiplier),
                      ),
                    ),
                  ),
                ]),
              )
                  .toList(),
            ),
          ),
        ));
    List<String> events = [
      "Mark Attendance",
      "View Attendance",
    ];
    return WillPopScope(
      onWillPop: _onbackpressed,
      child: isloading
          ? new DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: new Scaffold(
          appBar: new PreferredSize(
            preferredSize: Size.fromHeight(75),
            child: Container(
              color: Color(0xff6d6d46),
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    // new Expanded(child: new Container()),
                    new TabBar(
                      onTap: (index) async {
                        if (index == 1) {
                          int time;
                          DateFormat format = new DateFormat("HH");
                          time = int.parse(
                              format.format(new DateTime.now()));
                          bool show = true;

                          try {
                            if (time < 19 && time > 9) {
                              await Studinfo.remedial();
                            }
                            try {
                              await Studinfo.relist();
                              // print("ll");
                            } catch (e) {
                              throw Exception;
                              print("pko");
                            }
                          } catch (Exception) {
//                      pr.hide();
                            // print("jk");
                            show = false;
                          }
                          setState(() {
                            showrem = false;
                          });

                          if (show) {
                            setState(() {
                              defgen = true;
                            });
                          } else {
                            setState(() {
                              defgen = false;
                            });

                            showrem = false;
                          }
                        }
                      },
                      unselectedLabelColor: Color(0xff4e4e32),
                      labelColor: Colors.white,
                      isScrollable: true,
                      labelStyle: TextStyle(
                        fontSize: 2.4 * SizeConfig.heightMultiplier,
                      ),
                      tabs: <Widget>[
                        new Tab(
                          icon: new Icon(Icons.assessment),
                          text: "Attendance",
                        ),
                        new Tab(
                          icon: new Icon(Icons.assignment),
                          text: "Defaulter assignments",
                        ),
                      ],
                      controller: DefaultTabController.of(context),
                      indicatorColor: Color(0xffffffff),
                    ),
//
                  ],
                ),
              ),
            ),
          ),
          body: OfflineBuilder(
            connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
                ) {
              final bool connected =
                  connectivity != ConnectivityResult.none;
              if (!connected) {
                time1 = 0;
                call();
              } else {
                if (time1 == 0) startTimer();
              }
              return new Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    height: time1 == 0
                        ? 5 * SizeConfig.heightMultiplier
                        : 0 * SizeConfig.heightMultiplier,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: connected
                          ? Color(0xFFffffff)
                          : Color(0xFFEE4400),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(width: 32.0, height: 0.0),
                          Text(
                            "${connected ? 'ONLINE' : 'OFFLINE'}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: connected
                                    ? Color(0xffe65c00)
                                    : Color(0xff000000),
                                fontWeight: FontWeight.bold,
                                fontSize: 2 * SizeConfig.textMultiplier),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: ht * SizeConfig.heightMultiplier,
                    left: 0,
                    right: 0,
                    height: 100 * SizeConfig.heightMultiplier,
                    child: TabBarView(
                      // physics: NeverScrollableScrollPhysics(),
                      children: [
                        view,
                        gridView,
                      ],
                      controller: DefaultTabController.of(context),
                    ),
                  )
                ],
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  'There are no bottons to push :)',
                ),
                new Text(
                  'Just turn off your internet.',
                ),
              ],
            ),
          ),
        ),
      )
          : new Scaffold(
        appBar: GradientAppBar(
          title: new Text("home",
              style: TextStyle(
                color: Colors.white,
              )),
          // backgroundColor: HexColor.fromHex("#2f2f1e"),

          backgroundColorStart: Color(0xff6d6d46),
          backgroundColorEnd: Color(0xff6d6d46),
        ),
        body: OfflineBuilder(
          connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
              ) {
            final bool connected =
                connectivity != ConnectivityResult.none;
            if (!connected) {
              time1 = 0;
              call();
            } else {
              //call();
              if (time1 == 0) {
                print("bang");
                startTimer();
              }
            }
            return new Stack(
              fit: StackFit.expand,
              //overflow: Overflow.clip,
              children: [
                Positioned(
                  height: ht * SizeConfig.heightMultiplier,
                  left: 0,
                  right: 0,
                  child: Container(
                    color:
                    connected ? Color(0xFFe6e6e6) : Color(0xFFEE4400),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        //Container(width: 32.0),
                        Text(
                          "${connected ? 'ONLINE' : 'OFFLINE'}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: connected
                                  ? Color(0xffe65c00)
                                  : Color(0xff000000),
                              fontWeight: FontWeight.bold,
                              fontSize: 2 * SizeConfig.textMultiplier),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: ht * SizeConfig.heightMultiplier - 1,
                  left: 0,
                  right: 0,
                  height: 100 * SizeConfig.heightMultiplier,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 3 * SizeConfig.heightMultiplier,
                        horizontal: 12 * SizeConfig.widthMultiplier),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black87, Colors.black87]),
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 3.8 * SizeConfig.widthMultiplier,
                          vertical: SizeConfig.grp <= 4
                              ? 1 * SizeConfig.heightMultiplier
                              : 4 * SizeConfig.heightMultiplier),
                      width: 114 * SizeConfig.widthMultiplier,
                      child: GridView(
                        physics: BouncingScrollPhysics(),
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1),
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
                                    borderRadius:
                                    new BorderRadius.circular(20.0)),
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                    2.5 * SizeConfig.heightMultiplier,
                                    horizontal:
                                    5 * SizeConfig.widthMultiplier),
                                child: getCardByTitle(title),
                              ),
                            ),
                            onTap: clicked
                                ? null
                                : () async {
                              setState(() {
                                clicked = true;
                              });
                              if (title == "View Attendance") {
                                int time;
                                DateFormat format =
                                new DateFormat("HH");
                                time = int.parse(format
                                    .format(new DateTime.now()));
                                bool show = true;
//
                                setState(() {
                                  isloading = true;
                                });

                                try {
//                                              if (time < 19 && time > 9) {
                                  if(true){
                                    // pr.show();

                                    await get();
                                    await Attendance.displayatt();
                                    //await Studinfo.remedial();

                                  } else {
                                    var ford = new DateFormat(
                                        "yyyy_MM_dd");
                                    var now = new DateTime.now();
                                    String date = ford.format(now);
                                    try {
                                      if ((prefs.getString(
                                          "today_date") ==
                                          date)) {
                                        prefs.setInt("fetchatt", 0);
                                      } else {
                                        prefs.setString(
                                            "today_date", date);
                                        prefs.setInt("fetchatt", 1);
                                      }
                                    } catch (Exception) {
                                      prefs.setInt("fetchatt", 1);
                                      prefs.setString(
                                          "today_date", date);
                                    }
                                    if (prefs.getInt("fetchatt") ==
                                        1) {
                                      //pr.show();
                                      setState(() {
                                        // isloading=true;
                                      });
                                      //print("k");
                                      await Attendance.displayatt();
                                      await Studinfo.remedial();

                                      get();
                                      prefs.setInt("fetchatt", 0);
                                    }
                                  }
                                  try {
                                    await Attendance.getlist();
                                    // Studinfo.relist();

                                  } catch (e) {
//                                                print("pko");
                                    throw Exception;
//
                                  }
                                } catch (Exception) {
//
                                  show = false;
                                }
                                setState(() {
                                  showatt = false;
                                });

                                if (show) {
                                  print("showatt");
                                  setState(() {
                                    // isloading=true;
                                    gen = true;
                                  });
//
                                } else {
                                  print("no");
                                  setState(() {
                                    //isloading = false;
                                    gen = false;
                                  });
                                }
                              } else {
                                pr.show();
                                await get();
                                pr.hide();
                                if (checkyd) {
                                  _yd(context);
                                } else {
                                  try {
                                    final result =
                                    await InternetAddress
                                        .lookup('google.com');
                                    print(result);
                                    if (result.isNotEmpty &&
                                        result[0]
                                            .rawAddress
                                            .isNotEmpty) {
                                      print('connected');
                                      _displayDialog(context);
                                    } else {
                                      print('not connected');
                                    }
                                  } catch (Exception) {
                                    print('not connected');
                                  }
                                }
                                setState(() {
                                  clicked = false;
                                });
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                'There are no bottons to push :)',
              ),
              new Text(
                'Just turn off your internet.',
              ),
            ],
          ),
        ),
        drawer: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              //This will change the drawer background to blue.
              //other styles
              selectedRowColor: Colors.brown.shade300),
          child: Container(
            width: 64 * SizeConfig.widthMultiplier,
            child: Drawer(
              child: new ListView(
                children: <Widget>[
                  new UserAccountsDrawerHeader(
                    accountName: new Text(
                      Studinfo.name,
                      style: TextStyle(
                          fontSize: 2.7 * SizeConfig.textMultiplier,
                          color: HexColor.fromHex("#ffffff"),
                          fontWeight: FontWeight.bold),
                    ),
                    accountEmail: new Text(Studinfo.email,
                        style: TextStyle(
                            fontSize: 2.1 * SizeConfig.textMultiplier,
                            color: HexColor.fromHex("#ffffff"),
                            fontWeight: FontWeight.bold)),
                    currentAccountPicture: new CircleAvatar(
                      radius: 3 * SizeConfig.heightMultiplier,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 6 * SizeConfig.heightMultiplier,
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
                              padding:
                              EdgeInsets.fromLTRB(2.0, 0.0, 15.0, 0),
                              child: new Icon(
                                Icons.person,
                                color: HexColor.fromHex("#000000"),
                                size: iconsize,
                              ),
                            ),
                            new Text(
                              "Profile",
                              style: TextStyle(
                                  fontSize: textsize,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor.fromHex("#2e2e1f")),
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
                                builder: (context) => profilestud(),
                              ));
                        }),
                  ),
                  //new Divider(),
                  Card(
                    child: new ListTile(
                        title: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  2.0, 0.0, 10.0, 0),
                              child: new Icon(
                                Icons.message,
                                color: HexColor.fromHex("#000000"),
                                size: iconsize,
                              ),
                            ),
                            new Text(
                              "Parent info",
                              style: TextStyle(
                                  color: HexColor.fromHex("#2e2e1f"),
                                  fontSize: textsize,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.arrow_right,
                          color: Colors.black,
                        ),
                        onTap: () async {
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          try {
                            //print(prefs.getString("parent"));
                            if (prefs.getString("parent") == null) {
                              await dbref
                                  .child("Registration")
                                  .child("Student")
                                  .child(Dateinfo.dept)
                                  .child(Studinfo.roll)
                                  .child("Parent")
                                  .once()
                                  .then((snap) {
                                if (snap.value == null) {
                                  throw Exception;
                                } else {
                                  Studinfo.parentname =
                                      snap.value.toString();
                                  prefs.setString(
                                      "parent", snap.value.toString());
                                }
                              });
//
                            } else {
                              Studinfo.parentname =
                                  prefs.getString("parent");
                            }
                            pr.show();
                            await Studinfo.data();
                            pr.hide();
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => parentinfoPage(),
                                ));
                          } catch (Exception) {
                            pr.hide();
                            Fluttertoast.showToast(
                                msg: "No Parent Teacher Assigned",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        }),
                  ),
                  Card(
                    child: new ListTile(
                        title: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  2.0, 0.0, 10.0, 0),
                              child: new Icon(
                                Icons.thumb_up,
                                color: HexColor.fromHex("#000000"),
                                size: iconsize,
                              ),
                            ),
                            new Text(
                              "Like Us",
                              style: TextStyle(
                                  color: HexColor.fromHex("#2e2e1f"),
                                  fontSize: textsize,
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
                          Alert1 alert = new Alert1();
                          alert.displayDialog(context);
                        }),
                  ),
                  // new Divider(),
                  Card(
                    child: new ListTile(
                        title: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  2.0, 0.0, 10.0, 0),
                              child: new Icon(
                                Icons.phonelink_erase,
                                color: HexColor.fromHex("#000000"),
                                size: iconsize,
                              ),
                            ),
                            new Text(
                              "Log out",
                              style: TextStyle(
                                  color: HexColor.fromHex("#2e2e1f"),
                                  fontSize: textsize,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.arrow_right,
                          color: Colors.black,
                        ),
                        onTap: () async {
                          try {
                            Navigator.pop(context,true);

                            final FirebaseMessaging firebaseMessaging =
                            FirebaseMessaging();
                            firebaseMessaging
                                .unsubscribeFromTopic(Studinfo.roll);
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            dbref
                              ..child("Registration")
                                  .child('Student')
                                  .child(Studinfo.branch)
                                  .child(Studinfo.roll)
                                  .child("text")
                                  .set(prefs.getString("text"));
                            FirebaseAuth.instance.signOut();
                            Navigator.pop(context,true);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ));
                            prefs.setBool('login', false);
                          } catch (Exception) {}
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onbackpressed() async {
//    print(isloading);
//    print(showatt);

    if (isloading == true) {
      if (mounted) {
        setState(() {
          gen = false;
          defgen = false;
          isloading = false;
          showatt = true;
          showrem = true;
          clicked = false;
        });
      }
    } else {
      return true;
    }
  }

  void get() async {
//print(Studinfo.roll);
    try {
      await FirebaseDatabase.instance
          .reference()
          .child("defaulter")
          .child("modified")
          .child(Studinfo.roll)
          .once()
          .then((value) async {
        int bit = value.value;
        //print(bit);
        if (bit == 1) {
          // Attendance.viewattendance=true;
          await Attendance.owndata();
          FirebaseDatabase.instance
              .reference()
              .child("defaulter")
              .child("modified")
              .child(Studinfo.roll)
              .set(0);
        } else if (bit == -1) {
          if (mounted) {
            setState(() {
              checkyd = true;
            });
          }
        }
      });
    } catch (Exception) {
      print("modified");
    }
  }

  Column getCardByTitle(String title) {
    String img = '';
    if (title == "View Attendance")
      img = "assets/view1.png";
    else if (title == "Mark Attendance") img = "assets/view.jpg";
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
              color: HexColor.fromHex("#32324e")),
          textAlign: TextAlign.center,
        )
      ],
    );
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
      for (int i = 0; i < Attendance.attendanceDataList.length; i++) {
        TotalAttendance += (Attendance.attendanceDataList[i].total_attendance);
        // print(TotalAttendance);
        total_lect += (Attendance.attendanceDataList[i].total_lect);
        att_lect += (Attendance.attendanceDataList[i].attended_lect);
        total_pract += (Attendance.attendanceDataList[i].total_pract);
        att_pract += (Attendance.attendanceDataList[i].attended_pract);
        att_tut += (Attendance.attendanceDataList[i].attended_tut);
        total_tut += (Attendance.attendanceDataList[i].total_tut);
      }
      TotalAttendance = (att_lect +
          att_pract +
          att_tut +
          Attendance.medical +
          Attendance.sports +
          Attendance.others) /
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
      for (int i = 0; i < Attendance.attendanceDataList.length; i++) {
        AttendanceCounter +=
        (Attendance.attendanceDataList[i].total_attendance /
            Attendance.attendanceDataList.length);
        PieChartSectionData _item = PieChartSectionData(
          color: c.elementAt(i % 5),
          value: 100 / Attendance.attendanceDataList.length,
          title:
          '${Attendance.attendanceDataList[i].subjectName.endsWith(Studinfo.branch) ? Attendance.attendanceDataList[i].subjectName.substring(0, Attendance.attendanceDataList[i].subjectName.length - 4) : Attendance.attendanceDataList[i].subjectName}',
          radius: 6 * SizeConfig.heightMultiplier,
          titleStyle: TextStyle(
              color: Colors.white,
              fontSize: 1.9 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.bold),
        );
        _sections.add(_item);
        // }
      }
    } else {
      //AttendanceCounter=0;
      for (index; index < Attendance.attendanceDataList.length; index++) {
        if (Attendance.attendanceDataList[index].subjectName == sub) break;
      }

//      for Lectures :
      tot = 0;
      cnt = 0;
      double value;
      if (Attendance.attendanceDataList[index].total_lect != 0) {
        value = (Attendance.attendanceDataList[index].attended_lect /
            Attendance.attendanceDataList[index].total_lect) *
            100;
        tot += Attendance.attendanceDataList[index].total_lect;
        cnt += Attendance.attendanceDataList[index].attended_lect;
      } else {
        value = 100.00;
      }
      if (value != 0) {
        AttendanceCounter += (value / 2);
        PieChartSectionData _item1 = PieChartSectionData(
          color: value > 75 ? Color(0xff008080) : Color(0xffff4d4d),
          value: value / 2,
          title: 'Lec',
          radius: 6 * SizeConfig.heightMultiplier,
          titleStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 2 * SizeConfig.textMultiplier),
        );
        _sections.add(_item1);
      }

//    For Practicals :
      if (Attendance.attendanceDataList[index].total_pract != 0) {
        value = (Attendance.attendanceDataList[index].attended_pract /
            Attendance.attendanceDataList[index].total_pract) *
            100;
        tot += Attendance.attendanceDataList[index].total_pract;
        cnt += Attendance.attendanceDataList[index].attended_pract;
      } else {
        value = 100.00;
      }
      AttendanceCounter += (value / 2);
      if (value != 0) {
        PieChartSectionData _item2 = PieChartSectionData(
          color: value > 75 ? Color(0xff008080) : Color(0xffff4d4d),
          value: value / 2,
          title: 'Prac',
          radius: 6 * SizeConfig.heightMultiplier,
          titleStyle: TextStyle(
              color: Colors.white,
              fontSize: 2.1 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.bold),
        );
        _sections.add(_item2);
      }
      // for tutorial
      if (Attendance.attendanceDataList[index].total_tut != 0) {
        value = (Attendance.attendanceDataList[index].attended_tut /
            Attendance.attendanceDataList[index].total_tut) *
            100;
        tot += Attendance.attendanceDataList[index].total_tut;
        cnt += Attendance.attendanceDataList[index].attended_tut;
      } else {
        value = 100.00;
      }

      AttendanceCounter += (value / 2);
      if (value != 0) {
        PieChartSectionData _item2 = PieChartSectionData(
          color: value > 75 ? Color(0xff008080) : Color(0xffff4d4d),
          value: value / 2,
          title: 'Tut',
          radius: 6 * SizeConfig.heightMultiplier,
          titleStyle: TextStyle(
              color: Colors.white,
              fontSize: 2.1 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.bold),
        );
        _sections.add(_item2);
      }
    }
    if (b == false) {
      if (AttendanceCounter < 100) {
        PieChartSectionData _item = PieChartSectionData(
          color: Color(0xffff4d4d),
          value: (100 - AttendanceCounter),
          title: 'Abs',
          radius: 6 * SizeConfig.heightMultiplier,
          titleStyle: TextStyle(
              color: Colors.white,
              fontSize: 2 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.bold),
        );
        _sections.add(_item);
      }
    }

    return SafeArea(
        child: Container(
          child: Column(
            //direction: Axis.vertical, // make sure to set this
            mainAxisAlignment: MainAxisAlignment.start,

//              runSpacing: 0,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    right: 7.2 * SizeConfig.heightMultiplier,
                    left: 7.2 * SizeConfig.heightMultiplier,
                    top: SizeConfig.grp <= 4
                        ? 4 * SizeConfig.heightMultiplier
                        : 7 * SizeConfig.heightMultiplier,
                    bottom: SizeConfig.grp <= 4
                        ? 4 * SizeConfig.heightMultiplier
                        : 7 * SizeConfig.heightMultiplier),
                decoration: BoxDecoration(
                    color: Colors.white,
                    //     borderRadius: BorderRadius.circular(60),
                    shape: BoxShape.circle),
                child: AspectRatio(
                    aspectRatio:
                    (SizeConfig.widthMultiplier / SizeConfig.heightMultiplier) *
                        2.4,
                    child: FlChart(
                        chart: PieChart(
                          PieChartData(
                            sections: _sections,
                            // centerSpaceColor: Colors.orangeAccent,
                            borderData: FlBorderData(show: false),
                            centerSpaceRadius: SizeConfig.grp <= 4
                                ? 9.2 * SizeConfig.heightMultiplier
                                : 8.6 * SizeConfig.heightMultiplier,
                            sectionsSpace: 0.0,
                          ),
                        ))),
              ),
              sub == 'Overall'
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Extra Attendance : ',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 2.7 * SizeConfig.textMultiplier)),
                      Text(
                        '${Attendance.others}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 2.4 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: 1.5 * SizeConfig.heightMultiplier)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Total Attendance : ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 2.7 * SizeConfig.textMultiplier,
                              color: attcolr)),
                      Text(
                        '${TotalAttendance.toStringAsFixed(2)} %',
                        style: TextStyle(
                            fontSize: 2.4 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.bold,
                            color: attcolr),
                      )
                    ],
                  ),
                  new Padding(
                      padding: EdgeInsets.only(
                          bottom: 1.5 * SizeConfig.heightMultiplier)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('lectures  Attended: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: attcolr,
                              fontSize: 2.7 * SizeConfig.textMultiplier)),
                      Text(
                        '$att_lect' + '/' + '$total_lect',
                        style: TextStyle(
                            fontSize: 2.4 * SizeConfig.textMultiplier,
                            color: attcolr,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  new Padding(
                      padding: EdgeInsets.only(
                          bottom: 1.5 * SizeConfig.heightMultiplier)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Practicals  Attended: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: attcolr,
                              fontSize: 2.7 * SizeConfig.textMultiplier)),
                      Text(
                        '$att_pract' + '/' + '$total_pract',
                        style: TextStyle(
                            fontSize: 2.4 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.bold,
                            color: attcolr),
                      )
                    ],
                  ),
                  new Padding(
                      padding: EdgeInsets.only(
                          bottom: 1.5 * SizeConfig.heightMultiplier)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Tutorials  Attended: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: attcolr,
                              fontSize: 2.7 * SizeConfig.textMultiplier)),
                      Text(
                        '$att_tut' + '/' + '$total_tut',
                        style: TextStyle(
                            fontSize: 2.4 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.bold,
                            color: attcolr),
                      )
                    ],
                  ),
                  Padding(
                    padding:
                    EdgeInsets.all(1.5 * SizeConfig.heightMultiplier),
                  ),
                ],
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Extra Attendance : ',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 2.7 * SizeConfig.textMultiplier)),
                      Text(
                        '${Attendance.others}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 2.4 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  new Padding(
                      padding: EdgeInsets.only(
                          bottom: 1.5 * SizeConfig.heightMultiplier)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Total  Attendance: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: attcolr,
                              fontSize: 2.7 * SizeConfig.textMultiplier)),
                      Text(
                        '${(cnt / tot * 100).toStringAsFixed(2)} %',
                        style: TextStyle(
                            fontSize: 2.4 * SizeConfig.textMultiplier,
                            color: attcolr,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  new Padding(
                      padding: EdgeInsets.only(
                          bottom: 1.5 * SizeConfig.heightMultiplier)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Attended Lectures : ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: attcolr,
                              fontSize: 2.7 * SizeConfig.textMultiplier)),
                      Text(
                        '${Attendance.attendanceDataList[index].attended_lect}/${Attendance.attendanceDataList[index].total_lect}',
                        style: TextStyle(
                            fontSize: 2.4 * SizeConfig.textMultiplier,
                            color: attcolr,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  new Padding(
                      padding: EdgeInsets.only(
                          bottom: 1.5 * SizeConfig.heightMultiplier)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Attended Practicals: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: attcolr,
                              fontSize: 2.7 * SizeConfig.textMultiplier)),
                      Text(
                        '${Attendance.attendanceDataList[index].attended_pract}/${Attendance.attendanceDataList[index].total_pract}',
                        style: TextStyle(
                            fontSize: 2.4 * SizeConfig.textMultiplier,
                            color: attcolr,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  new Padding(
                      padding: EdgeInsets.only(
                          bottom: 1.5 * SizeConfig.heightMultiplier)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Attended Tutorials: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: attcolr,
                              fontSize: 2.7 * SizeConfig.textMultiplier)),
                      Text(
                        '${Attendance.attendanceDataList[index].attended_tut}/${Attendance.attendanceDataList[index].total_tut}',
                        style: TextStyle(
                            fontSize: 2.4 * SizeConfig.textMultiplier,
                            color: attcolr,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Padding(
                    padding:
                    EdgeInsets.all(1.5 * SizeConfig.heightMultiplier),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

_displayDialog(BuildContext context) async {
  bool pressed = false;
  var ford = new DateFormat("yyyy_MM_dd");

  ProgressDialog pr = new ProgressDialog(
    context,
    isDismissible: false,
  );
  pr.style(
      message: "wait",
      messageTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 2.7 * SizeConfig.textMultiplier));
  FocusNode focusNode = new FocusNode();
  TextEditingController _textFieldController = TextEditingController();
  //FocusNode focusNode1 = new FocusNode();
  final databaseReference = FirebaseDatabase.instance.reference();
  return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: Text(
                  'Passcode',
                  style: TextStyle(
                      color: HexColor.fromHex("#444422"),
                      fontWeight: FontWeight.bold),
                ),
                content: Padding(
                  padding:
                  EdgeInsets.only(top: 2 * SizeConfig.heightMultiplier),
                  child: new TextFormField(
                    controller: _textFieldController,
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
                              width: 1, color: HexColor.fromHex("#444422")),
                          borderRadius: BorderRadius.circular(10.00)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),

                      // hintStyle: TextStyle(),
                      labelText: "Enter here",
                      hintText: "1234",
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
                    keyboardType: TextInputType.phone,
                    obscureText: true,
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
                      onPressed: pressed == false
                          ? () async {
                        if (_textFieldController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "passcode?",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 2.2 * SizeConfig.textMultiplier);
                        } else {
                          var now = new DateTime.now();
//                          for (int j = 0; j < 6; j++) {
//                            for (int k = 0; k < 30; k++) {
//                              var newDate = new DateTime(
//                                  now.year, now.month + j, now.day + k);

                          String date = ford.format(now);

                          Navigator.pop(context);
                          pr.show();
                          //  await Future.delayed(Duration(seconds: 3));

                          String text;
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          text = prefs.getString("text");
                          print(text);
                          if (!(text == _textFieldController.text)) {
                            //if (true) {
                            String status;

                            try {
                              await databaseReference
                                  .child('c_teacher')
                                  .child(Studinfo.branch)
                                  .child(Studinfo.classs)
                                  .child("status")
                                  .once()
                                  .then((snap) {
                                status = snap.value;
                              });
                              Map data;
                              //  await Future.delayed(Duration(seconds: 4));
                              if (status == 'lecture') {
                                await databaseReference
                                    .child("c_teacher")
                                    .child(Studinfo.branch)
                                    .child(Studinfo.classs)
                                    .child(status)
                                    .once()
                                    .then((snap) {
                                  data = snap.value;
                                });
                              } else {
                                await databaseReference
                                    .child("c_teacher")
                                    .child(Studinfo.branch)
                                    .child(Studinfo.classs)
                                    .child(status)
                                    .child(Studinfo.batch)
                                    .once()
                                    .then((snap) {
                                  data = snap.value;
                                });
                              }
                              Future.delayed(Duration(seconds: 1))
                                  .then((value) {
                                pr.update(
                                    message: "Hang in there!!!",
                                    messageTextStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 2.7 *
                                            SizeConfig.textMultiplier));
                              });
                              print("Step 2");
                              //   await Future.delayed(Duration(seconds: 4));
                              if (_textFieldController.text ==
                                  data["passcode"].toString()) {
                                String leccount = data["count"];
//
//                                print("exist");
                                // await Future.delayed(Duration(seconds: 4));

                                Future.delayed(Duration(seconds: 2))
                                    .then((value) {
                                  pr.update(
                                      message: "Marked",
                                      messageTextStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 2.7 *
                                              SizeConfig.textMultiplier));
                                });

                                if (status == "lecture") {
                                  await databaseReference
                                      .child('Attendance')
                                      .child(Studinfo.branch)
                                      .child(Studinfo.classs)
                                      .child(data['Subject'])
                                      .child(data['Teacher'])
                                      .child(date)
                                      .child(status)
                                      .child(leccount.toString())
                                      .child(Studinfo.roll)
                                      .set("1");
                                  try {
                                    if (!(prefs.containsKey(
                                        data['Subject'] +
                                            data['Teacher']))) {
                                      throw Exception;
                                    }
                                  } catch (Exception) {
                                    prefs.setInt(
                                        data['Subject'] + data['Teacher'],
                                        0);
                                  }
                                  databaseReference
                                      .child("defaulter")
                                      .child(Studinfo.branch)
                                      .child(Studinfo.classs)
                                      .child(Studinfo.roll)
                                      .child(data['Subject'] +
                                      "_" +
                                      data['Teacher'])
                                      .set(prefs.getInt(data['Subject'] +
                                      data['Teacher']) +
                                      1);
                                  prefs.setInt(
                                      data['Subject'] + data['Teacher'],
                                      prefs.getInt(data['Subject'] +
                                          data['Teacher']) +
                                          1);

                                  print("if");
//                            });
                                } else if (status == "Practical") {
                                  await databaseReference
                                      .child('Attendance')
                                      .child(Studinfo.branch)
                                      .child(Studinfo.classs)
                                      .child(data['Subject'])
                                      .child(data['Teacher'])
                                      .child(date)
                                      .child(status)
                                      .child(Studinfo.batch)
                                      .child(leccount.toString())
                                      .child(Studinfo.roll)
                                      .set("1");
                                  try {
                                    if (!(prefs.containsKey(
                                        data['Subject'] +
                                            data['Teacher'] +
                                            "L"))) {
                                      throw Exception;
                                    }
                                  } catch (Exception) {
                                    prefs.setInt(
                                        data['Subject'] +
                                            data['Teacher'] +
                                            "L",
                                        0);
                                  }
                                  databaseReference
                                      .child("defaulter")
                                      .child(Studinfo.branch)
                                      .child(Studinfo.classs)
                                      .child(Studinfo.roll)
                                      .child(data['Subject'] +
                                      "_" +
                                      data['Teacher'] +
                                      "_" +
                                      Studinfo.batch)
                                      .set(prefs.getInt(data['Subject'] +
                                      data['Teacher'] +
                                      "L") +
                                      1);
                                  prefs.setInt(
                                      data['Subject'] +
                                          data['Teacher'] +
                                          "L",
                                      prefs.getInt(data['Subject'] +
                                          data['Teacher'] +
                                          "L") +
                                          1);

                                  print("if");
                                  // });

                                } else {
                                  await databaseReference
                                      .child('Attendance')
                                      .child(Studinfo.branch)
                                      .child(Studinfo.classs)
                                      .child(data['Subject'])
                                      .child(data['Teacher'])
                                      .child(date)
                                      .child(status)
                                      .child(Studinfo.batch)
                                      .child(leccount.toString())
                                      .child(Studinfo.roll)
                                      .set("1");
                                  try {
                                    if (!(prefs.containsKey(
                                        data['Subject'] +
                                            data['Teacher'] +
                                            "T"))) {
                                      throw Exception;
                                    }
                                  } catch (Exception) {
                                    prefs.setInt(
                                        data['Subject'] +
                                            data['Teacher'] +
                                            "T",
                                        0);
                                  }
                                  databaseReference
                                      .child("defaulter")
                                      .child(Studinfo.branch)
                                      .child(Studinfo.classs)
                                      .child(Studinfo.roll)
                                      .child(data['Subject'] +
                                      "_" +
                                      data['Teacher'] +
                                      "_" +
                                      Studinfo.batch +
                                      "_" +
                                      status)
                                      .set(prefs.getInt(data['Subject'] +
                                      data['Teacher'] +
                                      "T") +
                                      1);
                                  prefs.setInt(
                                      data['Subject'] +
                                          data['Teacher'] +
                                          "T",
                                      prefs.getInt(data['Subject'] +
                                          data['Teacher'] +
                                          "T") +
                                          1);

                                  print("tut");
                                  // });

                                }
                                Future.delayed(Duration(seconds: 3))
                                    .then((value) {
                                  pr.hide();
                                });
                                prefs.setString(
                                    "text", _textFieldController.text);
                                // Navigator.pop(context);
                              } else {
                                Future.delayed(Duration(seconds: 2))
                                    .then((value) {
                                  pr.update(
                                      message: "Wrong Passcode",
                                      messageTextStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 2.7 *
                                              SizeConfig.textMultiplier));
                                });
                                Future.delayed(Duration(seconds: 3))
                                    .then((value) {
                                  pr.hide();
                                });
                              }
                            } catch (Exception) {
                              Future.delayed(Duration(seconds: 1))
                                  .then((value) {
                                pr.hide();
                              });
                              Fluttertoast.showToast(
                                  msg: "Goli beta masti nhi",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          } else {
                            Future.delayed(Duration(seconds: 2))
                                .then((value) {
                              pr.update(
                                  message: "Attendance Marked Already",
                                  messageTextStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 2.7 *
                                          SizeConfig.textMultiplier));
                              // await Future.delayed(Duration(seconds: 1));
                            });
                            Future.delayed(Duration(seconds: 3))
                                .then((value) {
                              pr.hide();
                            });
                          }

                          setState(() {
                            pressed = true;
                          });
                        }
                      }
                          : null),
                  new FlatButton(
                    child: new Text(
                      'cancel',
                      style: TextStyle(
                          color: Color(0xff444422),
                          fontWeight: FontWeight.bold,
                          fontSize: 2.3 * SizeConfig.textMultiplier),
                    ),
                    onPressed: pressed == false
                        ? () {
                      Navigator.of(context).pop();
                      setState(() {
                        pressed = true;
                      });
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
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {});
}

_yd(BuildContext context) async {
  bool pressed = false;
  var ford = new DateFormat("yyyy_MM_dd");

  ProgressDialog pr = new ProgressDialog(context, isDismissible: false);
  pr.style(
      message: "wait",
      messageTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 2.7 * SizeConfig.textMultiplier));
  FocusNode focusNode = new FocusNode();
  TextEditingController _textFieldController = TextEditingController();
  //FocusNode focusNode1 = new FocusNode();
  final databaseReference = FirebaseDatabase.instance.reference();
  return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        //nal curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return StatefulBuilder(
          builder: (context, setState) {
            return Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: Text(
                  'Your account is suspened temporarily',
                  style: TextStyle(
                      color: HexColor.fromHex("#444422"),
                      fontWeight: FontWeight.bold),
                ),
                actions: <Widget>[
                  new FlatButton(
                      child: new Text(
                        'Okay',
                        style: TextStyle(
                            color: HexColor.fromHex("#444422"),
                            fontWeight: FontWeight.bold,
                            fontSize: 2.3 * SizeConfig.textMultiplier),
                      ),
                      onPressed: pressed == false
                          ? () async {
                        Navigator.pop(context);
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ));
                        prefs.setBool('login', false);
                      }
                          : null),
                ],
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
