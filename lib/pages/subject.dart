import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';
import 'login_page.dart';

class subject extends StatefulWidget {
  @override
  _subjectState createState() => _subjectState();
}

class _subjectState extends State<subject> {
  dynamic value,s,name;
  var s1;

  String Dep="Select Branch",_subject,sub="Subject";
  SharedPreferences prefs;
  FocusNode focusNode = new FocusNode();
  TextEditingController _controller = TextEditingController();
  bool mark; String classs='Select Class';
  var cla=['Select Class','FE1','FE2','FESS','SE1','SE2','SESS','TE1','TE2','TESS','BE1','BE2','BESS'];
  var branch=["Select Branch","FE","Computer","ENTC","Mechanical"];
  final dbref=FirebaseDatabase.instance.reference();
  Future<String> getname() async {
    prefs=await SharedPreferences.getInstance();
    setState(() {  s=prefs.getString("email");
    s1=s.split('@');
    dbref.child('Teacher_account').child(s1[0].toString()).child('name').once().then((snap) {
      name=snap.value;
    });
    });
    await Future.delayed(Duration(seconds: 3));
    String email=s.toString();
  }
  @override
  Widget build(BuildContext context) {
    getname();
    return MaterialApp(
        home:new Scaffold(
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
                    title: Container(
                      color: Colors.grey.shade500,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
                            child: new Icon(Icons.supervisor_account,size: 30.0,),
                          ),
                          new Text("class",style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),),

                        ],
                      ),
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
          appBar: new AppBar(
            title: new Text("Homepage"),
            elevation: defaultTargetPlatform == TargetPlatform.android?5.0:0.0,
          ),
          body: new Container(

            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20,top:40,right: 30.0,bottom:0.0),
                  child: Container(child: Text("Enter Class and Suject,initials only!!!",style: TextStyle(fontSize: 25),)),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 180,top: 40),
                  child: DropdownButton<String>(
                    items: branch.map((String listvalue) {
                      return DropdownMenuItem<String>(
                        value: listvalue,
                        child: Text(listvalue),
                      );
                    }).toList(),
                    onChanged: (val){
                      setState(() =>Dep=val);
                    },
                    value: Dep,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50,top:30,right:30.0,bottom: 0.0),
                  child: new  Column(
                    children: <Widget>[
                      new Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Flexible(child:
                            DropdownButton<String>(
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
                            ),),
                            new Flexible(child:
                            new TextFormField(
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
                                }),),
                          ])
                    ],
                  ),

                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50,top:70,right:30.0,bottom: 0.0),
                  child: Container(
                    width: 100,
                    child: new RaisedButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10.00)),
                        splashColor: Colors.blue,
                        onPressed: () async {

                          setState(() {
                            print(name);
                            dbref.child("Attendance").child(Dep).child(classs).child(_controller.text).child(name).child("total").set(1);
                            //      _controller.clear();
//                            classs="Select Class";
                          //  _controller.clear();
                          }
                          );
                        },
                        elevation: 2.0,
                        color: Colors.green.shade500,
                        textColor: Colors.black,
                        child: new Text("Add",
                            textAlign: TextAlign.center)),
                  ),
                ),
              ],
            ),

          ),
        )
    );
  }
}
