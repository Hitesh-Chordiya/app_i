import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/responsive/Screensize.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'AttendanceData.dart';

class parentinfoPage extends StatefulWidget {
  @override
  _parentinfoPageState createState() => _parentinfoPageState();
}

class _parentinfoPageState extends State<parentinfoPage> {
  TextEditingController _snamecontroller = TextEditingController(),
      _pnamecontroller = TextEditingController(),
      _smobilecontroller = TextEditingController(),
      _pmobilecontroller = TextEditingController(),
      _pemailcontroller = TextEditingController();

  final formKey = new GlobalKey<FormState>();
  bool autovaildate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _snamecontroller.text = Studinfo.name;
    if (Studinfo.datamap.length != 0) {
      _smobilecontroller.text = Studinfo.datamap["smobile"];
      _pnamecontroller.text = Studinfo.datamap["pname"];
      _pmobilecontroller.text = Studinfo.datamap["pmobile"];
      _pemailcontroller.text = Studinfo.datamap["pemail"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      body: SingleChildScrollView(
        child: Container(
          height:105*SizeConfig.heightMultiplier,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end:Alignment.bottomCenter,

              colors: [
                Color(0xffffffff),
                Color(0xffee9ca7),
              ],
            ),),
          child: Form(
            key: formKey,
            autovalidate: autovaildate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 5 * SizeConfig.heightMultiplier,
                  child: Stack(
                    children: <Widget>[],
                  ),
                ),
                SizedBox(
                  height: 5 * SizeConfig.heightMultiplier,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5*SizeConfig.widthMultiplier),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "If you are bad, \nI am your dad",
                        style: TextStyle(
                          fontSize: 3.8*SizeConfig.heightMultiplier,
                          color: Color(0xff00004d),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5.7*SizeConfig.heightMultiplier,
                      ),
                      Text(
                        "Student's Information",
                        style: TextStyle(
                          fontSize: 3.8*SizeConfig.heightMultiplier,
                          color: Color(0xff00004d),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(SizeConfig.heightMultiplier),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.transparent,
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(SizeConfig.heightMultiplier),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[100],
                                  ),
                                ),
                              ),
                              child: TextField(
                                style: TextStyle(color: Color(0xff888844),fontSize: 2.5*SizeConfig.heightMultiplier,fontWeight: FontWeight.bold),
                                controller: _snamecontroller,
                                cursorColor: Colors.grey,
                                enabled: false,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Student's name",
                                  hintStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey,fontSize: 2.5*SizeConfig.heightMultiplier),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(SizeConfig.heightMultiplier),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[100],
                                  ),
                                ),
                              ),
                              child: TextFormField(
                                style: TextStyle(color:Color(0xff888844),fontSize: 2.5*SizeConfig.heightMultiplier,fontWeight: FontWeight.bold),
                                controller: _smobilecontroller,
                                cursorColor: Colors.grey,
                                keyboardType: TextInputType.number,
                                validator: validatemobile,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Student's mobile number",
                                    hintStyle: TextStyle(color: Colors.grey,fontSize: 2.5*SizeConfig.heightMultiplier,fontWeight: FontWeight.bold)),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.7*SizeConfig.heightMultiplier,
                      ),
                      Text(
                        "Parent's Information",
                        style: TextStyle(
                          fontSize: 3.8*SizeConfig.heightMultiplier,
                          color: Color(0xff00004d),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(SizeConfig.heightMultiplier),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(SizeConfig.heightMultiplier),
                          color: Colors.transparent,
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(SizeConfig.heightMultiplier),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[100],
                                  ),
                                ),
                              ),
                              child: TextFormField(
                                style: TextStyle(color: Color(0xff888844),fontSize: 2.5*SizeConfig.heightMultiplier,fontWeight: FontWeight.bold),
                                controller: _pnamecontroller,
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Parent's name",
                                  hintStyle: TextStyle(color: Colors.grey,fontSize: 2.5*SizeConfig.heightMultiplier,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(SizeConfig.heightMultiplier),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[100],
                                  ),
                                ),
                              ),
                              child: TextFormField(
                                style: TextStyle(color: Color(0xff888844),fontSize: 2.5*SizeConfig.heightMultiplier,fontWeight: FontWeight.bold),
                                validator: validatemobile,
                                cursorColor: Colors.grey,
                                keyboardType: TextInputType.number,
                                controller: _pmobilecontroller,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Parent's mobile number",
                                    hintStyle: TextStyle(color: Colors.grey,fontSize: 2.5*SizeConfig.heightMultiplier,fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(SizeConfig.heightMultiplier),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[100],
                                  ),
                                ),
                              ),
                              child: TextFormField(
                                style: TextStyle(color: Color(0xff888844),fontSize: 2.5*SizeConfig.heightMultiplier,fontWeight: FontWeight.bold),
                                validator: validateEmail,
                                cursorColor: Colors.grey,
                                controller: _pemailcontroller,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Parent's Email",
                                    hintStyle: TextStyle(color: Colors.grey,fontSize: 2.5*SizeConfig.heightMultiplier,fontWeight: FontWeight.bold)),
                              ),
                            ),
                           new Padding(padding: EdgeInsets.only(bottom: 3*SizeConfig.heightMultiplier)),
                            new RaisedButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.00)),
                                splashColor: HexColor.fromHex("#ffffff"),
                                onPressed: () async {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  if (_snamecontroller.text == "" ||
                                      _smobilecontroller.text == "" ||
                                      _pnamecontroller.text == "" ||
                                      _pmobilecontroller.text == "" ||
                                      _pemailcontroller.text == "") {
                                    Fluttertoast.showToast(
                                        msg: "Pura toh bhar na",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 2.3*SizeConfig.heightMultiplier);
                                  } else {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();
                                      ProgressDialog pr = new ProgressDialog(
                                          context,
                                          type: ProgressDialogType.Normal);
                                      pr.show();
                                      final dbref = FirebaseDatabase.instance
                                          .reference()
                                          .child("ParentTeacher")
                                          .child(Studinfo.parentname)
                                          .child(Studinfo.classs)
                                          .child(Studinfo.roll);
                                      await dbref
                                          .child("pname")
                                          .set(_pnamecontroller.text);
                                      await dbref
                                          .child("smobile")
                                          .set(_smobilecontroller.text);
                                      await dbref
                                          .child("pmobile")
                                          .set(_pmobilecontroller.text);
                                      await dbref
                                          .child("pemail")
                                          .set(_pemailcontroller.text);
                                      // print("object");
                                      pr.hide();
                                    } else {
                                      setState(() {
                                        autovaildate = true;
                                      });
                                    }
                                  }
                                },
                                elevation: 2.0,
                                color: Color(0xff00004d),
                                textColor: Colors.white,
                                child: new Text(
                                  "Save",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                      fontSize: 2.5 * SizeConfig.textMultiplier),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (value.isEmpty || !regex.hasMatch(value))
    return 'Invalid Email';
  else
    return null;
}

String validatemobile(String value) {
  Pattern pattern = r'^([6-9]\d{9})$';
  RegExp regex = new RegExp(pattern);
  if (value.isEmpty || !regex.hasMatch(value) || value.length != 10)
    return 'Invalid Mobile';
  else
    return null;
}
