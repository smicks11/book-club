import 'package:book_club/models/studyGroup.dart';
import 'package:book_club/provider/Userprovider.dart';
import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
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

String comment;

void createForumComments() async {
  final userID = FirebaseAuth.instance.currentUser;
  // StudyGroupModel forum;

  try {
    FirebaseFirestore.instance
        .collection("studyGroup")
        .doc("D5bxUycjtdZlQioFZ7Wp")
        .update({
      'Forum': {"comment": comment, "userID": userID}
    });
  } on PlatformException catch (e) {
    print(e.message.toString());
  }
}

class _StudyDetailState extends State<StudyDetail> {
  TextEditingController textController = TextEditingController();

  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
        pinned: true,
        floating: false,
        delegate: _SliverAppBarDelegate(
            minHeight: MediaQuery.of(context).size.height * 0.2,
            maxHeight: MediaQuery.of(context).size.height * 0.4,
            child: Container(
              // height: MediaQuery.of(context).size.height * 0.2,
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
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: buttonColor,
      body: CustomScrollView(
        // controller: _scrollController,
        slivers: <Widget>[
          makeHeader('Header Section 1'),
          SliverFillRemaining(
            hasScrollBody: false,
            fillOverscroll: false,
            child: Container(
              color: backgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: TextFormField(
                      controller: textController,
                      onChanged: (value) {
                        setState(() {
                          comment = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Write a comment",
                        suffixIcon: GestureDetector(
                            onTap: () async{
                              createForumComments();
                              print(comment);
                            },
                            child: Icon(Icons.send)),
                      ),
                    ),
                  )
                  // Text('adkljf')
                ],
              ),
            ),
          ),

          //
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
