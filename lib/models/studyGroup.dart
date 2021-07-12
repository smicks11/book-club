// import 'package:flutter/material.dart';

class StudyGroupModel {
  final String courseCode;
  final String location;
  final String when;
  final String userID;
  final String id;
  final ForumModel forum;

  StudyGroupModel({this.forum,this.id,
      this.courseCode, this.location, this.when, this.userID});
}

class ForumModel {
  final String comment;
  final String userId;

  ForumModel({this.comment, this.userId});
}
