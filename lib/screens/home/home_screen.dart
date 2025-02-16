import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/providers/carousel.dart';
import 'package:mb_course/route/screen_export.dart';
import 'package:mb_course/screens/auth/login_screen.dart';
import 'package:mb_course/widgets/course_card.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';
import '../../widgets/course_carousel.dart';
import '../../providers/course_porvider.dart';
import '../../providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CourseProvider>(context, listen: false).fetchCourses();
    Provider.of<CarouselProvider>(context, listen: false).fetchCarousels();
  }

  @override
Widget build(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context);
  final courseProvider = Provider.of<CourseProvider>(context);    
  final courses = courseProvider.courses;

  // ✅ Ensure userProvider.currentUser is not null before accessing properties
  final imageUrl = (userProvider.currentUser?.image?.isNotEmpty == true)
    ? userProvider.currentUser!.image!
    : '';
  print('image url ${imageUrl}');

  return Scaffold(
    backgroundColor: backgroundColor,
    // appBar: AppBar(
    //   backgroundColor: backgroundColor,
    //   title: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Image.asset(
    //             'assets/logo/main_logo.png', // Replace with your butterfly icon
    //             width: 60,
    //             height: 60,
    //           )
    //       // userProvider.isAuthenticated
    //       //     ? Image.asset(
    //       //       'assets/logo/main_logo.png', // Replace with your butterfly icon
    //       //       width: 60,
    //       //       height: 60,
    //       //     )
    //       //     : DefaultTextWg(
    //       //         text: 'Course List',
    //       //         fontSize: 24,
    //       //         fontWeight: FontWeight.bold,
    //       //         // fontColor: whiteColor,
    //       //       ),
    //       // if (userProvider.isAuthenticated && userProvider.currentUser != null)
    //       //   DefaultTextWg(
    //       //     text: userProvider.currentUser!.username,
    //       //     fontSize: 15,
    //       //     fontColor: blackColor,
    //       //   ),
    //     ],
    //   ), 
      
    //   actions: [
    //     if (userProvider.isAuthenticated && userProvider.currentUser != null)          
    //       GestureDetector(
    //         onTap: () {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => UserProfileScreen(userId: userProvider.currentUser!.id),
    //             ),
    //           );               
    //         },
    //         child: Padding(
    //           padding: const EdgeInsets.all(10.0),
    //           child: CircleAvatar(
    //             backgroundImage: imageUrl != null
    //                 ? NetworkImage(imageUrl)
    //                 : AssetImage(noUserImagePath) as ImageProvider,                               
    //           ),                
    //         ),
    //       )
    //     else
    //       IconButton(
    //         // color: whiteColor,
    //         icon: Icon(Icons.login),
    //         onPressed: () {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => UserLoginScreen(),
    //             ),
    //           );
    //         },
    //       ),
    //   ],
    // ),
    body: RefreshIndicator(
      onRefresh: () async {
        courseProvider.fetchCourses();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Courses refreshed!'),
            backgroundColor: Colors.green,
          ),
        );
      },
      child: Column(        
        crossAxisAlignment: CrossAxisAlignment.start,    
        children: [
          const SizedBox(height: 20),
          userProvider.currentUser != null ?
            WelcomeHeader(
              username: userProvider.currentUser!.username,
              profileImageUrl: imageUrl,
            )
          : WelcomeHeader(
              username: "User",
              profileImageUrl: "",
            ),
          const SizedBox(height: 16),
          CourseCarousel(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: DefaultTextWg(
              text: 'Our Programs',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontColor: Colors.black,
            ),
          ),              
          // const SizedBox(height: 8),
          // Course List
          Expanded(
            child: ListView.builder(
              itemCount: courseProvider.courses.length,
              itemBuilder: (context, index) {
                final course = courseProvider.courses[index];
                final cardColor = (index % 2 == 0) ? primaryColor : (Colors.grey[300] ?? Colors.grey);
                return CourseCard(course: course, cardColor: cardColor);
              },
            ),
          )
        ],
      ),
    ),
    floatingActionButton: userProvider.isAuthenticated
        ? null
        : FloatingActionButton(
            onPressed: () {                
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserLoginScreen(),
                ),
              );
            },
            backgroundColor: const Color.fromARGB(255, 54, 109, 72),
            child: const Icon(Icons.login_rounded, color: Colors.white),
          ),
  );
}
}

class WelcomeHeader extends StatelessWidget {
  final String username;
  final String profileImageUrl;

  const WelcomeHeader({
    super.key,
    required this.username,
    required this.profileImageUrl,
  });

  /// Function to get greeting based on the current time
  String _getGreeting() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 18) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      color: const Color(0xFFFDF5EC), // Light beige background
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Section: Icon and Greeting Text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Butterfly Icon
              Image.asset(
                logoImagePath, // Replace with your butterfly icon
                width: 80,
                height: 80,
              ),
              const SizedBox(height: 8),
              // "Hello, User" Text
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Petrov Sans', // Custom font
                    fontSize: 28,
                    fontWeight: FontWeight.w800, // Semi Bold
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(
                      text: "Hello, ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: username,
                      style: const TextStyle(
                        color: Color(0xFF59786D), // Greenish color for username
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              // Dynamic Greeting Text
              Text(
                "${_getGreeting()} and welcome back.",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: 'Petrov Sans',
                ),
              ),
            ],
          ),

          // Right Section: User Profile Picture (Prevents Null Errors)
          CircleAvatar(
            radius: 30,
            backgroundImage: (profileImageUrl.isNotEmpty)
                ? NetworkImage(profileImageUrl)
                : AssetImage(noUserImagePath) as ImageProvider,                               
          ),   
        ],
      ),
    );
  }
}

