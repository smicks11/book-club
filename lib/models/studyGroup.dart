// import 'package:flutter/material.dart';

class StudyGroupModel {
  final String courseCode;
  final String location;
  final String when;
  final String userID;
  final String id;
  final ForumModel forum;
  final List members;

  StudyGroupModel({this.forum,this.id,this.members,
      this.courseCode, this.location, this.when, this.userID});
}

class ForumModel {
  final String comment;
  final String userId;

  ForumModel({this.comment, this.userId});
}
