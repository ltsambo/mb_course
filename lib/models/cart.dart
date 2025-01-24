import 'package:flutter/cupertino.dart';

class CartModel with ChangeNotifier {
  final String id, productId;

  CartModel({
    required this.id,
    required this.productId,
  });
}