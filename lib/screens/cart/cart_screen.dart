import 'package:flutter/material.dart';
import 'package:mb_course/widgets/default_text.dart';

import '../../consts/consts.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: DefaultTextWg(text: 'Cart (5)', fontColor: whiteColor, fontWeight: FontWeight.bold, fontSize: 22,),
        actions: [
          IconButton(
            onPressed: () {
              // GlobalMethods.warningDialog(
              //     title: 'Empty your cart?',
              //     subtitle: 'Are you sure?',
              //     fct: () async {
              //       await cartProvider.clearOnlineCart();
              //       cartProvider.clearLocalCart();
              //     },
              //     context: context);
            },
            icon: Icon(
              Icons.delete,
              color: primaryColor,
            ),
          ),
        ]
      ),
      body: Column(
        children: [
          // _checkout(ctx: context),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: cartItemsList.length,
          //     itemBuilder: (ctx, index) {
          //       return ChangeNotifierProvider.value(
          //           value: cartItemsList[index],
          //           child: CartWidget(
          //             q: cartItemsList[index].quantity,
          //           ));
          //     },
          //   ),
          // ),
        ],
      ),    
    );
  }
}