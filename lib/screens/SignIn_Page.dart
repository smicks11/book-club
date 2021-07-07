import 'package:book_club/screens/SignUp_Page.dart';
import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
String passwordL;
String emailL;
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _SignInPageState extends State<SignInPage> {
  Future<void> validation() async {
    //  setState(() {
    //     loading = true;
    //   });
    final FormState _form = _formKey.currentState;
    if (!_form.validate()) {
      try {
        UserCredential result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: emailL, password: passwordL);
        setState(() {
          loading = false;
          emailL = '';
          passwordL = '';
        });
      
        print(result.user.uid);
      } on PlatformException catch (e) {
        print(e.message);
        // ignore: deprecated_member_use
        // _scaffoldKey.currentState.showSnackBar(SnackBar(
        //   content: Text(e.message),
        // ));
      }
    } else {
      print("No");
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
          key: _formKey,
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
                            validator: (value) {
                              if (value == "") {
                                return "Please fill Email";
                              } else if (!regExp.hasMatch(value)) {
                                return "Email Is Invalid";
                              }
                              return "";
                            },
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
                            validator: (value) {
                              if (value == "") {
                                return "Please FIll Password";
                              } else if (value.length < 8) {
                                return "Password is too short";
                              }
                              return "";
                            },
                            onChanged: (value) {
                              setState(() {
                                passwordL = value;
                              });
                            }),
                      ]),
                    ),
                    GestureDetector(
                      onTap: passwordL == null
                          ? null
                          : () {
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
                        child: CustomText(
                          text: "Log In",
                          size: 17,
                          weight: FontWeight.w400,
                          color: white,
                        ),
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
