import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/route/route_constants.dart';
import 'package:mb_course/route/screen_export.dart';
import 'package:mb_course/widgets/default_text.dart';

class ManagementItemsScreen extends StatelessWidget {
  const ManagementItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Light beige background
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () {
        //     // Add back navigation
        //   },
        // ),        
        title: DefaultTextWg(text: 'Management', fontSize: 24,),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: managementItems.length,
          itemBuilder: (context, index) {
            final item = managementItems[index];
            return GestureDetector(
              onTap: () {
                // Handle tap
              },
              child: InkWell(
                onTap: () {    
                  if (item['route'] != null) {
                    // Navigator.pushNamed(context, listUserScreenRoute);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserListScreen(),
                      ),
                    );
                  } else {
                    print('Route is not defined for this item.');
                  }              
                  // Navigator.pushNamed(context, route.toString();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => item['page'](), // Replace TargetScreen with your desired page
                  //   ),
                  // );
                },
                borderRadius: BorderRadius.circular(12), // Matches the Card's border radius
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: item['color'] as Color,
                        child: Icon(
                          item['icon'] as IconData,
                          color: whiteColor,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DefaultTextWg(text: item['label'] as String),
                    ],
                  ),
                ),
              )

            );
          },
        ),
      ),
    );
  }
}

