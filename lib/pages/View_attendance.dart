import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/pages/AttendanceData.dart';
import 'package:flutter_app/responsive/Screensize.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final databaseReference = FirebaseDatabase.instance.reference();
  String subjectName = 'Overall';
  int height;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
//
        appBar: AppBar(
          backgroundColor: HexColor.fromHex("#008080"),
          title: Text('Your attendance'),
        ),
        body:
          Container(
              color: Color(0xffd9d9d9),
              child: Padding(
                padding:  EdgeInsets.symmetric(vertical:3*SizeConfig.heightMultiplier,horizontal:4*SizeConfig.widthMultiplier),
                child: Container(
                  height: 90*SizeConfig.heightMultiplier ,
                  width: 100*SizeConfig.widthMultiplier ,
                  decoration: BoxDecoration(

                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black87,
                          blurRadius: 2.8*SizeConfig.widthMultiplier,
                          spreadRadius: -12
                      )
                    ],
                  ),
                  child: Container(
                    child: Card(
                      margin: new EdgeInsets.symmetric(
                        //vertical: ,
                          horizontal: 7*SizeConfig.widthMultiplier),
                      elevation: 5.0,
                      color: Colors.blueAccent.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        // color: Colors.black87,
//                            decoration: BoxDecoration(
//                              image: DecorationImage(
//                                image: new AssetImage("assets/profile.jpg"),
//                                fit: BoxFit.cover,
//                              ),
//                            ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              AttendancePieChart(subjectName),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical:3*SizeConfig.heightMultiplier,horizontal: 4*SizeConfig.widthMultiplier),
                                child: new Swiper(
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
                                    itemWidth: 60*SizeConfig.widthMultiplier,
                                    itemHeight: 15*SizeConfig.heightMultiplier,
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
                                          border: Border.all(width: 4.0, color: Colors.grey.shade500),
//
//                                              gradient:LinearGradient(
//                                                  begin: Alignment.topRight,
//                                                  end: Alignment.bottomLeft,
//                                                  colors: [
//                                                    HexColor.fromHex("#00d2ff"),
//                                                    HexColor.fromHex("#3a7bd5")
////                                                Colors.cyan,
//////                                                Colors.yellowAccent
////                                                Colors.black,
////                                                  Colors.yellowAccent
//                                                  ])
                                        ),
                                      );
                                    },
                                    itemCount: Attendance.subjectList.length),
                              ),
                            ]
                        ),

                      ),
                    ),
                  ),
                ),
              )
          ),

//        Padding(
//          padding: const EdgeInsets.all(30.0),

    );
  }

//Pie Chart Class :
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
          titleStyle: TextStyle(color: Colors.white, fontSize: 2.1*SizeConfig.textMultiplier),
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
              : Color(0xffa60c0c),
          value: value / 2,
          title: 'Lec',
          radius: 6*SizeConfig.heightMultiplier,
          titleStyle: TextStyle(color: Colors.white, fontSize: 2*SizeConfig.textMultiplier),
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
              : Color(0xffa60c0c),
          value: value / 2,
          title: 'Prac',
          radius: 6*SizeConfig.heightMultiplier,
          titleStyle: TextStyle(color: Colors.white, fontSize: 2.1*SizeConfig.textMultiplier),
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
              : Color(0xffa60c0c),
          value: value / 2,
          title: 'Tut',
          radius: 6*SizeConfig.heightMultiplier,
          titleStyle: TextStyle(color: Colors.white, fontSize: 2.1*SizeConfig.textMultiplier),
        );
        _sections.add(_item2);
      }
    }
    if(b==false){
      if (AttendanceCounter < 100) {
        PieChartSectionData _item = PieChartSectionData(
          color:Color(0xffa60c0c),
          value: (100 - AttendanceCounter),
          title: 'Abs',
          radius: 6*SizeConfig.heightMultiplier,
          titleStyle: TextStyle(
            color: Colors.white,
            fontSize: 2*SizeConfig.textMultiplier,
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
              AspectRatio(
                  aspectRatio: (SizeConfig.widthMultiplier/SizeConfig.heightMultiplier)*2.4,
                  child: FlChart(
                      chart: PieChart(
                        PieChartData(
                          sections: _sections,
                          borderData: FlBorderData(show: false),
                          centerSpaceRadius: 7*SizeConfig.heightMultiplier,
                          sectionsSpace: 5,
                        ),
                      )
                  )
              ),

              sub == 'Overall' ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            'Total Attendance : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 2.7*SizeConfig.textMultiplier)),
                        Text(
                          '${TotalAttendance.toStringAsFixed(2)} %'
                          ,style: TextStyle(fontSize: 2.4*SizeConfig.textMultiplier,fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.7*SizeConfig.textMultiplier,top: 2*SizeConfig.heightMultiplier),
                    child: new Row(
                      children: <Widget>[
                        Text(
                            'lectures  Attended: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 2.7*SizeConfig.textMultiplier)),
                        Text(
                          '$att_lect'+'/'+'$total_lect'
                          ,style: TextStyle(fontSize: 2.4*SizeConfig.textMultiplier,fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.7*SizeConfig.textMultiplier,top: 2*SizeConfig.heightMultiplier),
                    child: new Row(
                      children: <Widget>[
                        Text(
                            'Practicals  Attended: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 2.7*SizeConfig.textMultiplier)),
                        Text(
                          '$att_pract'+'/'+'$total_pract'
                          ,style: TextStyle(fontSize: 2.4*SizeConfig.textMultiplier,fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.7*SizeConfig.textMultiplier,top: 2*SizeConfig.heightMultiplier),
                    child: new Row(
                      children: <Widget>[
                        Text(
                            'Tutorials  Attended: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 2.7*SizeConfig.textMultiplier)),
                        Text(
                          '$att_tut'+'/'+'$total_tut'
                          ,style: TextStyle(fontSize: 2.4*SizeConfig.textMultiplier,fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ):
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 5.7*SizeConfig.textMultiplier),
                    child: new Row(
                      children: <Widget>[
                        Text(
                            'Total  Attendance: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 2.7*SizeConfig.textMultiplier)),
                        Text(
                          '${(cnt/tot*100).toStringAsFixed(2)} %'
                          ,style: TextStyle(fontSize: 2.4*SizeConfig.textMultiplier,fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.7*SizeConfig.textMultiplier,top: 2*SizeConfig.heightMultiplier),
                    child: new Row(
                      children: <Widget>[
                        Text(
                            'Attended Lectures : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 2.7*SizeConfig.textMultiplier)),
                        Text(
                          '${Attendance.attendanceDataList[index]
                              .attended_lect}/${Attendance.attendanceDataList[index]
                              .total_lect}'
                          ,style: TextStyle(fontSize: 2.4*SizeConfig.textMultiplier,fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.7*SizeConfig.textMultiplier,top: 2*SizeConfig.heightMultiplier),
                    child: new Row(
                      children: <Widget>[
                        Text(
                            'Attended Practicals: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 2.7*SizeConfig.textMultiplier)),
                        Text(
                          '${Attendance.attendanceDataList[index]
                              .attended_pract}/${Attendance.attendanceDataList[index]
                              .total_pract}'
                          ,style: TextStyle(fontSize: 2.4*SizeConfig.textMultiplier,fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.7*SizeConfig.textMultiplier,top: 2*SizeConfig.heightMultiplier),
                    child: new Row(
                      children: <Widget>[
                        Text(
                            'Attended Tutorials: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 2.7*SizeConfig.textMultiplier)),
                        Text(
                          '${Attendance.attendanceDataList[index]
                              .attended_tut}/${Attendance.attendanceDataList[index]
                              .total_tut}'
                          ,style: TextStyle(fontSize: 2.4*SizeConfig.textMultiplier,fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              )
//
            ],
          ),
        )
    ) ;

  }

//Progress bar :
}