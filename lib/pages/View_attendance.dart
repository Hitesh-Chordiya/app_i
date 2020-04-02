import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/pages/AttendanceData.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final List<AttendanceData> attendanceDataList = List<AttendanceData>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String roll_no = '2';
    String class_name = "TE1";

    int attended_lect;
    int total_lect;
    int attended_pract;
    int total_pract;
    String subject;

    databaseReference
        .child('Attendance')
        .child("Class")
        .child(class_name)
        .once()
        .then((snapshot) {
      Map data = snapshot.value;
      for (final key in data.keys) {
        Map subjectData = data[key];
        subject = key.toString();
        attended_lect = 0;
        total_lect = 0;
        attended_pract = 0;
        total_pract = 0;

        for (final key in subjectData.keys) {
          Map TeacherData = subjectData[key];
          for (final key in TeacherData.keys) {
            Map DateWiseData = TeacherData[key];

            // retriving lecture Attendance
            try{
              Map lectureData = DateWiseData['lecture']; // Lecture
              total_lect += int.parse(lectureData['leccount'].toString());

              int lect_held =  int.parse(lectureData['leccount'].toString());

              for (int i=1;i<= lect_held;i++) {
                String key=i.toString();
                Map SessionData = lectureData[key]; // Lecture
                try {
                  Map StudentData = SessionData[roll_no]; //student info
                  attended_lect +=
                      int.parse(StudentData['Attended'].toString());
                } catch (Exception) {}
              } // for - per Session
            } //try
            catch (Exception) {}

            //retriving Pract Attendance

            try{
              Map PracticalData = DateWiseData['Practical']; // Lecture
              total_pract += int.parse(PracticalData['practcount'].toString());
              int pract_held =  int.parse(PracticalData['practcount'].toString());

              for (int i=1;i<= pract_held;i++) {
                String key=i.toString();
                Map SessionData = PracticalData[key]; // Lecture
                try {
                  Map StudentData = SessionData[roll_no]; //student info
                  attended_pract +=
                      int.parse(StudentData['Attended'].toString());
                } catch (Exception) {}
              } // for - per Session
            } //try
            catch (Exception) {}

          } //for - per Teacher
        } //for - per Subject


        print(subject+" : ");
        print(attended_lect.toString()+" out of "+total_lect.toString());
        print(attended_pract.toString()+" out of "+total_pract.toString());

        AttendanceData a = new AttendanceData(
            subject, total_lect, attended_lect, total_pract, attended_pract);
        attendanceDataList.add(a);
      } //all data
    });
  }

  @override
  Widget build(BuildContext context) {
    double TotalAttendance = 0;

    try {
      for (int i = 0; i < attendanceDataList.length; i++) {
        TotalAttendance += (attendanceDataList[i].total_attendance /
            attendanceDataList.length);
      }
    } catch (Exception) {}

    return Scaffold(
        appBar: AppBar(
          title: Text('AppName'),
        ),

        body: SingleChildScrollView(
          child: Container(
            child: attendanceDataList.length == 0
                ? ProgressBar()
                : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                AttendancePieChart(attendanceDataList),

                Text(
                  'Total Attendance : ${TotalAttendance.round()} %',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                TableUI(),

              ],
            ),
          ),
        )

    );
  }


// Table :
  Widget TableUI() {
    List<TableRow> tableRows = [];
    tableRows.add(TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Subject',
          style: TextStyle( fontSize: 20,),
          textAlign: TextAlign.start,
        ),
      ),

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Attended lectures' ,
          style: TextStyle( fontSize: 20,),
          textAlign: TextAlign.start,
        ),
      ),

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Total lectures',
          style: TextStyle( fontSize: 20,),
          textAlign: TextAlign.start,
        ),
      ),

    ]));

    for(int i=0; i<attendanceDataList.length;i++)
    {
      tableRows.add(TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(attendanceDataList[i].subjectName,
            style: TextStyle( fontSize: 20,),
            textAlign: TextAlign.start,
          ),
        ),


        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(attendanceDataList[i].attended_lectures.toString(),
            style: TextStyle( fontSize: 20,),
            textAlign: TextAlign.start,
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(attendanceDataList[i].total_lect.toString(),
            style: TextStyle( fontSize: 20,),
            textAlign: TextAlign.start,
          ),
        ),

      ]));
    }

    return new Table(
      border: TableBorder(
          horizontalInside: new BorderSide(color: Colors.grey[600], width: 1)
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: tableRows,


    );
  }

//Pie Chart Class :
  Widget AttendancePieChart(List<AttendanceData> attendanceDataList) {
    List<PieChartSectionData> _sections = List<PieChartSectionData>();
    List<AttendanceData> data = List<AttendanceData>();
    double AttendanceCounter = 0;

    for (int i = 0; i < attendanceDataList.length; i++) {
      AttendanceCounter +=
      (attendanceDataList[i].total_attendance / attendanceDataList.length);
      PieChartSectionData _item = PieChartSectionData(
        color: attendanceDataList[i].total_attendance > 75
            ? Colors.green[400]
            : Colors.orange,
        value: (attendanceDataList[i].total_attendance /
            attendanceDataList.length),
        title: '${attendanceDataList[i].subjectName}',
        radius: 50,
        titleStyle: TextStyle(color: Colors.white, fontSize: 15),
      );
      _sections.add(_item);
    }

    if (AttendanceCounter < 100) {
      PieChartSectionData _item = PieChartSectionData(
        color: Colors.red,
        value: (100 - AttendanceCounter),
        title: 'Absent',
        radius: 50,
        titleStyle: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      );
      _sections.add(_item);
    }

    return Container(
        child: AspectRatio(
            aspectRatio: 1,
            child: FlChart(
                chart: PieChart(
                  PieChartData(
                    sections: _sections,
                    borderData: FlBorderData(show: false),
                    centerSpaceRadius: 60,
                    sectionsSpace: 1,
                  ),
                ))));
  }


//Progress bar :
  Widget ProgressBar() {
    return Container(
        width: 100,
        height: 100,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              backgroundColor: Colors.cyan,
              strokeWidth: 10,
            ),
          ),
        ));
  }


}