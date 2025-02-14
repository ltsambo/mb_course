import 'package:flutter/material.dart';
import '../models/business.dart';
import '../services/api_service.dart';

class BusinessProvider with ChangeNotifier {
  List<Business> _businesses = [];
  bool _isLoading = false;

  List<Business> get businesses => _businesses;
  bool get isLoading => _isLoading;

  // Fetch businesses
  Future<void> fetchBusinesses() async {
    _isLoading = true;
    notifyListeners();

    try {
      _businesses = await ApiService.fetchBusinesses();
    } catch (e) {
      print("Error fetching businesses: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add a new business
  Future<void> addBusiness(Business business) async {
    try {
      Business newBusiness = await ApiService.createBusiness(business);
      _businesses.add(newBusiness);
      notifyListeners();
    } catch (e) {
      print("Error adding business: $e");
    }
  }

  // Update business
  Future<void> updateBusiness(Business business) async {
    try {
      Business updatedBusiness = await ApiService.updateBusiness(business);
      int index = _businesses.indexWhere((b) => b.id == business.id);
      if (index != -1) {
        _businesses[index] = updatedBusiness;
        notifyListeners();
      }
    } catch (e) {
      print("Error updating business: $e");
    }
  }

  // Patch business
  // Future<void> patchBusiness(int id, Map<String, dynamic> updates) async {
  //   try {
  //     Business patchedBusiness = await ApiService.patchBusiness(id, updates);
  //     int index = _businesses.indexWhere((b) => b.id == id);
  //     if (index != -1) {
  //       _businesses[index] = patchedBusiness;
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     print("Error patching business: $e");
  //   }
  // }
}
