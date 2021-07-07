import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight weight;
  final double letterspacing;

  const CustomText(
      {Key key,
      @required this.text,
      @required this.size,
      @required this.color,
        this.letterspacing=0,
      this.weight
      })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.dmSans(
          textStyle: TextStyle(
            letterSpacing: letterspacing,
              fontSize: size ?? 16,
              color: color ?? Colors.black,
              fontWeight: weight ?? FontWeight.normal),
        ));
  }
}
