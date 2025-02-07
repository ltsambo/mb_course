import 'package:flutter/cupertino.dart';

class CartItemModel with ChangeNotifier {
  final String id, courseId;
  final double price;

  CartItemModel({
    required this.id,
    required this.courseId,
    required this.price,
  });
}