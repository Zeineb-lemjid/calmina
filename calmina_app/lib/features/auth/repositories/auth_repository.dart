import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

abstract class IAuthRepository {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> updateUserProfile({String? displayName, String? photoUrl});
}

class AuthRepository implements IAuthRepository {
  final SharedPreferences _prefs;
  static const String _currentUserKey = 'current_user';
  static const String _usersKey = 'users';

  AuthRepository(this._prefs);

  @override
  Future<UserModel?> getCurrentUser() async {
    final userJson = _prefs.getString(_currentUserKey);
    if (userJson == null) return null;
    return UserModel.fromJson(json.decode(userJson));
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    final usersJson = _prefs.getString(_usersKey);
    if (usersJson == null) {
      throw Exception('Aucun utilisateur trouvé avec cet email.');
    }

    final List<dynamic> users = json.decode(usersJson);
    final userData = users.firstWhere(
      (user) => user['email'] == email && user['password'] == password,
      orElse: () => throw Exception('Email ou mot de passe incorrect.'),
    );

    final user = UserModel.fromJson(userData);
    await _prefs.setString(_currentUserKey, json.encode(user.toJson()));
    return user;
  }

  @override
  Future<UserModel> createUserWithEmailAndPassword(String email, String password) async {
    final usersJson = _prefs.getString(_usersKey);
    final List<dynamic> users = usersJson != null ? json.decode(usersJson) : [];

    if (users.any((user) => user['email'] == email)) {
      throw Exception('Cet email est déjà utilisé.');
    }

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      isEmailVerified: false,
      createdAt: DateTime.now(),
    );

    users.add({
      ...newUser.toJson(),
      'password': password,
    });

    await _prefs.setString(_usersKey, json.encode(users));
    await _prefs.setString(_currentUserKey, json.encode(newUser.toJson()));
    return newUser;
  }

  @override
  Future<void> signOut() async {
    await _prefs.remove(_currentUserKey);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    final usersJson = _prefs.getString(_usersKey);
    if (usersJson == null) {
      throw Exception('Aucun utilisateur trouvé avec cet email.');
    }

    final List<dynamic> users = json.decode(usersJson);
    if (!users.any((user) => user['email'] == email)) {
      throw Exception('Aucun utilisateur trouvé avec cet email.');
    }

    // In a real app, you would send an email here
    // For now, we'll just simulate success
  }

  @override
  Future<void> updateUserProfile({String? displayName, String? photoUrl}) async {
    final currentUser = await getCurrentUser();
    if (currentUser == null) {
      throw Exception('Aucun utilisateur connecté.');
    }

    final updatedUser = UserModel(
      id: currentUser.id,
      email: currentUser.email,
      displayName: displayName ?? currentUser.displayName,
      photoUrl: photoUrl ?? currentUser.photoUrl,
      isEmailVerified: currentUser.isEmailVerified,
      lastLoginAt: currentUser.lastLoginAt,
      createdAt: currentUser.createdAt,
    );

    await _prefs.setString(_currentUserKey, json.encode(updatedUser.toJson()));

    // Update in users list
    final usersJson = _prefs.getString(_usersKey);
    if (usersJson != null) {
      final List<dynamic> users = json.decode(usersJson);
      final userIndex = users.indexWhere((user) => user['id'] == currentUser.id);
      if (userIndex != -1) {
        users[userIndex] = {
          ...users[userIndex],
          'displayName': displayName ?? currentUser.displayName,
          'photoUrl': photoUrl ?? currentUser.photoUrl,
        };
        await _prefs.setString(_usersKey, json.encode(users));
      }
    }
  }
} 