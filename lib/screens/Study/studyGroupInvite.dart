import 'package:book_club/screens/Study/study.dart';
import 'package:book_club/shared/button.dart';
import 'package:book_club/shared/constants.dart';
import 'package:book_club/shared/customtext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudyInvite extends StatefulWidget {
  final String id;
  final String courseCode;
  final String when;
  const StudyInvite(
      {Key key,
       this.id, this.courseCode, this.when})
      : super(key: key);

  @override
  _StudyInviteState createState() => _StudyInviteState();
}



class _StudyInviteState extends State<StudyInvite> {
  @override
  void initState() {
    super.initState();
    getStudyDetail(widget.id);
  }

  String courseCode = '';

  Future<void> getStudyDetail(id) async{
    var courses = await FirebaseFirestore.instance.collection("studyGroup").doc(id)
        .get()
        .then((value) {
          setState(() {
            courseCode = value.data()['courseCode'];
          });
    });
  }

  acceptInvite() async{
    User currentUser = FirebaseAuth.instance.currentUser;
    print('you suppose dey get this normal normal');
    print(widget.id);
    var courses = await FirebaseFirestore.instance.collection("studyGroup").doc(widget.id).set({
      'members' : FieldValue.arrayUnion([
        currentUser.uid,
      ])
    },SetOptions(merge: true));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 20),
        child: Column(
          children: [
            Expanded(
              flex: 2,
                child: SvgPicture.asset('assets/svg/student.svg',height: 200,width: 200,)),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Study Group Invite',style: headerFour.copyWith(color: Colors.black),),
                  SizedBox(height: 10,),
                  Text('Join my ${courseCode} study group! Lets study together', style: caption.copyWith(color: Colors.black),)
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      acceptInvite();
                    },
                      child: button(text: 'Accept Invite')
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Study(),
                          ),
                        );
                      },
                      child: button(text: 'Decline Invite')
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}