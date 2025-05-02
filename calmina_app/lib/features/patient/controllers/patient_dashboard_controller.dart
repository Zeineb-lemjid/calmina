import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientDashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  final RxInt currentMood = 0.obs;
  final RxBool hasTrackedToday = false.obs;
  final RxList<Map<String, dynamic>> moodHistory = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> suggestedActivities = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkTodayMood();
    loadMoodHistory();
    loadSuggestedActivities();
  }

  Future<void> checkTodayMood() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    
    try {
      final moodDoc = await _firestore
          .collection('moods')
          .doc(_auth.currentUser?.uid)
          .collection('entries')
          .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
          .get();

      hasTrackedToday.value = moodDoc.docs.isNotEmpty;
    } catch (e) {
      print('Error checking today\'s mood: $e');
    }
  }

  Future<void> saveMood(int moodValue) async {
    try {
      isLoading.value = true;
      await _firestore
          .collection('moods')
          .doc(_auth.currentUser?.uid)
          .collection('entries')
          .add({
        'mood': moodValue,
        'timestamp': FieldValue.serverTimestamp(),
      });

      currentMood.value = moodValue;
      hasTrackedToday.value = true;
      await loadMoodHistory();
      await loadSuggestedActivities();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save mood: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoodHistory() async {
    try {
      isLoading.value = true;
      final moodDocs = await _firestore
          .collection('moods')
          .doc(_auth.currentUser?.uid)
          .collection('entries')
          .orderBy('timestamp', descending: true)
          .limit(7)
          .get();

      moodHistory.value = moodDocs.docs
          .map((doc) => {
                'mood': doc.data()['mood'],
                'timestamp': doc.data()['timestamp'],
              })
          .toList();
    } catch (e) {
      print('Error loading mood history: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSuggestedActivities() async {
    try {
      isLoading.value = true;
      final activities = await _firestore
          .collection('activities')
          .where('moodThreshold', isLessThanOrEqualTo: currentMood.value)
          .get();

      suggestedActivities.value = activities.docs
          .map((doc) => doc.data())
          .toList();
    } catch (e) {
      print('Error loading suggested activities: $e');
    } finally {
      isLoading.value = false;
    }
  }
} 