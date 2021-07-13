import 'package:book_club/models/commentmodel.dart';
import 'package:book_club/provider/StudyProvider.dart';
import 'package:book_club/provider/Userprovider.dart';
import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:provider/provider.dart';

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

class _StudyDetailState extends State<StudyDetail> {
  List<CommentModel> finalComment = List<CommentModel>.empty(growable: true);
  TextEditingController textController = TextEditingController();
  List comments = [];
  StateSetter forumState;
  StudyProvider studyProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getComments();
    });
  }

  void createForumComments() async {
    final userID = FirebaseAuth.instance.currentUser;

    try {
//var encodedObject = json.encode(yourObject);

      FirebaseFirestore.instance
          .collection("studyGroup")
          .doc("5YE8sWQXE26ITn5e3tQl")
          .set({
        'forum': FieldValue.arrayUnion([
          {"comment": comment, "userId": userID.uid},
        ])
      }, SetOptions(merge: true));
      getComments();
    } on PlatformException catch (e) {
      print(e.message.toString());
    }
  }

  Future<void> getComments() async {
    List<CommentModel> mainComment = [];
    FirebaseFirestore.instance
        .collection("studyGroup")
        .doc("5YE8sWQXE26ITn5e3tQl")
        .get()
        .then((docSnapshot) {
      setState(() {
        comments = docSnapshot.data()['forum'];
      });
      comments.forEach((element) {
        CommentModel commentModel = CommentModel(
          comment: element['comment'],
          uid: element['uid'],
        );
        mainComment.add(commentModel);
      });
      print(comments);
    });

    finalComment = mainComment;

    // notifyListeners();
  }

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
    UserProvider user;
    studyProvider = Provider.of<StudyProvider>(context);

    final displayName = Provider.of<UserProvider>(context, listen: true);
    displayName.getUserData(context);
    //studyProvider.getComments();
    return Scaffold(
      backgroundColor: buttonColor,
      body: CustomScrollView(
        // controller: _scrollController,
        slivers: <Widget>[
          makeHeader('Header Section 1'),
          SliverFillRemaining(
            hasScrollBody: true,
            fillOverscroll: true,
            child: Container(
              color: backgroundColor,
              child: Column(
                children: [
                  Container(
                    height: 400,
                    child: ListView.builder(
                      itemCount: finalComment.length,
                      itemBuilder: (_, index) {
                        return Container(
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: buttonColor,
                                child: Text('${displayName.userModel.fullName.split("")[0][0]}${user.userModel.fullName.split(" ")[1][0]}')
                              ),
                              Text(finalComment[index].comment),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // Container(
                  //   child: Text(finalComment.toString()),
                  // ),
                  Column(
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
                                onTap: () async {
                                  createForumComments();

                                  // print(comment);
                                  //print(studyProvider.forumModelList.length);
                                },
                                child: Icon(Icons.send)),
                          ),
                        ),
                      )
                      // Text('adkljf')
                    ],
                  ),
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
