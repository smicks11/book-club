import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  final String fullName;
  final String matricNumber;
  final String level;
  final String email;
  final String dept;

  UserModel(
      {this.fullName, this.matricNumber, this.level, this.email, this.dept});
}
