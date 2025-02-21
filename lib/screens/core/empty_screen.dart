import 'package:flutter/material.dart';
// import 'package:grocery_app/inner_screens/feeds_screen.dart';
// import 'package:grocery_app/services/global_methods.dart';
// import 'package:grocery_app/widgets/text_widget.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/widgets/default_text.dart';

import '../../services/utlis.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen(
    {
      Key? key,
      required this.imagePath,
      required this.title,
      required this.subtitle,
      required this.buttonText,
      required this.onPressed
    })
      : super(key: key);
  final String imagePath, title, subtitle, buttonText;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {    
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      backgroundColor: backgroundColor,      
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Image.asset(                
                imagePath,
                width: double.infinity,
                height: size.height * 0.3,                
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Whoops!',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 40,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
              DefaultTextWg(text: title, fontSize: 20, fontColor: primaryColor,),
              // TextWidget(text: title, color: Colors.cyan, textSize: 20),
              const SizedBox(
                height: 20,
              ),
              DefaultTextWg(text: subtitle, fontSize: 20,),
              // TextWidget(text: subtitle, color: Colors.cyan, textSize: 20),
              SizedBox(
                height: size.height * 0.1,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: onPressed,
                child: DefaultTextWg(
                  text: buttonText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontColor: whiteColor,
                ),
              ),              
            ]),
      )),
    );
  }
}