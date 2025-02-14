import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/services/global_methods.dart';
import 'package:mb_course/widgets/custom_button.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';
import '../../models/carousel.dart';
import '../../providers/carousel.dart';

class UpdateCarouselScreen extends StatefulWidget {
  final Carousel carousel;

  UpdateCarouselScreen({required this.carousel});

  @override
  _UpdateCarouselScreenState createState() => _UpdateCarouselScreenState();
}

class _UpdateCarouselScreenState extends State<UpdateCarouselScreen> {
  final TextEditingController _titleController = TextEditingController();
  File? _selectedImage;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.carousel.title;
  }

  // Function to pick an image
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Function to clear the selected image
  void _clearImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _updateCarousel() async {
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
      Carousel updatedCarousel = Carousel(id: widget.carousel.id, title: _titleController.text);
      await Provider.of<CarouselProvider>(context, listen: false)
          .updateCarousel(updatedCarousel, _selectedImage);
      await Provider.of<CarouselProvider>(context, listen: false)
          .fetchCarousels();
      Navigator.pop(context); // Close the screen after update
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update carousel")),
      );
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final carouselProvider = Provider.of<CarouselProvider>(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: DefaultTextWg(text: 'Update Carousel', fontSize: 20, fontColor: Colors.white),
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Colors.white,)),
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
                    : widget.carousel.image != null
                        ? Image.network(widget.carousel.image!, fit: BoxFit.cover)
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
                    onPressed: _updateCarousel,
                    text: "Update Carousel",
                  ),
            SizedBox(height: 20),
            CustomDeleteBtm(fct: () async {
                // await cartProvider.clearOnlineCart();
                carouselProvider.disableCarousel(widget.carousel.id!);
                carouselProvider.fetchCarousels();
                Navigator.pop(context);
              }, lastDate: GlobalMethods.formatDate(widget.carousel.modifiedOn.toString())),          
            ],
        ),
      ),
    );
  }
}
