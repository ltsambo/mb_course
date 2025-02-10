import 'package:flutter/material.dart';
import 'package:mb_course/main.dart';
import 'package:mb_course/providers/order_provider.dart';
import 'package:mb_course/providers/user_provider.dart';
import 'package:mb_course/screens/auth/login_screen.dart';
import 'package:mb_course/widgets/badge.dart';
import 'package:mb_course/widgets/custom_button.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../../consts/consts.dart';
import '../../services/global_methods.dart';

class AceeptOrderListScreen extends StatefulWidget {
  const AceeptOrderListScreen({super.key});

  @override
  State<AceeptOrderListScreen> createState() => _AceeptOrderListScreenState();
}

class _AceeptOrderListScreenState extends State<AceeptOrderListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<OrderProvider>(context, listen: false).fetchPendingAcceptanceOrders(context);
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final pendingOrders = orderProvider.pendingAcceptanceOrders;

    Future<void> _approveReceipt(int paymentId) async {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);

      try {
        await orderProvider.approvePayment(paymentId, context);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Payment approved!')),
        // );
        
      } catch (error) {
        print('error $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading receipt: $error')),
        );
      }
    }
    
    return pendingOrders.isEmpty
        ? Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: primaryColor,
              elevation: 0,
              title: DefaultTextWg(
                text: 'Payments',
                fontSize: 24,
                fontColor: whiteColor,
              ),
            ),
            body: Column(
              children: [
                Spacer(), // Pushes the empty cart section to center vertically
                Icon(Icons.account_balance_wallet_sharp,
                    size: 60, color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  "No pending payments.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                // Text(
                //   'Log in to see your recent orders',
                //   style: TextStyle(color: Colors.grey),
                // ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // if (!userProvider.isAuthenticated)
                    //   OutlinedButton(
                    //     onPressed: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => UserLoginScreen(),
                    //         ),
                    //       );
                    //     },
                    //     child: Text('Sign in / Register'),
                    //   )
                    // else
                    //   OutlinedButton(
                    //     onPressed: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => MainScreen(),
                    //         ),
                    //       );
                    //     },
                    //     child: Text('Continue Shopping'),
                    //   ),
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
              centerTitle: false,
              elevation: 0,
              title: DefaultTextWg(
                text: 'Acceptance Orders (${pendingOrders.length})',
                fontSize: 24,
                fontColor: whiteColor,
              ),
            ),
            body: Padding(
              padding: EdgeInsetsDirectional.only(
                  start: 20, top: 20, end: 20, bottom: 50),
              child: Column(
                children: [
                  // _checkout(ctx: context),
                  Expanded(
                    child: ListView.builder(
              itemCount: pendingOrders.length,
              itemBuilder: (context, index) {
                final order = pendingOrders[index];
                final payments = order['order_payment'] as List<dynamic>;

                return Card(
                  // margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order ID: ${order['order_uuid']}', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('Total Amount: ${order['total_amount']} ks'),
                        // Text('Status: ${_getStatusDisplay(order['status'])}'),
                        SizedBox(height: 12),
                        
                        payments.isEmpty
                            ? Text('No payment receipt uploaded.', style: TextStyle(color: Colors.red))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: payments.map((payment) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (payment['receipt'] != null)
                                        Image.network(
                                          payment['receipt'],
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      SizedBox(height: 8),
                                      CustomElevatedButton(text: 'Approve', onPressed: () =>  _approveReceipt(payment['id'])) 
                                      // Text('Approved: ${payment['is_approved'] ? "Yes" : "No"}', style: TextStyle(color: payment['is_approved'] ? Colors.green : Colors.red)),
                                    ],
                                  );
                                }).toList(),
                              ),
                                                           
                      ],
                    ),
                  ),
                );
              },
            ),
  
                  ),
                  
                  // DefaultTextWg(text: cartProvider.totalPrice.toString()),
                  // CustomElevatedButton(text: 'Checkout', onPressed: () {
                  //   cartProvider.checkout(context);
                  // })
                ],
              ),
            ),
          );
  }
}
