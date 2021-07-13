import 'package:book_club/controller/app_controller.dart';
import 'package:book_club/provider/AuthenticationProvider.dart';
import 'package:book_club/provider/StudyProvider.dart';
import 'package:book_club/provider/Userprovider.dart';
import 'package:book_club/provider/onBoarding.dart';
import 'package:book_club/screens/Auth/SignIn_Page.dart';
import 'package:book_club/screens/Homescreen/curatedtimetable.dart';
import 'package:book_club/screens/Study/studyDetail.dart';
import 'package:book_club/screens/Study/studyGroupInvite.dart';
import 'package:book_club/screens/homepage.dart';
import 'package:book_club/screens/pageview.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:statusbarz/statusbarz.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  //Dependency Injection just like how tou are using provider below
  Get.put(AppController());

   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    statusBarBrightness: Brightness.dark
  ));


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.



  @override
  Widget build(BuildContext context) {
    UserProvider userProvider;
    User currentUser = FirebaseAuth.instance.currentUser;

    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        ),
        ListenableProvider<UserProvider>(
          create: (ctx) => UserProvider(),
        ),
        ListenableProvider<TimeTableProvider>(
          create: (ctx) => TimeTableProvider(),
        ),
        ListenableProvider<StudyProvider>(
          create: (ctx) => StudyProvider(),
        ),
      ],
      child: StatusbarzCapturer(
        child: MaterialApp(
          title: 'funet',
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: <String, WidgetBuilder>{
            '/hello': (BuildContext context) => StudyDetail(),
          },
          navigatorObservers: [Statusbarz.instance.observer],
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: GoogleFonts.dmSansTextTheme(
              Theme.of(context).textTheme,
            ),
          ),

          // home: StreamBuilder(
          //   stream: FirebaseAuth.instance.authStateChanges(),
          //   builder: (ctx, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.active) {
          //       return HomePage();
          //     } else {
          //       return SignInPage();
          //     }
          //   },
          // ),
          home: SignInPage(),
        ),
      ),
    );
  }
}

