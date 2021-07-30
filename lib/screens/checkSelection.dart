import 'package:book_club/provider/Userprovider.dart';
import 'package:book_club/screens/Homescreen/curatedtimetable.dart';
import 'package:book_club/screens/homepage.dart';
import 'package:book_club/screens/pageview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckSelection extends StatefulWidget {
  const CheckSelection({Key key}) : super(key: key);

  @override
  _CheckSelectionState createState() => _CheckSelectionState();
}

class _CheckSelectionState extends State<CheckSelection> {
  UserProvider user;
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).getUserData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: Provider.of<UserProvider>(context, listen: false)
          .getUserData(context),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (Provider.of<UserProvider>(context, listen: false).userModel.readingSession == "")
            return HomePage();
          else {
            return PageViewScreen();
          }
        }
        // return CircularProgressIndicator();
      },
    );
  }
}
