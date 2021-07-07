import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';

class TabSelect extends StatelessWidget {
  final String firstTab;
  final String secondTab;
  const TabSelect({
    Key key, @required this.firstTab, @required this.secondTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
        child: Center(
          child: Container(
              height: 50.0,
              margin:const EdgeInsets.symmetric(horizontal: 52),
              decoration: BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TabBar(
                indicator: BubbleTabIndicator(
                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    indicatorHeight: 40.0,
                    indicatorColor: buttonColor
                ),
                labelStyle: TextStyle(fontSize: 12.0,),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Text(firstTab),
                 Text(secondTab)

                ],
              )
          ),
        ));
  }
}