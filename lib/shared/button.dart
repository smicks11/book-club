import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
import 'package:flutter/material.dart';

class button extends StatelessWidget {
  final String text;
  const button({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 60,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomText(
        text: text,
        size: 17,
        weight: FontWeight.w400,
        color: white,
      ),
    );
  }
}
