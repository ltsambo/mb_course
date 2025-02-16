// import 'dart:convert';

class Business {
  final int id;
  final String name;
  final String contact;
  final String email;
  final String address;

  Business({
    required this.id,
    required this.name,
    required this.contact,
    required this.email,
    required this.address,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      contact: json['contact'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
    );
  }
}


class BankInfo {
  final int id;
  final String title;
  final String logo;

  BankInfo({required this.id, required this.title, required this.logo});

  factory BankInfo.fromJson(Map<String, dynamic> json) {
    return BankInfo(
      id: json['id'] ?? 0,
      title: json['title'] ?? "Unknown",
      logo: json['logo'] ?? "",
    );
  }
}


class PaymentBankInfo {
  final int id;
  final BankInfo bank;
  final String logo;
  final String accountNo;
  final String name;

  PaymentBankInfo({
    required this.id,
    required this.bank,
    required this.logo,
    required this.accountNo,
    required this.name,
  });

  factory PaymentBankInfo.fromJson(Map<String, dynamic> json) {
    return PaymentBankInfo(
      id: json['id'] ?? 0,
      bank: BankInfo.fromJson(json['bank'] ?? {}), // Parse nested bank object
      logo: json['logo'] ?? '',
      accountNo: json['account_no'] ?? 'No Account',
      name: json['name'] ?? 'No Name',
    );
  }
}
// class BusinessProfile {
//   final String logo, name, email, contact, address, description;
//   final List<SocialProfile> socialProfiles;

//   BusinessProfile({
//     required this.logo,
//     required this.name,
//     required this.email,
//     required this.contact,
//     required this.address,
//     required this.description,
//     required this.socialProfiles,    
//   });
// }


// class SocialProfile {
//   final String id;  
//   final SocialMedia socialMedia;
//   final String account;
//   final String link;

//   SocialProfile({
//     required this.id,
//     required this.socialMedia,
//     required this.account,
//     required this.link,
//   });
// }


// class SocialMedia {
//   final String id;
//   final String media; 
//   final String mediaIcon;  
//   SocialMedia({
//     required this.id,
//     required this.media,
//     required this.mediaIcon,
//   });
// }
