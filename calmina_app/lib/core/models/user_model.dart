import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoURL;
  final String? phoneNumber;
  final bool emailVerified;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoURL,
    this.phoneNumber,
    this.emailVerified = false,
    this.createdAt,
    this.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      phoneNumber: json['phoneNumber'],
      emailVerified: json['emailVerified'] ?? false,
      createdAt: json['createdAt']?.toDate(),
      lastLoginAt: json['lastLoginAt']?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'emailVerified': emailVerified,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'lastLoginAt': lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
    };
  }
}

extension UserModelX on UserModel {
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'isEmailVerified': emailVerified,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'lastLoginAt':
          lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
    };
  }
}
