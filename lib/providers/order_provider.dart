import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mb_course/config/api_config.dart';
import 'package:mb_course/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class OrderProvider with ChangeNotifier {  
  List<Map<String, dynamic>> _userOrders = [];
  List<Map<String, dynamic>> get userOrders => _userOrders;
  List<dynamic> pendingAcceptanceOrders = []; 
  Map<String, int> statusCounts = {};
  
  // final userCollection = FirebaseFirestore.instance.collection('users');
  Future<void> fetchUserOrders(BuildContext context, {bool retry = true}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final url = Uri.parse(fetchUserOrderUrl);
    
    final token = await AuthHelper.getToken();    
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {    
        final data = jsonDecode(response.body);
        if (data['data']['orders'] is List){
          _userOrders = List<Map<String, dynamic>>.from(data['data']['orders']);
          print('status count ${data['data']['status_count']}');
          final statusList = data['data']['status_count'] as List<dynamic>;
          statusCounts = {
            for (var statusItem in statusList)
              statusItem['status']: statusItem['count']
          };
          print('status count 2 $statusCounts');
        }
        else {
          _userOrders = [];
        }

        notifyListeners();  // Notify UI about cart updates
      } else if (response.statusCode == 401 && retry) {      
        if (userProvider.isAuthenticated) {
          bool refreshed = await AuthHelper.refreshToken();
          if (refreshed) {
            return fetchUserOrders(context, retry: false);  // Retry after refreshing token
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Session Expired! Please log in again.')),
            );
            userProvider.logout(context);  // Log out the user if refresh fails
          }
        }
      } else {
        print('Error: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode} Failed to fetch order: ${response.body}')),
        );
      }
    } catch (e) {
      print('error $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching orders: $e')),
      );
    }
  }

  Future<void> uploadReceipt(int orderId, File receiptImage, BuildContext context, {bool retry = true}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = await AuthHelper.getToken();
    final url = Uri.parse(orderPaymentUrl);

    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['order'] = orderId.toString();

    // Attach receipt file if provided
    if (receiptImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('receipt', receiptImage.path),
      );
    }

    // Sending the request
    final response = await request.send();
    final responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 201) {
      // Successfully uploaded
      fetchUserOrders(context);
      notifyListeners();
    } else if (response.statusCode == 401 && retry) {      
      if (userProvider.isAuthenticated) {
        bool refreshed = await AuthHelper.refreshToken();
        if (refreshed) {
          return uploadReceipt(orderId, receiptImage, context, retry: false);  // Retry after refreshing token
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Session Expired! Please log in again.')),
          );
          userProvider.logout(context);  // Log out the user if refresh fails
        }
      }
    } else {
      // Handle error
      final error = jsonDecode(responseBody.body);
      throw Exception('Failed to upload receipt: ${error['message']}');
    }
  }

  Future<Map<String, dynamic>> createPayment({
    required int orderId,
    File? receipt,
  }) async {
    final token = await AuthHelper.getToken();
    final url = Uri.parse(orderPaymentUrl);
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['order'] = orderId.toString();

    if (receipt != null) {
      request.files.add(await http.MultipartFile.fromPath('receipt', receipt.path));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create payment: ${response.body}');
    }
  }

  // Get payments for the logged-in user
  Future<List<dynamic>> getPayments() async {
    final token = await AuthHelper.getToken();
    final response = await http.get(
      Uri.parse(orderPaymentUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch payments');
    }
  }

  Future<void> fetchPendingAcceptanceOrders(BuildContext context, {bool retry = true}) async {
    final token = await AuthHelper.getToken();
    final url = Uri.parse(retrievePaymentAcceptanceUrl);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        pendingAcceptanceOrders = data['data'];  // Extract pending orders
        notifyListeners();  // Notify UI to update
      } else if (response.statusCode == 401 && retry) {      
        if (userProvider.isAuthenticated) {
          bool refreshed = await AuthHelper.refreshToken();
          if (refreshed) {
            return fetchPendingAcceptanceOrders(context, retry: false);  // Retry after refreshing token
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Session Expired! Please log in again.')),
            );
            userProvider.logout(context);  // Log out the user if refresh fails
          }
        }
    } else {
        throw Exception('Failed to fetch pending acceptance orders');
      }
    } catch (e) {
      print('Error fetching pending acceptance orders: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching orders: $e')),
      );
    }
  }

  // Admin: Approve payment
  Future<void> approvePayment(int paymentId) async {
    final token = await AuthHelper.getToken();
    final response = await http.post(
      Uri.parse('$orderPaymentUrl/$paymentId/approve/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to approve payment');
    }
  }

  int get orderCount => _userOrders.length;
}