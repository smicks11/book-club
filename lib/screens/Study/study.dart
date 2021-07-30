import 'package:book_club/provider/StudyProvider.dart';
import 'package:book_club/provider/Userprovider.dart';
import 'package:book_club/screens/Study/studyDetail.dart';
import 'package:book_club/shared/button.dart';
import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:get_time_ago/get_time_ago.dart';

class Study extends StatefulWidget {
  const Study({Key key}) : super(key: key);

  @override
  _StudyState createState() => _StudyState();
}

class _StudyState extends State<Study> with SingleTickerProviderStateMixin {
  @override
  TabController _tabController;
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudyProvider>(context, listen: false).getStudyGroup(context);
      Provider.of<StudyProvider>(context, listen: false).getTutorial(context);
    });
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _form1Key = GlobalKey<FormState>();
  final GlobalKey<FormState> _studyGroupKey = GlobalKey<FormState>();
  String courseCode = 'CSC 320';
  String location = '';
  var datTime;
  StateSetter studyState;

  Future<Uri> createDynamicLink(String id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://funet.page.link',
      link: Uri.parse('https://funet.page.link/?id=$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.book_club',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.example.book_club',
        minimumVersion: '1.0.1',
      ),
    );

    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;
    return shortUrl;
  }

  void validation() async {
    final FormState _form = _form1Key.currentState;
    await Firebase.initializeApp();
    try {
      FirebaseFirestore.instance.collection("Tutorial").add({
        'courseCode': courseCode,
        'location': location,
        'when': datTime
      }).then((value) => print('Created Succesfully'));
      Navigator.of(context).pop();
      // myDialogBox();
    } on PlatformException catch (e) {
      print(e.message.toString());
    }
  }

  void createStudyGroup() async {
    final FormState _form = _studyGroupKey.currentState;
    await Firebase.initializeApp();
    final userData = Provider.of<UserProvider>(context, listen: false);
    try {
      final docRef = FirebaseFirestore.instance.collection("studyGroup").add({
        'userID': userData.userModel.userID,
        'courseCode': courseCode,
        'location': location,
        'when': datTime,
        'meetingDays': selectedDay,
        'members': FieldValue.arrayUnion([
          userData.userModel.userID,
        ])
      }).then((value) {
        Provider.of<StudyProvider>(context, listen: false)
            .getStudyGroup(context);
        showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: "Study Group created successfully",
          ),
        );
        var documentId = value.id;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (ctx) => StudyDetail(
                    courseCode: courseCode,
                    when: datTime,
                    location: location,
                    id: documentId.toString())));
      });

      // myDialogBox();
    } on PlatformException catch (e) {
      print(e.message.toString());
    }
  }

  List<String> courseList = [
    "CSC 320",
    "CSC 310",
    "CSC 330",
    "CSC 300",
    "CSC 220"
  ];

  List<String> daysList = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  String selectedDay = "Monday";

  Widget _buildFields(
      {String labelText,
      Function validator,
      Function onChanged,
      Widget textIcon}) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey[400].withOpacity(0.2),
          borderRadius: BorderRadius.circular(8)),
      child: TextFormField(
        validator: validator,
        onChanged: onChanged,
        style: TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        // controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: textIcon,
          contentPadding: EdgeInsets.only(left: 16),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          labelStyle: TextStyle(
              fontSize: 14,
              color: primaryTextColor,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(timeago.format(datTime));
    // print(GetTimeAgo.parse(datTime));
    final study = Provider.of<StudyProvider>(context, listen: true);
    // study.getStudyGroup(context);
    final user = Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Study',
                style: headerText,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Tutorials happening this week',
                style: caption,
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                height: 50.0,
                margin: const EdgeInsets.symmetric(horizontal: 52),
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TabBar(
                    onTap: (index) {
                      _tabController.animateTo(
                        index,
                      );
                    },
                    controller: _tabController,
                    indicator: BubbleTabIndicator(
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                      indicatorHeight: 40.0,
                      indicatorColor: Colors.white,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 12.0,
                    ),
                    labelColor: buttonColor,
                    unselectedLabelColor: Colors.white,
                    tabs: [
                      Tab(
                        text: 'Tutorials',
                      ),
                      Tab(
                        text: 'Study Groups',
                      ),
                    ]),
              ),
              SizedBox(
                height: 24,
              ),
              Expanded(
                child: TabBarView(controller: _tabController, children: [
                  Scaffold(
                    backgroundColor: backgroundColor,
                    floatingActionButton: Visibility(
                      visible: user.userModel.admin == false ? false : true,
                      child: FloatingActionButton(
                          backgroundColor: buttonColor,
                          child: Icon(Icons.add),
                          elevation: 2.0,
                          onPressed: () => showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) => StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter myState) {
                                    //studyState = setState;
                                    return Material(
                                      child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.8,
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(24.0),
                                            child: ListView(
                                              children: [
                                                Row(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: GestureDetector(
                                                          onTap: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                          child: Icon(Icons
                                                              .arrow_back)),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      'Create Tutorial',
                                                      style: caption.copyWith(
                                                          fontSize: 12,
                                                          color: Colors.black),
                                                    ),
                                                    Spacer()
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 24,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomText(
                                                            text:
                                                                'Choose Course',
                                                            weight:
                                                                FontWeight.w400,
                                                            size: 16,
                                                            color: HexColor(
                                                                '0F193B')),
                                                        SizedBox(
                                                          height: 16,
                                                        ),
                                                        Container(
                                                          height: 60,
                                                          width:
                                                              double.infinity,
                                                          decoration: BoxDecoration(
                                                              color: HexColor(
                                                                  'F0F0F0'),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12)),
                                                          child: DropdownButton(
                                                            isExpanded: true,
                                                            hint: Text(
                                                              "Choose Course",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            value: courseCode,
                                                            items: courseList
                                                                .map((String
                                                                    value) {
                                                              return DropdownMenuItem(
                                                                value: value,
                                                                child: Text(
                                                                  value,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color:
                                                                          primaryTextColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              );
                                                            }).toList(),
                                                            onChanged: (value) {
                                                              studyState(() {
                                                                courseCode =
                                                                    value;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 24,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomText(
                                                            text:
                                                                'Choose Date & Time',
                                                            size: 16,
                                                            weight:
                                                                FontWeight.w400,
                                                            color: HexColor(
                                                                '0F193B')),
                                                        SizedBox(
                                                          height: 16,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            DatePicker.showDateTimePicker(
                                                                context,
                                                                showTitleActions:
                                                                    true,
                                                                onChanged:
                                                                    (date) {},
                                                                onConfirm:
                                                                    (date) {
                                                              setState(() {
                                                                datTime = date
                                                                    .toString();
                                                              });
                                                              print('monday');
                                                            },
                                                                currentTime:
                                                                    DateTime
                                                                        .now());
                                                          },
                                                          child: Container(
                                                            height: 68,
                                                            width:
                                                                double.infinity,
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 16,
                                                                    top: 20,
                                                                    bottom: 20),
                                                            color: HexColor(
                                                                'FAFAFA'),
                                                            child: Text(
                                                                '${datTime == '' ? 'Saturday' : datTime}'),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 24,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomText(
                                                            text:
                                                                'Enter Location',
                                                            size: 16,
                                                            weight:
                                                                FontWeight.w400,
                                                            color: HexColor(
                                                                '0F193B')),
                                                        SizedBox(
                                                          height: 16,
                                                        ),
                                                        _buildFields(
                                                            labelText: "",
                                                            onChanged: (value) {
                                                              studyState(() {
                                                                location =
                                                                    value;
                                                              });
                                                            }),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 44,
                                                ),
                                                GestureDetector(
                                                    onTap: () async {
                                                      validation();
                                                    },
                                                    child: button(
                                                        text:
                                                            'Create Tutorial')),
                                              ],
                                            ),
                                          )),
                                    );
                                  }))),
                    ),
                    body: Container(
                      child: ListView.builder(
                        itemCount: study.tutorialModelList.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return tutorialCard(
                            courseCode: study.tutorialModel.courseCode,
                            location: study.tutorialModel.location,
                            date: study.tutorialModel.when,
                          );
                        },
                      ),
                    ),
                  ),
                  Scaffold(
                      resizeToAvoidBottomInset: true,
                      backgroundColor: backgroundColor,
                      floatingActionButton: FloatingActionButton(
                          backgroundColor: buttonColor,
                          child: Icon(Icons.add),
                          elevation: 2.0,
                          onPressed: () => showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) => StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter setState) {
                                    studyState = setState;
                                    return Material(
                                      child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.9,
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(24.0),
                                            child: ListView(
                                              children: [
                                                Row(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: GestureDetector(
                                                          onTap: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                          child: Icon(Icons
                                                              .arrow_back)),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      'Create Study Group',
                                                      style: caption.copyWith(
                                                          fontSize: 12,
                                                          color: Colors.black),
                                                    ),
                                                    Spacer()
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 24,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomText(
                                                            text:
                                                                'Choose Course',
                                                            weight:
                                                                FontWeight.w400,
                                                            size: 16,
                                                            color: HexColor(
                                                                '0F193B')),
                                                        SizedBox(
                                                          height: 16,
                                                        ),
                                                        Container(
                                                          height: 60,
                                                          width:
                                                              double.infinity,
                                                          decoration: BoxDecoration(
                                                              color: HexColor(
                                                                  'F0F0F0'),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12)),
                                                          child: DropdownButton(
                                                            isExpanded: true,
                                                            hint: Text(
                                                              "Choose Course",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            value: courseCode,
                                                            items: courseList
                                                                .map((String
                                                                    value) {
                                                              return DropdownMenuItem(
                                                                value: value,
                                                                child: Text(
                                                                  value,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color:
                                                                          primaryTextColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              );
                                                            }).toList(),
                                                            onChanged: (value) {
                                                              studyState(() {
                                                                courseCode =
                                                                    value;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 24,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomText(
                                                            text: 'Choose Time',
                                                            size: 16,
                                                            weight:
                                                                FontWeight.w400,
                                                            color: HexColor(
                                                                '0F193B')),
                                                        SizedBox(
                                                          height: 16,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            DatePicker.showTime12hPicker(
                                                                context,
                                                                showTitleActions:
                                                                    true,
                                                                onChanged:
                                                                    (date) {
                                                              print('change $date in time zone ' +
                                                                  date.timeZoneOffset
                                                                      .inHours
                                                                      .toString());
                                                            }, onConfirm:
                                                                    (date) {
                                                              studyState(() {
                                                                datTime = date
                                                                    .toString();
                                                              });
                                                              print(date);
                                                            },
                                                                currentTime:
                                                                    DateTime
                                                                        .now());
                                                            // DatePicker.showTime12hPicker(
                                                            //     context,
                                                            //     showTitleActions:
                                                            //         true,
                                                            //     onChanged:
                                                            //         (date) {},
                                                            //     onConfirm:
                                                            //         (date) {
                                                            //   setState(() {
                                                            //     datTime = date
                                                            //         .toString();
                                                            //   });
                                                            //   print(
                                                            //       'confirm $date');
                                                            // },
                                                            //     currentTime:
                                                            //         DateTime
                                                            //             .now());
                                                          },
                                                          child: Container(
                                                            height: 68,
                                                            width:
                                                                double.infinity,
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 16,
                                                                    top: 20,
                                                                    bottom: 20),
                                                            color: HexColor(
                                                                'FAFAFA'),
                                                            child: Text(
                                                                '${datTime == '' ? DateTime.now() : datTime}'),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 16,
                                                        ),
                                                        CustomText(
                                                            text:
                                                                'Choose Meeting Days',
                                                            size: 16,
                                                            weight:
                                                                FontWeight.w400,
                                                            color: HexColor(
                                                                '0F193B')),
                                                        SizedBox(
                                                          height: 16,
                                                        ),
                                                        Container(
                                                          height: 60,
                                                          width:
                                                              double.infinity,
                                                          decoration: BoxDecoration(
                                                              color: HexColor(
                                                                  'F0F0F0'),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12)),
                                                          child: DropdownButton(
                                                            isExpanded: true,
                                                            hint: Text(
                                                              "Choose Day",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            value: selectedDay,
                                                            items: daysList.map(
                                                                (String value) {
                                                              return DropdownMenuItem(
                                                                value: value,
                                                                child: Text(
                                                                  value,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color:
                                                                          primaryTextColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              );
                                                            }).toList(),
                                                            onChanged: (value) {
                                                              studyState(() {
                                                                selectedDay =
                                                                    value;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 24,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomText(
                                                            text:
                                                                'Enter MeetUp Location ( Optional )',
                                                            size: 16,
                                                            weight:
                                                                FontWeight.w400,
                                                            color: HexColor(
                                                                '0F193B')),
                                                        SizedBox(
                                                          height: 16,
                                                        ),
                                                        _buildFields(
                                                            labelText: "",
                                                            onChanged: (value) {
                                                              studyState(() {
                                                                location =
                                                                    value;
                                                              });
                                                            }),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 44,
                                                ),
                                                GestureDetector(
                                                    onTap: () async {
                                                      createStudyGroup();
                                                      //createDynamicLink();
                                                    },
                                                    child: button(
                                                        text:
                                                            'Create Study Group')),
                                              ],
                                            ),
                                          )),
                                    );
                                  }))),
                      body: Container(
                        child: ListView.builder(
                          itemCount: 1,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              children: study.studyGroupModelList
                                  .map((e) => GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (ctx) => StudyDetail(
                                                      courseCode: e.courseCode,
                                                      when: e.when,
                                                      location: e.location,
                                                      id: e.id,
                                                    )));
                                      },
                                      child: Column(children: [
                                        studyCard(
                                          courseCode: e.courseCode,
                                          location: e.location,
                                          date: e.when,
                                        ),
                                      ])))
                                  .toList(),
                            );
                          },
                        ),
                      ))
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class tutorialCard extends StatelessWidget {
  final String courseCode;
  final String location;
  final String date;

  const tutorialCard({
    Key key,
    @required this.courseCode,
    @required this.location,
    @required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            courseCode,
            style: headerFour,
          ),
          SizedBox(
            height: 24,
          ),
          Text(location, style: captionGrey),
          SizedBox(
            height: 24,
          ),
          Text(date, style: captionGrey),
        ],
      ),
    );
  }
}

class studyCard extends StatelessWidget {
  final String courseCode;
  final String location;
  final String date;

  const studyCard({
    Key key,
    @required this.courseCode,
    @required this.location,
    @required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            courseCode,
            style: headerFour,
          ),
          SizedBox(
            height: 24,
          ),
          Text(location, style: captionGrey),
          SizedBox(
            height: 24,
          ),
          Text(date, style: captionGrey),
        ],
      ),
    );
  }
}
