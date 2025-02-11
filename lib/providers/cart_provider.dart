// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

// import 'package:grocery_app/consts/firebase_consts.dart';
import 'package:flutter/material.dart';
import 'package:mb_course/config/api_config.dart';
import 'package:mb_course/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import 'package:http/http.dart' as http;

import '../screens/order/order_screen.dart';

class CartProvider with ChangeNotifier {  
  final Map<String, CartItemModel> _cartItems = {};
  final List<int> _cartCourses = [];
  List<Map<String, dynamic>> _cartUserCourses = [];

  List<Map<String, dynamic>> get cartUserCourses => _cartUserCourses;
  List<int> get cartCourses => _cartCourses;

  Map<String, CartItemModel> get getCartItems {
    return _cartItems;
  }
  
  // final userCollection = FirebaseFirestore.instance.collection('users');
  Future<void> fetchUserCart(BuildContext context, {bool retry = true}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final url = Uri.parse(fetchUserCartUrl);
    final token = await AuthHelper.getToken();

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] is List){
          _cartUserCourses = List<Map<String, dynamic>>.from(data['data']);
        }
        else {
          _cartUserCourses = [];
        }

        notifyListeners();  // Notify UI about cart updates
      } else if (response.statusCode == 401 && retry) {      
        if (userProvider.isAuthenticated) {
          bool refreshed = await AuthHelper.refreshToken();
          if (refreshed) {
            return fetchUserCart(context, retry: false);  // Retry after refreshing token
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Session Expired! Please log in again.')),
            );
            userProvider.logout(context);  // Log out the user if refresh fails
          }
        }
      } else {
        print('Error: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode} Failed to fetch cart: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching cart: $e')),
      );
    }
  }

  Future<void> deleteCartItem(int cart_item_id, BuildContext context) async {
    final url = Uri.parse(cartCourseRemoveUrl(cart_item_id));
    final token = await AuthHelper.getToken();

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Remove item locally after successful deletion
        _cartUserCourses.removeWhere((item) => item['id'] == cart_item_id);
        notifyListeners();  // Notify UI about the change

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Course removed from cart successfully!')),
        );
      } else if (response.statusCode == 401) {      
        bool refreshed = await AuthHelper.refreshToken();
        if (refreshed) {
          return deleteCartItem(cart_item_id, context);           
        } 
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Session Expired!')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.statusCode} Failed to remove course from cart.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing course from cart: $e')),
      );
    }
  }

  Future<void> deleteAllCartItems(BuildContext context) async {
    final url = Uri.parse(cartCourseRemoveAllUrl);
    final token = await AuthHelper.getToken();

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _cartUserCourses.clear();  // Clear cart locally
        notifyListeners();   // Update UI

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('All courses removed from cart successfully!')),
        );
      } else if (response.statusCode == 401) {      
        bool refreshed = await AuthHelper.refreshToken();
        if (refreshed) {
          return deleteAllCartItems(context);           
        } 
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Session Expired!')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to clear cart.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error clearing cart: $e')),
      );
    }
  }

  void clearLocalCart() {
    _cartItems.clear();
    _cartUserCourses.clear();
    notifyListeners();
  }
  
  Future<void> addCourseToCart({
    required String courseId,
    required double price,
    required BuildContext context,
  }) async {
    final url = Uri.parse(addToCartUrl);
    final token = await AuthHelper.getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'course_id': int.parse(courseId),
          'price': price,          
        }),
      );

      if (response.statusCode == 201) {
        _cartCourses.add(int.parse(courseId));  // Update local cart (optional)
        
        notifyListeners();  // Notify UI about cart update
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Course added to cart!')),
        );
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Course is already in the cart.')),
        );
      } else if (response.statusCode == 401) {      
        bool refreshed = await AuthHelper.refreshToken();
        if (refreshed) {
          return addCourseToCart(courseId: courseId, price: price, context: context);            
        } 
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Session Expired!')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add course to cart.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding course to cart: $e')),
      );
    }
  }

  Future<void> checkout(BuildContext context) async {
    final url = Uri.parse(checkoutUrl);
    final token = await AuthHelper.getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _cartUserCourses.clear();  // Clear cart locally after successful checkout
        notifyListeners();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Checkout successful! Order ID: ${data['data']['order_uuid']}')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderListScreen(), 
          ),
        );
      } else if (response.statusCode == 401) {      
        bool refreshed = await AuthHelper.refreshToken();
        if (refreshed) {
          return checkout(context);
        } 
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Session Expired!')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Checkout failed: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during checkout: $e')),
      );
    }
  }

  double get totalPrice {
    return _cartUserCourses.fold(0, (sum, item) => sum + item['price']);
  }

  int get cartCount => _cartItems.length;
}