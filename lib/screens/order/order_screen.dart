import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mb_course/main.dart';
import 'package:mb_course/providers/order_provider.dart';
import 'package:mb_course/providers/user_provider.dart';
import 'package:mb_course/screens/auth/login_screen.dart';
import 'package:mb_course/screens/order/order_details.dart';
import 'package:mb_course/widgets/badge.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../../consts/consts.dart';
import '../../services/global_methods.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
   Map<int, File?> _receiptImages = {}; // Maps order ID to selected receipt image
    Map<int, bool> _isUploading = {}; // Track upload status per order

  @override
  void initState() {
    super.initState();
    Provider.of<OrderProvider>(context, listen: false).fetchUserOrders(context);
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    // File? _receiptImage;

    final picker = ImagePicker();
   
    // ✅ Pick Image
    Future<void> _pickReceiptImage(int orderId) async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      print('picked file ${pickedFile?.path}');
      if (pickedFile != null) {
        setState(() {
          _receiptImages[orderId] = File(pickedFile.path);
        });
      }
    }

    Future<void> _uploadReceipt(int orderId) async {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final receiptImage = _receiptImages[orderId];

      if (receiptImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an image first.')),
        );
        return;
      }

      setState(() {
        _isUploading[orderId] = true;
      });

      try {
        await orderProvider.uploadReceipt(orderId, receiptImage, context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Receipt uploaded successfully!')),
        );
        setState(() {
          _receiptImages.remove(orderId); // Clear the selected image after upload
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading receipt: $error')),
        );
      } finally {
        setState(() {
          _isUploading[orderId] = false;
        });
      }
    }
    // final cartItemsList = cartProvider.cartUserCourses.values.toList().reversed.toList();

    return orderProvider.userOrders.isEmpty
        ? Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: primaryColor,
              elevation: 0,
              title: DefaultTextWg(
                text: 'My Purchases',
                fontSize: 24,
                fontColor: whiteColor,
              ),
            ),
            body: Column(
              children: [
                Spacer(), // Pushes the empty cart section to center vertically
                Icon(Icons.shopping_cart_outlined,
                    size: 60, color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  "You do not have any order yet.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'Log in to see your recent orders',
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
              centerTitle: false,
              elevation: 0,
              title: DefaultTextWg(
                text: 'My Purchases (${orderProvider.userOrders.length})',
                fontSize: 24,
                fontColor: whiteColor,
              ),
              // actions: [
              //   IconButton(
              //     onPressed: () {
              //       GlobalMethods.warningDialog(
              //         title: 'Empty your cart?',
              //         subtitle: 'Are you sure?',
              //         fct: () async {
              //           // await cartProvider.clearOnlineCart();
              //           // orderProvider.deleteAllCartItems(context);
              //         },
              //       context: context);
              //     },
              //     icon: Icon(
              //       Icons.delete,
              //       color: whiteColor,
              //     ),
              //   ),
              // ]
            ),
            body: Padding(
              padding: EdgeInsetsDirectional.only(
                  start: 20, top: 20, end: 20, bottom: 50),
              child: Column(
                children: [
                  // _checkout(ctx: context),
                  Expanded(
                    child: ListView.builder(
                      itemCount: orderProvider.orderCount,
                      itemBuilder: (ctx, index) {
                        final item = orderProvider.userOrders[index];
                        final orderId = item['order_id'];
                        final receiptImage = _receiptImages[orderId];
                        Color badgeColor = Colors.white;                        
                        if (item['order_status'] == 'Pending upload') 
                          badgeColor = Colors.lightBlue;
                        else if (item['order_status'] == 'Pending Acceptance') 
                          badgeColor = Colors.amber;
                        else if (item['order_status'] == 'Accepted') 
                          badgeColor = Colors.green;
                        else
                          badgeColor = Colors.white;
                        return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                            child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Product Info
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        TextButton(onPressed: () => Navigator.push(
                                                            context, MaterialPageRoute(builder: (context) => OrderDetailsPage(order: item))
                                                          ), child: Text(
                                                          'Order Id: ${item['order_uuid']}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),),                                                        
                                                        CustomBadge(text: item['order_status'], backgroundColor: badgeColor),                                                        
                                                      ],
                                                    )
                                                  ],
                                                ),                                                
                                              ),                                              
                                            ],
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                              'Purchase on: ${GlobalMethods.formatDate(item['order_date'])}',
                                              style: TextStyle(color: Colors.grey)),
                                          SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Total ${item['total_items']} item(s): ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                '${item['total_amount']} ks',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ]
                                          ),
                                          SizedBox(height: 12),

                                          // Payment Countdown
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.fromLTRB(10, 12, 12, 12),
                                            decoration: BoxDecoration(
                                              color: Colors.red[50],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    text:
                                                        'Check Payment Methods here ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                    children: [
                                                      TextSpan(
                                                        text: '',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      TextSpan(text: ''),
                                                    ],
                                                  ),
                                                ),
                                                Icon(Icons.arrow_forward_ios,
                                                    size: 16,
                                                    color: Colors.red),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          // Action Buttons
                                          if (item['order_status'] == 'Pending upload') 
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              OutlinedButton(
                                                onPressed: () => _pickReceiptImage(orderId),
                                                child: Text(receiptImage == null ? "Select Screenshot" : "Screenshot: ${receiptImage.path.split('/').last}"),
                                                style: OutlinedButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 12),
                                                  side: BorderSide(
                                                      color: Colors.grey),
                                                ),                                                
                                              ),                                              
                                              SizedBox(width: 12),
                                              ElevatedButton(
                                                onPressed: _isUploading[orderId] == true
                                                ? null
                                                : () => _uploadReceipt(orderId),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: primaryColor,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 12),
                                                ),
                                                child: _isUploading[orderId] == true
                                                  ? CircularProgressIndicator(color: Colors.white)
                                                  : Text('Upload', style: TextStyle(color: Colors.white)),
                                              ),
                                            ],
                                          ),
                                          if (receiptImage != null)                                              
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  "Selected: ${receiptImage.path.split('/').last}",
                                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                                ),
                                              ),
                                        ],
                                      )
                                    ])));
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
