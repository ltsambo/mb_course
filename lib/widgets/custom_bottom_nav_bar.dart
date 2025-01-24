import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onItemTapped;

  const CustomBottomNavBar({super.key, 
    required this.currentIndex,
    this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onItemTapped,
      items: const [
        BottomNavigationBarItem(
          backgroundColor: Color.fromARGB(255, 199, 122, 122),
          icon: Icon(Icons.home, color: blackColor,),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book, color: blackColor),
          label: 'My Courses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_shopping_cart, color: blackColor),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings, color: blackColor),
          label: 'Settings',
        ),
      ],
    );
  }
}



class BtmMotionNavbar extends StatelessWidget {
  final MotionTabBarController? motionTabBarController;  
  final Function(int)? onItemTapped;

  const BtmMotionNavbar({super.key, this.motionTabBarController, this.onItemTapped});
  
  @override
  Widget build(BuildContext context) {
    return MotionTabBar(
        initialSelectedTab: "Home",
        labels: const ["Home", "Courses", "Cart", "Settings"],
        icons: const [Icons.home, Icons.book, Icons.add_shopping_cart_outlined, Icons.settings],
        tabSize: 50,
        tabBarHeight: 65,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Colors.grey,
        tabIconSize: 28,
        tabIconSelectedSize: 30,
        tabSelectedColor: primaryColor,
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: onItemTapped
      );
  }
}

