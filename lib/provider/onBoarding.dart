import 'package:book_club/models/timetable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TimeTableProvider with ChangeNotifier {
  List<TimeTableModel> ttModelList = [];

  TimeTableModel ttModel;

  //Get User Data From Firebase

  Future getStudyTimeTable(BuildContext context) async {


  }

  List<TimeTableModel> get getTimeTableModelList {
    return ttModelList;
  }
}
