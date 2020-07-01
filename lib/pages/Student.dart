// ignore: avoid_web_libraries_in_flutter
import 'dart:io';
import 'dart:ui';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter_app/pages/View_attendance.dart';
import 'package:flutter_app/pages/forgotpassword.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/pages/parentinfo.dart';
import 'package:flutter_app/responsive/Screensize.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AttendanceData.dart';

class shome extends StatefulWidget {
  @override
  _shomeState createState() => _shomeState();
}

class _shomeState extends State<shome> with TickerProviderStateMixin {
  dynamic name, email;
  TabController tabController;
  bool sort=false;
  bool isloading=false,showatt =true,showrem=true;
  SwiperController controller;
  Map info;
  Color attcolr=Colors.white;
  bool checkyd=false,clicked=false;
  String subjectName = 'Overall';
  int height,index=0;
  FocusNode focusNode1 = new FocusNode();
  final dbref = FirebaseDatabase.instance.reference();
  SharedPreferences prefs;

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


  }

  @override
  void initState() {
    // TODO: implement initState
    controller = new SwiperController();
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
//    getname();
//    get();

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
      onResume: (Map<String, dynamic> message) async{

      },
      onLaunch: (Map<String, dynamic> message)async {
      },
    );
    // Or do other work.
  }
  void get()async{
//print(Studinfo.roll);
    try {
      await FirebaseDatabase.instance.reference().child("defaulter")
          .child("modified").child(Studinfo.roll).once().then((value) async {
        int bit = value.value;
//        print(bit);
        if (bit == 1) {
          // Attendance.viewattendance=true;
          await Attendance.owndata();
          FirebaseDatabase.instance.reference().child("defaulter")
              .child("modified").child(Studinfo.roll).set(0);

        }else if(bit==-1){
          setState(() {
            checkyd=true;
          });
        }
      });

    }catch(Exception){
      print("modified");
    }

  }
  Future<bool> _onbackpressed()async{
//    print(isloading);
//    print(showatt);

    if(isloading==true){
      setState(() {
        isloading=false;
        showatt=true;
        showrem=true;
        clicked=false;
      });

    }else {
      return true;
    }

  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
  onSortColum(int columnIndex, bool ascending) {
    // print(columnIndex);
    if (columnIndex == 0) {
      // print("esdf");
      if (ascending) {
        Studinfo.remediallist.sort((a, b) => a.subjectname.compareTo(b.subjectname));
      } else {
        Studinfo.remediallist.sort((a, b) => b.subjectname.compareTo(a.subjectname));
      }
    } else {
      // print("esdf");
      if (ascending) {
        Studinfo.remediallist.sort((a, b) => a.workload.compareTo(b.workload));
      } else {
        Studinfo.remediallist.sort((a, b) => b.workload.compareTo(a.workload));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    tabController = new TabController(length: 2, vsync: this);

    double iconsize=3 * SizeConfig.heightMultiplier;
    double textsize=2 * SizeConfig.textMultiplier;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "wait");

    List<String> events = [
      "Mark Attendance",
      "View Attendance",
    ];
    getname();
    var view=showatt?new SpinKitWave(
      color: Color(0xff8a8a5c),
      size: 6*SizeConfig.heightMultiplier,
      // controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
    ):
    Container(
      color: Colors.black87,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AttendancePieChart(subjectName),
            Padding(
              padding: EdgeInsets.symmetric(vertical:4*SizeConfig.heightMultiplier,horizontal: 4*SizeConfig.widthMultiplier),
              child: new Swiper(
                  controller:controller ,
                  layout: SwiperLayout.TINDER,
                  customLayoutOption: new CustomLayoutOption(
                      startIndex: -1,
                      stateCount: 3
                  ).addRotate([
                    -45.0/180,
                    0.0,
                    45.0/180
                  ]).addTranslate([
                    new Offset(-370.0, -40.0),
                    new Offset(0.0, 0.0),
                    new Offset(370.0, -40.0)
                  ]),
                  onIndexChanged: (int index){
                    setState(() {
                      subjectName=Attendance.subjectList.elementAt(index);
                    });
                  },
                  itemWidth: 55*SizeConfig.widthMultiplier,
                  itemHeight: 13*SizeConfig.heightMultiplier,
                  itemBuilder: (context, index) {

                    return new Container(
//                                          width: 100,
//                                          height: 100,
                      child: Center(child: Text(Attendance.subjectList.elementAt(index),style: TextStyle(fontSize: 4*SizeConfig.heightMultiplier,fontWeight: FontWeight.bold,color: Colors.black87),)),
                      decoration:BoxDecoration(
                        image: DecorationImage(
                          image: new AssetImage("assets/card1.jpg"),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: new BorderRadius
                            .circular(30.0),
                        shape: BoxShape.rectangle,
                        border: Border.all(width: 4.0, color: Colors.grey),
                      ),
                    );
                  },
                  itemCount: Attendance.subjectList.length),
            ),
          ]
      ),
    )
    ;
    var gridView =showrem?new SpinKitWave(
      color: Color(0xff8a8a5c),
      size: 6*SizeConfig.heightMultiplier,
      // controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
    ):
    Container(
      color: Colors.black87,
      child: new SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
//          sortAscending: sort,
//          sortColumnIndex: index,
          columns: [
            DataColumn(
              label: Text("Subjects",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 2.5*SizeConfig.heightMultiplier,color: Colors.white),),
              numeric: false,
              tooltip: "This is  subject",
//                onSort: (columnIndex, ascending) {
//                  setState(() {
//                    index=0;
//                    sort = !sort;
//                  });
//                  onSortColum(columnIndex, ascending);
//                }
            ),
            DataColumn(
              label: Text("Remedial hours",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 2.5*SizeConfig.heightMultiplier,color: Colors.white),),
              numeric: true,
              tooltip: "This is Last work",
//                onSort: (columnIndex, ascending) {
//                  setState(() {
//                    index=1;
//                    sort = !sort;
//                  });
//                  onSortColum(columnIndex, ascending);
//
//                }
            ),
          ],
          rows: Studinfo.remediallist
              .map(
                (user) => DataRow(
                cells: [
                  DataCell(
                    Text(user.subjectname,style: TextStyle(color: Colors.white,fontSize: 2.2*SizeConfig.heightMultiplier),),
                  ),
                  DataCell(
                    Text(user.workload.toString(),style: TextStyle(color: Colors.white,fontSize: 2.2*SizeConfig.heightMultiplier),),
                  ),
                ]),
          )
              .toList(),
        ),
      ),
    );
    return WillPopScope(
      onWillPop: _onbackpressed,
      child:isloading?  new DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: new Scaffold(
          appBar:new PreferredSize(
            preferredSize: Size.fromHeight(75),
            child: Container(
              color: HexColor.fromHex("#008080"),
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    // new Expanded(child: new Container()),
                    new TabBar(onTap: (index)async{
                      if(index==1) {
                        int time;
                        DateFormat format = new DateFormat("HH");
                        time = int.parse(format.format(new DateTime.now()));
                        bool show = true;

                        try {
                          if (time < 19 && time > 9) {
                            await Studinfo.remedial();
                          }
                          try {
                            await  Studinfo.relist();
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

                        if (show) {
                          setState(() {
                            // isloading=true;
                            showrem = false;

                          });
                        } else {
                          Fluttertoast.showToast(
                              msg: "Nothing to show here",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          showrem = false;
                        }
                      }
                    },
                      unselectedLabelColor: Color(0xff006666),

                      labelColor: Colors.white,
                      labelStyle: TextStyle(fontSize: 2.4*SizeConfig.heightMultiplier,fontWeight: FontWeight.bold) ,
                      tabs:<Widget> [
                        new Tab(
                          icon: new Icon(Icons.assessment), text: "Attendance",

                        ),
                        new Tab(
                          icon: new Icon(Icons.assignment),text: "Defaulter assignments",
                        ),

                      ],controller: DefaultTabController.of(context),indicatorColor: Color(0xffffffff),),

//                  ),
                  ],
                ),
              ),
            ),
          ),
          body: new TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              view,
              gridView,
            ],
            controller: DefaultTabController.of(context),

          ),
        ),
      ):new Scaffold(
        body: Container(
          padding: EdgeInsets.only(
              top: 3 * SizeConfig.heightMultiplier,
              left: 12 * SizeConfig.widthMultiplier,
              right: 12 * SizeConfig.widthMultiplier),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black87,
                  Colors.black87
                ]),
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
                  onTap: clicked?null:() async {
                    setState(() {
                      clicked=true;
                    });
                    if (title == "View Attendance") {
                      int time;
                      DateFormat format=new DateFormat("HH");
                      time=int.parse(format.format(new DateTime.now()));
                      bool show=true;
//
                      setState(() {
                        isloading=true;

                      });

                      try{
                        if(time<19&&time>9){
                          // pr.show();

                          await get();
                          await Attendance.displayatt();
                          //await Studinfo.remedial();

                        }else{
                          var ford = new DateFormat("yyyy_MM_dd");
                          var now = new DateTime.now();
                          String date = ford.format(now);
                          try{
                            if ((prefs.getString("today_date") == date)) {
                              prefs.setInt("fetchatt", 0);
                            } else {
                              prefs.setString("today_date", date);
                              prefs.setInt("fetchatt", 1);
                            }
                          }catch(Exception){
                            prefs.setInt("fetchatt", 1);
                            prefs.setString("today_date", date);
                          }
                          if(prefs.getInt("fetchatt")==1){
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
                          Attendance.getlist();
                          // Studinfo.relist();

                        }catch(e){
                          throw Exception;
                          print("pko");
                        }
                      }catch(Exception){
//                      pr.hide();
                        show=false;
                      }

                      if(show) {
                        print(showatt);
                        setState(() {
                          // isloading=true;
                          showatt=false;
                        });
//
                      }else{
                        setState(() {
                          isloading=false;
                        });
                        Fluttertoast.showToast(
                            msg: "Nothing to show here",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    } else {
                      await get();
//                      print("sdf");
                      if(checkyd){
                        _yd(context);
                      }else {

                        try {
                          final result = await InternetAddress.lookup('google.com');
                          print(result);
                          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                            print('connected');
                            _displayDialog(context);
                          }else{
                            print('not connected');
                          }

                        } catch (Exception) {
                          print('not connected');
                        }

                      }
                      setState(() {
                        clicked=false;
                      });
                    }
                  },
                );
              }).toList(),
            ),
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
                              padding: EdgeInsets.fromLTRB(2.0, 0.0, 15.0, 0),
                              child: new Icon(
                                Icons.person,
                                color: HexColor.fromHex("#000000"),
                                size:iconsize,
                              ),
                            ),
                            new Text(
                              "Profile",
                              style: TextStyle(
                                  fontSize:textsize,
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
                              padding: const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
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
                        onTap: ()async {
                          SharedPreferences prefs=await SharedPreferences.getInstance();
                          var  e = Studinfo.email.split('@');
                          String b = e[0]
                              .toString()
                              .replaceAll(
                              new RegExp(r'\W'), "_");
                          try {
                            if (prefs.getString("parent") == null) {
                              await dbref
                                  .child("Registration")
                                  .child('Student')
                                  .child(Studinfo.branch)
                                  .child(b.toString())
                                  .child("Parent")
                                  .once()
                                  .then((snap) async {
                                String name = snap.value;
                                if (snap.value == null) {
                                  throw Exception;
                                } else {
                                  Studinfo.parentname = name;
                                  prefs.setString("parent", name);
                                }
                              });
                            } else {
                              Studinfo.parentname = prefs.getString("parent");
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
                          }catch(Exception){
                            pr.hide();
                          }
                        }),
                  ),
                  Card(
                    child: new ListTile(
                        title: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
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
                              padding: const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
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
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          title: new Text("Home",
              style: TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
          // backgroundColor: HexColor.fromHex("#2f2f1e"),
          backgroundColor: HexColor.fromHex("#008080"),
        ),
      ),
    );
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
    int tot=0,cnt=0;
    double TotalAttendance = 0;
    int index = 0;
    int total_lect=0;
    int att_lect=0;
    int total_pract=0;
    int att_pract=0;
    int att_tut=0;
    int total_tut=0;
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
      TotalAttendance = (att_lect+att_pract+att_tut+Attendance.medical+Attendance.sports+Attendance.others) / (total_lect+total_pract+total_tut)*100;
      TotalAttendance=TotalAttendance.toStringAsFixed(2) as double;
      FirebaseDatabase.instance.reference().child("defaulter")
          .child(Studinfo.branch).child(Studinfo.classs)
          .child(Studinfo.roll).child("zzTotal").set(TotalAttendance.toStringAsFixed(2)+"%");
    } catch (Exception) {}
    List<Color> c=[HexColor.fromHex("#008080"),Colors.orange.shade400,HexColor.fromHex("#001a33"),HexColor.fromHex("#ff4d4d"),HexColor.fromHex("#73264d")];
    bool b=false;
    if (sub == 'Overall') {
      b=true;
      for (int i = 0; i < Attendance.attendanceDataList.length; i++) {
        AttendanceCounter +=
        (Attendance.attendanceDataList[i].total_attendance /
            Attendance.attendanceDataList.length);
        PieChartSectionData _item = PieChartSectionData(
          color: c.elementAt(i%5),
          value: 100/Attendance.attendanceDataList.length,
          title: '${Attendance.attendanceDataList[i].subjectName}',
          radius: 6*SizeConfig.heightMultiplier,
          titleStyle: TextStyle(color: Colors.white, fontSize: 1.9*SizeConfig.textMultiplier,fontWeight: FontWeight.bold),
        );
        _sections.add(_item);
        // }
      }
    }
    else {
      //AttendanceCounter=0;
      for (index; index < Attendance.attendanceDataList.length; index++) {
        if (Attendance.attendanceDataList[index].subjectName == sub)
          break;
      }

//      for Lectures :
      tot=0;
      cnt=0;
      double value;
      if (Attendance.attendanceDataList[index].total_lect != 0) {
        value = (Attendance.attendanceDataList[index].attended_lect /
            Attendance.attendanceDataList[index].total_lect) * 100;
        tot+=Attendance.attendanceDataList[index].total_lect;
        cnt+=Attendance.attendanceDataList[index].attended_lect;
      }
      else {
        value = 100.00;
      }
      if(value!=0){
        AttendanceCounter += (value / 2);
        PieChartSectionData _item1 = PieChartSectionData(
          color: value > 75
              ? Color(0xff155511)
              : Color(0xff990000),
          value: value / 2,
          title: 'Lec',
          radius: 6*SizeConfig.heightMultiplier,
          titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 2*SizeConfig.textMultiplier),
        );
        _sections.add(_item1);
      }

//    For Practicals :
      if (Attendance.attendanceDataList[index].total_pract != 0) {
        value = (Attendance.attendanceDataList[index].attended_pract /
            Attendance.attendanceDataList[index].total_pract) * 100;
        tot+=Attendance.attendanceDataList[index].total_pract;
        cnt+=Attendance.attendanceDataList[index].attended_pract;
      }
      else {
        value = 100.00;
      }
      AttendanceCounter += (value / 2);
      if(value!=0){
        PieChartSectionData _item2 = PieChartSectionData(
          color: value > 75
              ? Color(0xff155511)
              : Color(0xff990000),
          value: value / 2,
          title: 'Prac',
          radius: 6*SizeConfig.heightMultiplier,
          titleStyle: TextStyle(color: Colors.white, fontSize: 2.1*SizeConfig.textMultiplier,fontWeight: FontWeight.bold),
        );
        _sections.add(_item2);
      }
      // for tutorial
      if (Attendance.attendanceDataList[index].total_tut != 0) {
        value = (Attendance.attendanceDataList[index].attended_tut /
            Attendance.attendanceDataList[index].total_tut) * 100;
        tot+=Attendance.attendanceDataList[index].total_tut;
        cnt+=Attendance.attendanceDataList[index].attended_tut;
      }
      else {
        value = 100.00;
      }

      AttendanceCounter += (value / 2);
      if(value!=0){
        PieChartSectionData _item2 = PieChartSectionData(
          color: value > 75
              ? Color(0xff155511)
              : Color(0xff990000),
          value: value / 2,
          title: 'Tut',
          radius: 6*SizeConfig.heightMultiplier,
          titleStyle: TextStyle(color: Colors.white, fontSize: 2.1*SizeConfig.textMultiplier,fontWeight: FontWeight.bold),
        );
        _sections.add(_item2);
      }
    }
    if(b==false){
      if (AttendanceCounter < 100) {
        PieChartSectionData _item = PieChartSectionData(
          color:Color(0xff990000),
          value: (100 - AttendanceCounter),
          title: 'Abs',
          radius: 6*SizeConfig.heightMultiplier,
          titleStyle: TextStyle(
              color: Colors.white,
              fontSize: 2*SizeConfig.textMultiplier,
              fontWeight: FontWeight.bold
          ),
        );
        _sections.add(_item);
      }
    }

    return SafeArea(
        child:Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            //    mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(72.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle
                ),
                child: AspectRatio(
                    aspectRatio: (SizeConfig.widthMultiplier/SizeConfig.heightMultiplier)*2.4,
                    child: FlChart(
                        chart: PieChart(
                          PieChartData(
                            sections: _sections,
                            // centerSpaceColor: Colors.orangeAccent,
                            borderData: FlBorderData(show: false),
                            centerSpaceRadius: 7*SizeConfig.heightMultiplier,
                            sectionsSpace: 0.0,
                          ),
                        )
                    )
                ),
              ),

              sub == 'Overall' ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          'Total Attendance : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 2.7*SizeConfig.textMultiplier,color: attcolr)),
                      Text(
                        '${TotalAttendance.toStringAsFixed(2)} %'
                        ,style: TextStyle(fontSize: 2.4*SizeConfig.textMultiplier,fontWeight: FontWeight.bold,color: attcolr),
                      )
                    ],
                  ),
                  new Padding(padding: EdgeInsets.only(bottom: 1.5*SizeConfig.heightMultiplier)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          'lectures  Attended: ',style: TextStyle(fontWeight: FontWeight.bold,color: attcolr,fontSize: 2.7*SizeConfig.textMultiplier)),
                      Text(
                        '$att_lect'+'/'+'$total_lect'
                        ,style: TextStyle(fontSize: 2.4*SizeConfig.textMultiplier,color: attcolr,fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  new Padding(padding: EdgeInsets.only(bottom: 1.5*SizeConfig.heightMultiplier)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          'Practicals  Attended: ',style: TextStyle(fontWeight: FontWeight.bold,color: attcolr,fontSize: 2.7*SizeConfig.textMultiplier)),
                      Text(
                        '$att_pract'+'/'+'$total_pract'
                        ,style: TextStyle(fontSize: 2.4*SizeConfig.textMultiplier,fontWeight: FontWeight.bold,color: attcolr),
                      )
                    ],
                  ),
                  new Padding(padding: EdgeInsets.only(bottom: 1.5*SizeConfig.heightMultiplier)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          'Tutorials  Attended: ',style: TextStyle(fontWeight: FontWeight.bold,color: attcolr,fontSize: 2.7*SizeConfig.textMultiplier)),
                      Text(
                        '$att_tut'+'/'+'$total_tut'
                        ,style: TextStyle(fontSize: 2.4*SizeConfig.textMultiplier,fontWeight: FontWeight.bold,color: attcolr),
                      )
                    ],
                  ),
                ],
              ):
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          'Total  Attendance: ',style: TextStyle(fontWeight: FontWeight.bold,color: attcolr,fontSize: 2.7*SizeConfig.textMultiplier)),
                      Text(
                        '${(cnt/tot*100).toStringAsFixed(2)} %'
                        ,style: TextStyle(fontSize: 2.4*SizeConfig.textMultiplier,color: attcolr,fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  new Padding(padding: EdgeInsets.only(bottom: 1.5*SizeConfig.heightMultiplier)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          'Attended Lectures : ',style: TextStyle(fontWeight: FontWeight.bold,color: attcolr,fontSize: 2.7*SizeConfig.textMultiplier)),
                      Text(
                        '${Attendance.attendanceDataList[index]
                            .attended_lect}/${Attendance.attendanceDataList[index]
                            .total_lect}'
                        ,style: TextStyle(fontSize: 2.4*SizeConfig.textMultiplier,color: attcolr,fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  new Padding(padding: EdgeInsets.only(bottom: 1.5*SizeConfig.heightMultiplier)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          'Attended Practicals: ',style: TextStyle(fontWeight: FontWeight.bold,color: attcolr,fontSize: 2.7*SizeConfig.textMultiplier)),
                      Text(
                        '${Attendance.attendanceDataList[index]
                            .attended_pract}/${Attendance.attendanceDataList[index]
                            .total_pract}'
                        ,style: TextStyle(fontSize: 2.4*SizeConfig.textMultiplier,color: attcolr,fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  new Padding(padding: EdgeInsets.only(bottom: 1.5*SizeConfig.heightMultiplier)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          'Attended Tutorials: ',style: TextStyle(fontWeight: FontWeight.bold,color: attcolr,fontSize: 2.7*SizeConfig.textMultiplier)),
                      Text(
                        '${Attendance.attendanceDataList[index]
                            .attended_tut}/${Attendance.attendanceDataList[index]
                            .total_tut}'
                        ,style: TextStyle(fontSize: 2.4*SizeConfig.textMultiplier,color: attcolr,fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              )
//
            ],
          ),
        )
    ) ;

  }
}

_displayDialog(BuildContext context) async {
  bool pressed = false;
  var ford = new DateFormat("yyyy_MM_dd");

  ProgressDialog pr = new ProgressDialog(context,isDismissible: false,);
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

                                if(status=="lecture") {
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
                                  try{
                                    if(!(
                                        prefs.containsKey(data['Subject'] +
                                            data['Teacher']
                                        ))){
                                      throw Exception;
                                    }

                                  }catch(Exception){
                                    prefs.setInt(data['Subject'] +
                                        data['Teacher']
                                        ,0);

                                  }
                                  databaseReference
                                      .child("defaulter")
                                      .child(Studinfo.branch)
                                      .child(Studinfo.classs)
                                      .child(Studinfo.roll)
                                      .child(data['Subject'] +
                                      "_" +
                                      data['Teacher']
                                  )
                                      .set(prefs.getInt(data['Subject'] +
                                      data['Teacher']
                                  ) +
                                      1);
                                  prefs.setInt(data['Subject'] +
                                      data['Teacher']
                                      ,prefs.getInt(data['Subject'] +
                                          data['Teacher']
                                      ) +
                                          1);

                                  print("if");
//                            });
                                }else if(status=="Practical"){
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
                                  try{
                                    if(!(prefs.containsKey(data['Subject'] +
                                        data['Teacher'] +
                                        "L"))){
                                      throw Exception;
                                    }
                                  }catch(Exception){
                                    prefs.setInt(data['Subject'] +
                                        data['Teacher'] +
                                        "L",0);
                                  }
                                  databaseReference
                                      .child("defaulter")
                                      .child(Studinfo.branch)
                                      .child(Studinfo.classs)
                                      .child(Studinfo.roll)
                                      .child(data['Subject'] +
                                      "_" +
                                      data['Teacher'] +
                                      "_"+Studinfo.batch)
                                      .set(prefs.getInt(data['Subject'] +
                                      data['Teacher'] +
                                      "L") +
                                      1);
                                  prefs.setInt(data['Subject'] +
                                      data['Teacher'] +
                                      "L",prefs.getInt(data['Subject'] +
                                      data['Teacher'] +
                                      "L") +
                                      1);

                                  print("if");
                                  // });

                                }else {
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
                                  try{
                                    if(!(prefs.containsKey(data['Subject'] +
                                        data['Teacher'] +
                                        "T"))){
                                      throw Exception;
                                    }
                                  }catch(Exception){
                                    prefs.setInt(data['Subject'] +
                                        data['Teacher'] +
                                        "T",0);
                                  }
                                  databaseReference
                                      .child("defaulter")
                                      .child(Studinfo.branch)
                                      .child(Studinfo.classs)
                                      .child(Studinfo.roll)
                                      .child(data['Subject'] +
                                      "_" +
                                      data['Teacher'] +
                                      "_"+Studinfo.batch+"_"+status)
                                      .set(prefs.getInt(data['Subject'] +
                                      data['Teacher'] +
                                      "T") +
                                      1);
                                  prefs.setInt(data['Subject'] +
                                      data['Teacher'] +
                                      "T",prefs.getInt(data['Subject'] +
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
                          color: Colors.black,
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

  ProgressDialog pr = new ProgressDialog(context,isDismissible: false);
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
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
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
