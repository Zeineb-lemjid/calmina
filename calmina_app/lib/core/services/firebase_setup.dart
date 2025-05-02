import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseSetup {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createUserDocument(User user, String role) async {
    await _firestore.collection('users').doc(user.uid).set({
      'name': user.displayName ?? 'User',
      'email': user.email,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addSampleActivities() async {
    final activities = [
      {
        'title': 'Deep Breathing Exercise',
        'description': 'Take 5 deep breaths, inhaling for 4 seconds and exhaling for 6 seconds.',
        'moodThreshold': 3,
        'type': 'exercise',
      },
      {
        'title': 'Gratitude Journal',
        'description': 'Write down three things you are grateful for today.',
        'moodThreshold': 4,
        'type': 'journaling',
      },
      {
        'title': 'Mindful Walk',
        'description': 'Take a 10-minute walk, focusing on your surroundings and breathing.',
        'moodThreshold': 5,
        'type': 'exercise',
      },
      {
        'title': 'Meditation Session',
        'description': 'Find a quiet place and meditate for 5 minutes.',
        'moodThreshold': 2,
        'type': 'meditation',
      },
      {
        'title': 'Progressive Muscle Relaxation',
        'description': 'Tense and relax each muscle group for 5 seconds each.',
        'moodThreshold': 3,
        'type': 'exercise',
      },
      {
        'title': 'Positive Affirmations',
        'description': 'Repeat positive statements about yourself for 2 minutes.',
        'moodThreshold': 4,
        'type': 'meditation',
      },
    ];

    for (var activity in activities) {
      await _firestore.collection('activities').add({
        ...activity,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> initializeDatabase() async {
    // Check if activities already exist
    final activitiesSnapshot = await _firestore.collection('activities').get();
    if (activitiesSnapshot.docs.isEmpty) {
      await addSampleActivities();
    }
  }
} 