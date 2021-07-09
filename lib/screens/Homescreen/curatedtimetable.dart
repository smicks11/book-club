import 'package:book_club/models/userModel.dart';
import 'package:book_club/provider/Userprovider.dart';
import 'package:book_club/provider/onBoarding.dart';
import 'package:book_club/screens/Auth/SignIn_Page.dart';
import 'package:book_club/screens/Homescreen/notifications.dart';
import 'package:book_club/screens/Homescreen/preferences.dart';
import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
import 'package:book_club/shared/tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CuratedTimeTable extends StatefulWidget {
  const CuratedTimeTable({Key key}) : super(key: key);

  @override
  _CuratedTimeTableState createState() => _CuratedTimeTableState();
}

class _CuratedTimeTableState extends State<CuratedTimeTable> {
  TimeTableProvider timeTableProvider;
  List days = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'];
  List weekdays = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri'];
  List weekends = ['Sat', 'Sun'];
  String selectedDay = 'Mon';

  List timetable = [];
  StateSetter ttTable;

  @override
  void initState() {
    getTimetable();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).getUserData(context);
      //Provider.of<TimeTableProvider>(context, listen: false).getStudyTimeTable(context);
    });
    super.initState();
  }

  Future<List> getTimetable() async {
    List timetableList = [];
    final timetables = FirebaseFirestore.instance.collection('Timetable');
    timetables.get().then((querySnapshot) {
      final timeTableData = querySnapshot.docs.map((doc) => doc.data());
      timetableList.add(timeTableData);
    });
    return timetableList;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: true);
    final study = Provider.of<TimeTableProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: buttonColor,
      body: SafeArea(
        child: Container(
          color: backgroundColor,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 350,
                  child: Stack(
                    children: [
                      Container(
                        height: 300.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: buttonColor,
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 20),
                              child: Row(
                                children: [
                                  CustomText(
                                      text: "Timetable",
                                      size: 24,
                                      color: white,
                                      letterspacing: 2,
                                      weight: FontWeight.w500),
                                  Spacer(),
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        Preferences()));
                                          },
                                          child: SvgPicture.asset(
                                            'assets/svg/settings.svg',
                                          )),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      GestureDetector(
                                        onTap: () async{
                                          await FirebaseAuth.instance.signOut();
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                                              builder: (ctx) => SignInPage()));
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Text(
                                            '${user.userModel.fullName.split("")[0][0]}${user.userModel.fullName.split("")[1][0]}',
                                            style: TextStyle(
                                                color: buttonColor,
                                                fontSize: 14),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            TabSelect(firstTab: 'Study', secondTab: 'Class'),
                            SizedBox(
                              height: 24,
                            ),
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: (user.userModel.readingDays.contains('weekend'))
                                      ? weekends
                                          .map((e) => GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedDay = e;
                                                  });
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      color: selectedDay == e
                                                          ? HexColor('001E97')
                                                          : Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              32.0)),
                                                  child: CustomText(
                                                      text: e,
                                                      size: 13,
                                                      color: white,
                                                      letterspacing: 2,
                                                      weight: FontWeight.w500),
                                                ),
                                              ))
                                          .toList()
                                      : weekdays
                                          .map((e) => GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedDay = e;
                                                  });
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      color: selectedDay == e
                                                          ? HexColor('001E97')
                                                          : Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              32.0)),
                                                  child: CustomText(
                                                      text: e,
                                                      size: 13,
                                                      color: white,
                                                      letterspacing: 2,
                                                      weight: FontWeight.w500),
                                                ),
                                              ))
                                          .toList(),
                                )),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 20,
                        left: 20,
                        bottom: 0,
                        child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),

                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Timetable(
                                    course: 'CSC 203',
                                    time: '05 AM - 07 PM',
                                  ),
                                  Container(
                                    height: 60,
                                    width: 0.6,
                                    color: HexColor('E4E7F1'),
                                  ),
                                  Timetable(
                                    course: 'CSC 203',
                                    time: '05 AM - 07 PM',
                                  )
                                ]


                                //

                                //

                                ),
                            ),
                      )
                    ],
                  )),
              SizedBox(
                height: 44,
              ),
              Notifications()
            ],
          ),
        ),
      ),
    );
  }
}

class Timetable extends StatelessWidget {
  final String course;
  final String time;
  const Timetable({
    @required this.course,
    @required this.time,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
              text: course,
              size: 20,
              color: HexColor('1C1C1C'),
              letterspacing: 2,
              weight: FontWeight.w500),
          SizedBox(
            height: 20,
          ),
          CustomText(
              text: time,
              size: 12,
              color: HexColor('1C1C1C'),
              letterspacing: 2,
              weight: FontWeight.w500),
        ]);
  }
}
