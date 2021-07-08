import 'package:book_club/models/timetable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TimeTableProvider with ChangeNotifier {
  List<TimeTableModel> ttModelList = [];

  TimeTableModel ttModel;

  //Get User Data From Firebase

  // Future<void> getStudyTimeTable(BuildContext context) async {
  //  var instance = FirebaseFirestore.instance;
  //
  //  CollectionReference study = instance.collection('Studies');
  //
  //  DocumentSnapshot snapshot = await study.doc('study').get();
  //  var data = snapshot.data() as Map;
  //  var studyData = data['timetable'] as List<dynamic>;
  //
  //  studyData.forEach((sData){
  //    TimeTableModel table = TimeTableModel.fromJson(sData);
  //    ttModelList.add(table);
  //  });
  //
  // }

  List<TimeTableModel> get getTimeTableModelList {
    return ttModelList;
  }
}
