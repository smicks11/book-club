import 'package:flutter/cupertino.dart';

class TimeTableModel with ChangeNotifier{
  final List study;

  TimeTableModel({this.study});


  TimeTableModel.fromJson(Map<String, dynamic> json):study = json['monday'];


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> studyTable = new Map<String, dynamic>();
    studyTable['monday'] = this.study;

    return studyTable;
  }
  String toString() {
    return 'Study{study: $study';
  }

}