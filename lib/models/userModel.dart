import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  final String fullName;
  final String userID;
  final String level;
  final String email;
  final String dept;
  final String readingSession;
  final String readingDays;
  final bool admin;

  UserModel(
      {this.fullName, this.admin, this.readingDays, this.readingSession, this.userID, this.level, this.email, this.dept});
}
