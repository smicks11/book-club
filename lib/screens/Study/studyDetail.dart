<<<<<<< HEAD
import 'package:book_club/models/commentmodel.dart';
import 'package:book_club/provider/StudyProvider.dart';
import 'package:book_club/provider/Userprovider.dart';
=======
import 'package:book_club/provider/StudyProvider.dart';
import 'package:book_club/shared/button.dart';
>>>>>>> 9c21482417de6d6066eafc86908f7e09c494aebc
import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:provider/provider.dart';

class StudyDetail extends StatefulWidget {
  final String courseCode;
  final String when;
  final String location;
  final String id;
  const StudyDetail({
      Key key,
        this.id,
      this.courseCode,
      this.when,
      this.location,
      }) : super(key: key);

  @override
  _StudyDetailState createState() => _StudyDetailState();
}

class _StudyDetailState extends State<StudyDetail> {

  String url = '';

  Future<Uri> createDynamicLink(String id) async {

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://funet.page.link',
      link: Uri.parse('https://funet.page.link/?id=$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.book_club',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.example.book_club',
        minimumVersion: '1.0.1',
      ),
    );

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
    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;

    setState(() {
      url = shortUrl.toString();
    });

    print(url);
    //return shortUrl;
  }

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;

          if (deepLink != null) {
            // ignore: unawaited_futures
            Navigator.pushNamed(context, deepLink.path);
          }
        }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
    await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      // ignore: unawaited_futures
      Navigator.pushNamed(context, deepLink.path);
    }
  }



  void initState() {
    initDynamicLinks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudyProvider>(context, listen: false).getStudyGroup(context);
    });
    super.initState();
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
<<<<<<< HEAD
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
=======
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
                          GestureDetector(
                              onTap: () {
                                createDynamicLink(widget.id);
                              },
                              child: Icon(
                                Icons.share,
                                color: Colors.white,
                              )),
                        ],
                      ),
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
                    Text('${url}')
                  ],),
                )
              ]),
        ),
>>>>>>> 9c21482417de6d6066eafc86908f7e09c494aebc
      ),
    );
  }
}
