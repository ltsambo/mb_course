import 'package:flutter/material.dart';
import 'package:mb_course/widgets/default_text.dart';

class BtmDeleteUser extends StatelessWidget {
  const BtmDeleteUser({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          // Handle delete action
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
        ));
  }
}
