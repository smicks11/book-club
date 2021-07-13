import 'package:book_club/models/userModel.dart';
import 'package:book_club/provider/Userprovider.dart';
import 'package:book_club/provider/onBoarding.dart';
import 'package:book_club/screens/Auth/SignIn_Page.dart';
import 'package:book_club/screens/Homescreen/Profile.dart';
import 'package:book_club/screens/Homescreen/notifications.dart';
import 'package:book_club/screens/Homescreen/preferences.dart';
import 'package:book_club/screens/Library/library.dart';
import 'package:book_club/screens/Study/study.dart';
import 'package:book_club/screens/Study/studyDetail.dart';
import 'package:book_club/screens/Study/studyGroupInvite.dart';
import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
import 'package:book_club/shared/tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CuratedTimeTable extends StatefulWidget {
  const CuratedTimeTable({Key key}) : super(key: key);

  @override
  _CuratedTimeTableState createState() => _CuratedTimeTableState();
}

class _CuratedTimeTableState extends State<CuratedTimeTable>{
  TimeTableProvider timeTableProvider;
  List days = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'];
  List weekdays = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri'];
  List weekends = ['Sat', 'Sun'];
  String selectedDay = 'Mon';
  String selectDay = '';

  List monday = [];
  List tuesday =[];
  List mon, tue,wed,thur,fri,sat,sun =[""];
  StateSetter ttTable;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).getUserData(context);
      getstudyTimetable();
    });
    initDynamicLinks();
  }


  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink.link;
          if (deepLink != null) {
            print('this is the deeplink for null');
            //print(deepLink.path);
            print(deepLink.queryParameters['id']);
            // Navigator.pushNamed(context, '/invite', arguments: deepLink.queryParameters['id']);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => StudyInvite(id:deepLink.path),
              ),
            );
          }
        }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      print('this is the deeplink');
      print(deepLink.queryParameters['id']);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (BuildContext context) => StudyInvite(id:deepLink.queryParameters['id']),
      //   ),
      // );
      Navigator.pushNamed(context, '/invite', arguments: deepLink.queryParameters['id']);
    }

    // if(deepLink.path = '')
  }

  Future getstudyTimetable() async {
    var instance = FirebaseFirestore.instance;
    CollectionReference study = instance.collection('Timetable');
    QuerySnapshot snapshot = await study.doc('study')
        .get()
        .then((value) { // ignore: missing_return
      Map<String, dynamic> data = new Map<String, dynamic>.from(value.data());
      setState(() {
        mon = data['monday'];
        tue = data['tuesday'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: true);
    user.getUserData(context);
    final study = Provider.of<TimeTableProvider>(context, listen: true);

    //List<UserModel> getName = Provider.of<UserProvider>(context);
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
                                        onTap: () async {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      Profile()));
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Text(
                                            '${user.userModel.fullName.split("")[0][0]}${user.userModel.fullName.split(" ")[1][0]}',
                                            style: TextStyle(
                                                color: buttonColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
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
                                  children: (user.userModel.readingDays
                                          .contains('weekend'))
                                      ? weekends
                                          .map((e) => GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedDay = e;
                                                    selectDay = e;
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
                                                    selectDay = e;
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
                          child:
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Timetable(
                                  course: '${mon[0]['courseCode']}',
                                  time: '${mon[0]['time']} AM',
                                ),
                                Container(
                                  height: 60,
                                  width: 0.6,
                                  color: HexColor('E4E7F1'),
                                ),
                                Timetable(
                                  course: '${mon[1]['courseCode']}',
                                  time: '${mon[1]['time']} PM',
                                ),
                              ]
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
