import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  final String fullName;
  final String matricNumber;
  final String level;
  final String email;
  final String dept;
  final String readingSession;
  final String readingDays;

  UserModel(
      {this.fullName, this.readingDays, this.readingSession, this.matricNumber, this.level, this.email, this.dept});
}
