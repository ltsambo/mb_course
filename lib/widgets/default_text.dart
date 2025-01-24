import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mb_course/consts/consts.dart';


class DefaultTextWg extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color fontColor;
  final TextAlign textAlign;

  const DefaultTextWg({
    super.key, 
    required this.text, 
    this.fontSize = 14, 
    this.fontWeight = FontWeight.bold,
    this.fontColor = blackColor,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: fontColor,
      ),
    );
  }
}
