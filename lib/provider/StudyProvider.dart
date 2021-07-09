import 'package:book_club/models/studyGroup.dart';
import 'package:book_club/models/tutorialModel.dart';
import 'package:book_club/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class StudyProvider with ChangeNotifier {
  List<TutorialModel> tutorialModelList = [];
  List<StudyGroupModel> studyGroupModelList = [];

  TutorialModel tutorialModel;

  StudyGroupModel studyGroupModel;


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

  Future<void> getStudyGroup (BuildContext context) async {
    List<StudyGroupModel> newStudyGroupList = [];
    //User currentUser = FirebaseAuth.instance.currentUser;

    QuerySnapshot studyGroupSnapShots =
    await FirebaseFirestore.instance.collection("studyGroup").get().where('age', isGreaterThan: 20);
    studyGroupSnapShots.docs.forEach((element) {
      studyGroupModel = StudyGroupModel(
        courseCode: element.get("courseCode"),
        location: element.get("location"),
        when: element.get("when"),
        userID: element.get('userID')
      );
      newStudyGroupList.add(studyGroupModel);

      studyGroupModelList = newStudyGroupList;
      // print(userModelList);
    });

    notifyListeners();
  }

  List<TutorialModel> get getTutorialModelList {
    return tutorialModelList;
  }

  List<StudyGroupModel> get getStudyGroupModelList {
    return studyGroupModelList;
  }
}
