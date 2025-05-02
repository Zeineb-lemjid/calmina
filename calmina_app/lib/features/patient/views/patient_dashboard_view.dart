import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/patient_dashboard_controller.dart';
import '../../../core/controllers/auth_controller.dart';

class PatientDashboardView extends GetView<PatientDashboardController> {
  const PatientDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calmina - Patient Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Get.find<AuthController>().signOut(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMoodTracker(),
              const SizedBox(height: 24),
              _buildMoodHistory(),
              const SizedBox(height: 24),
              _buildSuggestedActivities(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMoodTracker() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How are you feeling today?',
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Obx(() => Slider(
                  value: controller.currentMood.value.toDouble(),
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: _getMoodLabel(controller.currentMood.value),
                  onChanged: (value) {
                    controller.currentMood.value = value.toInt();
                  },
                )),
            const SizedBox(height: 8),
            Obx(() => Text(
                  _getMoodLabel(controller.currentMood.value),
                  style: Get.textTheme.titleMedium,
                )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.saveMood(controller.currentMood.value),
              child: const Text('Save Mood'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodHistory() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mood History',
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Obx(() => controller.moodHistory.isEmpty
                ? const Text('No mood history available')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.moodHistory.length,
                    itemBuilder: (context, index) {
                      final entry = controller.moodHistory[index];
                      return ListTile(
                        title: Text(_getMoodLabel(entry['mood'])),
                        subtitle: Text(_formatDate(entry['timestamp'])),
                      );
                    },
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedActivities() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Suggested Activities',
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Obx(() => controller.suggestedActivities.isEmpty
                ? const Text('No activities suggested')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.suggestedActivities.length,
                    itemBuilder: (context, index) {
                      final activity = controller.suggestedActivities[index];
                      return ListTile(
                        leading: const Icon(Icons.favorite),
                        title: Text(activity['title']),
                        subtitle: Text(activity['description']),
                      );
                    },
                  )),
          ],
        ),
      ),
    );
  }

  String _getMoodLabel(int mood) {
    switch (mood) {
      case 0:
        return 'Very Sad';
      case 1:
        return 'Sad';
      case 2:
        return 'Down';
      case 3:
        return 'Low';
      case 4:
        return 'Neutral';
      case 5:
        return 'Okay';
      case 6:
        return 'Good';
      case 7:
        return 'Happy';
      case 8:
        return 'Very Happy';
      case 9:
        return 'Excited';
      case 10:
        return 'Ecstatic';
      default:
        return 'Neutral';
    }
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Unknown date';
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }
} 