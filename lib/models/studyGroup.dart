import 'package:flutter/material.dart';

class StudyGroupModel with ChangeNotifier {
  final String courseCode;
  final String location;
  final String when;
  final String userID;


  StudyGroupModel(
      { this.courseCode,this.location,this.when,this.userID});
}
