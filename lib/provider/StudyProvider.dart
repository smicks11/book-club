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
    String docID = '';
    User currentUser = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
        print(user.uid);
      } else {
        print('User is signed in!');
        print(user.uid);
      }
    });
    QuerySnapshot studyGroupSnapShots = await FirebaseFirestore.instance.collection("studyGroup")
      .where('userID', isEqualTo: currentUser.uid)
        .get();

    studyGroupSnapShots.docs.forEach((element) {
      studyGroupModel = StudyGroupModel(
        id: element.id,
        courseCode: element.get("courseCode"),
        location: element.get("location"),
        when: element.get("when"),
       // forum: element.get({"comment": "comment", "userID": "userID"}),
        userID: element.get('userID'),
      );

      newStudyGroupList.add(studyGroupModel);
      studyGroupModelList = newStudyGroupList;

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
