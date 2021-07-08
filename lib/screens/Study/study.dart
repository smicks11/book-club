import 'package:book_club/provider/StudyProvider.dart';
import 'package:book_club/shared/button.dart';
import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
import 'package:book_club/shared/tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';

class Study extends StatefulWidget {
  const Study({Key key}) : super(key: key);

  @override
  _StudyState createState() => _StudyState();



}

class _StudyState extends State<Study> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudyProvider>(context, listen: false).getTutorial(context);
    });
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String courseCode = 'CSC 320';
  String location;
  var datTime = 'Saturday';
  void validation() async {
    final FormState _form = _formKey.currentState;
    await Firebase.initializeApp();
      try {
        FirebaseFirestore.instance.collection("Tutorial").add({
          'courseCode': courseCode,
          'location' : location,
          'when' : datTime
        }).then((value) => print('Created Succesfully'));
       Navigator.of(context).pop();
        // myDialogBox();
      } on PlatformException catch (e) {
        print(e.message.toString());
      }
  }


  StateSetter studyState;
  List<String> courseList = ["CSC 320", "CSC 310", "CSC 330", "CSC 300", "CSC 220"];

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
    final study = Provider.of<StudyProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonColor,
        child: Icon(Icons.add),
        elevation: 2.0,
        onPressed:  () => showCupertinoModalBottomSheet(
          context: context,
          builder: (context) => StatefulBuilder(builder: (BuildContext context,
              StateSetter myState ) {
            //studyState = setState;
            return Material(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                  color: Colors.white,
                child : Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Icon(Icons.arrow_back)
                            ),
                          ),
                          Spacer(),
                          Text('Create Tutorial', style: caption.copyWith(fontSize: 12,color: Colors.black),),
                          Spacer()
                        ],
                      ),
                      SizedBox(height: 24,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                  text: 'Choose Course', weight: FontWeight.w400,size: 16, color: HexColor('0F193B')),
                              SizedBox(height: 16,),
                              Container(
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: HexColor('F0F0F0'),
                                    borderRadius: BorderRadius.circular(12)),
                                child: DropdownButton(
                                  isExpanded: true,
                                  hint: Text(
                                    "Choose Course",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  value: courseCode,
                                  items: courseList.map((String value) {
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
                                      courseCode = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                  text: 'Choose Date & Time', size: 16, weight: FontWeight.w400,color: HexColor('0F193B')),
                              SizedBox(height: 16,),
                              GestureDetector(
                                onTap:() {
                                  DatePicker.showDateTimePicker(
                                      context,
                                      showTitleActions: true,
                                      onChanged: (date) {
                                      }, onConfirm: (date) {
                                    setState(() {
                                      datTime = date.toString();
                                    });
                                    print('confirm $date');
                                  }, currentTime: DateTime.now());
                                },
                                child: Container(
                                  height: 68,
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(left: 16,top: 20,bottom: 20),
                                  color: HexColor('FAFAFA'),
                                  child: Text(
                                      '${datTime == '' ? 'Saturday' : datTime}'
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 24,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                  text: 'Enter Location', size: 16, weight: FontWeight.w400,color: HexColor('0F193B')),
                              SizedBox(height: 16,),
                              _buildFields(
                                  labelText: "",
                                  onChanged: (value) {
                                    setState(() {
                                      location = value;
                                    });
                                  }),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 44,),
                      GestureDetector(
                        onTap: () async{
                          validation();
                        },
                          child: button(text:'Create Tutorial')
                      ),
                    ],
                  ),
                )
              ),
            );
          })
        )
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Study',
                style: headerText,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Tutorials happening this week',
                style: caption,
              ),
              SizedBox(
                height: 24,
              ),
              TabSelect(
                firstTab: 'Tutorials',
                secondTab: 'Study Groups',
                bdgColor: buttonColor,
                indicatorColor: Colors.white,
                labelColor: buttonColor,
                inactiveColor: Colors.white,
              ),
              SizedBox(
                height: 24,
              ),
             tutorialCard(courseCode: study.tutorialModel.courseCode, location: study.tutorialModel.location, date:study.tutorialModel.when,)
            ],
          ),
        ),
      ),
    );
  }
}

class tutorialCard extends StatelessWidget {
  final String courseCode;
  final String location;
  final String date;

  const tutorialCard({
    Key key,
   @required this.courseCode,
    @required this.location,
    @required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              courseCode,
              style: headerFour,
            ),
            SizedBox(
              height: 24,
            ),
            Text(location, style: captionGrey),
            SizedBox(
              height: 24,
            ),
            Text(date, style: captionGrey),
          ],
        ),
    );
  }
}
