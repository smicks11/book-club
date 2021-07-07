import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';

class Preferences extends StatefulWidget {
  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  List days = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'];
  String selectedDay = 'Mon';
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
                            tabs: days
                                .map((e) => Container(
                                  child: Text(e)
                                ))
                                .toList())),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
