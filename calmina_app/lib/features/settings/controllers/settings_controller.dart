import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final RxBool dailyReminders = false.obs;
  final RxBool meditationReminders = false.obs;
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    dailyReminders.value = prefs.getBool('daily_reminders') ?? false;
    meditationReminders.value = prefs.getBool('meditation_reminders') ?? false;
    isDarkMode.value = prefs.getBool('dark_mode') ?? false;
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminders', dailyReminders.value);
    await prefs.setBool('meditation_reminders', meditationReminders.value);
    await prefs.setBool('dark_mode', isDarkMode.value);
  }

  void toggleDailyReminders(bool value) {
    dailyReminders.value = value;
    _saveSettings();
    // TODO: Implement notification scheduling
  }

  void toggleMeditationReminders(bool value) {
    meditationReminders.value = value;
    _saveSettings();
    // TODO: Implement notification scheduling
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    _saveSettings();
    Get.changeThemeMode(
      value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  Future<void> exportData() async {
    // TODO: Implement data export
    Get.snackbar(
      'En cours',
      'L\'exportation des données sera bientôt disponible',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> deleteData() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Supprimer les données'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer toutes vos données ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Implement data deletion
      Get.snackbar(
        'En cours',
        'La suppression des données sera bientôt disponible',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
} 