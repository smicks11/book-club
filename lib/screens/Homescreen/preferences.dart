import 'package:book_club/provider/Userprovider.dart';
import 'package:book_club/provider/onBoarding.dart';
import 'package:book_club/shared/button.dart';
import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Preferences extends StatefulWidget {
  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  // TimeTableProvider timeTableProvider;
  List days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  List weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  List weekends = ['Sat', 'Sun'];
  String selectedDay =
      DateFormat(DateFormat.ABBR_WEEKDAY).format(DateTime.now());
  String selectDay = DateFormat(DateFormat.ABBR_WEEKDAY).format(DateTime.now());

  List monday = [];
  List tuesday = [];
  List wednesday = [];
  List thursday = [];
  List friday = [];
  List saturday = [];
  List mon, tue, wed, thur, fri, sat, sun = [" "];
  DateTime date = DateTime.now();
  // DateTime dateTime = DateTime.now();
  // List days = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'];
  // String selectedDay =
  //     DateFormat(DateFormat.ABBR_WEEKDAY).format(DateTime.now());
  String selectedMorningValueCourse;
  String selectedEveningValueCourse;
  List<String> courseList = [
    "CSC 320",
    "CSC 310",
    "CSC 330",
    "CSC 300",
    "CSC 220"
  ];

  Future getstudyTimetable() async {
    var instance = FirebaseFirestore.instance;
    CollectionReference study = instance.collection('Timetable');
    QuerySnapshot snapshot = await study.doc('study').get().then((value) {
      // ignore: missing_return
      Map<String, dynamic> data = new Map<String, dynamic>.from(value.data());
      setState(() {
        mon = data['monday'];
        tue = data['tuesday'];
        wed = data['Wednesday'];
        thur = data['thursday'];
        fri = data['friday'];
        sat = data['saturday'];
        sun = data['sunday'];
      });
    });
  }

  Future updatestudyTimetable() async {
    List<Map<String, dynamic>> updatedList = [];
    Map<String, dynamic> updatedData = {
      'monday': updatedList,
    };
    var instance = FirebaseFirestore.instance;
    CollectionReference updateStudy = instance.collection('Timetable');

    updateStudy.doc('study').update({

    });
  }

  @override
  void initState() {
    super.initState();
    getstudyTimetable();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: true);
    user.getUserData(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(context);
                  },
                  child: Icon(Icons.arrow_back)),
              SizedBox(height: 24),
              CustomText(
                  text: 'Preferences', size: 24, color: HexColor('0F193B')),
              SizedBox(height: 32),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: (user.userModel.readingDays.contains('weekend'))
                        ? weekends
                            .map((e) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedDay = e;
                                      selectDay = e;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: selectedDay == e
                                            ? buttonColor
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(32.0)),
                                    child: CustomText(
                                        text: e,
                                        size: 13,
                                        color: primaryTextColor,
                                        letterspacing: 2,
                                        weight: FontWeight.w500),
                                  ),
                                ))
                            .toList()
                        : weekdays
                            .map((e) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      // if(selectedDay.contains(DateFormat('EEEE').format(date).toString())){
                                      //   return selectedDay = e;
                                      // }
                                      // do {
                                      //   selectedDay = e;
                                      // } while (
                                      //   DateFormat('EEEE').format(date).contains(selectedDay)
                                      // );

                                      selectedDay = e;
                                      selectDay = e;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        // DateFormat('EEEE').format(date).contains(e)
                                        color: selectedDay == e
                                            ? buttonColor
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(32.0)),
                                    child: CustomText(
                                        text: e,
                                        size: 13,
                                        color: selectedDay == e
                                            ? white
                                            : primaryTextColor,
                                        letterspacing: 2,
                                        weight: FontWeight.w500),
                                  ),
                                ))
                            .toList(),
                  )),
              // DefaultTabController(
              //     length: days.length,
              //     child: Center(
              //       child: Container(
              //           child: TabBar(
              //               indicator: BubbleTabIndicator(
              //                   tabBarIndicatorSize: TabBarIndicatorSize.label,
              //                   indicatorHeight: 40.0,
              //                   indicatorColor: buttonColor),
              //               labelStyle: TextStyle(
              //                 fontSize: 10.0,
              //               ),
              //               labelColor: Colors.white,
              //               unselectedLabelColor: HexColor('656565'),
              //               isScrollable: true,
              //               tabs: days
              //                   .map((e) => Container(
              //                           child: Text(
              //                         e,
              //                         style: TextStyle(fontSize: 12),
              //                       )))
              //                   .toList())),
              //     )),
              SizedBox(
                height: 56,
              ),
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          text: 'Morning Session',
                          size: 16,
                          color: HexColor('0F193B')),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: DropdownButton(
                          isExpanded: true,
                          hint: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              selectedDay.contains('Mon')
                                  ? '${mon[0]['courseCode']}'
                                  : selectedDay.contains('Tue')
                                      ? '${tue[0]['courseCode']}'
                                      : selectedDay.contains('Wed')
                                          ? '${wed[0]['courseCode']}'
                                          : selectedDay.contains('Thu')
                                              ? '${thur[0]['courseCode']}'
                                              : selectedDay.contains('Fri')
                                                  ? '${fri[0]['courseCode']}'
                                                  : '',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          value: selectedMorningValueCourse,
                          items: courseList.map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: primaryTextColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedMorningValueCourse = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          text: 'Evening Session',
                          size: 16,
                          color: HexColor('0F193B')),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: DropdownButton(
                          isExpanded: true,
                          hint: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              selectedDay.contains('Mon')
                                  ? '${mon[1]['courseCode']}'
                                  : selectedDay.contains('Tue')
                                      ? '${tue[1]['courseCode']}'
                                      : selectedDay.contains('Wed')
                                          ? '${wed[1]['courseCode']}'
                                          : selectedDay.contains('Thu')
                                              ? '${thur[1]['courseCode']}'
                                              : selectedDay.contains('Fri')
                                                  ? '${fri[1]['courseCode']}'
                                                  : '',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          value: selectedEveningValueCourse,
                          items: courseList.map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: primaryTextColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedEveningValueCourse = value;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () async {
                  // var instance = FirebaseFirestore.instance;
                  // CollectionReference study = instance.collection('Timetable');
                  // study.doc('study').update({

                  // })

                  // QuerySnapshot snapshot = await study.doc('study').get().then((value) {
                },
                child: button(
                  text: 'Update',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
