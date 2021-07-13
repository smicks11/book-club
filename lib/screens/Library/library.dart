import 'package:book_club/provider/Userprovider.dart';
import 'package:book_club/shared/button.dart';
import 'package:book_club/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class Library extends StatefulWidget {
  const Library({ Key key }) : super(key: key);

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> with SingleTickerProviderStateMixin{


  TabController _tabController;
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: buttonColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Library',
                style: headerText,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Get access to all reading materials',
                style: caption,
              ),
              SizedBox(
                height: 24,
              ),
              Expanded(
                child: TabBarView(controller: _tabController, children: [
                  Scaffold(
                    backgroundColor: backgroundColor,
                    floatingActionButton: Visibility(
                      visible: user.userModel.admin == false ? false : true,
                      child: FloatingActionButton(
                          backgroundColor: buttonColor,
                          child: Icon(Icons.add),
                          elevation: 2.0,
                          onPressed: () => showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) => StatefulBuilder(builder:
                                  (BuildContext context,
                                  StateSetter myState) {
                                //studyState = setState;
                               return Container();
                              }))),
                    ),
                    body: Container(
                      // child: ListView.builder(
                      //   itemCount: study.tutorialModelList.length,
                      //   scrollDirection: Axis.vertical,
                      //   shrinkWrap: true,
                      //   itemBuilder: (context, index) {
                      //     return tutorialCard(
                      //       courseCode: study.tutorialModel.courseCode,
                      //       location: study.tutorialModel.location,
                      //       date: study.tutorialModel.when,
                      //     );
                      //   },
                      // ),
                    ),
                  ),
                  Scaffold(
                      backgroundColor: backgroundColor,
                      floatingActionButton: FloatingActionButton(
                          backgroundColor: buttonColor,
                          child: Icon(Icons.add),
                          elevation: 2.0,
                          onPressed: () => showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) => StatefulBuilder(builder:
                                  (BuildContext context,
                                  StateSetter myState) {
                                //studyState = setState;
                                return Container();
                              }))),
                      body: Container(),
                  )]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}