import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:grocery_app/inner_screens/product_details.dart';
// import 'package:grocery_app/models/cart_model.dart';
// import 'package:grocery_app/providers/products_provider.dart';
// import 'package:grocery_app/widgets/heart_btn.dart';
// import 'package:grocery_app/widgets/text_widget.dart';
import 'package:mb_course/providers/course_porvider.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../../../models/cart.dart';
import '../../../providers/cart_provider.dart';
import '../../../services/utlis.dart';
// import '../../providers/cart_provider.dart';
// import '../../providers/wishlist_provider.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({Key? key}) : super(key: key);
  
  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    // _quantityTextController.text = widget.q.toString();
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<CourseProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final getCurrProduct = productProvider.findProdById(cartModel.courseId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    // final wishlistProvider = Provider.of<WishlistProvider>(context);
    // bool? isInWishlist =
    //     wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, ProductDetails.routeName,
        //     arguments: cartModel.productId);
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      height: size.width * 0.25,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: FancyShimmerImage(
                        imageUrl: 'https://cdn.pixabay.com/photo/2014/05/07/15/19/django-339744_1280.png',
                        boxFit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultTextWg(text: getCurrProduct.title),
                        DefaultTextWg(text: '\$${(usedPrice).toStringAsFixed(2)}', fontWeight: FontWeight.normal,),
                        const SizedBox(
                          height: 16.0,
                        ),                        
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              await cartProvider.removeCourse(cartModel.id, courseId: cartModel.courseId);
                            },
                            child: const Icon(
                              CupertinoIcons.bin_xmark,
                              color: Colors.red,
                              size: 25,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          // HeartBTN(
                          //   productId: getCurrProduct.id,
                          //   isInWishlist: isInWishlist,
                          // ),
                          // DefaultTextWg(text: '\$${(usedPrice).toStringAsFixed(2)}')
                          // TextWidget(
                          //   text:
                          //       '\$${(usedPrice * int.parse(_quantityTextController.text)).toStringAsFixed(2)}',
                          //   color: color,
                          //   textSize: 18,
                          //   maxLines: 1,
                          // )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}