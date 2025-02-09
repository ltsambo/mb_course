import 'package:flutter/material.dart';
import 'package:mb_course/widgets/default_text.dart';

class CustomBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const CustomBadge({
    Key? key,
    required this.text,
    this.backgroundColor = Colors.grey,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DefaultTextWg(text: text, fontColor: textColor,)      
    );
  }
}
