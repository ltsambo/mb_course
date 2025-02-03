import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/cart_provider.dart';
import '../screens/course/course_detail_screen.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset(course.coverImage, width: 50, height: 50),
        title: DefaultTextWg(text: course.title),
        isThreeLine: true,        
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${course.duration} | ${course.lessons.length} lessons'),   
            DefaultTextWg(text: '20 USD', fontColor: primaryColor),   
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
              cartProvider.addCoursesToCart(
                courseId: course.id,
                price: course.price
              );
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to cart!')));
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
