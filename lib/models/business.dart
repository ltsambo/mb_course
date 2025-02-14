// import 'dart:convert';

class Business {
  int? id;
  String name;
  String? logo;
  String contact;
  String? email;
  String? address;

  Business({
    this.id,
    required this.name,
    this.logo,
    required this.contact,
    this.email,
    this.address,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      contact: json['contact'],
      email: json['email'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logo': logo,
      'contact': contact,
      'email': email,
      'address': address,
    };
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
