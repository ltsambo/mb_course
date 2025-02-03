import 'package:flutter/cupertino.dart';

class CartModel with ChangeNotifier {
  final String id, courseId;
  final double price;

  CartModel({
    required this.id,
    required this.courseId,
    required this.price,
  });
}