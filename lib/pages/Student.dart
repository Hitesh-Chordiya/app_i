import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/View_attendance.dart';
import 'package:flutter_app/pages/forgotpassword.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/responsive/Screensize.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AttendanceData.dart';

class shome extends StatefulWidget {
  @override
  _shomeState createState() => _shomeState();
}

class _shomeState extends State<shome> with SingleTickerProviderStateMixin {
  dynamic name, email;
  TabController controller;
  Map info;
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
    var e=Studinfo.email.split("@");
    Alert.name=e[0].toString().replaceAll(new RegExp(r'\W'), "_");
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
    ProgressDialog pr=new ProgressDialog(context,type: ProgressDialogType.Normal,isDismissible: true);
    pr.style(message: "wait");

    List<String> events = [
      "Mark Attendance",
      "View Attendance",
    ];
    getname();
    return new Scaffold(

      body: Container(
//        width: 10*SizeConfig.widthMultiplier,
//        height: 10*SizeConfig.heightMultiplier,

        padding:
        EdgeInsets.only(top:3*SizeConfig.heightMultiplier,left: 12*SizeConfig.widthMultiplier,right: 12*SizeConfig.widthMultiplier),
        decoration: BoxDecoration(
          gradient:LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
//              stops: [0,0.5,1],
//              colors: [
//                HexColor.fromHex("#135058"),
//                HexColor.fromHex("#fff"),
//                HexColor.fromHex("#135058")
//              ]
            colors: [
              //HexColor.fromHex("#000000"),
              HexColor.fromHex("#14141f"),
              HexColor.fromHex("#14141f"),
//              HexColor.fromHex("#6d6d46"),
//              HexColor.fromHex("#6d6d46"),


            ]
              ),
        ),
                child: Container(

                  margin:EdgeInsets.symmetric(horizontal: 3.8*SizeConfig.widthMultiplier,vertical:5*SizeConfig.heightMultiplier ),
          width:114*SizeConfig.widthMultiplier,
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
                          spreadRadius: -20
                      )
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
                  if (title == "View Attendance") {
                    try{
                      // Attendance.attendanceDataList.clear();
                      if(Studinfo.fetch==false){
                        ProgressDialog pr=new ProgressDialog(context);
                        pr.style(message:"wait",messageTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 2.7*SizeConfig.textMultiplier));
                        pr.show();
                        await Attendance.view();
                        Studinfo.fetch=true;
                        pr.hide();
                      }

                      if(Attendance.viewattendance==true) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            ));
                      }
                      else
                        throw Exception;
                    }
                    catch(Exception){
                      Fluttertoast.showToast(
                          msg: "Nothing to show here",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }

                  } else {
                    _displayDialog(context);
                  }
                },
              );
            }).toList(),
          ),
        ),
      ),

      drawer: Theme(data:Theme.of(context).copyWith(
          canvasColor: Colors.white, //This will change the drawer background to blue.
          //other styles
          selectedRowColor: Colors.brown.shade300
      ), child: Container(
        width: 76*SizeConfig.widthMultiplier,
        child:Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text(
                  Studinfo.name,
                  style: TextStyle(fontSize: 2.7*SizeConfig.textMultiplier,color:HexColor.fromHex("#ffffff"),fontWeight: FontWeight.bold),
                ),
                accountEmail:
                new Text(Studinfo.email, style: TextStyle(fontSize: 2.1*SizeConfig.textMultiplier,color: HexColor.fromHex("#ffffff"),fontWeight: FontWeight.bold)),
                currentAccountPicture: new CircleAvatar(
                  radius: 3*SizeConfig.heightMultiplier,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 6*SizeConfig.heightMultiplier,
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
              new ListTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding:EdgeInsets.fromLTRB(2.0, 0.0, 15.0, 0),
                        child: new Icon(
                          Icons.person,
                         color: HexColor.fromHex("#000000"),
                          size: 4*SizeConfig.heightMultiplier,
                        ),
                      ),
                      new Text(
                        "Profile",
                        style: TextStyle(
                            fontSize: 2.4*SizeConfig.textMultiplier, fontWeight: FontWeight.bold,color: HexColor.fromHex("#2e2e1f")),
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
              new Divider(),
              new ListTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
                        child: new Icon(
                          Icons.thumb_up,
                          color:HexColor.fromHex("#000000"),
                          size: 4*SizeConfig.heightMultiplier,
                        ),
                      ),
                      new Text(
                        "Like Us",
                        style: TextStyle(
                          color:HexColor.fromHex("#2e2e1f"),
                            fontSize: 2.4*SizeConfig.textMultiplier, fontWeight: FontWeight.bold),
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
                        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
                        child: new Icon(
                          Icons.phonelink_erase,
                          color: HexColor.fromHex("#000000"),
                          size: 4*SizeConfig.heightMultiplier,
                        ),
                      ),
                      new Text(
                        "Log out",
                        style: TextStyle(
                          color: HexColor.fromHex("#2e2e1f"),
                            fontSize: 2.4*SizeConfig.textMultiplier, fontWeight: FontWeight.bold),
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
                    prefs.setBool('login', false);
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
      ) ,

      appBar: AppBar(
        title: new Text("Home",style:TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)),
       // backgroundColor: HexColor.fromHex("#2f2f1e"),
        backgroundColor: HexColor.fromHex("#6d6d46"),
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
                  width: 45*SizeConfig.widthMultiplier,
                  height: 15*SizeConfig.heightMultiplier,
                )
              ],
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 3.1*SizeConfig.textMultiplier, fontWeight: FontWeight.bold,color: HexColor.fromHex("#32324e")),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}




_displayDialog(BuildContext context) async {
  ProgressDialog pr = new ProgressDialog(context);
  pr.style(
      message: "wait",messageTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 2.7*SizeConfig.textMultiplier));
  FocusNode focusNode = new FocusNode();
  TextEditingController _textFieldController = TextEditingController();
  //FocusNode focusNode1 = new FocusNode();
  final databaseReference =  FirebaseDatabase.instance.reference();
  return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              title: Text('Passcode',style: TextStyle(color:HexColor.fromHex("#444422"),fontWeight: FontWeight.bold),),
              content: Padding(
                padding:EdgeInsets.only(top:2*SizeConfig.heightMultiplier),
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
                      fontSize: 2.5*SizeConfig.textMultiplier),
                  decoration: new InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal:5.5*SizeConfig.widthMultiplier),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1,color: HexColor.fromHex("#444422")),
                          borderRadius: BorderRadius.circular(10.00)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),

                     // hintStyle: TextStyle(),
                      labelText: "Enter here",
                      hintText: "1234",
                      hintStyle: TextStyle(color: HexColor.fromHex("d6d6c2"),fontWeight: FontWeight.bold,fontSize: 15),
                      labelStyle: TextStyle(color: HexColor.fromHex("#d6d6c2"), fontSize: 2.3*SizeConfig.textMultiplier,fontWeight: FontWeight.bold),
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
                      style: TextStyle(color: HexColor.fromHex("#444422"),fontWeight: FontWeight.bold,fontSize: 2.3*SizeConfig.textMultiplier),
                    ),
                    onPressed: () async {
                      if (_textFieldController.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "passcode?",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 2.2*SizeConfig.textMultiplier);
                      } else {
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
                        Navigator.pop(context);
                        pr.show();
                        //  await Future.delayed(Duration(seconds: 3));

                        String text;
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        text = prefs.getString("text");
                        print(text);
                        if (!(text == _textFieldController.text)) {
                          String status;


                          await    databaseReference
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
                            await    databaseReference
                                .child("c_teacher")
                                .child(Studinfo.branch)
                                .child(Studinfo.classs)
                                .child(status)
                                .once()
                                .then((snap) {
                              data = snap.value;
                            });
                          } else {
                            await   databaseReference
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
                          Future.delayed(Duration(seconds: 1)).then((value) {
                            pr.update(message: "Hang in there!!!",messageTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 2.7*SizeConfig.textMultiplier));
                          });
                          print("Step 2");
                          //   await Future.delayed(Duration(seconds: 4));
//                      Map exist;
                          if (_textFieldController.text ==
                              data["passcode"].toString()) {
                            // Future.delayed(Duration(seconds: 4)).then((value) {
                            //   pr.update(message: "Almost done");
                            //   });
                            String leccount = data["count"];
//
                            print("exist");
                            // await Future.delayed(Duration(seconds: 4));

                            Future.delayed(Duration(seconds: 2)).then((value) {
                              pr.update(
                                  message: "Marked",messageTextStyle: TextStyle(color: Colors.lightGreen,fontWeight: FontWeight.bold,fontSize: 2.7*SizeConfig.textMultiplier));
                            });

                            if (status == "Practical") {
//
                              await    databaseReference
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
                              print("if");
                              // });
                            } else {
                              print(Studinfo.roll);
                              await   databaseReference
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
                              print("if");
//                            });
                            }
                            Future.delayed(Duration(seconds: 3)).then((value) {
                              pr.hide();
                            });
                            //   await Future.delayed(Duration(seconds: 3));
                            prefs.setString("text", _textFieldController.text);
                            Navigator.pop(context);
                          } else {
                            Future.delayed(Duration(seconds: 2)).then((value) {
                              pr.update(
                                  message: "Wrong Passcode",messageTextStyle: TextStyle(color: Colors.red.shade400,fontWeight: FontWeight.bold,fontSize: 2.7*SizeConfig.textMultiplier));
                            });
                            Future.delayed(Duration(seconds: 3)).then((value) {
                              pr.hide();
                            });
                          }
                        }
                        else {
                          Future.delayed(Duration(seconds: 2)).then((value) {
                            pr.update(
                                message: "Attendance Marked Already",messageTextStyle: TextStyle(color: Colors.red.shade400,fontWeight: FontWeight.bold,fontSize: 2.7*SizeConfig.textMultiplier));
                            // await Future.delayed(Duration(seconds: 1));
                          });
                          Future.delayed(Duration(seconds: 3)).then((value) {
                            pr.hide();
                          });
                        }
                      }
                    }),
                new FlatButton(
                  child: new Text(
                    'cancel',
                    style: TextStyle(color: HexColor.fromHex("#444422"),fontWeight: FontWeight.bold,fontSize: 2.3*SizeConfig.textMultiplier),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
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
