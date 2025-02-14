import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/widgets/custom_button.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';
import '../../models/carousel.dart';
import '../../providers/carousel.dart';

class CreateCarouselScreen extends StatefulWidget {
  @override
  _CreateCarouselScreenState createState() => _CreateCarouselScreenState();
}

class _CreateCarouselScreenState extends State<CreateCarouselScreen> {
  final TextEditingController _titleController = TextEditingController();
  File? _selectedImage;
  bool _isSubmitting = false;

  // Function to pick an image
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _createCarousel() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Title is required")),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      Carousel newCarousel = Carousel(title: _titleController.text);
      await Provider.of<CarouselProvider>(context, listen: false)
          .addCarousel(context, newCarousel, _selectedImage);      
      Navigator.pop(context); // Close the screen after creation
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create carousel")),
      );
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: DefaultTextWg(text: 'Create Carousel', fontSize: 20, fontColor: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(       
                hintText: "Title",         
                hintStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: const Color(0xFFF0F4F8), // Light grey background
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _selectedImage != null
                    ? Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(_selectedImage!, fit: BoxFit.cover),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: _clearImage,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.7),
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.close, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 50, color: Colors.grey[700]),
                            SizedBox(height: 8),
                            Text("Tap to select image", style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                      ),
              ),
            ),
            SizedBox(height: 20),
            _isSubmitting
                ? CircularProgressIndicator()
                : CustomElevatedButton(
                    onPressed: _createCarousel,
                    text: "Create Carousel",
                  ),
          ],
        ),
      ),
    );
  }
}
