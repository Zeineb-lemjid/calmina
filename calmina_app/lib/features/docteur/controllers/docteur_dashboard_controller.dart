import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DocteurDashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  final RxList<Map<String, dynamic>> patients = <Map<String, dynamic>>[].obs;
  final RxMap<String, List<Map<String, dynamic>>> patientMoodHistory = <String, List<Map<String, dynamic>>>{}.obs;
  final RxBool isLoading = false.obs;
  final RxString selectedPatientId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadPatients();
  }

  Future<void> loadPatients() async {
    try {
      isLoading.value = true;
      final patientsSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'patient')
          .get();

      patients.value = patientsSnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      print('Error loading patients: $e');
      Get.snackbar(
        'Error',
        'Failed to load patients: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadPatientMoodHistory(String patientId) async {
    try {
      isLoading.value = true;
      final moodDocs = await _firestore
          .collection('moods')
          .doc(patientId)
          .collection('entries')
          .orderBy('timestamp', descending: true)
          .limit(30)
          .get();

      final moodHistory = moodDocs.docs
          .map((doc) => {
                'mood': doc.data()['mood'],
                'timestamp': doc.data()['timestamp'],
              })
          .toList();

      patientMoodHistory[patientId] = moodHistory;
    } catch (e) {
      print('Error loading patient mood history: $e');
      Get.snackbar(
        'Error',
        'Failed to load mood history: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void selectPatient(String patientId) {
    selectedPatientId.value = patientId;
    loadPatientMoodHistory(patientId);
  }

  Future<void> addNote(String patientId, String note) async {
    try {
      isLoading.value = true;
      await _firestore
          .collection('notes')
          .doc(_auth.currentUser?.uid)
          .collection('patient_notes')
          .doc(patientId)
          .collection('entries')
          .add({
        'note': note,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Success',
        'Note added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error adding note: $e');
      Get.snackbar(
        'Error',
        'Failed to add note: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
} 