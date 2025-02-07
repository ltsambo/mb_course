// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

// import 'package:grocery_app/consts/firebase_consts.dart';
import 'package:flutter/material.dart';
import 'package:mb_course/config/api_config.dart';
import 'package:mb_course/providers/user_provider.dart';
import '../models/cart.dart';
import 'package:http/http.dart' as http;

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
  Future<void> fetchUserCart(BuildContext context) async {
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
        print('output data $data');
        if (data['data'] is List){
          _cartUserCourses = List<Map<String, dynamic>>.from(data['data']);
        }
        else {
          _cartUserCourses = [];
        }
       
        print('cart course $_cartUserCourses');
        notifyListeners();  // Notify UI about cart updates
      } else if (response.statusCode == 401) {      
        bool refreshed = await AuthHelper.refreshToken();
        if (refreshed) {
          return fetchUserCart(context);           
        } 
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Session Expired!')),
          );
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

  // Future<void> removeCourse(String id, 
  //     {required courseId
  //   }) async {
  //   // final User? user = authInstance.currentUser;
  //   // await userCollection.doc(user!.uid).update({
  //   //   'userCart': FieldValue.arrayRemove([
  //   //     {'cartId': cartId, 'productId': productId, 'quantity': quantity}
  //   //   ])
  //   // });
  //   _cartItems.remove(courseId);
  //   await fetchUserCart();
  //   notifyListeners();
  // }

  // Future<void> clearOnlineCart() async {
  //   final User? user = authInstance.currentUser;
  //   await userCollection.doc(user!.uid).update({
  //     'userCart': [],
  //   });
  //   _cartItems.clear();
  //   notifyListeners();
  // }

  void clearLocalCart() {
    _cartItems.clear();
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

  double get totalPrice {
    return _cartItems.values.fold(0, (sum, item) => sum + item.price);
  }

  int get cartCount => _cartItems.length;
}