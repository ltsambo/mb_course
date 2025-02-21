import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:grocery_app/inner_screens/product_details.dart';
// import 'package:grocery_app/models/cart_model.dart';
// import 'package:grocery_app/providers/products_provider.dart';
// import 'package:grocery_app/widgets/heart_btn.dart';
// import 'package:grocery_app/widgets/text_widget.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../../../providers/cart_provider.dart';
import '../../../services/utlis.dart';
// import '../../providers/cart_provider.dart';
// import '../../providers/wishlist_provider.dart';

class CartWidget extends StatefulWidget {
  final Map<String, dynamic> item;
  const CartWidget({Key? key, required this.item}) : super(key: key);
  
  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  
  @override
  void initState() {
    // _quantityTextController.text = widget.q.toString();
    super.initState();
  }

  @override
  void dispose() {    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    // final courseProvider = Provider.of<CourseProvider>(context);
    // final cartModel = Provider.of<CartItemModel>(context);
    // final getCurrProduct = courseProvider.findProdById(cartModel.courseId);
    // double usedPrice = getCurrProduct.isOnSale
    //     ? getCurrProduct.salePrice
    //     : getCurrProduct.price;
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
                      height: size.width * 0.20,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: FancyShimmerImage(
                        imageUrl: widget.item['course']['cover_image'],
                        boxFit: BoxFit.fill,
                        errorWidget: Image.asset(
                          'assets/not-available.jpeg',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultTextWg(text: widget.item['course']['title']),
                        DefaultTextWg(text: '${widget.item['course']['price']} ks', fontWeight: FontWeight.normal,),
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
                              print('course id ${widget.item}');
                              cartProvider.deleteCartItem(widget.item['id'], context);
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