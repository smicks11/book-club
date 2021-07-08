import 'package:flutter/cupertino.dart';

class TimeTableModel with ChangeNotifier{
  final String study;

  TimeTableModel({this.study});


  TimeTableModel.fromJson(Map<String, dynamic> json):study = json['study'];


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> studyTable = new Map<String, dynamic>();
    studyTable['study'] = this.study;

    return studyTable;
  }
  String toString() {
    return 'Study{study: $study';
  }

}