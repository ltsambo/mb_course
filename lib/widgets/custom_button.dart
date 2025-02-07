import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/services/global_methods.dart';
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
        minimumSize: const Size(double.infinity, 50),
      ),
      child: DefaultTextWg(text: text, fontColor: color ?? whiteColor,)
    );    
  }
}

class CustomDeleteBtm extends StatelessWidget {
  final Function fct;
  final String lastDate;

  const CustomDeleteBtm({super.key, required this.fct, required this.lastDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DefaultTextWg(
          text: "last update: $lastDate",
          fontColor: Colors.grey,
        ),
        ElevatedButton(
          onPressed: () {            
            GlobalMethods.warningDialog(
            title: 'Confirm?',
            subtitle: 'Are you sure to delete?',
            fct: () async {
              fct();
            },
            context: context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: DefaultTextWg(
            text: "Delete",
            fontColor: Colors.red,
          )),
      ],
    );              
  }  
}
