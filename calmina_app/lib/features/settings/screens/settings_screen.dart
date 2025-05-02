import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: AppTheme.peachLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Paramètres',
          style: AppTheme.titleMedium.copyWith(
            color: AppTheme.primaryPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                title: 'Notifications',
                children: [
                  Obx(() => SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    title: Text(
                      'Notifications quotidiennes',
                      style: AppTheme.subtitleMedium.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Recevoir un rappel pour enregistrer votre humeur',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    value: controller.dailyReminders.value,
                    onChanged: controller.toggleDailyReminders,
                    activeColor: AppTheme.primaryPurple,
                  )),
                  const Divider(height: 1),
                  Obx(() => SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    title: Text(
                      'Rappels de méditation',
                      style: AppTheme.subtitleMedium.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Recevoir des rappels pour vos séances de méditation',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    value: controller.meditationReminders.value,
                    onChanged: controller.toggleMeditationReminders,
                    activeColor: AppTheme.primaryPurple,
                  )),
                ],
              ),
              const SizedBox(height: 32),
              _buildSection(
                title: 'Apparence',
                children: [
                  Obx(() => SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    title: Text(
                      'Mode sombre',
                      style: AppTheme.subtitleMedium.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Changer le thème de l\'application',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    value: controller.isDarkMode.value,
                    onChanged: controller.toggleDarkMode,
                    activeColor: AppTheme.primaryPurple,
                  )),
                ],
              ),
              const SizedBox(height: 32),
              _buildSection(
                title: 'Données',
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.download,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                    title: Text(
                      'Exporter mes données',
                      style: AppTheme.subtitleMedium.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Télécharger toutes vos données au format JSON',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.textSecondary,
                      size: 16,
                    ),
                    onTap: controller.exportData,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                    ),
                    title: Text(
                      'Supprimer mes données',
                      style: AppTheme.subtitleMedium.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Supprimer définitivement toutes vos données',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.textSecondary,
                      size: 16,
                    ),
                    onTap: controller.deleteData,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildSection(
                title: 'À propos',
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    title: Text(
                      'Version',
                      style: AppTheme.subtitleMedium.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '1.0.0',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    title: Text(
                      'Conditions d\'utilisation',
                      style: AppTheme.subtitleMedium.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.textSecondary,
                      size: 16,
                    ),
                    onTap: () => Get.toNamed('/terms'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    title: Text(
                      'Politique de confidentialité',
                      style: AppTheme.subtitleMedium.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.textSecondary,
                      size: 16,
                    ),
                    onTap: () => Get.toNamed('/privacy'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.subtitleLarge.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
} 