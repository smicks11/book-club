import 'package:book_club/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  List<UserModel> userModelList = [];

  UserModel userModel;

  //Get User Data From Firebase

  Future<String> getUserData(BuildContext context) async {
    List<UserModel> newUserList = [];
    User currentUser = FirebaseAuth.instance.currentUser;

    QuerySnapshot userSnapShots =
        await FirebaseFirestore.instance.collection("User").get();
    userSnapShots.docs.forEach((element) {
      if (currentUser.uid == element.get("UserId")) {
        userModel = UserModel(
            fullName: element.get("fullName"),
            dept: element.get("Dept"),
            level: element.get("Level"),
            userID: element.get("UserId"),
            email: element.get("UserEmail"),
            readingDays: element.get("readingDays"),
            admin:element.get("admin"),
            readingSession: element.get('readingSession'));
        newUserList.add(userModel);
      }
      userModelList = newUserList;
      // print(userModelList);
    });

    notifyListeners();
  }

  List<UserModel> get getUserModelList {
    return userModelList;
  }
}
