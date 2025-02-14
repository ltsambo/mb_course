import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mb_course/config/api_config.dart';
import 'package:provider/provider.dart';
import '../models/business.dart';
import '../models/carousel.dart';
import '../providers/user_provider.dart';

class ApiService {

  // Fetch businesses
  static Future<List<Business>> fetchBusinesses() async {
    final response = await http.get(Uri.parse(businessListUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Business.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load businesses');
    }
  }

  // Create Business
  static Future<Business> createBusiness(Business business) async {
    final response = await http.post(
      Uri.parse(businessListUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(business.toJson()),
    );

    if (response.statusCode == 201) {
      return Business.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create business');
    }
  }

  // Update Business (PUT)
  static Future<Business> updateBusiness(Business business) async {
    final response = await http.put(
      Uri.parse('$businessListUrl${business.id}/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(business.toJson()),
    );

    if (response.statusCode == 200) {
      return Business.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update business');
    }
  }

  // Fetch carousels
  static Future<List<Carousel>> fetchCarousels() async {
    final response = await http.get(Uri.parse(carouselistUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Carousel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load carousels');
    }
  }

  // Create Carousel
  static Future<Carousel> createCarousel(Carousel carousel, File? imageFile) async {
    var uri = Uri.parse(carouselistUrl); // Directly hit Carousel API
    // var request = http.MultipartRequest('POST', uri);
    
    final token = await AuthHelper.getToken();    
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['title'] = carousel.title;

      // Add title as a field
      // request.fields['title'] = carousel.title;

      // If an image is selected, attach it
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',  // The field name should match Django's serializer field
            imageFile.path,
          ),
        );
      }

      var response = await request.send();

      if (response.statusCode == 201) {
        var responseData = await response.stream.bytesToString();
        return Carousel.fromJson(json.decode(responseData));
      } else {
        throw Exception('Failed to create carousel');
      }
    
  }

  // Update Carousel (PUT)
  static Future<Carousel> updateCarousel(Carousel carousel, File? imageFile) async {
    var uri = Uri.parse('$carouselistUrl${carousel.id}/');

    final token = await AuthHelper.getToken();    
    final request = http.MultipartRequest('PATCH', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['title'] = carousel.title;
    // Add title if changed
    // request.fields['title'] = carousel.title;

    // Add new image if selected
    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      return Carousel.fromJson(json.decode(responseData));
    } else {
      throw Exception('Failed to update carousel');
    }
  }

  // Patch Carousel (PATCH)
  static Future<bool> disableCarousel(int id) async {
    final  uri = Uri.parse('$carouselistUrl${id}/deactivate/');

    final token = await AuthHelper.getToken();    
    
    final response = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({'is_active': false}), // Only update is_active
    );

    return response.statusCode == 200;
  }
}
