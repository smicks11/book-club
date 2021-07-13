import 'package:book_club/models/userModel.dart';
import 'package:book_club/provider/Userprovider.dart';
import 'package:book_club/screens/Homescreen/curatedtimetable.dart';
import 'package:book_club/screens/pageview.dart';
// import 'package:book_club/screens/pageview.dart';
import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final String name;
  const HomePage({Key key, this.name = ""}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserProvider userProvider;
  List _read = ["Morning", "Evening","Both"];
  String _firstSelectedOption;
  String _secondSelectedOption;
  String _thirdSelectedOption;

  List _time = ["Weekdays", "Weekends", "Both"];
  List getTime;
  List _timeTable = ["Yes", "No, i will do it myself"];
  String weekDaysFrame = "Mon Tue Wed Thur Fri";
  String weekendsFrame = "Sat Sun";

  String convertFirstSelect;
  String convertSecondSelect;
  String convertThirdSelect;
  String readingSession = null;
  String readingDays = '';

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).getUserData(context);
    });
  }

  updateUserData() async{
    User currentUser = FirebaseAuth.instance.currentUser;
    print(currentUser.uid);
    var courses = await FirebaseFirestore.instance.collection("User").doc(currentUser.uid).update({
      "readingSession": readingSession.toLowerCase(),
      "readingDays": readingDays.toLowerCase()
    }).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => PageViewScreen()));
    });
  }
  Widget _buildHeader() {
    List<UserModel> userModel = userProvider.userModelList;
    return Container(
      alignment: Alignment.center,
      //height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      decoration: BoxDecoration(
        color: buttonColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: userModel.map((e) {
          //String name = fullNames[0];
          return Column(
            children: [
              CustomText(
                  text: "Hi ${e.fullName == '' ?  widget.name : e.fullName.split(" ")[0]} 🥳",
                  size: 20,
                  color: white,
                  weight: FontWeight.w500),
              CustomText(
                  text: "Personalize Your Study Habit",
                  size: 17,
                  color: Color(0xff7088e8),
                  weight: FontWeight.w400),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _firstOption() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _read.map((e) {
          return GestureDetector(
            onTap: () {
              setState(() {
                readingSession = e;
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: 65,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: readingSession == e ? buttonColor : white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: CustomText(
                text: e,
                size: 14,
                color: readingSession == e ? white : buttonColor,
                weight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _secondOption() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _time.map((e) {
          return GestureDetector(
            onTap: () {
              setState(() {
                readingDays = e;
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: 65,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: readingDays == e ? buttonColor : white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: CustomText(
                text: e,
                size: 14,
                color: readingDays == e ? white : buttonColor,
                weight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _thirdOption() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _timeTable.map((e) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _thirdSelectedOption = e;
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: 65,
              width: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                color: _thirdSelectedOption == e ? buttonColor : white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: CustomText(
                text: e,
                size: 14,
                color: _thirdSelectedOption == e ? white : buttonColor,
                weight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // bool _selectedOptions = false;

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: true);

    userProvider.getUserData(context);
    return Material(
      color: buttonColor,
      child: Container(
        height: MediaQuery.of(context).size.height * 1.0,
        child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: _buildHeader()),
            Container(
              color: backgroundColor,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 32, left: 24, right: 24),
                    height: 120,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                            text: "When best do you read?",
                            size: 16,
                            color: primaryTextColor,
                            weight: FontWeight.w500),
                        SizedBox(
                          height: 20,
                        ),
                        _firstOption(),
                        // _read(firstText: "Morning", secondText: "Evening"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 120,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                            text: "Choose Preferable time",
                            size: 16,
                            color: primaryTextColor,
                            weight: FontWeight.w500),
                        SizedBox(
                          height: 20,
                        ),
                        _secondOption(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 20),
                  //   height: MediaQuery.of(context).size.height * 0.2,
                  //   width: double.infinity,
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       CustomText(
                  //           text:
                  //               "Would you like us to help you curate your timetable?",
                  //           size: 16,
                  //           color: primaryTextColor,
                  //           weight: FontWeight.w500),
                  //       SizedBox(
                  //         height: 20,
                  //       ),
                  //       _thirdOption(),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: readingSession == null ? null : () {
                      updateUserData();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 60,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomText(
                        text: "Done",
                        size: 17,
                        weight: FontWeight.w400,
                        color: white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
