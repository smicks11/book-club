import 'package:book_club/models/timetable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TimeTableProvider with ChangeNotifier {
  List<TimeTableModel> timeTableModelList = [];

  TimeTableModel timeTableModel;

  //Get User Data From Firebase

  Future<void> getTimeTableData() async {
    List<TimeTableModel> newTimeTableList = [];
    // User currentUser = FirebaseAuth.instance.currentUser;

    QuerySnapshot timeTableSnapShots = await FirebaseFirestore.instance
        .collection("Timetable")
        .doc("QrEYKPwlEDEITXhCvLi1")
        .collection("DaySessions")
        .get();

    // print(FirebaseFirestore.instance.collection("Timetable").doc("QrEYKPwlEDEITXhCvLi1").collection("DaySessions").get());

    timeTableSnapShots.docs.forEach((element) {
      timeTableModel = TimeTableModel(
        
      );

      print(element.get("time"));

      newTimeTableList.add(timeTableModel);

      timeTableModelList = newTimeTableList;
    });

    notifyListeners();
  }

  List<TimeTableModel> get getTimeTableModelList {
    return timeTableModelList;
  }
}
