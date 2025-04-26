import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/auth_service.dart';
import '../../../auth/cubit/auth_cubit.dart';
import '../../../auth/cubit/auth_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final AuthService _authService;
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _biometricAuthEnabled = false;
  String _selectedLanguage = 'en';
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _authService = AuthService(prefs);
      await _loadSettings();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to initialize settings: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadSettings() async {
    try {
      final darkMode = await _authService.getThemePreference();
      final notifications = await _authService.getNotificationPreference();
      final biometricAuth = await _authService.isBiometricAuthEnabled();
      final language = await _authService.getLanguagePreference();

      if (mounted) {
        setState(() {
          _isDarkMode = darkMode;
          _notificationsEnabled = notifications;
          _biometricAuthEnabled = biometricAuth;
          _selectedLanguage = language;
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load settings: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    setState(() => _isLoading = true);
    try {
      switch (key) {
        case 'dark_mode':
          await _authService.setThemePreference(value as bool);
          setState(() => _isDarkMode = value);
        case 'notifications':
          await _authService.setNotificationPreference(value as bool);
          setState(() => _notificationsEnabled = value);
        case 'biometric_auth':
          if (value as bool) {
            await _authService.enableBiometricAuth();
          } else {
            await _authService.disableBiometricAuth();
          }
          setState(() => _biometricAuthEnabled = value);
        case 'language':
          await _authService.setLanguagePreference(value as String);
          setState(() => _selectedLanguage = value);
      }
      _showSnackBar('Settings updated successfully');
    } catch (e) {
      _showSnackBar('Failed to update setting: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            error: (message) => _showSnackBar(message, isError: true),
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            authenticated: (user) => _buildSettingsList(user),
            orElse: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget _buildSettingsList(User user) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: TextStyle(color: Colors.red[700])),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadSettings,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [
        _buildProfileSection(user),
        const Divider(),
        _buildAppearanceSection(),
        const Divider(),
        _buildSecuritySection(),
        const Divider(),
        _buildNotificationsSection(),
        const Divider(),
        _buildSupportSection(),
        const Divider(),
        _buildSignOutSection(),
      ],
    );
  }

  Widget _buildProfileSection(User user) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            user.photoURL != null ? NetworkImage(user.photoURL!) : null,
        child: user.photoURL == null
            ? Text(user.displayName?[0].toUpperCase() ?? 'U')
            : null,
      ),
      title: Text(user.displayName ?? 'User'),
      subtitle: Text(user.email ?? ''),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => Navigator.pushNamed(context, '/profile'),
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Appearance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Enable dark theme'),
          value: _isDarkMode,
          onChanged: (value) => _saveSetting('dark_mode', value),
        ),
        ListTile(
          title: const Text('Language'),
          subtitle: Text(_getLanguageName(_selectedLanguage)),
          trailing: DropdownButton<String>(
            value: _selectedLanguage,
            items: [
              DropdownMenuItem(
                  value: 'en', child: Text(_getLanguageName('en'))),
              DropdownMenuItem(
                  value: 'fr', child: Text(_getLanguageName('fr'))),
              DropdownMenuItem(
                  value: 'es', child: Text(_getLanguageName('es'))),
              DropdownMenuItem(
                  value: 'ar', child: Text(_getLanguageName('ar'))),
            ],
            onChanged: (value) {
              if (value != null) _saveSetting('language', value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Security',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SwitchListTile(
          title: const Text('Biometric Authentication'),
          subtitle: const Text('Use fingerprint or face ID'),
          value: _biometricAuthEnabled,
          onChanged: (value) => _saveSetting('biometric_auth', value),
        ),
        ListTile(
          leading: const Icon(Icons.lock),
          title: const Text('Change Password'),
          onTap: () => Navigator.pushNamed(context, '/change-password'),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Notifications',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SwitchListTile(
          title: const Text('Push Notifications'),
          subtitle: const Text('Receive app notifications'),
          value: _notificationsEnabled,
          onChanged: (value) => _saveSetting('notifications', value),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Support',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Help & Support'),
          onTap: () => Navigator.pushNamed(context, '/help'),
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('Privacy Policy'),
          onTap: () => Navigator.pushNamed(context, '/privacy'),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About'),
          onTap: () => Navigator.pushNamed(context, '/about'),
        ),
      ],
    );
  }

  Widget _buildSignOutSection() {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text(
        'Sign Out',
        style: TextStyle(color: Colors.red),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sign Out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthCubit>().signOut();
                  Navigator.pop(context);
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      case 'es':
        return 'Español';
      case 'ar':
        return 'العربية';
      default:
        return code;
    }
  }
}
