import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../core/theme/app_theme.dart';

class RegisterScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authController = Get.find<AuthController>();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.peachLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                Hero(
                  tag: 'app_logo',
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'Créer un compte',
                  style: AppTheme.titleLarge.copyWith(
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Rejoignez Calmina pour commencer votre voyage vers le bien-être',
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
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
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: AppTheme.primaryPurple,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppTheme.peachLight,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre email';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Veuillez entrer un email valide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Obx(() => TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          labelStyle: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: AppTheme.primaryPurple,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _authController.isPasswordVisible.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppTheme.textSecondary,
                            ),
                            onPressed: () {
                              _authController.togglePasswordVisibility();
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppTheme.peachLight,
                        ),
                        obscureText: !_authController.isPasswordVisible.value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un mot de passe';
                          }
                          if (value.length < 6) {
                            return 'Le mot de passe doit contenir au moins 6 caractères';
                          }
                          return null;
                        },
                      )),
                      const SizedBox(height: 16),
                      Obx(() => TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirmer le mot de passe',
                          labelStyle: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: AppTheme.primaryPurple,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _authController.isPasswordVisible.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppTheme.textSecondary,
                            ),
                            onPressed: () {
                              _authController.togglePasswordVisibility();
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppTheme.peachLight,
                        ),
                        obscureText: !_authController.isPasswordVisible.value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez confirmer votre mot de passe';
                          }
                          if (value != _passwordController.text) {
                            return 'Les mots de passe ne correspondent pas';
                          }
                          return null;
                        },
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Obx(() => ElevatedButton(
                  onPressed: _authController.isLoading.value
                      ? null
                      : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _authController.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'S\'inscrire',
                          style: AppTheme.subtitleMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Déjà un compte ? ',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Se connecter',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.primaryPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      _authController.signUp(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }
} 