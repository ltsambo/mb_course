import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mb_course/main.dart';
import 'package:mb_course/providers/user_provider.dart';
import 'package:mb_course/screens/auth/login_screen.dart';
// import 'package:mb_course/widgets/custom_button.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../../consts/consts.dart';
import '../../providers/cart_provider.dart';
import '../../services/global_methods.dart';
// import '../core/empty_screen.dart';
import 'components/cart_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CartProvider>(context, listen: false).fetchUserCart(context);
  }

  // Future<void> _checkAndFetchCart() async {
  //    // Check if user is logged in
  //   bool isLoggedIn = await AuthHelper.isLoggedIn();
  //   if (isLoggedIn) {
  //     Provider.of<CartProvider>(context, listen: false).fetchUserCart(context);
  //   }
  //   //  else {
  //   //   print("User is not logged in. Cart will not be fetched.");
  //   // }
  // }
  int _calculateTotal(CartProvider cartProvider) {
  return cartProvider.cartUserCourses.fold(0, (sum, item) {
    double price = double.tryParse(item['course']['price'].toString()) ?? 0; // Ensure numeric value
    return sum + price.toInt(); // Convert to int to avoid decimals
  });
}


  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    int totalPrice = _calculateTotal(cartProvider);
    // final cartItemsList = cartProvider.cartUserCourses.values.toList().reversed.toList();
    return cartProvider.cartUserCourses.isEmpty
        ? Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: primaryColor,
              elevation: 0,
              title: DefaultTextWg(
                text: 'Cart',
                fontSize: 24,
                fontColor: whiteColor,
              ),
              leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: whiteColor,)),
            ),
            body: Column(
              children: [
                Spacer(), // Pushes the empty cart section to center vertically
                Icon(Icons.shopping_cart_outlined,
                    size: 60, color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  'Your cart is empty',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'Log in to see shopping cart',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!userProvider.isAuthenticated)
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserLoginScreen(),
                            ),
                          );
                        },
                        child: Text('Sign in / Register'),
                      )
                    else
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainScreen(),
                            ),
                          );
                        },
                        child: Text('Continue Shopping'),
                      ),
                  ],
                ),
                Spacer(), // Pushes the recommendation section to the bottom
              ],
            ),
          )
        : Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
                backgroundColor: primaryColor,
                elevation: 0,
                title: DefaultTextWg(
                  text: 'Cart (${cartProvider.cartUserCourses.length})',
                  fontSize: 24,
                  fontColor: whiteColor,
                ),
                leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: whiteColor,)),
                actions: [
                  IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                          title: 'Empty your cart?',
                          subtitle: 'Are you sure?',
                          fct: () async {
                            // await cartProvider.clearOnlineCart();
                            cartProvider.deleteAllCartItems(context);
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    "You Are Buying",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Cart Items List
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartProvider.cartUserCourses.length,
                      itemBuilder: (context, index) {
                        final item = cartProvider.cartUserCourses[index];

                        print('item $item');
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item['course']['title'] ?? '',
                                  style: defaultTextStyle(fontWeight: FontWeight.w800)
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${GlobalMethods.formatPrice(double.tryParse(item['course']['price'].toString()) ?? 0)} Ks",
                                      style: defaultTextStyle(fontWeight: FontWeight.w800)                                      
                                    ),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () => cartProvider.deleteCartItem(
                                          item['id'], context),
                                      child: const Icon(Icons.close, size: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Total Price
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: DefaultTextWg(text: "Total: ${GlobalMethods.formatPrice(totalPrice.toString())} Ks", fontSize: 18,)
                  ),

                  // Go to Payment Button
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            primaryColor, // Green Button Color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        cartProvider.checkout(context);
                      },
                      child: const DefaultTextWg(
                        text: "Go to Payment",
                        fontSize: 16,
                        fontColor: whiteColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
  }
}


 // Padding(
            //   padding: EdgeInsetsDirectional.only(start: 20, top: 20, end: 20, bottom: 50),
            //   child: Column(
            //     children: [
            //       // _checkout(ctx: context),
            //       Expanded(
            //         child: ListView.builder(
            //           itemCount: cartProvider.cartUserCourses.length,
            //           itemBuilder: (ctx, index) {
            //             final item = cartProvider.cartUserCourses[index];
            //             return CartWidget(item: item,);
            //           },
            //         ),
            //       ),
            //       Container(
            //         color: Colors.white,
            //         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             // All Checkbox
            //             Row(
            //               children: [
            //                 // Icon(Icons.add_shopping_cart_outlined, size: 24),
            //                 // SizedBox(width: 8),
            //                 DefaultTextWg(text: 'Total: ${cartProvider.totalPrice.toStringAsFixed(0)} ks', fontSize: 16,),
            //               ],
            //             ),                        
            //             Stack(
            //               alignment: Alignment.topRight,                          
            //               children: [
            //                 ElevatedButton(
            //                   onPressed: () {
            //                     cartProvider.checkout(context);
            //                   },
            //                   style: ElevatedButton.styleFrom(
            //                     backgroundColor: primaryColor,
            //                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            //                   ),
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       DefaultTextWg(text: 'Checkout', fontColor: whiteColor,),
            //                       // Text('% Coupon Savings!', style: TextStyle(fontSize: 12, color: Colors.orange)),
            //                     ],
            //                   ),
            //                 ),
            //                 // Free Shipping Label                            
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
               
            //       // DefaultTextWg(text: cartProvider.totalPrice.toString()),
            //       // CustomElevatedButton(text: 'Checkout', onPressed: () {
            //       //   cartProvider.checkout(context);
            //       // })
            //     ],
            //   ),              
            // ),
            
          // );