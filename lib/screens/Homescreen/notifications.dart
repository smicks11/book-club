import 'package:book_club/shared/customtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: 'Notifications', size: 17, color: HexColor('1c1c1c')),
          SizedBox(height: 24,),
          Notification(
            username: 'IA',
            notificationMsg: 'Inioluwa is inviting you to his CSC 316 study group',
          )
        ],
      ),
    );
  }
}

class Notification extends StatelessWidget {
  final String username;
  final String notificationMsg;
  const Notification({
    Key key, @required this.username, @required this.notificationMsg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: HexColor('1A43E7'),
          child: Text(
            username, style: TextStyle(
            color: Colors.white
          ),
          ),
        ),
        SizedBox(width: 10,),
        Container(
          width: MediaQuery.of(context).size.width*0.7,
          child: CustomText(
              text: notificationMsg,
              size: 16,
              color: HexColor('1c1c1c')
          ),
        ),

      ],
    );
  }
}
