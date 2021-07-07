import 'package:book_club/controller/app_controller.dart';
import 'package:book_club/models/userModel.dart';
import 'package:book_club/provider/Userprovider.dart';
import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final String name;
  const HomePage({Key key, this.name = ""}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppController _appController = Get.find();
  UserProvider userProvider;

 // bool _selectedOptions = false;

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
                  text: "Hi ${widget.name.split(" ")[0]} 🥳",
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

  Widget _read({String firstText, String secondText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: _appController.changeToMorning(),
          child: Container(
            alignment: Alignment.center,
            height: 65,
            width: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: _appController.morning.value == true ? buttonColor : white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: CustomText(
              text: firstText,
              size: 14,
              color: _appController.morning.value ? white : buttonColor,
              weight: FontWeight.w500,
            ),
          ),
        ),
        GestureDetector(
          onTap: _appController.changeToEvening(),
          child: Container(
            alignment: Alignment.center,
            height: 65,
            width: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: _appController.evening.value ? buttonColor : white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: CustomText(
              text: secondText,
              size: 14,
              color: _appController.evening.value ? white : buttonColor,
              weight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }

  Widget _time({String firstText, String secondText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: _appController.changeToWeekdays(),
          child: Container(
            alignment: Alignment.center,
            height: 65,
            width: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: _appController.weekdays.value == true ? buttonColor : white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: CustomText(
              text: firstText,
              size: 14,
              color: _appController.weekdays.value ? white : buttonColor,
              weight: FontWeight.w500,
            ),
          ),
        ),
        GestureDetector(
          onTap: _appController.changeToWeekends(),
          child: Container(
            alignment: Alignment.center,
            height: 65,
            width: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: _appController.weekends.value ? buttonColor : white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: CustomText(
              text: secondText,
              size: 14,
              color: _appController.weekends.value ? white : buttonColor,
              weight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }

  Widget _timetable({String firstText, String secondText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: _appController.changeToYes(),
          child: Container(
            alignment: Alignment.center,
            height: 65,
            width: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: _appController.yes.value == true ? buttonColor : white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: CustomText(
              text: firstText,
              size: 14,
              color: _appController.yes.value ? white : buttonColor,
              weight: FontWeight.w500,
            ),
          ),
        ),
        GestureDetector(
          onTap: _appController.changeToNo(),
          child: Container(
            alignment: Alignment.center,
            height: 65,
            width: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: _appController.no.value ? buttonColor : white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: CustomText(
              text: secondText,
              size: 14,
              color: _appController.no.value ? white : buttonColor,
              weight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    userProvider.getUserData();
    return Material(
      color: buttonColor,
      child: Container(
        height: MediaQuery.of(context).size.height * 1.0,
        child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: _buildHeader()),
            Obx(
              () => Container(
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
                          _read(firstText: "Morning", secondText: "Evening"),
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
                          _time(firstText: "Weekdays", secondText: "Weekends")
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                              text:
                                  "Would you like us to help you curate your timetable?",
                              size: 16,
                              color: primaryTextColor,
                              weight: FontWeight.w500),
                          SizedBox(
                            height: 20,
                          ),
                          _timetable(
                              firstText: "Yes",
                              secondText: "No, i will do it myself")
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
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
            ),
          ],
        ),
      ),
    );
  }
}
