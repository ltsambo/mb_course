import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/screens/carousel/update_carousel_screen.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../../providers/carousel.dart';
import 'create_carousel_screen.dart';


class CarouselScreen extends StatefulWidget {
  @override
  _CarouselScreenState createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  // final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<CarouselProvider>(context, listen: false).fetchCarousels();
  }

  @override
  Widget build(BuildContext context) {
    final carouselProvider = Provider.of<CarouselProvider>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: DefaultTextWg(text: "Carousel List", fontSize: 20, fontColor: whiteColor,),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: whiteColor,)), 
        actions: [
          IconButton(
            icon: Icon(Icons.add_a_photo_outlined, color: whiteColor,),
            onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateCarouselScreen()),
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          
          Expanded(
            child: carouselProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : Padding(
              padding: EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // Show 2 items per row
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 5 / 3.8, // Adjust for better image display
                ),
                itemCount: carouselProvider.carousels.length,
                itemBuilder: (context, index) {
                final carousel = carouselProvider.carousels[index];                
                  return Card(
                    // elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Image Section
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            child: carousel.image != null && carousel.image!.isNotEmpty
                                ? Image.network(
                                    carousel.image!,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return Center(child: CircularProgressIndicator());
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: Icon(Icons.broken_image, size: 50, color: Colors.grey[600]),
                                      );
                                    },
                                  )
                                : Container(
                                    color: Colors.grey[300],
                                    child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
                                  ),
                          ),
                        ),
                        // Title & Actions Section
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  DefaultTextWg(text: carousel.title,),
                                  SizedBox(height: 4),
                                  IconButton(
                                    icon: Icon(Icons.edit, color: primaryColor),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpdateCarouselScreen(carousel: carousel),
                                        ),
                                      );
                                    },
                                  ),
                                  // IconButton(
                                  //   icon: Icon(Icons.delete, color: Colors.red),
                                  //   onPressed: () {
                                  //     // Implement delete functionality
                                  //   },
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
