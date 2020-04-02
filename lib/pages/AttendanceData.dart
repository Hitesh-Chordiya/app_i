class AttendanceData {
  String subjectName;
  int total_lect;
  int attended_lect;
  int total_pract = 0;
  int attended_pract = 0;
  double total_attendance=0.0;

  int get total_lectures => total_lect;
  int get attended_lectures => attended_lect;
  int get total_practicals => total_pract;
  int get attended_practicals => attended_pract;
  String get subject_name => subjectName;

  AttendanceData(subjectName, total_lect, attended_lect,total_pract, attended_pract)
  {
    this.attended_pract=attended_pract;
    this.attended_lect=attended_lect;
    this.total_pract=total_pract;
    this.total_lect=total_lect;
    this.subjectName=subjectName;
    this.total_attendance=((attended_lect+attended_pract)/(total_pract+total_lect))*100;
  }
}
