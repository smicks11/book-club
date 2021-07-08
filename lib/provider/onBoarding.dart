import 'package:book_club/models/timetable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class TimeTableProvider with ChangeNotifier {
  List<TimeTableModel> timeTableModelList = [];

  TimeTableModel timeTableModel;

  //Get User Data From Firebase

  // Future<void> getTimeTableData() async {
  //   List<TimeTableModel> newTimeTableList = [];
  //   User currentUser = FirebaseAuth.instance.currentUser;
  //
  //   QuerySnapshot userSnapShots = await FirebaseFirestore.instance.collection("User").get();
  //   QuerySnapshot timetableSnapShots = await FirebaseFirestore.instance.collection("Timetable").get();
  //   userSnapShots.docs.forEach((element) {
  //     if (currentUser.uid == element.get("UserId")) {
  //       timeTableModel = TimeTableModel(
  //         monday: element.get("Monday"),
  //         tuesday: element.get("tuesday"),
  //       );
  //       newTimeTableList.add(timeTableModel);
  //     }
  //     timeTableModelList = newTimeTableList;
  //     // print(userModelList);
  //   });
  //
  //   notifyListeners();
  // }

  List<TimeTableModel> get getTimeTableModelList {
    return timeTableModelList;
  }
}
