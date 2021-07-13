import 'package:book_club/provider/Userprovider.dart';
import 'package:book_club/shared/button.dart';
import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class CourseDoc extends StatefulWidget {
  final String courseCode;
  const CourseDoc({Key key, this.courseCode}) : super(key: key);

  @override
  _CourseDocState createState() => _CourseDocState();
}

class _CourseDocState extends State<CourseDoc>
    with SingleTickerProviderStateMixin {


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).getUserData(context);
    });
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }
  TabController _tabController;

  // Future<void> getDocuments(){
  //   //Fetch file from FirebaseStorage first
  //   LaunchFile.loadFromFirebase(context, file)
  //   //Creating PDF file at disk for ios and android & assigning pdfUrl for web
  //       .then((url) => LaunchFile.createFileFromPdfUrl(url).then(
  //         (f) => setState(
  //           () {
  //         if (f is File) {
  //           pathPDF = f.path;
  //         } else if (url is Uri) {
  //           //Open PDF in tab (Web)
  //           pdfUrl = url.toString();
  //         }
  //       },
  //     ),
  //   ));
  // }
  //}

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(context);
                  },
                  child: Icon(Icons.arrow_back)),
              SizedBox(height: 24),
              CustomText(
                  text: widget.courseCode, size: 24, color: HexColor('0F193B')),
              SizedBox(
                height: 24,
              ),
              Container(
                height: 50.0,
                margin: const EdgeInsets.symmetric(horizontal: 44),
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TabBar(
                    onTap: (index) {
                      _tabController.animateTo(
                        index,
                      );
                    },
                    controller: _tabController,
                    indicator: BubbleTabIndicator(
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                      indicatorHeight: 40.0,
                      indicatorColor: Colors.white,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 12.0,
                    ),
                    labelColor: buttonColor,
                    unselectedLabelColor: Colors.white,
                    tabs: [
                      Tab(
                        text: 'Documents',
                      ),
                      Tab(
                        text: 'Past Questions',
                      ),
                    ]),
              ),
              SizedBox(
                height: 24,
              ),

              Expanded(
                child: TabBarView(controller: _tabController, children: [
                  Scaffold(
                    backgroundColor: backgroundColor,
                    body: Container(
                      child: Text(
                        'Documents'
                      ),
                    ),
                  ),
                  Scaffold(
                    backgroundColor: backgroundColor,
                    body: Container(
                      child: Text(
                          'Past Questions'
                      ),
                    ),
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
