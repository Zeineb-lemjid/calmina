import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadFile(File file, String userId, {String? folder}) async {
    try {
      final fileName = path.basename(file.path);
      final destination = 'users/$userId/${folder ?? 'uploads'}/$fileName';

      final ref = _storage.ref().child(destination);
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  Future<void> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  Future<List<String>> listFiles(String userId, {String? folder}) async {
    try {
      final ref = _storage.ref().child('users/$userId/${folder ?? 'uploads'}');
      final result = await ref.listAll();

      final urls = await Future.wait(
        result.items.map((ref) => ref.getDownloadURL()),
      );

      return urls;
    } catch (e) {
      throw Exception('Failed to list files: $e');
    }
  }

  Future<int> getStreakDays(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data()?['streakDays'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future<int> getTotalMoods(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('moods')
          .count()
          .get();
      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future<int> getTotalMeditations(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('meditations')
          .count()
          .get();
      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
