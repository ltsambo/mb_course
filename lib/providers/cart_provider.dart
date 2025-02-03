// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
// import 'package:grocery_app/consts/firebase_consts.dart';
import 'package:flutter/material.dart';
import '../models/cart.dart';


class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};

  Map<String, CartModel> get getCartItems {
    return _cartItems;
  }

  void addCoursesToCart({
    required String courseId,
    required double price,
  }) {
    _cartItems.putIfAbsent(
      courseId,
      () => CartModel(
        id: DateTime.now().toString(),
        courseId: courseId,
        price: price,
      ),
    );
    notifyListeners();
  }

  // final userCollection = FirebaseFirestore.instance.collection('users');
  Future<void> fetchCart() async {
  //   final User? user = authInstance.currentUser;
  //   final DocumentSnapshot userDoc = await userCollection.doc(user!.uid).get();
  //   if (userDoc == null) {
  //     return;
  //   }
  //   final leng = userDoc.get('userCart').length;
  //   for (int i = 0; i < leng; i++) {
  //     _cartItems.putIfAbsent(
  //         userDoc.get('userCart')[i]['productId'],
  //         () => CartModel(
  //               id: userDoc.get('userCart')[i]['cartId'],
  //               productId: userDoc.get('userCart')[i]['productId'],
  //               quantity: userDoc.get('userCart')[i]['quantity'],
  //             ));
  //   }
    notifyListeners();
  }

  Future<void> removeCourse(String id, 
      {required courseId
    }) async {
    // final User? user = authInstance.currentUser;
    // await userCollection.doc(user!.uid).update({
    //   'userCart': FieldValue.arrayRemove([
    //     {'cartId': cartId, 'productId': productId, 'quantity': quantity}
    //   ])
    // });
    _cartItems.remove(courseId);
    await fetchCart();
    notifyListeners();
  }

  Future<void> clearOnlineCart() async {
    // final User? user = authInstance.currentUser;
    // await userCollection.doc(user!.uid).update({
    //   'userCart': [],
    // });
    _cartItems.clear();
    notifyListeners();
  }

  void clearLocalCart() {
    _cartItems.clear();
    notifyListeners();
  }

  double get totalPrice {
    return _cartItems.values.fold(0, (sum, item) => sum + item.price);
  }

  int get cartCount => _cartItems.length;
}