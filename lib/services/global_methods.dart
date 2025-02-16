// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:grocery_app/consts/firebase_consts.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/widgets/default_text.dart';
// import 'package:uuid/uuid.dart';

class GlobalMethods {
  static navigateTo({required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, routeName);
  }

  static Future<void> warningDialog({
    required String title,
    required String subtitle,
    required Function fct,
    required BuildContext context,
  }) async {
    await showDialog(        
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: backgroundColor,
            title: Row(children: [
              Image.asset(
                'assets/warning_sign.jpeg',
                height: 30,
                width: 30,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(title),
              SizedBox(height: 16,),
            ]),            
            content: Text(subtitle),
            actions: [
              TextButton(
                
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: DefaultTextWg(text: 'Cancel', fontColor: primaryColor,)                
              ),
              TextButton(
                onPressed: () {
                  fct();
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: DefaultTextWg(text: 'OK', fontColor: const Color.fromARGB(255, 177, 32, 21),)                              
              ),
            ],
          );
        });
  }

  static Future<void> errorDialog({
    required String subtitle,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(children: [
              Image.asset(
                'assets/images/warning-sign.png',
                height: 20,
                width: 20,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                width: 8,
              ),
              const Text('An Error occured'),
            ]),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: DefaultTextWg(text: 'Ok', fontSize: 18,)
              ),
            ],
          );
        });
  }

  static Future<void> addToCart(
      {required String productId,
      required int quantity,
      required BuildContext context}) async {
    // final User? user = authInstance.currentUser;
    // final uid = user!.uid;
    // final cartId = const Uuid().v4();
    try {
      // FirebaseFirestore.instance.collection('users').doc(uid).update({
      //   'userCart': FieldValue.arrayUnion([
      //     {
      //       'cartId': cartId,
      //       'productId': productId,
      //       'quantity': quantity,
      //     }
      //   ])
      // });
      // await Fluttertoast.showToast(
      //   msg: "Item has been added to your cart",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      // );
    } catch (error) {
      errorDialog(subtitle: error.toString(), context: context);
    }
  }

  static Future<void> addToWishlist(
      {required String productId, required BuildContext context}) async {
    // final User? user = authInstance.currentUser;
    // final uid = user!.uid;
    // final wishlistId = const Uuid().v4();
    try {
      // FirebaseFirestore.instance.collection('users').doc(uid).update({
      //   'userWish': FieldValue.arrayUnion([
      //     {
      //       'wishlistId': wishlistId,
      //       'productId': productId,
      //     }
      //   ])
      // });
      // await Fluttertoast.showToast(
      //   msg: "Item has been added to your wishlist",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      // );
    } catch (error) {
      errorDialog(subtitle: error.toString(), context: context);
    }
  }

  static String formatDate(String dateString) {
    try {
      DateTime parsedDate = DateTime.parse(dateString);
      String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
      return formattedDate;
    } catch (e) {
      return 'Invalid Date';
    }
  }

  static String formatPrice(dynamic price) {
    double parsedPrice = double.tryParse(price.toString()) ?? 0;
    return NumberFormat('#,###').format(parsedPrice);
  }
}