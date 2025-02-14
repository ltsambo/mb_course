import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mb_course/config/api_config.dart';
import 'package:mb_course/models/course.dart';
import 'package:mb_course/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class OrderProvider with ChangeNotifier {  
  List<Map<String, dynamic>> _userOrders = [];
  List<Map<String, dynamic>> get userOrders => _userOrders;
  List<dynamic> pendingAcceptanceOrders = []; 
  Map<String, int> statusCounts = {};

  List<Course> _enrolledCourses = [];
  bool _isLoading = false;

  List<Course> get enrolledCourses => _enrolledCourses;
  bool get isLoading => _isLoading;
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
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
          // print('status count $_userOrders');
          
          // final statusList = data['data']['status_count'] as List<dynamic>;
          final statusList = (data['data']['status_count'] != null && data['data']['status_count'].isNotEmpty)
          ? (data['data']['status_count'] as List<dynamic>)
          : [];  
          
          statusCounts = {
            for (var statusItem in statusList)
              statusItem['status']: statusItem['count']
          };
          // print('status count 2 $statusCounts');
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
        
        // pendingAcceptanceOrders = data['data'];  // Extract pending orders
        if (data['data'] is List) {
          pendingAcceptanceOrders = data['data'];  // If 'data' is a list
        } else if (data['data'] is Map) {
          pendingAcceptanceOrders = data['data'].values.toList();  // Convert map values to list
        } else {
          throw Exception('Unexpected data format from API');
        }
        
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
  Future<void> approvePayment(int paymentId, BuildContext context, {bool retry = true}) async {
    final token = await AuthHelper.getToken();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await http.post(
      Uri.parse('$orderPaymentUrl$paymentId/approve/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    try {
      if (response.statusCode == 200) {
        fetchPendingAcceptanceOrders(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment Approved')),
        );
        notifyListeners();  
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
        throw Exception('Failed to approve payment');
      }
    } catch (e) {
      print('Error approving payments: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error approving payments: $e')),
      );
    }
  }

  Future<void> fetchEnrolledCourses(BuildContext context, {bool retry = true}) async {
    _setLoading(true);
    final url = Uri.parse(fetchEnrolledCoursesUrl);
    final token = await AuthHelper.getToken();

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (token == null || token.isEmpty) {
      print("No authentication token found. User might be logged out.");
      _setLoading(false);
      return;
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Fetch enrolled courses response: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('response data ${responseData['data']}');
        if (responseData['data'] is List) {
          _enrolledCourses = (responseData['data'] as List)
              .map((course) => Course.fromJson(course))
              .toList();
        }
      } else if (response.statusCode == 401 && retry) {      
          if (userProvider.isAuthenticated) {
            bool refreshed = await AuthHelper.refreshToken();
            if (refreshed) {
              return fetchEnrolledCourses(context, retry: false);  // Retry after refreshing token
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Session Expired! Please log in again.')),
              );
              userProvider.logout(context);  // Log out the user if refresh fails
            }
          }
      } else if (response.statusCode == 404) {
        print("No enrolled courses found.");
        _enrolledCourses = [];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch enrolled courses. Error: ${response.statusCode}')),
      );
      }
    } catch (error) {
      print("Error fetching enrolled courses: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching enrolled courses: $error')),
      );
    }

    _setLoading(false);
    notifyListeners();
  }

  int get orderCount => _userOrders.length;
}