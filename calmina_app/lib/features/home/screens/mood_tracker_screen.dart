import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  String selectedMood = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.peachLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Hi ${Get.arguments?['name'] ?? 'there'}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
          const Text(
            'How are you feeling today?',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.grey,
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMoodOption('Angry', '😠'),
                      _buildMoodOption('Okay', '😐'),
                      _buildMoodOption('Happy', '😊'),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const CircularProgressIndicator(
                    value: 0.7,
                    backgroundColor: Colors.white,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedMood.isNotEmpty) {
                        Get.toNamed('/chat', arguments: {'mood': selectedMood});
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Consult Brainsy AI',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodOption(String mood, String emoji) {
    final isSelected = selectedMood == mood;
    return GestureDetector(
      onTap: () => setState(() => selectedMood = mood),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 8),
            Text(
              mood,
              style: TextStyle(
                color: isSelected ? AppTheme.primary : AppTheme.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 