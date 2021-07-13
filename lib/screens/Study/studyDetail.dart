import 'package:book_club/models/commentmodel.dart';
import 'package:book_club/provider/StudyProvider.dart';
import 'package:book_club/provider/Userprovider.dart';
import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StudyDetail extends StatefulWidget {
  final String courseCode;
  final String when;
  final String location;
  final String id;
  const StudyDetail(
      {Key key,
        @required this.courseCode,
        @required this.when,
        @required this.location, this.id})
      : super(key: key);

  @override
  _StudyDetailState createState() => _StudyDetailState();
}

String comment;

class _StudyDetailState extends State<StudyDetail> {
  List<CommentModel> finalComment = List<CommentModel>.empty(growable: true);
  TextEditingController textController = TextEditingController();
  List comments = [""];
  StateSetter forumState;
  StudyProvider studyProvider;

  String link = '';
  bool _isCreatingLink = false;
  String _linkMessage;

  // ignore: missing_return
  Future<void> createDynamicLink(String id) async {

    setState(() {
      _isCreatingLink = true;
    });
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://funet.page.link',
      link: Uri.parse('https://funet.page.link/$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.book_club',
        minimumVersion: 1,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      socialMetaTagParameters:  SocialMetaTagParameters(
        title: 'Funet Book Club',
        description: 'Hi! Join my ${widget.courseCode} study group with this link',
      ),
    );

    Uri url;
    final ShortDynamicLink shortLink = await parameters.buildShortLink();
    url = shortLink.shortUrl;

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });


    print(_linkMessage);
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getComments(widget.id);
    });
  }

  void createForumComments() async {
    final userID = FirebaseAuth.instance.currentUser;

    try {
      FirebaseFirestore.instance
          .collection("studyGroup")
          .doc(widget.id)
          .set({
        'forum': FieldValue.arrayUnion([
          {"comment": comment, "userId": userID.displayName},
        ])
      }, SetOptions(merge: true));
      getComments(widget.id);
    } on PlatformException catch (e) {
      print(e.message.toString());
    }
  }

  Future<void> getComments(id) async {
    List<CommentModel> mainComment = [];
    FirebaseFirestore.instance
        .collection("studyGroup")
        .doc(widget.id)
        .get()
        .then((docSnapshot) {
      setState(() {
        comments = docSnapshot.data()['forum'];
      });
      comments.forEach((element) {
        CommentModel commentModel = CommentModel(
          comment: element['comment'],
          uid: element['userId'],
        );
        mainComment.add(commentModel);
      });
    });

    finalComment = mainComment;

    // notifyListeners();
  }



  @override
  Widget build(BuildContext context) {
    UserProvider user;
    studyProvider = Provider.of<StudyProvider>(context);

   // final displayName = Provider.of<UserProvider>(context, listen: true);
    //displayName.getUserData(context);
    //studyProvider.getComments();
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: buttonColor,
      body: Container(
        child: Column(
          children: [
                Container(
                margin: EdgeInsets.only(top: 44),
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                        Spacer(),
                        Text('Study Group Detail', style: TextStyle(color: Colors.white),),
                        Spacer(),
                        GestureDetector(
                            onTap: () {
                              print('is this thing even working');
                              Clipboard.setData(ClipboardData(text: _linkMessage));
                               createDynamicLink(widget.id);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              child: Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    ),
                    SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        createDynamicLink(widget.id);
                      },
                      child: CustomText(
                          text: widget.courseCode,
                          size: 24,
                          color: HexColor('FFFFFF')),
                    ),
                  ],
                ),
              ),
            Expanded(
              flex: 2,
                child:   Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ListView.builder(
                              itemCount: finalComment.length,
                              itemBuilder: (_, index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                          backgroundColor: buttonColor,
                                          child: Text('${finalComment[index].uid.split(" ")[0][0]}${finalComment[index].uid.split(" ")[1][0]}')
                                      ),
                                      SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(finalComment[index].uid, style: TextStyle(
                                            color: HexColor('747474'),
                                            fontWeight: FontWeight.bold,
                                              fontSize: 12
                                          ),),
                                          Text(finalComment[index].comment, style: TextStyle(
                                            fontSize: 16,

                                          ),),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                     // color: backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: textController,
                      onChanged: (value) {
                        setState(() {
                          comment = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Type a message",
                        suffixIcon: GestureDetector(
                            onTap: () async {
                              createForumComments();
                              textController.text = '';
                            },
                            child: Icon(Icons.send)),
                      ),
                    ),
                  )
                  // Text('adkljf')
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}


