import 'package:flutter/material.dart';

class TutorialModel with ChangeNotifier {
  final String courseCode;
  final String location;
  final String when;


  TutorialModel(
      { this.courseCode,this.location,this.when});
}
