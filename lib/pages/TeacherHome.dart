import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/Signup.dart';
import 'package:flutter_app/pages/homepage.dart';
import 'package:flutter_app/pages/subject.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class Presignup extends StatefulWidget {
  @override
  _PresignupState createState() => _PresignupState();
}

class _PresignupState extends State<Presignup> {
  var _radioValue1, choice, _radioValue;
  dynamic value, s, name;
  var s1;
  Map tinfo;
  SharedPreferences prefs;
  final dbref = FirebaseDatabase.instance.reference();

  Future<String> getname() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      s = prefs.getString("email");
      s1 = s.split('@');
      dbref
          .child('Teacher_account')
          .child(s1[0].toString())
          .once()
          .then((snap) {
        tinfo = snap.value;
        name=tinfo["name"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: new Scaffold(
          drawer: new Drawer(
            child: new ListView(
              children: <Widget>[
                new UserAccountsDrawerHeader(
                  accountName: new Text(
                    name.toString(),
                    style: TextStyle(fontSize: 20.0),
                  ),
                  accountEmail:
                  new Text(s.toString(), style: TextStyle(fontSize: 15.0)),
                  currentAccountPicture: new CircleAvatar(
                    backgroundColor: Colors.black87,
                    child: Icon(
                      Icons.person,
                      size: 70.0,
                    ),
                  ),
                ),
                new ListTile(
                    title: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
                          child: new Icon(
                            Icons.person,
                            size: 30.0,
                          ),
                        ),
                        new Text(
                          "Profile",
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
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
                            size: 28.0,
                          ),
                        ),
                        new Text(
                          "Like Us",
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ));
                    }),
                new Divider(),
                new ListTile(
                    title: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
                          child: new Icon(
                            Icons.supervisor_account,
                            size: 30.0,
                          ),
                        ),
                        new Text(
                          "class",
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ));
                    }),
                new Divider(),
                new ListTile(
                    title: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
                          child: new Icon(
                            Icons.arrow_right,
                            size: 30.0,
                          ),
                        ),
                        new Text(
                          "Log out",
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.phonelink_erase,
                      color: Colors.black,
                    ),
                    onTap: () async {
                      SharedPreferences log = await SharedPreferences.getInstance();
                      log.setBool("login", false);
                      FirebaseAuth.instance.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ));
                    }),
              ],
            ),
          ),
          body: new Container(
            child: Center(
              child: Row(children: <Widget>[
                new Radio(
                  value: 0,
                  groupValue: _radioValue1,
                  onChanged: (value) {
                    setState(() {
                      _radioValue1 = value;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Signup(),
                          ));
                    });
                  },
                ),
                new Text(
                  'Teacher',
                  style: new TextStyle(fontSize: 16.0),
                ),
                new Radio(
                  value: 1,
                  groupValue: _radioValue1,
                  onChanged: (value) {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ));
                    });
                  },
                ),
                new Text(
                  'stud',
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ]),
            ),
          ),
        ));
  }
}

class Passcode extends StatefulWidget {
  @override
  _PasscodeState createState() => _PasscodeState();
}

class _PasscodeState extends State<Passcode>
    with SingleTickerProviderStateMixin {
  TabController controller;
  dynamic value, s, name;
  var s1;
  String classs = 'Select Class', sub, stat = "Select Status";
  String lec;
  FocusNode focusNode1 = new FocusNode();
  FocusNode focusNode2 = new FocusNode();
  Map tinfo;

  var cla = [
    'Select Class',
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
  var status = ['Select Status', 'lecture', 'Practical'];
  SharedPreferences prefs;
  final databaseReference = FirebaseDatabase.instance.reference();
  TextEditingController _controller = TextEditingController();

  Future<String> getname() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      s = prefs.getString("email");
      s1 = s.split('@');
      databaseReference
          .child('Teacher_account')
          .child(s1[0].toString())
          .once()
          .then((snap) {
        tinfo = snap.value;
        name=tinfo["name"];
      });
    });
    await Future.delayed(Duration(seconds: 4));
  }

  int code = 1000;
  dynamic str = "your code";

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
    getname();
    return MaterialApp(
        home: new Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: new AppBar(
            title: new Text("Attendance"),
            backgroundColor: Colors.blue,
          ),
          drawer: new Drawer(
            child: new ListView(
              children: <Widget>[
                new UserAccountsDrawerHeader(
                  accountName: new Text(
                    name.toString(),
                    style: TextStyle(fontSize: 20.0),
                  ),
                  accountEmail:
                  new Text(s.toString(), style: TextStyle(fontSize: 15.0)),
                  currentAccountPicture: new CircleAvatar(
                    backgroundColor: Colors.black87,
                    child: Icon(
                      Icons.person,
                      size: 70.0,
                    ),
                  ),
                ),
                new ListTile(
                    title: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
                          child: new Icon(
                            Icons.person,
                            size: 30.0,
                          ),
                        ),
                        new Text(
                          "Profile",
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
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
                            size: 28.0,
                          ),
                        ),
                        new Text(
                          "Like Us",
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ));
                    }),
                new Divider(),
                new ListTile(
                    title: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
                          child: new Icon(
                            Icons.supervisor_account,
                            size: 30.0,
                          ),
                        ),
                        new Text(
                          "class",
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ));
                    }),
                new Divider(),
                new ListTile(
                    title: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
                          child: new Icon(
                            Icons.phonelink_erase,
                            size: 30.0,
                          ),
                        ),
                        new Text(
                          "Log out",
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Colors.black,
                    ),
                    onTap: () async {
                      SharedPreferences log = await SharedPreferences.getInstance();
                      log.setBool("login", false);
                      FirebaseAuth.instance.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ));
                    }),
              ],
            ),
          ),
          body: new Container(
              child: new Padding(
                padding: EdgeInsets.only(left: 75, top: 50.0, right: 75.0, bottom: 5.0),
                child: Column(
                  children: <Widget>[
                    DropdownButton<String>(
                      items: cla.map((String listvalue) {
                        return DropdownMenuItem<String>(
                          value: listvalue,
                          child: Text(listvalue),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() => classs = val);
                      },
                      value: classs,
                    ),
                    DropdownButton<String>(
                      items: status.map((String listvalue) {
                        return DropdownMenuItem<String>(
                          value: listvalue,
                          child: Text(listvalue),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() => stat = val);
                      },
                      value: stat,
                    ),
                    new TextFormField(
                        controller: _controller,
                        focusNode: focusNode1,
                        enableSuggestions: true,
                        style: TextStyle(
                            fontFamily: 'BalooChettan2',
                            color: Colors.black54,
                            fontSize: 20.00),
                        decoration: new InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20.00, right: 20.00),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.00)),
                            labelText: "No. of lectures",
                            labelStyle: new TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontSize: 15.00)),
                        keyboardType: TextInputType.phone,
                        onChanged: (val) {
                          setState(() => lec = val);
                        }),
                    new Padding(padding: const EdgeInsets.only(top: 30.00)),
                    new TextFormField(
                        focusNode: focusNode2,
                        enableSuggestions: true,
                        style: TextStyle(
                            fontFamily: 'BalooChettan2',
                            color: Colors.black54,
                            fontSize: 20.00),
                        decoration: new InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20.00, right: 20.00),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.00)),
                            labelText: "Subject (intitials)",
                            labelStyle: new TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontSize: 15.00)),
                        keyboardType: TextInputType.text,
                        onChanged: (val) {
                          setState(() => sub = val);
                        }),
                    new Padding(padding: EdgeInsets.all(10.00)),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 50.0, right: 50, bottom: 10.0),
                      child: new RaisedButton(
                        color: Colors.green,
                        child: new Text("Passcode", textAlign: TextAlign.center),
                        shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.00)),
                        splashColor: Colors.blue,
                        onPressed: () async {
                          var rng = new Random();
                          code = code + rng.nextInt(20000);
                          var snapShot;
                          int z = 0;
                          Map map;
                          databaseReference
                              .child("Attendance")
                              .child("Class")
                              .child('TE1')
                              .child('WT')
                              .child('Pole')
                              .once()
                              .then((DataSnapshot snapshot) async {
                            map = snapshot.value;
                            await Future.delayed(Duration(seconds: 5));
                          });
                          //   await Future.delayed(Duration(seconds: 5));

                          setState(() {
                            if (classs == "Select Class" ||
                                sub =="" ||
                                stat == "Select Status" ||
                                lec == "") {
                              Fluttertoast.showToast(
                                  msg: "fill all fields",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              str = code.toString();
                              databaseReference
                                  .child("c_teacher").child(tinfo["Branch"])
                                  .child(classs)
                                  .child(stat)
                                  .child("passcode")
                                  .set(str);
                              databaseReference
                                  .child("c_teacher").child(tinfo["Branch"])
                                  .child(classs)
                                  .child("count")
                                  .set(lec);
                              databaseReference
                                  .child("c_teacher").child(tinfo["Branch"])
                                  .child(classs)
                                  .child(stat)
                                  .child("Subject")
                                  .set(sub);
                              databaseReference
                                  .child('c_teacher').child(tinfo["Branch"])
                                  .child(classs)
                                  .child(stat)
                                  .child('Teacher')
                                  .set(name.toString());
                              code = 1000;
                            }
                          });
                        },
                      ),
                    ),
                    new Padding(padding: EdgeInsets.all(10.00)),
                    Padding(
                        padding: const EdgeInsets.only(left: 50.0, right: 50),
                        child: new Text(
                          str,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              )),
        ));
  }
}

class stud extends StatefulWidget {
  @override
  _studState createState() => _studState();
}

class _studState extends State<stud> with SingleTickerProviderStateMixin {
  TabController controller;
  dynamic value, s, name;
  var s1;
  SharedPreferences prefs;

  Future<String> getname() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      s = prefs.getString("email");
      s1 = s.split('@');
      FirebaseDatabase.instance
          .reference()
          .child('Teacher_account')
          .child(s1[0].toString())
          .child('name')
          .once()
          .then((snap) {
        name = snap.value;
      });
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
    List<String> events = [
      "Take Attendance",
      "Modify Attendance",
    ];
    getname();
    return new Scaffold(
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(
                name.toString(),
                style: TextStyle(fontSize: 20.0),
              ),
              accountEmail:
              new Text(s.toString(), style: TextStyle(fontSize: 15.0)),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.black87,
                child: Icon(
                  Icons.person,
                  size: 70.0,
                ),
              ),
            ),
            new ListTile(
                title: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
                      child: new Icon(
                        Icons.person,
                        size: 30.0,
                      ),
                    ),
                    new Text(
                      "Profile",
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
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
                        size: 28.0,
                      ),
                    ),
                    new Text(
                      "Like Us",
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ));
                }),
            new Divider(),
            new ListTile(
                title: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
                      child: new Icon(
                        Icons.supervisor_account,
                        size: 30.0,
                      ),
                    ),
                    new Text(
                      "class and subject",
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  color: Colors.black,
                ),
                onTap: () {
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
                      padding: const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
                      child: new Icon(
                        Icons.phonelink_erase,
                        size: 30.0,
                      ),
                    ),
                    new Text(
                      "Log out",
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  color: Colors.black,
                ),
                onTap: () async {
                  SharedPreferences log = await SharedPreferences.getInstance();
                  log.setBool("login", false);
                  FirebaseAuth.instance.signOut();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                }),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          image: DecorationImage(
              alignment: Alignment.center,
              image: AssetImage("assets/dem.png"),
              fit: BoxFit.cover),
        ),
        child: Container(
          margin: const EdgeInsets.only(left: 50.0),
          width: 300,
          child: GridView(
            physics: BouncingScrollPhysics(),
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            children: events.map((title) {
              return GestureDetector(
                child: Card(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0)),
                  margin: const EdgeInsets.all(30.0),
                  child: getCardByTitle(title),
                ),
                onTap: () {
                  if (title == "Modify Attendance") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ));
                  } else {
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
        title: new Text("grid View"),
        backgroundColor: Colors.blue,
        bottom: TabBar(
          controller: controller,
          tabs: <Widget>[
            new Tab(icon: new Icon(Icons.face)),
          ],
        ),
      ),
    );
  }

  Column getCardByTitle(String title) {
    String img = '';
    if (title == "Modify Attendance")
      img = "assets/view.png";
    else if (title == "Take Attendance") img = "assets/mark.png";
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new Center(
          child: Container(
            child: new Stack(
              children: <Widget>[
                new Image.asset(
                  img,
                  width: 100.0,
                  height: 100.0,
                )
              ],
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
