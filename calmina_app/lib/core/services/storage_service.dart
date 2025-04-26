import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

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
}
