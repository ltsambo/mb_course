import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/screens/course/course_update.dart';
import 'package:mb_course/screens/lessons/lesson_create.dart';
import 'package:mb_course/services/global_methods.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../models/course.dart';
import '../../providers/course_porvider.dart';
import '../../widgets/video_player_widget.dart';

class AdminCourseDetailScreen extends StatefulWidget {
  final Course course;
  const AdminCourseDetailScreen({super.key, required this.course});

  @override
  State<AdminCourseDetailScreen> createState() => _AdminCourseDetailScreenState();
}

class _AdminCourseDetailScreenState extends State<AdminCourseDetailScreen> {  
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CourseProvider>(context, listen: false).fetchCourseById(widget.course.id);
    });
  }

  @override
  Widget build(BuildContext context) {    
    final courseProvider = Provider.of<CourseProvider>(context);
    Course? _course = courseProvider.course;
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
            DefaultTextWg(text: _course!.title, fontSize: 28, fontWeight: FontWeight.w800,),            
            SizedBox(height: 8),
            DefaultTextWg(text: '${GlobalMethods.formatPrice(_course!.price.toString())} Ks', fontSize: 20,),
            SizedBox(width: 16), 
            Row(
              children: [
                Expanded( // ✅ Ensures button & price have space to render properly
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7), // Adjust padding
                      backgroundColor: primaryColor, // Different colors for different states
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                      minimumSize: Size(80, 32),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateCourseScreen(course: widget.course)));
                    },
                    child: Text(
                      'Edit Course',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Ensures text is visible on the button
                      ),
                    ),
                  ),
                ),
                 // ✅ Make sure there is space for this                
              ],
            ),

            SizedBox(height: 16),
            DefaultTextWg(text: widget.course.description!, fontWeight: FontWeight.w200, fontColor: Colors.black54,),
            // Course Description            
            SizedBox(height: 12),

            // Recommended Props
            DefaultTextWg(text: "Recommended Props: ${widget.course.recommendation}"),            
            SizedBox(height: 16),

            // Video Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (widget.course.demoVideo == null) 
                    Column(
                      children: [
                        Image.asset(noVideoImagePath), 
                        DefaultTextWg(text: 'Error on video loading!'),
                      ],
                    )
                  else
                    VideoPlayerWidget(url: widget.course.demoVideo!),  // ✅ Only load if URL is not null
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7), // Adjust padding
                      backgroundColor: primaryColor, // Different colors for different states
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                      minimumSize: Size(80, 32),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CreateLessonScreen(course: widget.course,)));
                    },
                    child: Text(
                      '+ Add Lessons',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Ensures text is visible on the button
                      ),
                    ),
                  ),
            ),            
            SizedBox(height: 8,),
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
              Icons.edit_note_rounded,
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

