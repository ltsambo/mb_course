import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/providers/user_provider.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../providers/course_porvider.dart';
import 'components/text_form_field_widget.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({Key? key}) : super(key: key);

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _recommendation = "";
  int _totalDuration = 0;
  String? _description;
  String _instructorUsername = "instructor"; // Replace with logged-in instructor
  bool _isOnSale = false;
  double _price = 0.0;
  double _salePrice = 0.0;
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
      final success = await Provider.of<CourseProvider>(context, listen: false).createCourse(
        title: _title,
        totalDuration: _totalDuration,
        description: _description,
        recommendation: _recommendation,
        instructorUsername: _instructorUsername,
        isOnSale: _isOnSale,
        price: _price,
        salePrice: _salePrice,
        coverImage: _coverImage,
        demoVideo: _demoVideo,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Course created successfully!")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to create course.")));
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: DefaultTextWg(
          text: "Create Course",
          fontSize: 24,
          fontColor: whiteColor,
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
              label: "Title",
              onSaved: (value) => _title = value!,
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              label: "Description",
              onSaved: (value) => _description = value,
            ),
            const SizedBox(height: 12),                        
            CustomTextFormField(
              label: "Recommendation", 
              onSaved: (value) => _recommendation = value!,
            ),
            const SizedBox(height: 12),                        
            CustomTextFormField(
              label: "Price", 
              keyboardType: TextInputType.number,
              onSaved: (value) => _price= double.tryParse(value!) ?? 0.0,
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
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
                "Create",
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

