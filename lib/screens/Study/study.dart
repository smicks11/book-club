import 'package:book_club/models/studyGroup.dart';
import 'package:book_club/provider/StudyProvider.dart';
import 'package:book_club/provider/Userprovider.dart';
import 'package:book_club/screens/Auth/SignIn_Page.dart';
import 'package:book_club/screens/Study/studyDetail.dart';
import 'package:book_club/shared/button.dart';
import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
// import 'package:book_club/shared/tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

class Study extends StatefulWidget {
  const Study({Key key}) : super(key: key);

  @override
  _StudyState createState() => _StudyState();
}

class _StudyState extends State<Study> with SingleTickerProviderStateMixin {
  final List<StudyGroupModel> forum = [];
  @override
  TabController _tabController;
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudyProvider>(context, listen: false).getTutorial(context);
      Provider.of<StudyProvider>(context, listen: false).getStudyGroup(context);
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
  String location;
  var datTime = 'Saturday';

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
      FirebaseFirestore.instance.collection("studyGroup").add({
        'userID': userData.userModel.userID,
        'courseCode': courseCode,
        'location': location,
        'when': datTime,
        'forum': "kjbkjhj"
        // 'Forum' : forum
      }).then((value) => Provider.of<StudyProvider>(context, listen: false)
          .getStudyGroup(context));
      Navigator.of(context).pop();
      // myDialogBox();
    } on PlatformException catch (e) {
      print(e.message.toString());
    }
  }

  StateSetter studyState;
  List<String> courseList = [
    "CSC 320",
    "CSC 310",
    "CSC 330",
    "CSC 300",
    "CSC 220"
  ];

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
          border: UnderlineInputBorder(borderSide: BorderSide.none),
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
    final study = Provider.of<StudyProvider>(context, listen: true);
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
                                                              setState(() {
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
                                                              print(
                                                                  'confirm $date');
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
                                                              setState(() {
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
                      backgroundColor: backgroundColor,
                      floatingActionButton: FloatingActionButton(
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
                                                              setState(() {
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
                                                              print(
                                                                  'confirm $date');
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
                                                              setState(() {
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
                                                    location: e.location)));
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
