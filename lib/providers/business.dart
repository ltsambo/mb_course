import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mb_course/config/api_config.dart';
import '../models/business.dart';
import '../services/api_service.dart';
import 'package:http/http.dart' as http;

import 'user_provider.dart';

class BusinessProvider with ChangeNotifier {
  List<Business> _businesses = [];
  bool _isLoading = false;

  Business? _business;
  Business? get business => _business;

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

  Future<void> fetchBusiness() async {
    try {
      final response = await http.get(Uri.parse(businessListUrl));
      final responseData = json.decode(response.body);
      print('Full API Response: $responseData'); // Debugging line
      
      if (response.statusCode == 200 && responseData is List && responseData.isNotEmpty) {
        _business = Business.fromJson(responseData[0]); // Extract first item from the list
        notifyListeners();
      } else {
        print("Error fetching business: Invalid response format");
      }
    } catch (e) {
      print("Error in fetchBusiness: $e");
    }
  }

  // Add a new business
  // Future<void> addBusiness(Business business) async {
  //   try {
  //     Business newBusiness = await ApiService.createBusiness(business);
  //     _businesses.add(newBusiness);
  //     notifyListeners();
  //   } catch (e) {
  //     print("Error adding business: $e");
  //   }
  // }

  // Update business

  Future<void> updateBusinessInfo(int id, String contact, String email, String address) async {
    try {
      final token = await AuthHelper.getToken(); 
      final response = await http.patch(
        Uri.parse('$businessListUrl$id/'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token',},
        body: json.encode({
          "contact": contact,
          "email": email,
          "address": address,
        }),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        print(responseData["message"]);
        fetchBusiness();
        notifyListeners();
      } else {
        print("Error: ${responseData["errors"] ?? "Failed to update business info"}");
      }
    } catch (e) {
      print("Error in updateBusinessInfo: $e");
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

class BankInfoProvider with ChangeNotifier {
  List<BankInfo> _banks = [];

  List<BankInfo> get banks => _banks;
  
  Future<void> fetchBanks() async {
    final token = await AuthHelper.getToken(); 
    final response = await http.get(
      Uri.parse(bankInfoUrl),
      headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      _banks = data.map((bank) => BankInfo(id: bank['id'], title: bank['title'], logo: bank['logo'])).toList();
      notifyListeners();
    }
  }
}


class PaymentBankInfoProvider with ChangeNotifier {
  List<PaymentBankInfo> _paymentBanks = [];

  List<PaymentBankInfo> get paymentBanks => _paymentBanks;

  Future<void> fetchPaymentBankInfo() async {
    print('touch fetch');
    final token = await AuthHelper.getToken(); 
    try {
      final response = await http.get(Uri.parse(paymentBankInfoUrl),
      headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _paymentBanks = data.map((bank) => PaymentBankInfo.fromJson(bank)).toList();
        notifyListeners();
      } else {
        throw Exception("Failed to load payment bank info");
      }
    } catch (e) {
      print("Error fetching payment bank info: $e");
    }
  }

  // Future<void> createPaymentBankInfo(int bankId, String accountNo, String name) async {
  //   try {
  //     final token = await AuthHelper.getToken(); 
  //     final createResponse = await http.post(
  //       Uri.parse('$paymentBankInfoUrl/'),
  //       headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
  //       body: json.encode({"bank": bankId, "account_no": accountNo, "name": name}),
  //     );
  //     if (createResponse.statusCode != 201) {
  //       throw Exception("Failed to create payment bank info ${createResponse.statusCode}");
  //     }
  //     // fetchPaymentBankInfo();
  //   } catch (e) {
  //     print("Error in createPaymentBankInfo: $e");
  //   }    
  // }

  Future<void> createPaymentBankInfo(int bankId, String accountNo, String name) async {
  try {
    final token = await AuthHelper.getToken();
    final response = await http.post(
      Uri.parse('$paymentBankInfoUrl/'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: json.encode({"bank_id": bankId, "account_no": accountNo, "name": name}),
    );

    final responseData = json.decode(response.body);
    
    if (response.statusCode == 201) {
      print(responseData["message"]); // Show success message
      fetchPaymentBankInfo(); // Refresh the list
    } else {
      print("Error: ${responseData["errors"] ?? "Failed to create payment bank info"}");
    }
  } catch (e) {
    print("Error in createPaymentBankInfo: $e");
  }
}

Future<void> updatePaymentBankInfo(int id, int bankId, String accountNo, String name) async {
    try {
      final token = await AuthHelper.getToken();
      final response = await http.put(
        Uri.parse('$paymentBankInfoUrl/$id/'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: json.encode({"bank_id": bankId, "account_no": accountNo, "name": name}),
      );

      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        print(responseData["message"]); // Show success message
        fetchPaymentBankInfo(); // Refresh list
      } else {
        print("Error: ${responseData["errors"] ?? "Failed to update payment bank info"}");
      }
    } catch (e) {
      print("Error in updatePaymentBankInfo: $e");
    }
  }

  // Future<void> createPaymentBankInfo(int bankId, String accountNo, String name) async {
  //   try {
  //     final token = await AuthHelper.getToken(); 
  //     // final response = await http.get(Uri.parse('$paymentBankInfoUrl?bank_id=$bankId'), headers: {
  //     //         'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},);
  //     final createResponse = await http.post(
  //           Uri.parse('$paymentBankInfoUrl/'),
  //           headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
  //           body: json.encode({"bank_id": bankId, "account_no": accountNo, "name": name}),
  //         );
  //         if (createResponse.statusCode != 201) {
  //           throw Exception("Failed to create payment bank info");
  //     }  
  //     // if (response.statusCode == 200) {
  //     //   List<dynamic> data = json.decode(response.body);
  //     //   if (data.isNotEmpty) {
  //     //     final existingId = data[0]['id'];
  //     //     final updateResponse = await http.put(
  //     //       Uri.parse('$paymentBankInfoUrl/$existingId'),
  //     //       headers: {
  //     //         'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
  //     //       body: json.encode({"bank": bankId, "account_no": accountNo, "name": name}),
  //     //     );
  //     //     if (updateResponse.statusCode != 200) {
  //     //       throw Exception("Failed to update payment bank info");
  //     //     }
  //     //   } else {
          
  //     //   }
  //     //   notifyListeners();
  //     // } else {
  //     //   throw Exception("Failed to fetch payment bank info");
  //     // }
  //   } catch (e) {
  //     print("Error in createOrUpdatePaymentBankInfo: $e");
  //   }    
  // }

  Future<void> deactivatePaymentBankInfo(int bankId) async {
    try {
      final token = await AuthHelper.getToken();
      final response = await http.get(Uri.parse('$paymentBankInfoUrl?bank_id=$bankId'), headers: {
              'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},);
      
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final existingId = data[0]['id'];
          final updateResponse = await http.put(
            Uri.parse('$paymentBankInfoUrl/$existingId'),
            headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
            body: json.encode({"is_active": false}),
          );
          if (updateResponse.statusCode != 200) {
            throw Exception("Failed to deactivate payment bank info");
          }
          notifyListeners();
        } else {
          throw Exception("No payment bank info found to deactivate");
        }
      } else {
        throw Exception("Failed to fetch payment bank info");
      }
    } catch (e) {
      print("Error in deactivatePaymentBankInfo: $e");
    }
  }
}