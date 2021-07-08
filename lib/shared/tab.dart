import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';

class TabSelect extends StatelessWidget {
  final String firstTab;
  final String secondTab;
  final Color bdgColor;
  final Color indicatorColor;
  final Color labelColor;
  final Color inactiveColor;
  const TabSelect({
    Key key,
    @required this.firstTab,
    @required this.secondTab,
    this.bdgColor = Colors.white,
    this.indicatorColor = buttonColor,
    this.labelColor = Colors.white,
    this.inactiveColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Center(
          child: Container(
              height: 50.0,
              margin: const EdgeInsets.symmetric(horizontal: 52),
              decoration: BoxDecoration(
                color: bdgColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TabBar(
                indicator: BubbleTabIndicator(
                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    indicatorHeight: 40.0,
                    indicatorColor: indicatorColor
                ),
                labelStyle: TextStyle(
                  fontSize: 12.0,
                ),
                labelColor: labelColor,
                unselectedLabelColor: inactiveColor,
                tabs: [Text(firstTab), Text(secondTab)],
              )),
        ));
  }
}
