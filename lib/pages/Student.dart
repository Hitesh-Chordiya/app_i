import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/View_attendance.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Student extends StatefulWidget {
  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> with SingleTickerProviderStateMixin {
  TabController controller;
  dynamic s="";
  var s1;
  Map info;
  dynamic name;
  FocusNode focusNode1 = new FocusNode();

  final dbref= FirebaseDatabase.instance.reference();
  @override
  @override
  void initState() {
    // TODO: implement initState
    controller = new TabController(length: 1, vsync: this);
    super.initState();
    dbref.child('Student').once().then((snap){
      info=snap.value;
    });
  }
  SharedPreferences prefs;
  Future<String> getname() async {


    prefs=await SharedPreferences.getInstance();
    setState(() {s=prefs.getString("email");
    s1=s.split('@');
    dbref.child('Student').child(s1[0].toString()).child('name').once().then((snap) {
      name=snap.value;
    });
    });
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
      "Mark Attendance",
      "View Attendance",
    ];
    getname();

    return new Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 50.0, right: 50.0,top: 50.0,bottom: 50.0),
        decoration: BoxDecoration(
          image: DecorationImage(
              alignment: Alignment.center,
              image: AssetImage("assets/dem.png"),
              fit: BoxFit.cover),
        ),
        child: Container(
          // margin: const EdgeInsets.only(left: 50.0),
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
                  margin: const EdgeInsets.all(20.0),
                  child: getCardByTitle(title),
                ),
                onTap: () {
                  if(title=="View Attendance") {
                    Navigator.push(
                        context, MaterialPageRoute(
                      builder: (context) => Home(),
                    )
                    );
                  }
                  else{

                    _displayDialog(context,info,s);

                  }
                  Fluttertoast.showToast(
                      msg: title,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white
                      ,
                      fontSize
                          :
                      16.0
                  );

                },
              );
            }).toList(),
          ),
        ),
      ),
      drawer: new Drawer(

        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(name.toString(), style: TextStyle(fontSize: 20.0),),
              accountEmail: new Text(s,style: TextStyle(fontSize: 15.0)),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.black87,
                child: Icon(Icons.person, size: 70.0,),
              ),
            ),
            new ListTile(
                title: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
                      child: new Icon(Icons.person, size: 30.0,),
                    ),
                    new Text("Profile", style: TextStyle(
                        fontSize: 17.0, fontWeight: FontWeight.bold),),

                  ],
                ),
                trailing: Icon(Icons.arrow_right, color: Colors.black,),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(
                    builder: (context) => Student(),

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
                      child: new Icon(Icons.thumb_up, size: 28.0,),
                    ),
                    new Text("Like Us", style: TextStyle(
                        fontSize: 17.0, fontWeight: FontWeight.bold),),
                  ],
                ),
                trailing: Icon(Icons.arrow_right, color: Colors.black,),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(
                    builder: (context) => Student(),

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
                      child: new Icon(Icons.supervisor_account, size: 30.0,),
                    ),
                    new Text("class", style: TextStyle(
                        fontSize: 17.0, fontWeight: FontWeight.bold),),

                  ],
                ),
                trailing: Icon(Icons.arrow_right, color: Colors.black,),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(
                    builder: (context) => Student(),

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
                      child: new Icon(Icons.phonelink_erase, size: 28.0,),
                    ),
                    new Text("Log out", style: TextStyle(
                        fontSize: 17.0, fontWeight: FontWeight.bold),),

                  ],
                ),
                trailing: Icon(Icons.arrow_right, color: Colors.black,),
                onTap:() async{
                  SharedPreferences prefs =await SharedPreferences.getInstance();
                  prefs.setBool('login', false);
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
        title: new Text("Attendance"),
        backgroundColor: Colors.blue,

      ),
    );
  }

  Column getCardByTitle(String title) {
    String img = '';
    if (title == "View Attendance")
      img = "assets/view.png";
    else if (title == "Mark Attendance") img = "assets/mark.png";
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
          style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

}
_displayDialog(BuildContext context,Map info,var s) async {
  TextEditingController _textFieldController = TextEditingController();
  //FocusNode focusNode1 = new FocusNode();
  final databaseReference = FirebaseDatabase.instance.reference();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('TextField AlertDemo'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "TextField in Dialog"),
          ),
          actions: <Widget>[
            new FlatButton(
                child: new Text('SUBMIT'),
                onPressed: () async {
                  print("in");
                  String s1;String s2;
                  var now = new DateTime.now();
                  String date=((now.day).toString()+"_"+ (now.month).toString()+"_"+ (now.year).toString()) ;
                  await Future.delayed(Duration(seconds: 2));
                  var ss=s.split('@');
                  for(final key in info.keys){
                    if(ss[0]==key.toString()){
                      Map emailid = info[key];
                      s1=emailid['Class'];
                      s2=emailid['Serial_no'];
                      break;
                    }
                  }
                  print("Step 1");
                  await Future.delayed(Duration(seconds: 2));
                  String status;
                  databaseReference.child('c_teacher').child(s1).child("status").once().then((snap){
                    status=snap.value;
                  });
                  Map data;
                  await Future.delayed(Duration(seconds: 5));
                  if(status=='lecture'){
                    databaseReference.child("c_teacher").child(s1).child(status).once().then((dynamic snap) {
                      data=snap.value;

                    });
                  }else{
                    databaseReference.child("c_teacher").child(s1).child(status).child('P_Batch').once().then((snap) {
                      data=snap.value;
                    });
                  }
                  print("Step 2");
                  await Future.delayed(Duration(seconds: 4));
                  Map exist;
                  databaseReference.child('Attendance').child('Class').child(s1).child(data['Subject']).
                  child(data['Teacher']).once().then((snap){
                    exist=snap.value;
                  });
                  SharedPreferences prefs=await SharedPreferences.getInstance();
                  String text;
                  int count=0;
                  print("Step3");
                  await Future.delayed(Duration(seconds: 4));
                  if (_textFieldController.text == data["passcode"].toString()){
                    //                    Navigator.push(
                    //                        context, MaterialPageRoute(
                    //                      builder: (context) => Signup(),
                    //                    )
                    //                    );
                    dynamic leccount=1;
                    print("object");
                    text=prefs.getString("text");
                    if(exist.containsKey(date) && (status=='lecture'||status=='Practical') ){

                      // await Future.delayed(Duration(seconds: 4));
                      if(!(text==_textFieldController.text)){
                        databaseReference.child('Attendance').child('Class').child(s1).child(data['Subject']).
                        child(data['Teacher']).child(date).child(status).child('leccount').once().then((snap) async {
                          leccount=snap.value;
                          await Future.delayed(Duration(seconds: 5));
                          leccount=leccount+1;
                          databaseReference.child('Attendance').child('Class').child(s1).child(data['Subject']).
                          child(data['Teacher']).child(date).child(status).child("leccount").set(leccount);
                          await Future.delayed(Duration(seconds: 4));
                          databaseReference.child('Attendance').child('Class').child(s1).child(data['Subject']).
                          child(data['Teacher']).child(date).child(status).child('$leccount').child(s2.toString()).set({
                            "Total":0,
                            "Attended":0,
                            "flag":1,
                          });
                          print("if");

                        });
                      }
                    }else{
                      databaseReference.child('Attendance').child('Class').child(s1).child(data['Subject']).
                      child(data['Teacher']).child(date).child(status).child(leccount.toString()).child(s2.toString()).set({
                        "Total":0,
                        "Attended":0,
                        "flag":1,
                      });
                      print("else");
                      databaseReference.child('Attendance').child('Class').child(s1).child(data['Subject']).
                      child(data['Teacher']).child(date).child(status).child("leccount").set(leccount);
                    }

                    databaseReference.child('c_teacher').child(s1).child('count').once().then((snap){
                      count=snap.value;
                    });

                    await Future.delayed(Duration(seconds: 4));
                    final variable1=databaseReference.child('Attendance').child('Class').child(s1).child(data['Subject']).
                    child(data['Teacher']).child(date).child(status).child('$leccount').child(s2.toString());
                    variable1.once().then((dynamic snap) async {
                      Map data1=snap.value;
                      await Future.delayed(Duration(seconds: 5));
                      int att=data1["Attended"];
                      int flag=data1["flag"];
                      print(att);
                      await Future.delayed(Duration(seconds: 5));
                      if(flag==1){
                        att=att+count;
                        print(count);
                        variable1.child('Attended').set(att);
                        print("done");
                        variable1.child('flag').set(0);
                        print(_textFieldController.text);

                        prefs.setString("text", _textFieldController.text);

                      }
                      else{
                        Fluttertoast.showToast(
                            msg: "Attendance marked already",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize:16.0

                        );

                      }
                    });
                  }
                  else {
                    Navigator.push(
                        context, MaterialPageRoute(
                      builder: (context) => Student(),
                    )
                    );
                  }
//
                }
            ),
            new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
