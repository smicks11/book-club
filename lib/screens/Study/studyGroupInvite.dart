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

  Future<void> getStudyDetail(id) async{
    var courses = await FirebaseFirestore.instance.collection("studyGroup").doc(id)
        .get()
        .then((value) {
          print(value.data());
    });
  }

  acceptInvite(id) async{
    User currentUser = FirebaseAuth.instance.currentUser;
    print('you suppose dey get this normal normal');
    print(widget.id);
    var courses = await FirebaseFirestore.instance.collection("studyGroup").doc(id).set({
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
        child: Column(
          children: [
            Expanded(
              flex: 1,
                child: SvgPicture.asset('assets/svg/student.svg',height: 100,width: 100,)),
            Column(
              children: [
                Text('Study Group Invite',style: headerFour.copyWith(color: Colors.black),),
                SizedBox(height: 10,),
                Text('Lets study together on this study group', style: caption.copyWith(color: Colors.black),)
              ],
            ),
            GestureDetector(
              onTap: (){
                acceptInvite(widget.id);
              },
                child: button(text: 'Accept Invite')
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => PageView(),
                  ),
                );
              },
                child: button(text: 'Decline Invite')
            )
          ],
        ),
      ),
    );
  }
}