import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/AttendanceData.dart';
//import 'package:flutter_app/pages/View_attendance.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/responsive/Screensize.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/widgets.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

fun(BuildContext context) async {
  bool val=false,pressed=false;
  final formKey = new GlobalKey<FormState>();
  String disp="";
  FocusNode focusNode1 = new FocusNode();
  TextEditingController _controller = TextEditingController();
  return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;
        return StatefulBuilder(
          // transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            builder: (context, setState) {
              return Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  title: Column(
                    children: <Widget>[
                      new Icon(Icons.email,color: HexColor.fromHex("#800000"),size: 4.2*SizeConfig.heightMultiplier,),
                      Text('Enter registered email',textAlign: TextAlign.center,style: TextStyle(color:HexColor.fromHex("#00004d"),),
                      )],
                  ),
                  content: Container(
                    height: 10*SizeConfig.heightMultiplier,
                    child: Column(
                      children: <Widget>[
                        //    new Padding(padding: EdgeInsets.only(top:5)),
                        new Form(
                          autovalidate: val,
                          key: formKey,
                          child: TextFormField(
                            controller: _controller,
                            cursorColor: HexColor.fromHex("#00004d"),
                            focusNode: focusNode1,
                            style: TextStyle(
                                fontFamily: 'BalooChettan2',
                                fontWeight: FontWeight.bold,
                                color: HexColor.fromHex("00004d"),
                                fontSize: 2.4*SizeConfig.textMultiplier),
                            decoration: new InputDecoration(
                                errorStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 4*SizeConfig.widthMultiplier
                                ),
                                contentPadding: EdgeInsets.only(left: 20.00, right: 20.00),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1,color: HexColor.fromHex("#00004d")),
                                    borderRadius: BorderRadius.circular(10.00)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1,color: HexColor.fromHex("#800000")),
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelText: "Enter here",
                                labelStyle: TextStyle(color: HexColor.fromHex("#800000"),fontWeight: FontWeight.bold,fontSize: 2.3*SizeConfig.textMultiplier)),
                            keyboardType: TextInputType.emailAddress,
                            validator: validateEmail,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                        child: new Text(
                          'send email',
                          style: TextStyle(color: HexColor.fromHex("#00004d"),fontWeight: FontWeight.bold,fontSize: 2.3*SizeConfig.textMultiplier),
                        ),
                        onPressed:pressed==false? () async {
                          if (_controller.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Invalid  email",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);

                          }else{
                            if(formKey.currentState.validate()){
                              resetPassword(_controller.text.toLowerCase());
                              setState(() {
                                disp="email sent";
                              });
                              Fluttertoast.showToast(
                                  msg: "Check mail inbox",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }else{
                              val=true;
                            }
                            setState((){
                              pressed=true;
                            });
                          }
                        }:null),
                    new FlatButton(
                      child: new Text(
                        'cancel',
                        style: TextStyle(color: HexColor.fromHex("00004d"),fontWeight: FontWeight.bold,fontSize: 2.3*SizeConfig.textMultiplier),
                      ),
                      onPressed: pressed==false?() {
                        Navigator.of(context).pop();
                        setState((){
                          pressed=true;
                        });
                      }:null,
                    )
                  ],
                ),
              );
            }

        );
      },
      transitionDuration: Duration(milliseconds: 1000),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {});
}
// This widget will be passed as Top Card's Widget.
String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (value.isEmpty || !regex.hasMatch(value)||value.length<9)
    return '*Invalid Email';
  else
    return null;
}


Future<void> update(String email) async {
  final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  user.updateEmail(email);
}

@override
Future<void> resetPassword(String email) async {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}


String validate(String value) {
  if(value.isEmpty)
    return "please! update the field";
  else
    return null;
}

class profilestud extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<profilestud>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  final TextEditingController _depcontroller = TextEditingController();
  String dep=Studinfo.branch;
  final TextEditingController _namecontroller = new TextEditingController();
  String name = Studinfo.name;
  final TextEditingController _mailcontroller = new TextEditingController();
  String email =Studinfo.email;
  final TextEditingController _prncontroller = new TextEditingController();
  String prn =Studinfo.roll;
  final TextEditingController _batchcontroller = new TextEditingController();
  String batch =Studinfo.batch;
  final TextEditingController _classcontroller = new TextEditingController();
  String classs =Studinfo.classs;

  @override
  void initState() {
    // TODO: implement initState
    _namecontroller.text=name;
    _mailcontroller.text=email;
    _depcontroller.text=dep;
    _prncontroller.text=prn;
    _classcontroller.text=classs;
    _batchcontroller.text=batch;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int grp=SizeConfig.grp;
    Color top=Color(0xff6d6d46);
    Color bottom=Color(0xff800000);
    return new Scaffold(
        body: new Container(
          color: Colors.grey.shade500,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(

                    height: 27*SizeConfig.heightMultiplier,
                    // decoration:BoxDecoration(

//                        gradient:LinearGradient(
//                            begin: Alignment.topRight,
//                            end: Alignment.bottomLeft,
//                            colors: [
//                              HexColor.fromHex("#000046"),
//                              HexColor.fromHex("#1CB5E0")
//                            ])
                    //),
                    decoration: new BoxDecoration(
                      image: DecorationImage(
                        image: new AssetImage("assets/profile.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: new BorderRadius.circular(0.00),
                    ),
                    child: new Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 5*SizeConfig.widthMultiplier, top: 2.2*SizeConfig.heightMultiplier),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new InkWell(
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 3*SizeConfig.heightMultiplier,
                                  ),
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4*SizeConfig.widthMultiplier),
                                  child: new Text('Profile',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 2.7*SizeConfig.heightMultiplier,
                                          color: Colors.white)),
                                )
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 4*SizeConfig.heightMultiplier),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 5.3*SizeConfig.heightMultiplier,
                            child: new Icon(
                              Icons.person,
                              color: Colors.black87,
                              size: 9.4*SizeConfig.heightMultiplier,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  new Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin:  Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white,
                              HexColor.fromHex("#999999")
                              ,
                            ]
                        )
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 3.5*SizeConfig.heightMultiplier),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: grp<=4 ?EdgeInsets.only(
                                  left: 8*SizeConfig.widthMultiplier, right: 8*SizeConfig.widthMultiplier, top: 1*SizeConfig.heightMultiplier):
                              EdgeInsets.only(
                                  left: 8*SizeConfig.widthMultiplier, right: 8*SizeConfig.widthMultiplier, top: 2.4*SizeConfig.heightMultiplier)
                              ,
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        '          Personal Information',
                                        style: TextStyle(
                                            color: top,
                                            fontSize: 3*SizeConfig.heightMultiplier,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
//                                  new Column(
//                                    mainAxisAlignment: MainAxisAlignment.end,
//                                    mainAxisSize: MainAxisSize.min,
//                                    children: <Widget>[
//                                      _status ? _getEditIcon() : new Container(),
//                                    ],
//                                  )
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 7*SizeConfig.widthMultiplier, right: 7*SizeConfig.widthMultiplier, top: 3.5*SizeConfig.heightMultiplier),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Email ID',
                                        style: TextStyle(
                                            color:top,
                                            fontSize: 2.2*SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 7*SizeConfig.widthMultiplier, right: 7*SizeConfig.widthMultiplier, top: grp<=4?0.20*SizeConfig.heightMultiplier:0.25*SizeConfig.heightMultiplier),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(

                                      decoration: const InputDecoration(
                                          hintText: "Enter Email ID",
                                          hintStyle: TextStyle(color: Color(0xff800000)),
                                          labelStyle: TextStyle(color: Color(0xff800000))

                                      ),
                                      controller: _mailcontroller,
                                      enabled: false,
                                      onChanged: (val){
                                        email=val;
                                      },
                                    ),
                                  ),
                                ],
                              )),

                          Padding(
                              padding: EdgeInsets.only(
                                  left:7*SizeConfig.widthMultiplier , right: 7*SizeConfig.widthMultiplier, top: grp<=4?2.4*SizeConfig.heightMultiplier:3.5*SizeConfig.heightMultiplier),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Name',
                                        style: TextStyle(
                                            color: top,
                                            fontSize: 2.2*SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 7*SizeConfig.widthMultiplier, right: 7*SizeConfig.widthMultiplier, top: grp<=4?0.20*SizeConfig.heightMultiplier:0.25*SizeConfig.heightMultiplier),
                              child: new Row(
                                // mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                        hintText: "Enter your name",
                                      ),
                                      autofocus:true,
                                      focusNode: myFocusNode,
                                      controller: _namecontroller,
                                      enabled: !_status,
                                      onChanged: (text){
                                        setState(() {
                                          name=text;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 7*SizeConfig.widthMultiplier, right: 7*SizeConfig.widthMultiplier, top: grp<=4?2.4*SizeConfig.heightMultiplier:3.5*SizeConfig.heightMultiplier),
                              child: new Row(
                                //  mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'PRN',
                                        style: TextStyle(
                                            color: top,
                                            fontSize: 2.28*SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 7*SizeConfig.widthMultiplier, right: 7*SizeConfig.widthMultiplier, top: grp<=4?0.20*SizeConfig.heightMultiplier:0.25*SizeConfig.heightMultiplier),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: "Enter PRN"),
                                      enabled: false,
                                      controller: _prncontroller,
                                      onChanged: (val){
                                        prn=val;
                                      },
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 7*SizeConfig.widthMultiplier, right: 7*SizeConfig.widthMultiplier,top: grp<=4?2.4*SizeConfig.heightMultiplier:3.5*SizeConfig.heightMultiplier),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Branch',
                                        style: TextStyle(
                                            color: top,
                                            fontSize: 2.2*SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 7*SizeConfig.widthMultiplier, right: 7*SizeConfig.widthMultiplier, top:grp<=4?0.20*SizeConfig.heightMultiplier:0.25*SizeConfig.heightMultiplier),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: "Enter PRN"),
                                      enabled: !_status,
                                      controller: _depcontroller,
                                      onChanged: (val){
                                        dep=val;
                                      },
                                    ),
                                  ),
                                ],
                              )),

                          Padding(
                              padding: EdgeInsets.only(
                                  left:7*SizeConfig.widthMultiplier , right: 7*SizeConfig.widthMultiplier, top: grp<=4?2.4*SizeConfig.heightMultiplier:3.5*SizeConfig.heightMultiplier),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'Class',
                                        style: TextStyle(
                                            color: top,

                                            fontSize: 2.2*SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'Batch',
                                        style: TextStyle(
                                            color: top,

                                            fontSize: 2.2*SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 7*SizeConfig.widthMultiplier, right: 7*SizeConfig.widthMultiplier, top: grp<=4?0.20*SizeConfig.heightMultiplier:0.25*SizeConfig.heightMultiplier),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 2.8*SizeConfig.widthMultiplier),
                                      child: new TextField(
                                        decoration: const InputDecoration(
                                            hintText: "Enter Class"),
                                        enabled: !_status,
                                        controller: _classcontroller,
                                        onChanged: (val){
                                          classs=val;
                                        },
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: "Enter Batch"),
                                      enabled: !_status,
                                      controller: _batchcontroller,
                                      onChanged: (val){
                                        batch=val;
                                      },
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }


}
class teachprofile extends StatefulWidget {
  @override
  _teachprofileState createState() => _teachprofileState();


}

class _teachprofileState extends State<teachprofile> {
  final FocusNode myFocusNode = FocusNode();
  final TextEditingController _depcontroller = TextEditingController();
  String dep = Studinfo.branch;
  final TextEditingController _namecontroller = new TextEditingController();
  String name = Dateinfo.teachname;
  final TextEditingController _mailcontroller = new TextEditingController();
  String email = Dateinfo.teachemail;
  SharedPreferences prefs;
  bool _status = true;
  int l=1;
  List<String> cl=["nothing to show here"];
  Future<void> getprefs() async {
    prefs=await SharedPreferences.getInstance();
    try {
      cl.clear();
      cl.addAll(prefs.getStringList("scount"));
      setState(() {
        l = cl.length;
      });
    }catch(Ex){print("jj");}
  }
  void initState() {
    // TODO: implement initState
    _namecontroller.text = name;
    _mailcontroller.text = email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getprefs();
    return new Scaffold(
        body: new Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    height: 35 * SizeConfig.heightMultiplier,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: new AssetImage("assets/card1.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: new BorderRadius.circular(10.00),
                    ),
                    child: new Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                left: 5 * SizeConfig.widthMultiplier,
                                top: 2.2 * SizeConfig.heightMultiplier),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new InkWell(
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black87,
                                    size: 2.5 * SizeConfig.heightMultiplier,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 4 * SizeConfig.widthMultiplier),
                                  child: new Text('Profile',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 2.7 *
                                              SizeConfig.heightMultiplier,
                                          color: Colors.black87)),
                                ),
                                new Spacer(),
                                CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: PopupMenuButton<String>(
                                    onSelected: handleClick,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(20.0)),
                                    color: Colors.black,
                                    itemBuilder: (BuildContext context) {
                                      return {'Rate us', 'Logout'}
                                          .map((String choice) {
                                        return PopupMenuItem<String>(
                                          value: choice,
                                          child: Text(choice,style: TextStyle(color: Colors.white),),
                                        );
                                      }).toList();
                                    },
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.5 * SizeConfig.heightMultiplier),
                          child: new Stack(
                              fit: StackFit.loose, children: <Widget>[
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new CircleAvatar(
                                    radius: 5.5 * SizeConfig.heightMultiplier,
                                    backgroundColor: Colors.black87,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black87,
                                      radius: 5 * SizeConfig.heightMultiplier,
                                      child: new Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 10 *
                                            SizeConfig.heightMultiplier,
                                      ),
                                    )
                                )
                              ],
                            ),
                          ]),
                        )
                      ],
                    ),
                  ),
                  new Container(
                    decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide( //                    <--- top side
                            color: Colors.black,
                            width: 5.0,
                          ),
                        ),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,

                            colors: [
                              HexColor.fromHex("#ffffff"),
                              HexColor.fromHex("#ee9ca7")
                            ])
                    ),

                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 3.5 * SizeConfig.heightMultiplier),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 8 * SizeConfig.widthMultiplier,
                                  right: 8 * SizeConfig.widthMultiplier,
                                  top: 2.5 * SizeConfig.heightMultiplier),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Personal Information',
                                        style: TextStyle(
                                            fontSize: 2.5 *
                                                SizeConfig.heightMultiplier,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 7 * SizeConfig.widthMultiplier,
                                  right: 7 * SizeConfig.widthMultiplier,
                                  top: 3.5 * SizeConfig.heightMultiplier),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Email ID',
                                        style: TextStyle(
                                            fontSize: 2.2 *
                                                SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 7 * SizeConfig.widthMultiplier,
                                  right: 7 * SizeConfig.widthMultiplier,
                                  top: 0.25 * SizeConfig.heightMultiplier),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: "Enter Email ID"),
                                      controller: _mailcontroller,
                                      enabled: false,
                                      onChanged: (val) {
                                        email = val;
                                      },
                                    ),
                                  ),
                                ],
                              )),

                          Padding(
                              padding: EdgeInsets.only(
                                  left: 7 * SizeConfig.widthMultiplier,
                                  right: 7 * SizeConfig.widthMultiplier,
                                  top: 3.5 * SizeConfig.heightMultiplier),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Name',
                                        style: TextStyle(
                                            fontSize: 2.2 *
                                                SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 7 * SizeConfig.widthMultiplier,
                                  right: 7 * SizeConfig.widthMultiplier,
                                  top: 0.28 * SizeConfig.heightMultiplier),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                        hintText: "Enter your name",

                                      ),
                                      controller: _namecontroller,
                                      enabled: !_status,
                                      autofocus: !_status,
                                      onChanged: (text) {
                                        setState(() {
                                          name = text;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(left: 5 *
                                  SizeConfig.widthMultiplier, top: 5 *
                                  SizeConfig.heightMultiplier),
                              child: Container(
                                child: new Swiper(

                                    layout: SwiperLayout.TINDER,
                                    customLayoutOption: new CustomLayoutOption(
                                        startIndex: 0,
                                        stateCount: 3
                                    ).addRotate([
                                      -45.0 / 180,
                                      0.0,
                                      45.0 / 180
                                    ]),
                                    itemWidth: 60 * SizeConfig.widthMultiplier,
                                    itemHeight: 25 *
                                        SizeConfig.heightMultiplier,
                                    itemBuilder: (context, index) {
                                      return new Container(
                                        decoration: BoxDecoration(
                                          color:HexColor.fromHex("#ffffff"),
                                          border: Border.all(
                                              color: HexColor.fromHex("#4d0000")
                                              ,width: 3
                                          ),
                                          borderRadius: new BorderRadius
                                              .circular(30.0),
                                        ),
                                        child:cl.length==0?Center(child: new Text("Nothing to show here",style: TextStyle(fontSize: 2.8*SizeConfig.textMultiplier,color: Colors.black87),)):
                                        new Center(
                                          child: Column(
                                            children: <Widget>[
                                              new Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 6.0 * SizeConfig
                                                          .heightMultiplier)),
                                              swipe(index)
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: l),
                              )
                          )

                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],

          ),
        ));
  }

  Widget swipe(index) {
    var a=cl[index].split("_");
    if(a.length==3){
      var b=prefs.getString(cl[index].toString()).split(" ");
      return new Text(
        "Class: " + a[0].toString()+"\nSubject: "+a[1].toString()+"\nBatch: "+a[2].toString() + "\nTotal Practicals: " + b[0].toString(),
        style: TextStyle(fontSize: 2.9*SizeConfig.textMultiplier, fontWeight: FontWeight.bold,color: Colors.black87),);

    }else if(a.length==2){
      var b= prefs.getString(cl[index].toString()).split(" ");
      return new Text(
        "Class: " + a[0].toString()+"\nSubject: "+a[1].toString() + "\nTotal lectures: " +b[0].toString(),
        style: TextStyle(fontSize: 2.9*SizeConfig.textMultiplier, fontWeight: FontWeight.bold,color: Colors.black87),);

    }else{
      var b=prefs.getString(cl[index].toString()).split(" ");
      return new Text(
        "Class: " + a[0].toString()+"\nSubject: "+a[1].toString()+"\nBatch: "+a[2].toString() + "\nTotal Tutorials: " + b[0].toString(),
        style: TextStyle(fontSize: 2.9*SizeConfig.textMultiplier, fontWeight: FontWeight.bold,color: Colors.black87),);

    }


  }
  Future<void> handleClick(String value) async {
    switch (value) {
      case 'Logout':
        {
          SharedPreferences log = await SharedPreferences.getInstance();
          FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ));
          log.setBool("login", false);
          break;
        }
      case "Rate us":
        {
          Alert1 alert = new Alert1();
          alert.displayDialog(context);
        }
    }
  }
}