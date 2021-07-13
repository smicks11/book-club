import 'package:book_club/screens/Homescreen/curatedtimetable.dart';
import 'package:book_club/screens/homepage.dart';
import 'package:book_club/screens/pageview.dart';
import 'package:book_club/shared/button.dart';
import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
// import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

bool loading = false;
String error = '';
RegExp regExp = new RegExp(p);
bool obserText = true;
String email;
String matricNumber;
bool isMale = true;
String password;
String dept;
String level;
String fullName;

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
// final AuthServices _auth = AuthServices();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

String selectedValue;
String selectedValueLevel;
bool admin = false;

class _SignUpPageState extends State<SignUpPage> {
  void validation() async {
    // setState(() {
    //   loading = true;
    // });
    final FormState _form = _formKey.currentState;
    await Firebase.initializeApp();
    if (!_form.validate()) {
      try {
        UserCredential result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        setState(() {
          loading = false;
        });
        FirebaseFirestore.instance.collection("User").doc(result.user.uid).set({
          "UserId": result.user.uid,
          "UserEmail": email,
          "displayName": fullName,
          "Password": password,
          "Dept": dept,
          "Level": level,
          "readingDays" : "",
          "readingSession" : "",
          "admin" : admin
        }).then((res) {
          showTopSnackBar(
            context,
            CustomSnackBar.success(
              message:
              "Account Created Successfully",
            ),
          );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      });
        // Navigator.pushAndRemoveUntil(context,
        //     MaterialPageRoute(builder: (ctx) => HomePage(name:fullName)), (route) => false);
        // myDialogBox();
      } on PlatformException catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(e.message),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
        print(e.message.toString());
      }
    } else {}
  }

  final TextEditingController emailController = TextEditingController();

  final TextEditingController matricController = TextEditingController();

  final TextEditingController deptController = TextEditingController();

  final TextEditingController levelController = TextEditingController();

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
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          labelText: labelText,
          suffixIcon: textIcon,
          contentPadding: EdgeInsets.only(left: 16),
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
    List<String> dept = ["Computer Science"];
    List<String> levelList = ["100L", "200L", "300L", "400L", "500L"];
    return Scaffold(
      key: _scaffoldKey,
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
                      height: 100,
                      width: double.infinity,
                      child: CustomText(
                        text: "Sign Up",
                        size: 24,
                        color: headerColor,
                        weight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
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
                                  email = value;
                                });
                              }),

                          SizedBox(height: 18),
                          _buildFields(
                              labelText: "Full Name",
                              validator: (value) {
                                if (value == "") {
                                  return "Please fill in your full name";
                                }
                                return "";
                              },
                              onChanged: (value) {
                                setState(() {
                                  fullName = value;
                                });
                              }),
                          SizedBox(height: 18),
                          // _buildFields(
                          //     labelText: "Dept",
                          //     validator: (value) {
                          //       if (value == "") {
                          //         return "Please fill in your department";
                          //       }
                          //       return "";
                          //     },
                          //     onChanged: (value) {
                          //       setState(() {
                          //         dept = value;
                          //       });
                          //     }),
                          //     SizedBox(height: 18),
                          Container(
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.grey[400].withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8)),
                            child: DropdownButton(
                              isExpanded: true,
                              hint: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  "Dept",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: primaryTextColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              value: selectedValue,
                              items: dept.map((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: primaryTextColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value;
                                  print(selectedValue);
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 18),
                          Container(
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.grey[400].withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8)),
                            child: DropdownButton(
                              isExpanded: true,
                              hint: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  "Level",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: primaryTextColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              value: selectedValueLevel,
                              items: levelList.map((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: primaryTextColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedValueLevel = value;
                                  print(selectedValueLevel);
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 18),
                          _buildFields(
                              textIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    obserText = !obserText;
                                  });
                                  // FocusScope.of(context).unfocus();
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
                                  password = value;
                                });
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: 80,),
                    GestureDetector(
                      onTap: () async {
                        validation();
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                          child: button(text:'Sign Up')
                      ),
                    ),
                    Container(
                      height: 100,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "Already Have an Account?",
                            size: 16,
                            color: primaryTextColor,
                            weight: FontWeight.w500,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: CustomText(
                                text: "Sign In",
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


