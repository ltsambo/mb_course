import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/course.dart';
import '../../providers/course_porvider.dart';
import 'components/text_form_field_widget.dart';

class UpdateCourseScreen extends StatefulWidget {
  final Course course;
  const UpdateCourseScreen({Key? key, required this.course}) : super(key: key);

  @override
  State<UpdateCourseScreen> createState() => _UpdateCourseScreenState();
}

class _UpdateCourseScreenState extends State<UpdateCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _recommendation;
  late int _totalDuration = 0;
  String? _description;
  // String _instructorUsername = "instructor"; // Replace with logged-in instructor
  late bool _isOnSale = false;
  late double _price = 0.0;
  late double _salePrice = 0.0;
  File? _coverImage;
  File? _demoVideo;

  final picker = ImagePicker();

  // ✅ Pick Image
  Future<void> _pickCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _coverImage = File(pickedFile.path);
      });
    }
  }

  // ✅ Pick Video
  Future<void> _pickDemoVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _demoVideo = File(pickedFile.path);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final success = await Provider.of<CourseProvider>(context, listen: false).updateCourse(
        courseId: widget.course.id,
        title: _title,
        totalDuration: _totalDuration,
        description: _description,
        recommendation: _recommendation,
        isOnSale: _isOnSale,
        price: _price,
        salePrice: _salePrice,
        coverImage: _coverImage,
        demoVideo: _demoVideo,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Course updated successfully!")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update course.")));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    print('recommendation ${widget.course.recommendation}');
    _title = widget.course.title;
    _recommendation = widget.course.recommendation ?? "";
    _totalDuration = widget.course.totalDuration;
    _description = widget.course.description;
    _isOnSale = widget.course.isOnSale;
    _price = widget.course.price;
    _salePrice = widget.course.salePrice;
  }
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () {
        //     // Back button action
        //   },
        // ),
        title: Text(
          "Update Course",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: whiteColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextFormField(
              initialValue: _title,
              label: "Title",
              onSaved: (value) => _title = value!,
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              initialValue: _description,
              label: "Description",
              onSaved: (value) => _description = value,
            ),
            const SizedBox(height: 12),                        
            CustomTextFormField(
              initialValue: _recommendation,
              label: "Recommendation", 
              onSaved: (value) => _recommendation = value!,
            ),
            const SizedBox(height: 12),                        
            CustomTextFormField(
              initialValue: _price.toStringAsFixed(0),
              label: "Price", 
              keyboardType: TextInputType.number,
              onSaved: (value) => _price= double.tryParse(value!) ?? 0.0,
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
                  initialValue: _salePrice.toStringAsFixed(0),
                  label: "Sale Price",
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _salePrice = double.tryParse(value!) ?? 0.0,
                ),
            SwitchListTile(
                  title: Text("Is on Sale?"),
                  value: _isOnSale,
                  onChanged: (value) => setState(() => _isOnSale = value),
                ),
            const SizedBox(height: 12),
            ElevatedButton(
                  onPressed: _pickCoverImage,
                  child: Text(_coverImage == null ? "Select Cover Image" : "Cover: ${_coverImage!.path.split('/').last}"),
                ),
                if (_coverImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Selected: ${_coverImage!.path}",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
            const SizedBox(height: 12),
            // Role Dropdown
            ElevatedButton(
                  onPressed: _pickDemoVideo,
                  child: Text(_demoVideo == null ? "Select Demo Video" : "Video: ${_demoVideo!.path.split('/').last}"),
                ),     
                if (_demoVideo != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Selected: ${_demoVideo!.path}",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
            SizedBox(height: 12),
            // Select Image Button            
            authProvider.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                "Update",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            ],
          ),        
        ),)
      ),
    );
  }

  // Widget _buildTextField(String hint) {
  //   return TextField(
  //     decoration: InputDecoration(
  //       hintText: hint,
  //       hintStyle: GoogleFonts.poppins(
  //         fontSize: 14,
  //         color: Colors.grey,
  //       ),
  //       filled: true,
  //       fillColor: const Color(0xFFF0F4F8), // Light grey fill
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: BorderSide.none,
  //       ),
  //     ),
  //   );
  // }

  
}

