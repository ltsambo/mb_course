import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/widgets/default_text.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final double? borderRadius;
  final double? fontSize;

  const CustomElevatedButton({
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.borderRadius,
    this.fontSize,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding:
            const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
        backgroundColor: color ??  primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12.0),
        ),
      ),
      child: DefaultTextWg(text: text, fontColor: color ?? whiteColor,)
    );
  }
}
