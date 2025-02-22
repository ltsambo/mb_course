import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/screens/course/admin_course_details.dart';
import 'package:mb_course/widgets/custom_button.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/course.dart';
import '../../models/lesson.dart';
import '../../providers/lesson_provider.dart';


class CreateLessonScreen extends StatefulWidget {
  final Course course;
  const CreateLessonScreen({super.key, required this.course});
  @override
  _CreateLessonScreenState createState() => _CreateLessonScreenState();
}

class _CreateLessonScreenState extends State<CreateLessonScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _orderController = TextEditingController();
  bool _isDemo = false;
  // int? _selectedCourseId;
  File? _videoFile;

  @override
  void initState() {
    super.initState();
    Provider.of<LessonProvider>(context, listen: false).fetchDropDownCourses();
  }

  Future<void> _pickVideo() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitLesson() async {
    if (_formKey.currentState!.validate()) {
      if (widget.course.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a course")));
        return;
      }

      Lesson newLesson = Lesson(
        title: _titleController.text,
        content: _contentController.text,
        duration: int.parse(_durationController.text),
        isDemo: _isDemo,
        courseId: widget.course.id,
        order: int.parse(_orderController.text),
      );

      bool success = await Provider.of<LessonProvider>(context, listen: false)
          .createLesson(newLesson, _videoFile);

      if (success) {
        // Provider.of<CourseProvider>(context, listen: false).fetchCourseById(widget.course.id);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lesson created successfully!")));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminCourseDetailScreen(course: widget.course)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to create lesson")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final lessonProvider = Provider.of<LessonProvider>(context);
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: DefaultTextWg(text: 'Create Lesson', fontSize: 24, fontColor: whiteColor,),
        leading: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back, color: whiteColor,)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DefaultTextWg(text: widget.course.title, fontSize: 20, fontColor: primaryColor,),
                // DropdownButtonFormField<int>(
                //   value: _selectedCourseId,
                //   items: lessonProvider.courses.map((course) {
                //     print('course $course');
                //     return DropdownMenuItem<int>(
                //       value: course.id,
                //       child: Text(course.title),
                //     );
                //   }).toList(),
                //   onChanged: (value) => setState(() => _selectedCourseId = value),
                //   decoration: InputDecoration(labelText: "Course", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),)),
                // ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: "Title", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),)),
                  validator: (value) => value!.isEmpty ? "Enter title" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(labelText: "Content", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),),),                
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _durationController,
                  decoration: InputDecoration(labelText: "Duration (minutes)", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),)),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? "Enter duration" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _orderController,
                  decoration: InputDecoration(labelText: "Order", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),)),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? "Enter order" : null,
                ),
                const SizedBox(height: 12),                
                SwitchListTile(
                  title: Text("Is Demo"),
                  value: _isDemo,
                  onChanged: (value) => setState(() => _isDemo = value),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                    onPressed: _pickVideo,
                    child: Text(_videoFile == null ? "Select Video" : "Selected"),
                  ),     
                  if (_videoFile != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Selected: ${_videoFile!.path.split('/').last}",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                // CustomElevatedButton(
                //   onPressed: _pickVideo,
                //   text: "Pick Video",
                // ),
                SizedBox(height: 16,),
                CustomElevatedButton(
                  onPressed: _submitLesson,
                  text: "Submit",
                ),
              ],
            ),
          ),
        ),
      )      
    );
  }
}
