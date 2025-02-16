import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/providers/course_porvider.dart';
import 'package:mb_course/screens/order/order_screen.dart';
import 'package:mb_course/services/global_methods.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/cart_provider.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/course/admin_course_details.dart';
import '../screens/course/course_detail_screen.dart';
import '../screens/course/course_update.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final Color cardColor;

  const CourseCard({super.key, required this.course, this.cardColor = whiteColor});

  @override
  Widget build(BuildContext context) {    
    // print('course ${course.title} ${course.isPurchased}');   
    return Card(  
      color: primaryColor,    
      child: ListTile(
        selectedColor: primaryColor,
        leading: course.coverImage == null
                ? Image.asset('assets/not-available.jpeg', width: 50, height: 50, fit: BoxFit.cover)
                : Image.network(course.coverImage!, width: 50, height: 50, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Show fallback image when the network image fails to load
                  return Image.asset(
                    'assets/not-available.jpeg',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  );
                },
              ),// Image.network(course.coverImage!, width: 50, height: 50),
        title: DefaultTextWg(text: course.title, fontColor: whiteColor, fontSize: 20,),
        isThreeLine: true,        
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextWg(text: '${course.totalDuration} | ${course.lessons!.length} lessons', fontColor: whiteColor,),   
            DefaultTextWg(text: '${GlobalMethods.formatPrice(course.price.toStringAsFixed(0))} ks', fontColor: whiteColor),  
            // DefaultTextWg(text: 'InCart ${course.inCart}', fontColor: primaryColor),   
            // DefaultTextWg(text: 'IsPurchased ${course.isPurchased}', fontColor: primaryColor),   
            // DefaultTextWg(text: 'IsOrdered ${course.isOrdered}', fontColor: primaryColor),   
          ],
        ),
        trailing: Container(                         
          decoration: BoxDecoration(            
            color: primaryColor.withOpacity(0.1), 
            shape: BoxShape.circle, 
            border: Border.all(color: primaryColor, width: 1.5), 
          ),
          child: (course.isPurchased ?? false) 
          ? IconButton(
          icon: Icon(Icons.play_circle_fill, color: Colors.green),
          onPressed: () {
            // Navigate to the course content page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CourseDetailScreen(course: course)),
            );
          },
        )
      : (course.inCart ?? false)
          ? IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.orange),
              onPressed: () {
                // Navigate to the cart screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              },
            )
        : (course.isOrdered ?? false)
          ? IconButton(
              icon: Icon(Icons.currency_exchange_sharp, color: const Color.fromARGB(255, 12, 42, 173)),
              onPressed: () {
                // Navigate to the cart screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderListScreen()),
                );
              },
            )
        :           
          IconButton(
            icon: Icon(Icons.add_shopping_cart, color: whiteColor),
            onPressed: () async {
              final cartProvider = Provider.of<CartProvider>(context, listen: false);
              final courseProvider = Provider.of<CourseProvider>(context, listen: false);
              await cartProvider.addCourseToCart(
                courseId: course.id.toString(),
                price: course.price,
                context: context
              );
              await courseProvider.fetchCourses();
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added course to cart!')));
            },
          ),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseDetailScreen(course: course),
          ),
        ),
      ),
    );    
  }
}

class AdminCourseCard extends StatelessWidget {
  final Course course;

  const AdminCourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {    
    // print('admin course card ${course.coverImage}');
    return Card(
      child: ListTile(
        leading: course.coverImage != null ? Image.network(course.coverImage!, width: 50, height: 50, fit: BoxFit.cover)
                : Image.asset('assets/not-available.jpeg', width: 50, height: 50, fit: BoxFit.cover),
        title: DefaultTextWg(text: course.title),
        isThreeLine: true,        
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${course.totalDuration} | ${course.lessons!.length} lessons'),   
            DefaultTextWg(text: '${course.price.toStringAsFixed(0)} ks', fontColor: primaryColor),   
          ],
        ),
        trailing: Container(                         
          // decoration: BoxDecoration(            
          //   color: primaryColor.withOpacity(0.1), 
          //   // shape: BoxShape.circle, 
          //   // border: Border.all(color: primaryColor, width: 1.5), 
          // ),
          child: IconButton(
                  icon: Icon(Icons.edit_square, color: primaryColor),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateCourseScreen(course: course,)));
                  },
                ),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AdminCourseDetailScreen(course: course),
          ),
        ),
      ),
    );    
  }
}
