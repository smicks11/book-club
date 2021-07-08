import 'package:book_club/models/tutorialModel.dart';
import 'package:book_club/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class StudyProvider with ChangeNotifier {
  List<TutorialModel> tutorialModelList = [];

  TutorialModel tutorialModel;

  //Get User Data From Firebase

  Future<void> getTutorial (BuildContext context) async {
    List<TutorialModel> newTutorialList = [];
    //User currentUser = FirebaseAuth.instance.currentUser;

    QuerySnapshot tutorialSnapShots =
    await FirebaseFirestore.instance.collection("Tutorial").get();
    tutorialSnapShots.docs.forEach((element) {
        tutorialModel = TutorialModel(
            courseCode: element.get("courseCode"),
            location: element.get("location"),
          when: element.get("when"),
        );
        newTutorialList.add(tutorialModel);

        tutorialModelList = newTutorialList;
      // print(userModelList);
    });

    notifyListeners();
  }

  List<TutorialModel> get getTutorialModelList {
    return tutorialModelList;
  }
}
