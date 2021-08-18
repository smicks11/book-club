import 'dart:async';

import 'package:book_club/screens/Auth/SignUp_Page.dart';
import 'package:book_club/screens/checkSelection.dart';
import 'package:book_club/screens/homepage.dart';
import 'package:book_club/screens/pageview.dart';
import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
// import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
String passwordL;
String emailL;
final GlobalKey<FormState> _signKey = GlobalKey<FormState>();

class _SignInPageState extends State<SignInPage> {
  void animateButton() {
    setState(() {
      _state = 1;
    });

    Timer(Duration(milliseconds: 3300), () {
      setState(() {
        _state = 2;
      });
    });
  }
  var _state = 0;

  Widget setUpButtonChild() {
    if (_state == 0) {
      return new Text(
        "Log In",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }
  Future<void> validation() async {
    final FormState _form = _signKey.currentState;
    try {
      // UserCredential result = await FirebaseAuth.instance
      //     .signInWithEmailAndPassword(email: emailL, password: passwordL)
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailL, password: passwordL)
          .then((result) {
        print(result);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CheckSelection()));
      });
      setState(() {
        loading = false;
        emailL = '';
        passwordL = '';
      });

      // print(result.user);
    } on PlatformException catch (e) {
      print(e.message);
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message:
              "Something went wrong. Please check your credentials and try again",
        ),
      );
    }
  }

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  Widget _buildFields(
      {String labelText,
      Function validator,
      Function onChanged,
      Widget textIcon}) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey[400].withOpacity(0.2),
          borderRadius: BorderRadius.circular(8)),
      child: TextFormField(
        validator: validator,
        onChanged: onChanged,
        style: TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        // controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: textIcon,
          contentPadding: EdgeInsets.only(left: 16),
          border: UnderlineInputBorder(borderSide: BorderSide.none),
          labelStyle: TextStyle(
              fontSize: 14,
              color: primaryTextColor,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _signKey,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: double.infinity,
                      child: CustomText(
                        text: "Sign In",
                        size: 24,
                        color: headerColor,
                        weight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(children: [
                        _buildFields(
                            labelText: "Email Address",
                            validator: (value) {},
                            onChanged: (value) {
                              setState(() {
                                emailL = value;
                              });
                            }),
                        SizedBox(height: 18),
                        _buildFields(
                            textIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  obserText = !obserText;
                                });
                                FocusScope.of(context).unfocus();
                              },
                              child: Icon(
                                obserText == true
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                            ),
                            labelText: "Password",
                            onChanged: (value) {
                              setState(() {
                                passwordL = value;
                              });
                            }),
                      ]),
                    ),
                    GestureDetector(
                      onTap: passwordL == null && emailL == null
                          ? null
                          : () {
                              setState(() {
                                if (_state == 0) {
                                  animateButton();
                                }
                              });
                              validation();
                            },
                      child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: setUpButtonChild(),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "Don't Have an Account?",
                            size: 16,
                            color: primaryTextColor,
                            weight: FontWeight.w500,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => SignUpPage()));
                              },
                              child: CustomText(
                                text: "Sign Up",
                                size: 16,
                                color: buttonColor,
                                weight: FontWeight.w500,
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
