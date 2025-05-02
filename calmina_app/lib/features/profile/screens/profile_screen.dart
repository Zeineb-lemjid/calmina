import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/profile_controller.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/storage_service.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();
    final storageService = Get.find<StorageService>();
    final authController = Get.find<AuthController>();
    final controller = Get.put(ProfileController(
      authService: authService,
      storageService: storageService,
      authController: authController,
    ));

    return Scaffold(
      backgroundColor: AppTheme.peachLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profil',
          style: AppTheme.titleMedium.copyWith(
            color: AppTheme.primaryPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: AppTheme.textPrimary,
            ),
            onPressed: () => Get.toNamed('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(controller),
              const SizedBox(height: 32),
              _buildProfileStats(controller),
              const SizedBox(height: 32),
              _buildProfileActions(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileController controller) {
    return Obx(() => Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: AppTheme.lavenderLight,
            backgroundImage: controller.user.value?.photoURL != null
                ? NetworkImage(controller.user.value!.photoURL!)
                : null,
            child: controller.user.value?.photoURL == null
                ? Icon(
                    Icons.person,
                    size: 60,
                    color: AppTheme.primaryPurple,
                  )
                : null,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          controller.user.value?.displayName ?? 'Utilisateur',
          style: AppTheme.titleLarge.copyWith(
            color: AppTheme.primaryPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          controller.user.value?.email ?? '',
          style: AppTheme.bodyLarge.copyWith(
            color: AppTheme.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: controller.editProfile,
          icon: Icon(
            Icons.edit,
            color: AppTheme.primaryPurple,
          ),
          label: Text(
            'Modifier le profil',
            style: AppTheme.subtitleMedium.copyWith(
              color: AppTheme.primaryPurple,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            side: BorderSide(color: AppTheme.primaryPurple),
          ),
        ),
      ],
    ));
  }

  Widget _buildProfileStats(ProfileController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistiques',
            style: AppTheme.subtitleLarge.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.calendar_today,
                label: 'Jours consécutifs',
                value: controller.streakDays.toString(),
              ),
              _buildStatItem(
                icon: Icons.emoji_emotions,
                label: 'Humeurs enregistrées',
                value: controller.totalMoods.toString(),
              ),
              _buildStatItem(
                icon: Icons.self_improvement,
                label: 'Méditations',
                value: controller.totalMeditations.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryPurple,
            size: 24,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: AppTheme.titleMedium.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProfileActions(ProfileController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions',
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
                    Icons.history,
                    color: AppTheme.primaryPurple,
                  ),
                ),
                title: Text(
                  'Historique complet',
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
                onTap: () => Get.toNamed('/history'),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.insights,
                    color: AppTheme.primaryPurple,
                  ),
                ),
                title: Text(
                  'Statistiques détaillées',
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
                onTap: () => Get.toNamed('/stats'),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.help_outline,
                    color: AppTheme.primaryPurple,
                  ),
                ),
                title: Text(
                  'Aide et support',
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
                onTap: () => Get.toNamed('/help'),
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
                    Icons.logout,
                    color: Colors.red,
                  ),
                ),
                title: Text(
                  'Déconnexion',
                  style: AppTheme.subtitleMedium.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: controller.signOut,
              ),
            ],
          ),
        ),
      ],
    );
  }
} 