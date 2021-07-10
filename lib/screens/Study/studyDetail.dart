import 'package:book_club/shared/button.dart';
import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';

class StudyDetail extends StatefulWidget {
  final String courseCode;
  final String when;
  final String location;
  const StudyDetail(
      {Key key,
      @required this.courseCode,
      @required this.when,
      @required this.location})
      : super(key: key);

  @override
  _StudyDetailState createState() => _StudyDetailState();
}

class _StudyDetailState extends State<StudyDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: buttonColor,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                  color: buttonColor,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                      SizedBox(height: 24),
                      CustomText(
                          text: widget.courseCode,
                          size: 24,
                          color: HexColor('FFFFFF')),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  color: Colors.white,
                  width: double.infinity,
                  child: Column(children: [
                    Text('adkljf')
                  ],),
                )
              ]),
        ),
      ),
    );
  }
}
