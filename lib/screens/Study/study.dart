import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/tab.dart';
import 'package:flutter/material.dart';

class Study extends StatefulWidget {
  const Study({Key key}) : super(key: key);

  @override
  _StudyState createState() => _StudyState();
}

class _StudyState extends State<Study> {
  @override
  Widget build(BuildContext context) {
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
              TabSelect(
                firstTab: 'Tutorials',
                secondTab: 'Study Groups',
                bdgColor: buttonColor,
                indicatorColor: Colors.white,
                labelColor: buttonColor,
                inactiveColor: Colors.white,
              ),
              SizedBox(
                height: 24,
              ),
              tutorialCard(courseCode: 'CSC 320', location: 'St Mary, opposite Oye market', date: 'Saturday, June 12', time: '08:00 AM')
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
  final String time;

  const tutorialCard({
    Key key,
   @required this.courseCode,
    @required this.location,
    @required this.date,
    @required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            children: [
              Text(date, style: captionGrey),
              Spacer(),
              Text(time, style: captionGrey),
            ],
          )
        ],
      ),
    );
  }
}
