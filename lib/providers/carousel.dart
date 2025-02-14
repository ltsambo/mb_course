import 'dart:io';

import 'package:flutter/material.dart';
import '../models/carousel.dart';
import '../services/api_service.dart';

class CarouselProvider with ChangeNotifier {
  List<Carousel> _carousels = [];
  bool _isLoading = false;

  List<Carousel> get carousels => _carousels;
  bool get isLoading => _isLoading;

  // Fetch carousels
  Future<void> fetchCarousels() async {
    _isLoading = true;
    notifyListeners();

    try {
      _carousels = await ApiService.fetchCarousels();
    } catch (e) {
      print("Error fetching carousels: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add a new carousel
  Future<void> addCarousel(BuildContext context, Carousel carousel, File? imageFile) async {
    try {
      Carousel newCarousel = await ApiService.createCarousel(carousel, imageFile);
      _carousels.add(newCarousel);
      fetchCarousels();
      notifyListeners();
    } catch (e) {
      print("Error adding carousel: $e");
    }
  }

  // Update carousel
  Future<void> updateCarousel(Carousel carousel, File? imageFile) async {
    try {
      Carousel updatedCarousel = await ApiService.updateCarousel(carousel, imageFile);
      int index = _carousels.indexWhere((c) => c.id == carousel.id);
      if (index != -1) {
        _carousels[index] = updatedCarousel;
        fetchCarousels();
        notifyListeners();
      }
    } catch (e) {
      print("Error updating carousel: $e");
    }
  }

  // Patch carousel
  Future<void> disableCarousel(int id) async {
    bool success = await ApiService.disableCarousel(id);
    if (success) {
      _carousels.removeWhere((c) => c.id == id); // Remove from list      
      notifyListeners();
    } else {
      print("Error disabling carousel with id: $id");
    }
  }
}
