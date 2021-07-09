import 'package:book_club/shared/button.dart';
import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';


class Preferences extends StatefulWidget {
  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  DateTime dateTime = DateTime.now();
  List days = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'];
  String selectedDay = 'Mon';
  String selectedValueCourse = "CSC 320";
  List<String> courseList = ["CSC 320", "CSC 310", "CSC 330", "CSC 300", "CSC 220"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop(context);
                },
                  child: Icon(Icons.arrow_back)
              ),
              SizedBox(height: 24),
              CustomText(
                  text: 'Preferences', size: 24, color: HexColor('0F193B')),
              SizedBox(height: 32),
              DefaultTabController(
                  length: days.length,
                  child: Center(
                    child: Container(
                        child: TabBar(
                            indicator: BubbleTabIndicator(
                                tabBarIndicatorSize: TabBarIndicatorSize.label,
                                indicatorHeight: 40.0,
                                indicatorColor: buttonColor),
                            labelStyle: TextStyle(
                              fontSize: 10.0,
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: HexColor('656565'),
                            isScrollable: true,
                            tabs: days
                                .map((e) => Container(
                                  child: Text(e, style: TextStyle(
                                    fontSize: 12
                                  ),)
                                ))
                                .toList())),
                  )),
              SizedBox(height: 56,),
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          text: 'Morning Session', size: 16, color: HexColor('0F193B')),
                      SizedBox(height: 16,),
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
                              "Choose Course",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          value: selectedValueCourse,
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
                              selectedValueCourse = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          text: 'Evening Session', size: 16, color: HexColor('0F193B')),
                      SizedBox(height: 16,),
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
                              "Choose Course",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          value: selectedValueCourse,
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
                              selectedValueCourse = value;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Spacer(),
              button(text:'Update'),
            ],
          ),
        ),
      ),
    );
  }
}
