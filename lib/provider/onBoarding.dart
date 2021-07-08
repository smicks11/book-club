import 'package:book_club/models/timetable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TimeTableProvider with ChangeNotifier {
  List<TimeTableModel> ttModelList = [];

  TimeTableModel ttModel;

  //Get User Data From Firebase

  Future<Map<String,dynamic>> getTimeTableData(BuildContext context) async {
    List<TimeTableModel> newttList = [];
    // User currentUser = FirebaseAuth.instance.currentUser;

    QuerySnapshot timetableSnapShots = await FirebaseFirestore.instance.collection("Timetable").get();
        timetableSnapShots.docs.forEach((element) {
           ttModel = TimeTableModel(
            study: element.get("monday"),
        );
        newttList.add(ttModel);
      ttModelList = newttList;
    }) as Map;

    notifyListeners();
  }

  List<TimeTableModel> get getTimeTableModelList {
    return ttModelList;
  }
}
