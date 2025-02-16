import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
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
      style: TextStyle(
        fontFamily: 'Petrov Sans',  // Use the exact family name from pubspec.yaml
        fontSize: fontSize,         // Dynamic font size
        fontWeight: FontWeight.w800,     // Dynamic font weight
        color: fontColor,           // Dynamic text color
      ),
      // style: GoogleFonts.poppins(
      //   fontSize: fontSize,
      //   fontWeight: fontWeight,
      //   color: fontColor,
      // ),
    );
  }
}


TextStyle defaultTextStyle({
  double fontSize = 16, // Default font size
  FontWeight fontWeight = FontWeight.normal, // Default font weight
  Color fontColor = Colors.black, // Default font color
}) {
  return TextStyle(
    fontFamily: 'Petrov Sans',
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: fontColor,
  );
}