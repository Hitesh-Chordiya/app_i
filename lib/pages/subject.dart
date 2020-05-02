import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/AttendanceData.dart';
import 'package:flutter_app/responsive/Screensize.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'View_attendance.dart';
import 'forgotpassword.dart';
import 'homepage.dart';
import 'login_page.dart';

class subject extends StatefulWidget {
  @override
  _subjectState createState() => _subjectState();
}

class _subjectState extends State<subject> {
  dynamic value;
  var s1;
  int group;
  double lefttextsize=2.7 * SizeConfig.textMultiplier;
  Color lefttextclr=Color(0xff00004d);
  static const Color radioactivecolor=Color(0xff996600);

  String Dep = "Select Branch", _subject, sub = "Subject";
  FocusNode focusNode = new FocusNode();
  TextEditingController _controller = TextEditingController();
  bool mark;
  String classs = 'Select Class', status = "Select Status";
  List<String> lectlist;
  var classlist = [
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
  void get() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    lectlist=prefs.getStringList("list");

  }
  var stat = ["Select Status", "lecture", "Practical"];
  final dbref = FirebaseDatabase.instance.reference();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: new Scaffold(
          resizeToAvoidBottomInset: false,
          //resizeToAvoidBottomPadding: true,
          appBar: new AppBar(
           leading: IconButton(
             icon: Icon(
               Icons.arrow_back_ios,
               color: Colors.white,
             ),
            onPressed: (){
               Navigator.pop(context);
            },
           ),
            title: new Text("Homepage\\Subject reg."),
            backgroundColor: Color(0xff6d6d46),
            elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
          ),
          body: new Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    HexColor.fromHex("#000000"),
                    HexColor.fromHex("#000000"),
                    //HexColor.fromHex("#BA8B02")

                  ]),
            ),



                child:Padding(

                  padding:EdgeInsets.symmetric(vertical: 5*SizeConfig.heightMultiplier,horizontal: 5*SizeConfig.widthMultiplier),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                          color: Color(0xffDAD299),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                          Expanded(
                            child: Marquee(

                              text:"  Register your subject here "
                                  ,style: TextStyle(
                              fontSize: 20
                            ),
                            ),
                          ),
                            Padding(
                              padding:  EdgeInsets.only(bottom:8*SizeConfig.heightMultiplier,left: 10*SizeConfig.widthMultiplier),
                              child: Row(
                                children: <Widget>[
                                  new Radio(
                                    activeColor:radioactivecolor,
                                    value: 0,
                                    groupValue: group,
                                    onChanged:  _handleRadioValueChange1,
                                  ),
                                  new Text(
                                    'Theory' ,
                                    style: TextStyle(
                                        fontSize: lefttextsize,
                                        color: lefttextclr,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  new Radio(
                                    activeColor:radioactivecolor,
                                    value: 1,
                                    groupValue: group,
                                    onChanged:  _handleRadioValueChange1,
                                  ),
                                  new Text(
                                    'Practical',
                                    style: TextStyle(
                                        fontSize: lefttextsize,
                                        color:lefttextclr,
                                        fontWeight: FontWeight.bold),
                                  ),

                                ],
                              ),
                            ),

                            // new Padding(padding: EdgeInsets.only(left: 10)),


//                Padding(
//                  padding: EdgeInsets.only(
//                      top: 3.5 * SizeConfig.heightMultiplier,
//                      left: 7 * SizeConfig.widthMultiplier),
//                  child: Row(
//                    children: <Widget>[
//                      Text(
//                        "Status:",
//                        style: TextStyle(
//                            fontSize: 2.7 * SizeConfig.textMultiplier,
//                            color: HexColor.fromHex("#00004d"),
//                            fontWeight: FontWeight.bold),
//                      ),
//                      new Padding(
//                          padding: EdgeInsets.only(
//                              left: 6 * SizeConfig.widthMultiplier)),
//                      Container(
//                        height: 4.9 * SizeConfig.heightMultiplier,
//                        padding: EdgeInsets.symmetric(
//                            horizontal: 3.1 * SizeConfig.widthMultiplier,
//                            vertical: 0.7 * SizeConfig.heightMultiplier),
//                        decoration: BoxDecoration(
//                            color: Colors.white,
//                            borderRadius: BorderRadius.circular(8)),
//                        child: DropdownButton<String>(
//                          // itemHeight: 5.0,
//                          //hint: new Text("Select City"),
//                          items: stat.map((String listvalue) {
//                            return DropdownMenuItem<String>(
//                              value: listvalue,
//                              child: Text(
//                                listvalue,
//                                style: TextStyle(
//                                    fontSize: 2.4 * SizeConfig.textMultiplier,
//                                    fontWeight: FontWeight.bold),
//                              ),
//                            );
//                          }).toList(),
//                          onChanged: (val) {
//                            setState(() => status = val);
//                          },
//                          value: status,
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 10 * SizeConfig.heightMultiplier,
                              left: 7 * SizeConfig.widthMultiplier),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Select Class:",
                                style: TextStyle(
                                    fontSize: 2.7 * SizeConfig.textMultiplier,
                                    color: lefttextclr,
                                    fontWeight: FontWeight.bold),
                              ),
                              new Padding(
                                  padding: EdgeInsets.only(
                                      left: 6 * SizeConfig.widthMultiplier)),
                              Container(
                                height: 4.9 * SizeConfig.heightMultiplier,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.1 * SizeConfig.widthMultiplier,
                                    vertical: 0.7 * SizeConfig.heightMultiplier),
                                decoration: BoxDecoration(
                                  border: Border.all(color: lefttextclr),
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(10)),
                                child: DropdownButton<String>(
                                  iconEnabledColor: lefttextclr,
                                  //underline: ,
                                  items: classlist.map((String listvalue) {
                                    return DropdownMenuItem<String>(
                                      value: listvalue,
                                      child: Text(
                                        listvalue,
                                        style: TextStyle(
                                          color:lefttextclr,
                                            fontSize: 2.4 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() => classs = val);
                                  },
                                  value: classs,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 5 * SizeConfig.heightMultiplier,
                              left: 7 * SizeConfig.widthMultiplier),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Enter Subject:",
                                style: TextStyle(
                                    fontSize: 2.7 * SizeConfig.textMultiplier,
                                    color: lefttextclr,
                                    fontWeight: FontWeight.bold),
                              ),
                              new Padding(
                                padding:
                                EdgeInsets.only(left: 4 * SizeConfig.widthMultiplier),
                              ),
                              new Flexible(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  width: 30 * SizeConfig.widthMultiplier,
                                  child:TextFormField(
                                    //  focusNode: focusNode1,
                                      controller:_controller,
                                      enabled: true,
                                      cursorColor:lefttextclr ,
                                      enableSuggestions: true,
                                      style: TextStyle(
                                          fontFamily: 'BalooChettan2',
                                          color: lefttextclr,
                                          fontWeight: FontWeight.bold,
                                          fontSize:2.2*SizeConfig.heightMultiplier),
                                      //cursorColor: HexColor.fromHex("#00004d"),
                                      decoration: new InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(width: 1,color: lefttextclr),
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            borderSide: BorderSide(width: 1,color: lefttextclr),
                                          ),
                                          contentPadding: EdgeInsets.only(
                                              left: 5*SizeConfig.widthMultiplier,right: 5*SizeConfig.widthMultiplier),
                                          border: OutlineInputBorder(

                                              borderRadius:
                                              BorderRadius.circular(
                                                  10.00)),
                                          labelText: "Enter..",
                                          labelStyle: new TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:lefttextclr,
                                              fontSize: 2.5*SizeConfig.textMultiplier)),
                                      keyboardType:
                                      TextInputType.emailAddress,
                                      validator: validateEmail,
                                      onSaved: (val) {
                                        setState(() => _subject = val);
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 15 * SizeConfig.heightMultiplier),
                          child: Column(
                            children: <Widget>[
                              new RaisedButton(
                                onPressed: () async {
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                  if(classs=="Select Class" || status=="Select Status" || _subject==""){
                                    Fluttertoast.showToast(
                                        msg: "Fill all the fields",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 2.2*SizeConfig.textMultiplier);
                                  }else{
                                    ProgressDialog pr = new ProgressDialog(context,type: ProgressDialogType.Normal,isDismissible: true);
                                    pr.style(message: "wait");
                                    pr.show();
                                    Map exist;
                                    await dbref.child("Attendance").child(Dateinfo.dept).child(classs).child(_subject.toUpperCase()).once().then((snap){
                                      exist=snap.value;
                                    });
                                    if(exist==null){
                                      await  dbref.child("Attendance").child(Dateinfo.dept)
                                          .child(classs).child(_subject.toUpperCase()).child(
                                          Dateinfo.teachname).child("total")
                                          .set(1);

                                    }else{
                                      if(!(exist.containsKey(Dateinfo.teachname))){
                                        await  dbref.child("Attendance").child(Dateinfo.dept)
                                            .child(classs).child(_subject.toUpperCase()).child(
                                            Dateinfo.teachname).child("total")
                                            .set(1);
                                      }
                                    }
                                    SharedPreferences prefs=await SharedPreferences.getInstance();
                                    // var email=Dateinfo.teachemail.split("@");
                                    if(status=="lecture"){
                                      prefs.setString(classs.toUpperCase()+"_"+_subject.toUpperCase(),"0");
                                      await dbref.child("teach_att").child(Dateinfo.dept)
                                          .child(Dateinfo.teachname).child(classs.toUpperCase()+"_"+_subject.toUpperCase()).
                                      set(prefs.getString((classs.toUpperCase()+"_"+_subject.toUpperCase()).toString()));
                                      print(prefs.getString(classs+"_"+_subject));
                                      Future.delayed(Duration(seconds: 2)).then((value){
                                        pr.update(
                                            message: "Done");
                                      });
                                      await dbref.child("Teacher_account").child(Dateinfo.email).child("class_sub").
                                      child(status).child(classs).child(_subject.toUpperCase()).set(1);
                                      Future.delayed(Duration(seconds: 3)).then((onValue){
                                        pr.hide();
                                      });
                                      prefs.setBool("check", false);
                                    }else{

                                      setState(() {
                                        Dateinfo.classs=classs;
                                        Dateinfo.stat=status;
                                        Dateinfo.subject=_subject.toUpperCase();
                                        Alert.check=true;
                                      });

                                      await Alert.dialog(context);
                                      Future.delayed(Duration(seconds: 2)).then((value){
                                        pr.update(
                                            message: "Done");
                                      });
                                      Future.delayed(Duration(seconds: 3)).then((onValue){
                                        pr.hide();
                                      });
                                      prefs.setString(classs.toUpperCase()+"_"+_subject.toUpperCase()+"_"+Alert.batch.toUpperCase(),"0");
                                      dbref.child("teach_att").child(Dateinfo.dept)
                                          .child(Dateinfo.teachname).child(classs.toUpperCase()+"_"+_subject.toUpperCase()+"_"+Alert.batch.toUpperCase()).
                                      set(prefs.getString(classs.toUpperCase()+"_"+_subject.toUpperCase()+"_"+Alert.batch.toUpperCase()));
                                      prefs.setBool("check", false);

                                    }
                                    setState(()  {
                                      _controller.clear();
                                      classs="Select Class";
                                    });
                                    Dateinfo.fetch=false;
                                  }

                                },
                                color: Color(0xff996600),
                                shape: new RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.00)),
                                child: new Text(" Save Details",
                                    style: TextStyle(
                                        fontFamily: 'BalooChettan2',
                                        color: Colors.white,
                                        fontSize: 2.8 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        // new Padding(padding: EdgeInsets.all(10.00)),
                      ],
                    ),
                  ),
                ),
          ),
        ));
  }

  void _handleRadioValueChange1(int value) {
  if(value==0){
    setState(() {
      group=0;
      status="lecture";
    });
  }
  else{
    setState(() {
      group=1;
      status="Practical";
    });
  }
  }
}

class Monitor extends StatefulWidget {
  @override
  _MonitorState createState() => _MonitorState();
}

class _MonitorState extends State<Monitor> {
  String date="pick a date";
  int len=1;

  admin obj=new admin();
  var myFormat = DateFormat('yyyy_MM_dd');
  String classs = 'Class';
  List<String> classlist = ['Class','FE1','FE2','FESS','SE1','SE2','SESS','TE1','TE2','TESS','BE1','BE2','BESS'];
  @override
  Widget build(BuildContext context) {
    ProgressDialog pr =  ProgressDialog(context,type: ProgressDialogType.Normal);
    pr.style(message: " Wait");
    return MaterialApp(
        home:Scaffold(
          body: new
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top:20,left:70),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Desired Class:",
                      style: TextStyle(
                          fontSize: 2.6 * SizeConfig.textMultiplier,
                          color: HexColor.fromHex("#00004d"),
                          fontWeight: FontWeight.bold),
                    ),
                    new Padding(
                        padding: EdgeInsets.only(
                            left: 6 * SizeConfig.widthMultiplier)),

                    DropdownButton<String>(
                      items: classlist.map((String listvalue) {
                        return DropdownMenuItem<String>(
                          value: listvalue,
                          child: Text(listvalue,style: TextStyle(
                              fontSize: 2.3 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() => classs = val);
                      },
                      value: classs,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(left:35*SizeConfig.widthMultiplier,top:3*SizeConfig.heightMultiplier),
                child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(80.00)),
                    splashColor: HexColor.fromHex("#ffffff"),
                    onPressed: () async {
                      DateTime newDateTime = await showRoundedDatePicker(
                        context: context,
                        theme: ThemeData.dark(),
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        borderRadius: 16,
                      );
                      setState(() {
                        date = myFormat.format(newDateTime);
                      });
                    },
                    elevation: 2.0,
                    color: HexColor.fromHex("#00004d"),
                    textColor: Colors.white,
                    child: new Text(date,
                      textAlign: TextAlign.center,style: TextStyle(fontSize: 2*SizeConfig.textMultiplier),)),
              ),

              Padding(
                padding: EdgeInsets.only(left:38*SizeConfig.widthMultiplier,top:3*SizeConfig.heightMultiplier),
                child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(80.00)),
                    splashColor: HexColor.fromHex("#ffffff"),
                    onPressed: () async {
                      pr.show();
                      admin.date=date;
                      admin.classs=classs;
                      await obj.check();
                      pr.hide();
                      print(obj.adminlist);
                      if(obj.adminlist.length!=0) {
                        setState(() {
                          len = obj.adminlist.length;
                        });
                      }
                      for(final i in obj.adminlist){
                        print(i.teachername);
                        print(i.time);
                        print(i.batch);
                        print(i.subject);
                        print(i.total);

                      }
                    },
                    elevation: 2.0,
                    color: HexColor.fromHex("#00004d"),
                    textColor: Colors.white,
                    child: new Text("View",
                      textAlign: TextAlign.center,style: TextStyle(fontSize: 2*SizeConfig.textMultiplier),)),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 5 *
                      SizeConfig.widthMultiplier, top: 7 *
                      SizeConfig.heightMultiplier),
                  child: Container(
                    child: new Swiper(

                        layout: SwiperLayout.STACK,
                        customLayoutOption: new CustomLayoutOption(
                            startIndex: 0,
                            stateCount: 3
                        ).addRotate([
                          -45.0 / 180,
                          0.0,
                          45.0 / 180
                        ]),
                        itemWidth: 80 * SizeConfig.widthMultiplier,
                        itemHeight: 25 *
                            SizeConfig.heightMultiplier,
                        itemBuilder: (context, index) {
                          return new GestureDetector(
                              onLongPress: () async {
                                pr.show();
                                if(obj.adminlist[index].batch==""){
                                  String attendance="";
                                  final dbref = FirebaseDatabase.instance.reference();
                                  await dbref.child("teach_att").child(Dateinfo.dept).child(obj.adminlist[index].teachername).
                                  child(classs.toUpperCase()+"_"+obj.adminlist[index].subject).once().then((snap){
                                    attendance=snap.value.toString();
                                  });
                                  pr.hide();
                                  Fluttertoast.showToast(
                                      msg: attendance,
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                                else{
                                  String attendance="";
                                  final dbref = FirebaseDatabase.instance.reference();
                                  await dbref.child("teach_att").child(Dateinfo.dept).child(obj.adminlist[index].teachername).
                                  child(classs.toUpperCase()+"_"+obj.adminlist[index].subject+"_"+obj.adminlist[index].batch.toUpperCase())
                                      .once().then((snap){
                                    attendance=snap.value.toString();

                                      });
                                  pr.hide();
                                  Fluttertoast.showToast(
                                      msg: attendance,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: new BorderRadius
                                        .circular(30.0),
                                    gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [
//                                                  HexColor.fromHex("#F37335"),
//                                                  HexColor.fromHex("#FDC830")
                                          Colors.cyan,
                                          Colors.lightBlueAccent
                                        ])

                                ),
                                child:obj.adminlist.isEmpty?Center(child: new Text("Nothing to show here",style: TextStyle(fontSize: 2.8*SizeConfig.textMultiplier,color: Colors.white),)):
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
                              )

                          );
                        },
                        itemCount:len
                    ),
                  )
              )

            ],
          ),
          appBar: new AppBar(
            title: new Text("Monitor day"),
            backgroundColor: Colors.black87,
          ),
        )
    );
  }
  Widget swipe(int index) {
    if(obj.adminlist[index].batch==""){
      return new Text("lecture\n"+
          "Time:" + obj.adminlist[index].time + "\n" + "Professor:" + obj.adminlist[index].teachername+"\n"+"Subject:"+
          obj.adminlist[index].subject+"\nTotal:"+obj.adminlist[index].total,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),);
    }
    else{
      return new Text("practical\n"+"Batch:"+obj.adminlist[index].batch+
          "\nTime:" + obj.adminlist[index].time + "\n" + "Professor:" + obj.adminlist[index].teachername+"\n"+"Subject:"+
          obj.adminlist[index].subject+"\nTotal:"+obj.adminlist[index].total,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),);
    }
  }
}

