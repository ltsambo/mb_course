import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/cart_provider.dart';
import '../screens/course/admin_course_details.dart';
import '../screens/course/course_detail_screen.dart';
import '../screens/course/course_update.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {    
    return Card(
      child: ListTile(
        leading: course.coverImage == null
                ? Image.asset('assets/not-available.jpeg', width: 50, height: 50, fit: BoxFit.cover)
                : Image.network(course.coverImage!, width: 50, height: 50, fit: BoxFit.cover),// Image.network(course.coverImage!, width: 50, height: 50),
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
          decoration: BoxDecoration(            
            color: primaryColor.withOpacity(0.1), 
            shape: BoxShape.circle, 
            border: Border.all(color: primaryColor, width: 1.5), 
          ),
          child: IconButton(
            icon: Icon(Icons.add_shopping_cart, color: primaryColor),
            onPressed: () {
              final cartProvider = Provider.of<CartProvider>(context, listen: false);
              cartProvider.addCourseToCart(
                courseId: course.id.toString(),
                price: course.price,
                context: context
              );
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
    print('admin course card ${course.coverImage}');
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
