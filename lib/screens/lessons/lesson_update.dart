import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/providers/course_porvider.dart';
import 'package:provider/provider.dart';

import '../../models/course.dart';
import '../../models/lesson.dart';
import '../../providers/lesson_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/default_text.dart';

class UpdateLessonScreen extends StatefulWidget {
  final Course course;
  final int lessonId;

  const UpdateLessonScreen({
    Key? key,
    required this.course,
    required this.lessonId,
  }) : super(key: key);

  @override
  _UpdateLessonScreenState createState() => _UpdateLessonScreenState();
}

class _UpdateLessonScreenState extends State<UpdateLessonScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _orderController = TextEditingController();
  String? _videoFileName;
  bool _isDemo = false;
  File? _videoFile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLessonDetails();
    });
  }

  Future<void> _fetchLessonDetails() async {
    final lessonProvider = Provider.of<LessonProvider>(context, listen: false);    
    Lesson? lesson = await lessonProvider.fetchLessonById(widget.course.id, widget.lessonId);
    // print('lessons $lesson');
    if (lesson != null) {
      setState(() {
        _titleController.text = lesson.title;
        _contentController.text = lesson.content ?? "";
        _durationController.text = lesson.duration.toString();
        _orderController.text = lesson.order.toString();
        _isDemo = lesson.isDemo;

        if (lesson.video != null && lesson.video!.isNotEmpty) {
          _videoFileName = lesson.video!.split('/').last; // Extract filename from URL
        }
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateLesson() async {
    if (_formKey.currentState!.validate()) {
      bool success = await Provider.of<LessonProvider>(context, listen: false).updateLesson(
        lessonId: widget.lessonId,
        courseId: widget.course.id,
        title: _titleController.text,
        content: _contentController.text,
        duration: _durationController.text,
        isDemo: _isDemo,
        orderIndex: int.tryParse(_orderController.text) ?? 1,
        video: _videoFile,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lesson updated successfully!")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update lesson")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lessonProvider = Provider.of<LessonProvider>(context);
    final _courseProvider = Provider.of<CourseProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: DefaultTextWg(text: 'Update Lesson', fontSize: 24, fontColor: Colors.white),
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DefaultTextWg(text: widget.course.title, fontSize: 20, fontColor: Colors.blueAccent),
                    SizedBox(height: 12),
                    
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: "Title", border: OutlineInputBorder()),
                      validator: (value) => value!.isEmpty ? "Enter title" : null,
                    ),
                    SizedBox(height: 12),

                    TextFormField(
                      controller: _contentController,
                      decoration: InputDecoration(labelText: "Content", border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 12),

                    TextFormField(
                      controller: _durationController,
                      decoration: InputDecoration(labelText: "Duration (minutes)", border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? "Enter duration" : null,
                    ),
                    SizedBox(height: 12),

                    TextFormField(
                      controller: _orderController,
                      decoration: InputDecoration(labelText: "Order", border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? "Enter order" : null,
                    ),
                    SizedBox(height: 12),
                    
                    SwitchListTile(
                      title: Text("Is Demo"),
                      value: _isDemo,
                      onChanged: (value) => setState(() => _isDemo = value),
                    ),
                    SizedBox(height: 12),
                    
                    ElevatedButton(
                      onPressed: _pickVideo,
                      child: Text(_videoFile == null ? "Select Video" : "Change Video"),
                    ),
                    
                    if (_videoFile != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("Selected: ${_videoFile!.path.split('/').last}", style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ),
                    if (_videoFileName != null && _videoFile == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Selected: $_videoFileName",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),

                    SizedBox(height: 16),
                    
                    CustomElevatedButton(
                      onPressed: _updateLesson,
                      text: "Update Lesson",
                    ),

                    SizedBox(height: 16,),
                    CustomDeleteBtm(fct: () async {
                      // await cartProvider.clearOnlineCart();
                      lessonProvider.deactivateLesson(widget.lessonId);
                      _courseProvider.fetchCourseById(widget.course.id);
                      Navigator.pop(context);
                    }, lastDate: ''),          
                  ],
                ),
              ),              
            ),
    );
  }
}
