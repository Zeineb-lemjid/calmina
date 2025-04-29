import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? displayName,
    String? photoURL,
    String? phoneNumber,
    @Default(false) bool isEmailVerified,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? preferences,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      phoneNumber: data['phoneNumber'],
      isEmailVerified: data['isEmailVerified'] ?? false,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      lastLoginAt: data['lastLoginAt'] != null
          ? (data['lastLoginAt'] as Timestamp).toDate()
          : null,
      preferences: data['preferences'] as Map<String, dynamic>?,
    );
  }
}

extension UserModelX on UserModel {
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'lastLoginAt':
          lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
      'preferences': preferences,
    };
  }
}
