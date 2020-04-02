//import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
class Date extends StatefulWidget {
  @override
  _DateState createState() => _DateState();
}

class _DateState extends State<Date> {
  List<String> _list = ["11_02_2020","12_09_2020","24_01_2020"];
  String classs='Select Class',sub="subject",_subject="subject";
  var cla=['Select Class','FE1','FE2','FESS','SE1','SE2','SESS','TE1','TE2','TESS','BE1','BE2','BESS'];
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:new Scaffold(
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top:20,bottom: 20),
                child: new Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Flexible(child:
                      Padding(
                        padding: const EdgeInsets.only(left: 30,),
                        child: DropdownButton<String>(
                          items: cla.map((String listvalue) {
                            return DropdownMenuItem<String>(
                              value: listvalue,
                              child: Text(listvalue),
                            );
                          }).toList(),
                          onChanged: (val){
                            setState(() =>classs=val);
                          },
                          value: classs,
                        ),
                      ),),
                      new Flexible(child:
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: new TextFormField(
                            controller: _controller,
                            // focusNode: focusNode5,
                            enableSuggestions: true,
                            style: TextStyle(
                                fontFamily: 'BalooChettan2',
                                color: Colors.black54,
                                fontSize: 20.00),
                            decoration: new InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 20.00, right: 20.00),
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        10.00)),
                                labelText: sub,
                                labelStyle: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    fontSize: 15.00)),
                            keyboardType: TextInputType.text,

                            onChanged: (val) {
                              setState(() => _subject = val);
                            }),
                      ),),
                    ]),
              ),
              new Expanded(child:GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                childAspectRatio: 3,
                children: _list.map((value) {
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.grey.shade500,border: Border.all(color: Colors.black),borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        bottomRight: Radius.circular(25.0)
                    ) ),
                    child: Text("${value}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                  );
                }).toList(),
              )),

            ],
          ),
          appBar: new AppBar(
            title: new Text("grid View"),
            backgroundColor: Colors.blue,
          ),
        )
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic value,s,name;
  var s1;
  SharedPreferences prefs;
  bool mark;
  final dbref=FirebaseDatabase.instance.reference();
  Future<String> getname() async {
    prefs=await SharedPreferences.getInstance();
    setState(() {s=prefs.getString("email");
    s1=s.split('@');
    dbref.child('Teacher_account').child(s1[0].toString()).child('name').once().then((snap) {
      name=snap.value;
    });
    });
    String email=s.toString();
  }

  void modattendance(String roll) async {
    final dbref = FirebaseDatabase.instance.reference();
    dynamic name;
    var email1 = s.toString().split('@');
    dbref.child('Teacher_account').child(email1[0]).child('name').once().then((
        snap) async {name = snap.value;
    String email = s.toString();
    await Future.delayed(Duration(seconds: 3));
    dbref.child('Attendance').child('Class').child('TE1').child('DAA').child(name).child(roll).child('Attended').once().then((snap) async {
      String att=snap.value.toString();
      await Future.delayed(Duration(seconds: 3));
      if(mark==true){
        dbref.child('Attendance').child('Class').child('TE1').child('DAA').child(name).child(roll).child('Attended').set( int.parse(att)+1);
      }
      else{
        dbref.child('Attendance').child('Class').child('TE1').child('DAA').child(name).child(roll).child('Attended').set( int.parse(att)-1);

      }
    });
    });
  }
  @override
  Widget build(BuildContext context) {
    getname();
    Color _color = Colors.grey;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Homepage"),
        elevation: defaultTargetPlatform == TargetPlatform.android?5.0:0.0,
      ),
      body: ListView.builder(
        itemCount: 70,
        itemBuilder: (context, position) {
          return Container(
            height: 70,
            child: Card(
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: <Widget>[
                      Text((position+1).toString(), style: TextStyle(fontSize: 22.0),),
                      Padding(
                        padding: const EdgeInsets.only(left: 175),
                        child: Container(
                          width: 60,
                          child: new RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(100.00)),
                              splashColor: Colors.blue,
                              onPressed: () async {
                                mark=false;
                                modattendance((position+1).toString());
                              },
                              elevation: 2.0,
                              color: Colors.red,
                              textColor: Colors.black,
                              child: new Text("-1",
                                  textAlign: TextAlign.center)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:20),
                        child: Container(
                          width: 60,
                          child: new RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(100.00)),
                              splashColor: Colors.blue,
                              onPressed: () async {
                                mark=true;
                                modattendance((position+1).toString());
                              },
                              elevation: 2.0,
                              color: Colors.green,
                              textColor: Colors.black,
                              child: new Text("+1",
                                  textAlign: TextAlign.center)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      drawer: new Drawer(

        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(accountName: new Text(name.toString(),style: TextStyle(fontSize: 20.0),),
              accountEmail: new Text(s.toString(),style: TextStyle(fontSize: 15.0)),
              currentAccountPicture:new CircleAvatar(
                backgroundColor: Colors.black87,
                child: Icon(Icons.person,size: 70.0,),
              ),
            ),
            new ListTile(
                title: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
                      child: new Icon(Icons.person,size: 30.0,),
                    ),
                    new Text("Profile",style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),),

                  ],
                ),
                trailing: Icon(Icons.arrow_right,color: Colors.black,),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(
                    builder: (context) => HomePage(),

                  )
                  );
                }
            ),
            new Divider(),
            new ListTile(
                title: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
                      child: new Icon(Icons.thumb_up,size: 28.0,),
                    ),
                    new Text("Like Us",style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),),

                  ],
                ),
                trailing: Icon(Icons.arrow_right,color: Colors.black,),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(
                    builder: (context) => HomePage(),

                  )
                  );
                }
            ),
            new Divider(),
            new ListTile(
                title: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
                      child: new Icon(Icons.supervisor_account,size: 30.0,),
                    ),
                    new Text("class",style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),),

                  ],
                ),
                trailing: Icon(Icons.arrow_right,color: Colors.black,),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(
                    builder: (context) => HomePage(),

                  )
                  );
                }
            ),
            new Divider(),
            new ListTile(
                title: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
                      child: new Icon(Icons.phonelink_erase, size: 30.0,),
                    ),
                    new Text("Log out", style: TextStyle(
                        fontSize: 17.0, fontWeight: FontWeight.bold),),

                  ],
                ),
                trailing: Icon(Icons.arrow_right, color: Colors.black,),
                onTap: () async{
                  SharedPreferences log=await SharedPreferences.getInstance();
                  log.setBool("login", false);
                  FirebaseAuth.instance.signOut();
                  Navigator.push(
                      context, MaterialPageRoute(
                    builder: (context) => LoginPage(),

                  )
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
