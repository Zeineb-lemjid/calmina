import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/docteur_dashboard_controller.dart';
import '../../../core/controllers/auth_controller.dart';

class DocteurDashboardView extends GetView<DocteurDashboardController> {
  const DocteurDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calmina - Doctor Dashboard'),
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

        return Row(
          children: [
            _buildPatientList(),
            Expanded(
              child: _buildPatientDetails(),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPatientList() {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Patients',
              style: Get.textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: controller.patients.length,
                  itemBuilder: (context, index) {
                    final patient = controller.patients[index];
                    return ListTile(
                      selected: controller.selectedPatientId.value == patient['id'],
                      onTap: () => controller.selectPatient(patient['id']),
                      title: Text(patient['name'] ?? 'Unknown'),
                      subtitle: Text(patient['email'] ?? ''),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientDetails() {
    if (controller.selectedPatientId.isEmpty) {
      return const Center(
        child: Text('Select a patient to view details'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood History',
            style: Get.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildMoodChart(),
          ),
          const SizedBox(height: 16),
          _buildNoteInput(),
        ],
      ),
    );
  }

  Widget _buildMoodChart() {
    final moodHistory = controller.patientMoodHistory[controller.selectedPatientId.value] ?? [];
    if (moodHistory.isEmpty) {
      return const Center(
        child: Text('No mood history available'),
      );
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
            ),
          ),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: moodHistory.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;
              return FlSpot(
                index.toDouble(),
                (data['mood'] as int).toDouble(),
              );
            }).toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteInput() {
    final noteController = TextEditingController();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Note',
              style: Get.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter your notes here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                if (noteController.text.isNotEmpty) {
                  controller.addNote(
                    controller.selectedPatientId.value,
                    noteController.text,
                  );
                  noteController.clear();
                }
              },
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
} 