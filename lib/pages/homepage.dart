import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/AttendanceData.dart';
import 'package:flutter_app/responsive/Screensize.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'View_attendance.dart';

class Date extends StatefulWidget {
  @override
  _DateState createState() => _DateState();
}

class _DateState extends State<Date> {
  Map map, dates;
  bool isloading =false;
  var s1;
  Color dropcolor=Color(0xff996600);
  Color leftcolor=Color(0xff392613);
  String classs = 'Class', _subject = "Subject", stat = "Select";
  List<String> classlist = ["Class"], subjectlist = ["Subject"];
  int group;
  final dbref = FirebaseDatabase.instance.reference();
  //var status = [ 'Select','lecture', 'Practical'];
  FocusNode focusNode5 = new FocusNode();
  SharedPreferences prefs;

  void copy()async {
    prefs=await SharedPreferences.getInstance();
  }

  String date = "Select Date";
  dynamic value;
  bool mark;
  String map1;
  var myFormat = DateFormat('yyyy_MM_dd');
  static Future<int> getcount() async {
    if(Dateinfo.stat=="lecture"){
      final response = await FirebaseDatabase.instance
          .reference().child("Student")
          .child(total.dep)
          .child(total.classs)
          .once();
      try {
        Map  batches=response.value;
        // print(batches);
        Dateinfo.prnlist.clear();
        for (final k in batches.keys) {
          try {
            Map map = batches[k];
            total.studnames.addAll(map);
            print("eds");
            // var len = [];
            for (final k in map.keys) {
              Dateinfo.prnlist.add(k.toString());
            }
            // Dateinfo.prnlist.sort();
            total.count = Dateinfo.prnlist.length;
          } catch (Exception) {
            Fluttertoast.showToast(
                msg: "Nothing to show",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 2.2 * SizeConfig.textMultiplier);
            return null;
          }
        }
        await FirebaseDatabase.instance
            .reference().child("Attendance")
            .child(total.dep)
            .child(total.classs).child("total").set(total.count);
        print(total.studnames);

        return Dateinfo.prnlist.length;
      }catch(Exception){
        Fluttertoast.showToast(
            msg: "Nothing to ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 2.2 * SizeConfig.textMultiplier);
        return null;

      }
    }else {
      final response = await FirebaseDatabase.instance
          .reference().child("Student")
          .child(total.dep)
          .child(total.classs)
          .child(Alert1.batch)
          .once();
      try {
        total.studnames = response.value;
        Dateinfo.prnlist.clear();
        // var len = [];
        for (final k in total.studnames.keys) {
          Dateinfo.prnlist.add(k.toString());
        }
        // Dateinfo.prnlist.sort();
        total.count = Dateinfo.prnlist.length;
        await FirebaseDatabase.instance
            .reference().child("Attendance")
            .child(total.dep)
            .child(total.classs).child("total").set(total.count);
        return Dateinfo.prnlist.length;
      } catch (Exception) {
        Fluttertoast.showToast(
            msg: "Nothing to show",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 2.2 * SizeConfig.textMultiplier);
        return null;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    copy();
    Color righttxtclr = Color(0xff997a00);
    Color lefttxtclr = Color(0xff00004d);
    double lefttxtsize=2.5*SizeConfig.heightMultiplier;
    Color butclr = Color(0xff996600);
    ProgressDialog pr = new ProgressDialog(context);
    pr.style(
        message: "wait");
    return MaterialApp(
        home: new Scaffold(
          body:isloading?new SpinKitThreeBounce(
            color: Color(0xff6d6d46),
            size: 40.0,
            // controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
          ): Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.black87,Colors.black87])
            ),
            child: GradientCard(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              margin: new EdgeInsets.symmetric(
                  horizontal: 6*SizeConfig.widthMultiplier,
                  vertical: 14*SizeConfig.heightMultiplier
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                //  stops: [0,0.5,1],
                colors: [
                  //  HexColor.fromHex("#83afaf"),
                  HexColor.fromHex("#DAD299"),
                  HexColor.fromHex("#DAD299")
                ],
              ),
              elevation: 5.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Padding(padding: EdgeInsets.only(top:30)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Radio(
                        activeColor:HexColor.fromHex ("#996600"),
                        value: 0,
                        groupValue: group,
                        onChanged:  _handleRadioValueChange1,
                      ),
                      new Text(
                        'Theory' ,
                        style: TextStyle(
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                            color: lefttxtclr,
                            fontWeight: FontWeight.bold),
                      ),
                      // new Padding(padding: EdgeInsets.only(left: 10)),
                      new Radio(
                        activeColor:dropcolor,
                        value: 1,
                        groupValue: group,
                        onChanged:  _handleRadioValueChange1,
                      ),
                      new Text(
                        'Practical',
                        style: TextStyle(
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                            color: lefttxtclr,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: 1 * SizeConfig.heightMultiplier,
                       // left: 23 * SizeConfig.widthMultiplier
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Radio(
                          activeColor: dropcolor,
                          value: 2,
                          groupValue: group,
                          onChanged: _handleRadioValueChange1,
                        ),
                        new Text(
                          'Tutorial',
                          style: TextStyle(
                              fontSize: 2.5 * SizeConfig.textMultiplier,
                              color: lefttxtclr,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                        top: 4 * SizeConfig.heightMultiplier,
                    //    left: 7 * SizeConfig.widthMultiplier
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Select Class:",
                          style: TextStyle(
                              fontSize: lefttxtsize,
                              color:lefttxtclr,
                              fontWeight: FontWeight.bold),
                        ),
                        new Padding(
                            padding: EdgeInsets.only(
                                left: 6 * SizeConfig.widthMultiplier)),
                        Container(
                          height: 4.9*SizeConfig.heightMultiplier,
                          padding:
                          EdgeInsets.symmetric(horizontal:3.1*SizeConfig.widthMultiplier , vertical:0.7*SizeConfig.heightMultiplier),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: DropdownButton<String>(
                            iconEnabledColor: righttxtclr,
                            items: classlist.map((String listvalue) {
                              return DropdownMenuItem<String>(

                                value: listvalue,
                                child: Text(listvalue,style: TextStyle(
                                    fontSize: 2 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.bold,color: righttxtclr),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                classs=val;
                                subjectlist.clear();
                                _subject="Subject";
                                subjectlist=["Subject"];
                                if(!(stat=="Status"&& _subject=="Subject"))
                                  subjectlist.addAll(prefs.getStringList(classs+"_"+stat[0]));
                              });
                            },
                            value: classs,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 5* SizeConfig.heightMultiplier,
                   //     left: 7 * SizeConfig.widthMultiplier
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Select Subject:",
                          style: TextStyle(
                              fontSize: lefttxtsize,
                              color: lefttxtclr,
                              fontWeight: FontWeight.bold),
                        ),
                        new Padding(
                            padding: EdgeInsets.only(
                                left: 6 * SizeConfig.widthMultiplier)),
                        Container(
                          height: 4.9*SizeConfig.heightMultiplier,
                          padding:
                          EdgeInsets.symmetric(horizontal:3.1*SizeConfig.widthMultiplier, vertical: 0.7*SizeConfig.heightMultiplier),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: DropdownButton<String>(
                            iconEnabledColor: righttxtclr,
                            items: subjectlist.map((String listvalue) {
                              return DropdownMenuItem<String>(
                                value: listvalue,
                                child: Text(listvalue,style: TextStyle(
                                    fontSize: 2 * SizeConfig.textMultiplier,
                                    color: righttxtclr,
                                    fontWeight: FontWeight.bold),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {

                              setState(() => _subject = val);
                              Dateinfo.subject=_subject;
                            },
                            value: _subject,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:EdgeInsets.only(top: 3*SizeConfig.heightMultiplier),
                    child: new MaterialButton(
                      onPressed: () async{
                        FocusScope.of(context).requestFocus(new FocusNode());
                        DateTime newDateTime = await showDatePicker(
                          context: context,

                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),

                        );

                        setState(() {
                          try{
                            date = myFormat.format(newDateTime);
                          }catch(Exception){}
                        });

                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.00)),
                      child: new Text(date,
                          style: TextStyle(
                              fontFamily: 'BalooChettan2',
                              color: lefttxtclr,
                              fontSize: 3*SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold
                          )),
                    ),
                  ), //Forgot password button
                  Padding(
                    padding:EdgeInsets.symmetric(horizontal: 30*SizeConfig.widthMultiplier,vertical: 2*SizeConfig.heightMultiplier),
                    child: new RaisedButton(
                      onPressed: () async{
                        FocusScope.of(context).requestFocus(new FocusNode());
                        if(stat=="Select"||classs=="Class"|| _subject=="Subject"||date=="Select Date"){
                          Fluttertoast.showToast(
                              msg: "Fill all the fields",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }else {
                          //pr.show();

                          print(Dateinfo.part);
                          total.classs = classs;
                          total.dep = Dateinfo.dept;
                          Dateinfo.stat = stat;
                          Dateinfo.date1 = date;
                          Dateinfo.classs = classs;
                          Dateinfo.subject = _subject;
                          Dateinfo.lecnumber = "1";
                          try {
                            if (stat == "lecture") {
                              setState(() {
                                isloading=true;
                              });
                              await dbref
                                  .child("Attendance")
                                  .child(Dateinfo.dept)
                                  .child(classs)
                                  .child(_subject)
                                  .child(Dateinfo.teachname)
                                  .child(date)
                                  .child(stat)
                                  .child("leccount")
                                  .once()
                                  .then((snap) async {
                                Dateinfo.part = snap.value;
                                if (snap.value==null) throw Exception;
                              });
                            } else {
                              Alert1.check=true;
                              Alert1.inputlec=true;
                              if(stat=="Practical") {
                                Dateinfo.batches.clear();
                                Dateinfo.batches =
                                    prefs.getStringList(
                                        Dateinfo.subject);
                                print(Dateinfo.part);
                              }else{
                                Dateinfo.batches.clear();
                                Dateinfo.batches =
                                    prefs.getStringList(
                                        Dateinfo.subject+"T");

                              }
                              //print("object");
                              print(Dateinfo.part);
                              await Alert1.dialog(context);
                              setState(() {
                                isloading=true;
                              });
                            }
                            await Future.delayed(Duration(seconds: 2));
                            // pr.show();
                            int k = await getcount();
                            print(Dateinfo.part);

                            dbref.child("Attendance").child(Dateinfo.dept)
                                .child(classs).child("total")
                                .set(total.count);
                            if (Dateinfo.part != "1") {
                              await _displayDialog(context);
                              // await Future.delayed(Duration(seconds: 4));
                            }
                            await Dateinfo.info();
                            //    await Future.delayed(Duration(seconds: 6));
                            //pr.hide();
                            setState(() {
                              isloading=false;
                            });
                            Dateinfo.viewmod=false;
                            if (!(k == null)) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ));
                            }
                          }
                          catch (Exception) {
                            pr.hide();
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
                        }
                        //  await Future.delayed(Duration(seconds: 4

                      },
                      color: butclr,
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.00)),
                      child: new Text("  Display",
                          style: TextStyle(
                              fontFamily: 'BalooChettan2',
                              color: Colors.white,
                              fontSize: 2.5*SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          appBar: new AppBar(
            leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon:Icon(Icons.arrow_back,color: Colors.white,)

            ),
            title: new Text("Homepage\\check att",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 2.7*SizeConfig.textMultiplier)),
            backgroundColor: Color(0xff6d6d46),
          ),
        ));
  }

  void _handleRadioValueChange1(value) {
    if(value==0){
      setState(() {
        group=value;
        stat="lecture";
        classlist.clear();
        classlist=["Class"];
        subjectlist.clear();
        subjectlist=["Subject"];
        classs="Class";
        _subject="Subject";
        if(!(stat=="Status") && classs=="Class")
          classlist.addAll(prefs.getStringList(stat));
      });

    }
    else if(value==1){
      setState(() {
        group=value;
        stat="Practical";
        classlist.clear();
        classlist=["Class"];
        subjectlist.clear();
        subjectlist=["Subject"];
        classs="Class";
        _subject="Subject";
        if(!(stat=="Status") && classs=="Class")
          classlist.addAll(prefs.getStringList(stat));

      });
    }
    else{
      setState(() {
        group=value;
        stat="Tutorial";
        classlist.clear();
        classlist=["Class"];
        subjectlist.clear();
        subjectlist=["Subject"];
        classs="Class";
        _subject="Subject";
        if(!(stat=="Status") && classs=="Class")
          classlist.addAll(prefs.getStringList(stat));

      });
    }
  }
}


_displayDialog(BuildContext context) async {
  List<String> items = ["1", "2", "3"];
  items.clear();
  for (int i = 1; i <= int.parse(Dateinfo.part); i++) {
    items.add(i.toString());
  }

  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('select lecture number'),
          content: Container(
              width: 50,
              height: 130,
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Container(
                      width: 40,
                      child: new FlatButton(
                        color: Colors.greenAccent,
                        child: new Text(items[index]),
                        onPressed: () {
                          Navigator.pop(context);
                          Dateinfo.lecnumber = items[index].toString();
                          print(Dateinfo.lecnumber);
                        },
                      ),
                    );
                  })),
        );
      });
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  List<String> list=[""];
  var random;
  int count;
  final GlobalKey<RefreshIndicatorState>refresh=GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState>scaffold=GlobalKey<ScaffoldState>();
  IconData iconData = Icons.check_box;
  final String serverToken = 'AAAAzLvQqG0:APA91bFHMVn3YfGyxWs1Fkr9dtrFOvWg569HaK5vLy8lp3wOvFhZRvKMsQfsNEZhxZGj2hMwclWL_t7QLLNntuBojte5Jch58W20ykmyI7_0A2WwcHe-Z4FQNJIUvHcBg1mPNkY5X6iK';
  final dbref=FirebaseDatabase.instance.reference();
  Color checkboxclr=Colors.green;
  String  appbarname="home\\check_view";
  Future<void> handlerefresh(){
    final Completer<void>completer=Completer<void>();
    Timer(const Duration(seconds: 3),(){
      completer.complete();
    });
    setState(() {
      Dateinfo.list.addAll(list);
      Dateinfo.list=Dateinfo.list.toSet().toList();
    });
    return completer.future.then<void>((_){

      scaffold.currentState?.showSnackBar(SnackBar(
          content:const Text("Refresh complete"),
          action:SnackBarAction(
              label: "Retry",
              onPressed: (){
                refresh.currentState.show();
              }
          )
      ));

    });
  }
  Future<void> setcount() async {
    try{
      if(Dateinfo.stat=="lecture"){
        await FirebaseDatabase.instance
            .reference().child("Attendance")
            .child(total.dep)
            .child(total.classs).child(Dateinfo.subject).
        child(Dateinfo.teachname)
            .child(Dateinfo.date1).child(Dateinfo.stat).child(Dateinfo.lecnumber.toString())
            .child("a_total").set(count.toString());
      }else{
        await FirebaseDatabase.instance
            .reference().child("Attendance")
            .child(total.dep)
            .child(total.classs).child(Dateinfo.subject).
        child(Dateinfo.teachname)
            .child(Dateinfo.date1).child(Dateinfo.stat).child(Alert1.batch).child(Dateinfo.lecnumber.toString())
            .child("a_total").set(count.toString());
      }

      //return Dateinfo.prnlist.length;
    }catch(Exception){

      Fluttertoast.showToast(
          msg: "Nothing to show",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 2.2*SizeConfig.textMultiplier);
      return null;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    Dateinfo.list.remove("a_total");
    list.clear();
    list.addAll(Dateinfo.list);
    count=list.length;
    super.initState();
    if(Dateinfo.viewmod==true){
      appbarname="home\\check_modify";
    }
  }

  @override
  Widget build(BuildContext context) {
    Icon obj;
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Color(0xff008080),
        title: new Text(appbarname,style: TextStyle(fontStyle: FontStyle.italic,fontSize: 2.7*SizeConfig.textMultiplier),),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Modify'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body:Container(
        color: Colors.black87,
        // height: 50*SizeConfig.heightMultiplier,
        child: LiquidPullToRefresh(
          key:refresh,
          color: Colors.black,
          onRefresh: handlerefresh,
          showChildOpacityTransition: false,
          child: ListView.builder(padding:kMaterialListPadding,
            itemCount: total.count,
            itemBuilder:( BuildContext context,int index){

              if (Dateinfo.list.contains(Dateinfo.prnlist.elementAt(index).toString()) && list.contains(Dateinfo.prnlist.elementAt(index).toString())) {
                obj=new Icon(Icons.check_box,color: checkboxclr);
              } else if(!Dateinfo.list.contains(Dateinfo.prnlist.elementAt(index).toString()) && list.contains(Dateinfo.prnlist.elementAt(index).toString())){
                obj=new Icon(Icons.check_box);
              }
              else if(!Dateinfo.list.contains(Dateinfo.prnlist.elementAt(index).toString()) && !list.contains(Dateinfo.prnlist.elementAt(index).toString())){
                obj=new Icon(Icons.check_box_outline_blank);
              }else if(Dateinfo.list.contains(Dateinfo.prnlist.elementAt(index).toString()) && !list.contains(Dateinfo.prnlist.elementAt(index).toString())){
                obj=new Icon(Icons.check_box_outline_blank);
              }
              else{
                obj=new Icon(Icons.check_box);
              }
              return Card(
                elevation: 50,

                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0)),

                child: ListTile(
                    isThreeLine: false,
                    leading:  Text(Dateinfo.prnlist.elementAt(index).toString()+": ",style: TextStyle(fontSize: 2.5*SizeConfig.textMultiplier,fontWeight: FontWeight.bold,
                        color: Color(0xffac3973)
                    )),
                    title:Text(total.studnames[(Dateinfo.prnlist.elementAt(index).toString())].toString(),style: TextStyle(
                        fontSize: 2.2*SizeConfig.textMultiplier,color: Colors.black,fontWeight: FontWeight.bold
                    ),),
                    //subtitle: const Text("hiiiii"),
                    trailing:
                    new IconButton(icon: obj, onPressed: () async {
                      if(Dateinfo.viewmod){
                        Fluttertoast.showToast(
                            msg: "Pull to save",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        await http.post(
                          'https://fcm.googleapis.com/fcm/send',
                          headers: <String, String>{
                            'Content-Type': 'application/json',
                            'Authorization': 'key=$serverToken',
                          },
                          body: jsonEncode(
                            <String,   dynamic>{
                              'notification': <String, dynamic>{
                                'body': Dateinfo.teachname+" modified your "+Dateinfo.subject+" attendance ",
                                'title': "Attendance Modified",
                                //'icon':"assets/college_logo.png"
                              },

                              'priority': 'high',
                              'data': <String, dynamic>{
                                'Hello': 'Pune',
                                'id': '1',
                                'status': 'done',

                              },
                              "to": "/topics/${Dateinfo.prnlist.elementAt(index).toString()}"

                            },
                          ),
                        );
                        if(Dateinfo.stat=="lecture"){
                          if(Dateinfo.list.contains(Dateinfo.prnlist.elementAt(index).toString())||list.contains(Dateinfo.prnlist.elementAt(index).toString())){
                            await Dateinfo.list.remove(Dateinfo.prnlist.elementAt(index).toString());
                            list.remove(Dateinfo.prnlist.elementAt(index).toString());
                            dbref.child("defaulter")
                                .child("modified").child(Dateinfo.prnlist.elementAt(index).toString()).set(1);
                            await dbref.child("Attendance")
                                .child(Dateinfo.dept)
                                .child(Dateinfo.classs)
                                .child(Dateinfo.subject)
                                .child(Dateinfo.teachname)
                                .child(Dateinfo.date1)
                                .child(Dateinfo.stat)
                                .child(Dateinfo.lecnumber)
                                .child((Dateinfo.prnlist.elementAt(index).toString())).remove();
                            setState(() {
                              count=list.length;
                              obj=new Icon(Icons.check_box_outline_blank);
                            });
                            int a=0;
                            try {
                              await dbref.child("defaulter")
                                  .child(Dateinfo.dept).child(Dateinfo.classs)
                                  .child(Dateinfo.prnlist.elementAt(index)
                                  .toString())
                                  .child(
                                  Dateinfo.subject + "_" + Dateinfo.teachname)
                                  .once()
                                  .then((value) {
                                if(value.value==null) throw Exception;
                                a = value.value;
                              });
                            }catch(Exception){}
                            if(a>0)
                              dbref.child("defaulter")
                                  .child(Dateinfo.dept).child(Dateinfo.classs).child(Dateinfo.prnlist.elementAt(index).toString())
                                  .child(Dateinfo.subject+"_"+Dateinfo.teachname).set(a-1);
                            setcount();

                          }
                          else{
                            list.add(Dateinfo.prnlist.elementAt(index).toString());
                            dbref.child("defaulter")
                                .child("modified").child(Dateinfo.prnlist.elementAt(index).toString()).set(1);
                            await dbref.child("Attendance")
                                .child(Dateinfo.dept)
                                .child(Dateinfo.classs)
                                .child(Dateinfo.subject)
                                .child(Dateinfo.teachname)
                                .child(Dateinfo.date1)
                                .child(Dateinfo.stat)
                                .child(Dateinfo.lecnumber)
                                .child((Dateinfo.prnlist.elementAt(index).toString()))
                                .set("1");
                            setState(() {
                              count=list.length;
                              new Icon(Icons.check_box);
                            });
                            int a=0;
                            try {
                              await dbref.child("defaulter")
                                  .child(Dateinfo.dept).child(Dateinfo.classs)
                                  .child(Dateinfo.prnlist.elementAt(index)
                                  .toString())
                                  .child(
                                  Dateinfo.subject + "_" + Dateinfo.teachname)
                                  .once()
                                  .then((value) {
                                if(value.value==null) throw Exception;
                                a = value.value;
                              });
                            }catch(Exception){}
                            dbref.child("defaulter")
                                .child(Dateinfo.dept).child(Dateinfo.classs).child(Dateinfo.prnlist.elementAt(index).toString())
                                .child(Dateinfo.subject+"_"+Dateinfo.teachname).set(a+1);
                            setcount();

                          }
                        }else{
                          if(Dateinfo.list.contains(Dateinfo.prnlist.elementAt(index).toString())||list.contains(Dateinfo.prnlist.elementAt(index).toString())){
                            Dateinfo.list.remove(Dateinfo.prnlist.elementAt(index).toString());
                            list.remove(Dateinfo.prnlist.elementAt(index).toString());
                            dbref.child("defaulter")
                                .child("modified").child(Dateinfo.prnlist.elementAt(index).toString()).set(1);

                            await dbref.child("Attendance")
                                .child(Dateinfo.dept)
                                .child(Dateinfo.classs)
                                .child(Dateinfo.subject)
                                .child(Dateinfo.teachname)
                                .child(Dateinfo.date1)
                                .child(Dateinfo.stat)
                                .child(Alert1.batch)
                                .child(Dateinfo.lecnumber)
                                .child((Dateinfo.prnlist.elementAt(index).toString()).toString()).remove();
                            setState(() {
                              count=list.length;
                              obj=new Icon(Icons.check_box_outline_blank);
                            });
                            int a=0;
                            String key;
                            if(Dateinfo.stat=="Practical"){
                              key=Dateinfo.subject + "_" +
                                  Dateinfo.teachname + "_" + Alert1.batch;
                            }else{
                              key=Dateinfo.subject + "_" +
                                  Dateinfo.teachname + "_" + Alert1.batch+"_Tutorial";
                            }
                            try {
                              await dbref.child("defaulter")
                                  .child(Dateinfo.dept).child(Dateinfo.classs)
                                  .child(Dateinfo.prnlist.elementAt(index)
                                  .toString())
                                  .child(key)
                                  .once()
                                  .then((value) {
                                if(value.value==null) throw Exception;

                                a = value.value;
                              });
                            }catch(Exception){
                              a=0;
                            }
                            if(a>0)
                              dbref.child("defaulter")
                                  .child(Dateinfo.dept).child(Dateinfo.classs).child(Dateinfo.prnlist.elementAt(index).toString())
                                  .child(key).set(a-1);
                            setcount();
                          }
                          else{
                            list.add(Dateinfo.prnlist.elementAt(index).toString());
                            dbref.child("defaulter")
                                .child("modified").child(Dateinfo.prnlist.elementAt(index).toString()).set(1);
                            await dbref.child("Attendance")
                                .child(Dateinfo.dept)
                                .child(Dateinfo.classs)
                                .child(Dateinfo.subject)
                                .child(Dateinfo.teachname)
                                .child(Dateinfo.date1)
                                .child(Dateinfo.stat)
                                .child(Alert1.batch)
                                .child(Dateinfo.lecnumber)
                                .child((Dateinfo.prnlist.elementAt(index).toString()).toString())
                                .set("1");
                            setState(() {
                              count=list.length;
                              new Icon(Icons.check_box);
                            });
                            int a=0;
                            String key;
                            if(Dateinfo.stat=="Practical"){
                              key=Dateinfo.subject + "_" +
                                  Dateinfo.teachname + "_" + Alert1.batch;
                            }else{
                              key=Dateinfo.subject + "_" +
                                  Dateinfo.teachname + "_" + Alert1.batch+"_Tutorial";
                            }
                            try {
                              await dbref.child("defaulter")
                                  .child(Dateinfo.dept).child(Dateinfo.classs)
                                  .child(Dateinfo.prnlist.elementAt(index)
                                  .toString())
                                  .child(key)
                                  .once()
                                  .then((value) {
                                if(value.value==null) throw Exception;
                                a = value.value;
                              });
                            }catch(Exception){}
                            dbref.child("defaulter")
                                .child(Dateinfo.dept).child(Dateinfo.classs).child(Dateinfo.prnlist.elementAt(index).toString())
                                .child(key).set(a+1);

                            setcount();
                          }
                        }
                        // Dateinfo.b=!Dateinfo.b;
                      }else{
                        Fluttertoast.showToast(
                            msg: "You can't Modify here",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 2.2*SizeConfig.textMultiplier);
                      }
                    })
                ),
              );
            },
          ),
        ),
      ),

    );
    //);
  }

  void handleClick(String value) {
    Dateinfo.viewmod = true;

    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
  }
}