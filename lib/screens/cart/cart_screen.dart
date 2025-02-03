import 'package:flutter/material.dart';
import 'package:mb_course/main.dart';
import 'package:mb_course/widgets/custom_button.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../../consts/consts.dart';
import '../../providers/cart_provider.dart';
import '../../services/global_methods.dart';
import '../core/empty_screen.dart';
import 'components/cart_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);    
    final cartItemsList = cartProvider.getCartItems.values.toList().reversed.toList();
    return cartItemsList.isEmpty
        ? EmptyScreen(
            title: 'Your cart is empty',
            subtitle: 'Add something and make me happy :)',
            buttonText: 'Explore now',
            imagePath: 'assets/cart_image.jpeg',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(),
                ),
              );
              // Navigator.pushNamed(context, logInScreenRoute);
            },
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              elevation: 0,
              title: DefaultTextWg(text: 'Cart (${cartItemsList.length})', fontSize: 24, fontColor: whiteColor,),                   
                actions: [
                  IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                        title: 'Empty your cart?',
                        subtitle: 'Are you sure?',
                        fct: () async {
                          await cartProvider.clearOnlineCart();
                          cartProvider.clearLocalCart();
                        },
                      context: context);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: whiteColor,
                    ),
                  ),
                ]),
            body: Padding(
              padding: EdgeInsetsDirectional.only(start: 20, top: 20, end: 20, bottom: 50),
              child: Column(
                children: [
                  // _checkout(ctx: context),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItemsList.length,
                      itemBuilder: (ctx, index) {
                        return ChangeNotifierProvider.value(
                            value: cartItemsList[index],
                            child: CartWidget());
                      },
                    ),
                  ),
                  DefaultTextWg(text: cartProvider.totalPrice.toString()),
                  CustomElevatedButton(text: 'Checkout', onPressed: () {})
                ],
              ),              
            )
          );
  }
}
