import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/services/global_methods.dart';
import 'package:mb_course/widgets/custom_button.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:mb_course/widgets/lesson_card.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../models/course.dart';
import '../../providers/cart_provider.dart';
import '../../providers/course_porvider.dart';
import '../../widgets/video_player_widget.dart';
import '../cart/cart_screen.dart';
import '../order/order_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;
  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {  
  
  @override  
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    Course? _course = courseProvider.course;
    print('course $_course');
    if (_course == null) {
    return Scaffold(
      appBar: AppBar(title: Text("Course Details")),
      body: Center(child: CircularProgressIndicator()), // Show loading indicator
    );
  }
    print('course status ${_course?.isPurchased} - C ${_course?.inCart} - Li ${_course?.isOrdered}');
    bool isPurchased = _course?.isPurchased ?? false;
    bool inCart = _course?.inCart ?? false;
    bool isOrdered = _course?.isOrdered ?? false;
    return Scaffold(
      backgroundColor: backgroundColor, // Light Beige Background
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: DefaultTextWg(text: _course!.title, fontColor: whiteColor, fontSize: 20,),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: whiteColor,)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [         
            // Course Title & Price Section
            DefaultTextWg(text: _course.title, fontSize: 28, fontWeight: FontWeight.w800,),            
            SizedBox(height: 8),
            Row(
              children: [
                Expanded( // ✅ Ensures button & price have space to render properly
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7), // Adjust padding
                      backgroundColor: isPurchased ? Colors.grey
                                      : inCart ? Colors.blue
                                      : isOrdered ? Colors.orange
                                      : primaryColor, // Different colors for different states
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                      minimumSize: Size(80, 32),
                      elevation: 0,
                    ),
                    onPressed: () {
                      if (inCart) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
                      } else if (isOrdered) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderListScreen()));
                      } else if (!isPurchased) {
                        final cartProvider = Provider.of<CartProvider>(context, listen: false);
                        final courseProvider = Provider.of<CourseProvider>(context, listen: false);
                        
                        cartProvider.addCourseToCart(
                          courseId: _course.id.toString(),
                          price: _course.price,
                          context: context,
                        );

                        Future.delayed(Duration(milliseconds: 100), () async {
                          await courseProvider.fetchCourses();
                        });
                      }
                    },
                    child: Text(
                      isPurchased ? 'Purchased' 
                        : inCart ? 'View Cart' 
                        : isOrdered ? 'View Order' 
                        : 'Add to Cart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Ensures text is visible on the button
                      ),
                    ),
                  ),

                ),
                SizedBox(width: 16),  // ✅ Make sure there is space for this
                DefaultTextWg(text: '${GlobalMethods.formatPrice(_course.price.toString())} Ks', fontSize: 20,),
              ],
            ),

            SizedBox(height: 16),
            DefaultTextWg(text: _course.description!, fontWeight: FontWeight.w200, fontColor: Colors.black54,),
            // Course Description            
            SizedBox(height: 12),

            // Recommended Props
            DefaultTextWg(text: "Recommended Props: ${_course.recommendation}"),            
            SizedBox(height: 16),

            // Video Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_course.demoVideo == null) 
                    Column(
                      children: [
                        Image.asset(noVideoImagePath), 
                        DefaultTextWg(text: 'Error on video loading!'),
                      ],
                    )
                  else
                    VideoPlayerWidget(url: _course.demoVideo!),  // ✅ Only load if URL is not null
                ],
              ),
            ),

            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _course.lessons != null ? _course.lessons!.length : 0,  // ✅ Null check
              itemBuilder: (context, index) {
                final lesson = _course.lessons![index];

                return _buildLessonItem(
                  image: '',
                  title: lesson.title,
                  duration: '${lesson.duration.toStringAsFixed(0)} mins',
                  isDemo: lesson.isDemo,
                  isPurchased: _course.isPurchased ?? false,
                  videoUrl: lesson.video.toString(),
                  context: context,
                );
              },
            ),

        
            // Lessons List
            // _buildLessonItem(
            //   image: 'assets/yoga_pose1.jpg',
            //   title: "Legged King Pigeon",
            //   duration: "15 mins",
            // ),
            // _buildLessonItem(
            //   image: 'assets/yoga_pose2.jpg',
            //   title: "Forward-Bending Camel",
            //   duration: "12 mins",
            // ),
            // _buildLessonItem(
            //   image: 'assets/yoga_pose3.jpg',
            //   title: "Downward Facing Dog",
            //   duration: "19 mins",
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonItem({
    required String image,
    required String title,
    required String duration,
    required bool isDemo,
    required bool isPurchased,
    required String videoUrl, // ✅ Video URL for playback
    required BuildContext context, // ✅ Pass context for popup
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // ✅ Align text & icon properly
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/logo/main_logo.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextWg(text: title, fontColor: Colors.black54),
                  DefaultTextWg(text: duration, fontColor: Colors.black54, fontSize: 14),
                ],
              ),
            ],
          ),

          // ✅ Play Icon (Opens Video Popup)
          GestureDetector(
            onTap: () {
              if (isDemo || isPurchased) {
                _showVideoPopup(context, videoUrl);
              }
            },
            child: Icon(
              isDemo || isPurchased ? Icons.play_circle_fill : Icons.lock,
              color: isDemo || isPurchased ? Colors.green : Colors.grey,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  void _showVideoPopup(BuildContext context, String videoUrl) {
    VideoPlayerController controller = VideoPlayerController.network(videoUrl);
    
    controller.initialize().then((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: VideoPlayerWidget(url: videoUrl),
          );
        },
      ).then((_) {
        controller.dispose(); // Dispose video player when dialog is closed
      });
    });
  }
}


class VideoPlayerWidget1 extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget1({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget1> {
  late VideoPlayerController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() => _isLoading = false);
        _controller.play(); // Auto-play video
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose controller when closing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _isLoading
            ? Center(child: CircularProgressIndicator()) // Loading indicator
            : AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
        
        // ✅ Close Button
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            icon: Icon(Icons.close, color: Colors.white, size: 24),
            onPressed: () {
              Navigator.of(context).pop(); // Close the popup
            },
          ),
        ),
      ],
    );
  }
}




// class CourseDetailScreen extends StatelessWidget {
//   final Course course;

//   const CourseDetailScreen({required this.course});

//   @override
//   Widget build(BuildContext context) {
//     print('is purchased ${course.title} ${course.isPurchased}');
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: DefaultTextWg(text: course.title, fontColor: whiteColor, fontSize: 20,),
//         leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: whiteColor,)),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Preview Video Section
//             course.demoVideo == null ? Image.asset('assets/not-available.jpeg'):
//             VideoPlayerWidget(url: course.demoVideo!),

//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     course.title,
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     course.description.toString(),
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: 8),
//                   Text('Created by: ${course.instructorUsername}'),
//                   SizedBox(height: 8),
//                   Text('Last updated on: ${course.modifiedOn}'),
//                   SizedBox(height: 8),
//                   Text('Price: ${course.price}'),
//                   SizedBox(height: 16),
//                   if (course.isPurchased ?? true)
//                   CustomElevatedButton(
//                     text: 'Add to cart', 
//                     onPressed: () => {}),
                  
//                   SizedBox(height: 16),
//                   Text(
//                     'What youll learn',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   // ...course.learningPoints.map((point) => Text('• $point')).toList(),
//                 ],
//               ),
//             ),

//             Divider(),

//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'Lessons',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),

//             LessonCard(course: course)
//           ],
//         ),
//       ),
//     );
//   }
// }