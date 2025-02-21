
class UserModel {
  final String username, email, role, accessToken, refreshToken;
  final String? phoneNumber;
  final String image;
  final String? modifiedOn;
  final String? createdOn;
  final int id;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.phoneNumber,
    required this.role,
    required this.accessToken,
    required this.refreshToken,
    required this.image,
    this.modifiedOn,
    this.createdOn,
  });

  // Convert JSON to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      username: json["username"],
      email: json["email"] ?? "",
      phoneNumber: json["phone_number"] ?? "",
      role: json["role"] ?? "",
      image: json["avatar"] ?? '',
      modifiedOn: json['modified_on'],
      createdOn: json['created_on'],
      accessToken: json["access_token"],
      refreshToken: json["refresh_token"],
    );
  }
}

class PasswordChangeResponse {
  final String status;
  final String message;
  final Map<String, dynamic>? errors;

  PasswordChangeResponse({
    required this.status,
    required this.message,
    this.errors,
  });

  factory PasswordChangeResponse.fromJson(Map<String, dynamic> json) {
    return PasswordChangeResponse(
      status: json["status"],
      message: json["message"],
      errors: json["errors"] ?? {},
    );
  }
}


class UserProfileModel {
  final int id;
  final String username;
  final String email;
  final String? phoneNumber;
  final String role;
  final String avatar;
  final String? createdOn;
  final String? modifiedOn;

  UserProfileModel({
    required this.id,
    required this.username,
    required this.email,
    this.phoneNumber,
    required this.role,
    required this.avatar,
    required this.createdOn,
    required this.modifiedOn,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      phoneNumber: json["phone_number"],
      role: json["role"],
      avatar: json["avatar"] ?? '',
      createdOn: json["created_on"],
      modifiedOn: json["modified_on"],
    );
  }
}


class UserListModel {
  final int id;
  final String username;
  final String email;
  final String? phoneNumber;
  final String role;
  final String image;

  UserListModel({
    required this.id,
    required this.username,
    required this.email,
    this.phoneNumber,
    required this.role,
    required this.image,
  });

  factory UserListModel.fromJson(Map<String, dynamic> json) {
    return UserListModel(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      phoneNumber:json['phone_number'] ?? '',
      role: json["role"],
      image: json['avatar'] ?? '',  // Placeholder for now
    );
  }
}

// class User {
//   String name, image, email;
//   final String username;
//   final String password;
//   String phone;
//   final String? address;
//   String aboutMeDescription;

//   User({
//     required this.name,
//     required this.image,
//     required this.email,
//     required this.username,
//     required this.password,
//     required this.phone,
//     this.address,
//     required this.aboutMeDescription,
//   });

//   User copy({
//     String? imagePath,
//     String? name,
//     String? username,
//     String? password,
//     String? phone,
//     String? email,
//     String? about,
//   }) =>
//       User(
//         image: imagePath ?? this.image,
//         username: username ?? this.username,
//         password: password ?? this.password,
//         name: name ?? this.name,
//         email: email ?? this.email,
//         phone: phone ?? this.phone,
//         aboutMeDescription: about ?? this.aboutMeDescription,
//       );

//   static User fromJson(Map<String, dynamic> json) => User(
//         image: json['imagePath'],
//         username: json['username'],
//         password: json['password'],
//         name: json['name'],
//         email: json['email'],
//         aboutMeDescription: json['about'],
//         phone: json['phone'],
//       );

//   Map<String, dynamic> toJson() => {
//         'imagePath': image,
//         'username': username,
//         'password': password,
//         'name': name,
//         'email': email,
//         'about': aboutMeDescription,
//         'phone': phone,
//       };
// }

// class UserData {
//   static late SharedPreferences _preferences;
//   static const _keyUser = 'user';

//   static User myUser = User(
//     image:
//         "https://cdn.vectorstock.com/i/2000v/31/95/user-sign-icon-person-symbol-human-avatar-vector-12693195.avif",
//     name: 'Test Test',
//     username: 'test',
//     password: '123',
//     email: 'test.test@gmail.com',
//     phone: '(208) 206-5039',
//     aboutMeDescription:
//         'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat...',
//   );

//   static Future init() async =>
//       _preferences = await SharedPreferences.getInstance();

//   static Future setUser(User user) async {
//     final json = jsonEncode(user.toJson());

//     await _preferences.setString(_keyUser, json);
//   }

//   static User getUser() {
//     final json = _preferences.getString(_keyUser);

//     return json == null ? myUser : User.fromJson(jsonDecode(json));
//   }
// }