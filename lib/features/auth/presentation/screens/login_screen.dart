import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enevtly/core/constants/app_constants.dart';
import 'package:enevtly/core/resourses/colors_manager.dart';
import 'package:enevtly/features/auth/presentation/providers/auth_provider.dart';

/// Login Screen with Google Sign-In
class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';
  
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo or App Name
              Icon(
                Icons.event,
                size: 100,
                color: ColorsManager.primaryColor,
              ),
              const SizedBox(height: 24),
              
              Text(
                'Evently',
                style: theme.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              Text(
                'Discover and Create Amazing Events',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // Google Sign-In Button
              if (authProvider.isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: ColorsManager.primaryColor,
                  ),
                )
              else
                ElevatedButton.icon(
                  onPressed: () async {
                    await authProvider.signInWithGoogle();
                    if (context.mounted && authProvider.isAuthenticated) {
                      Navigator.pushReplacementNamed(
                        context,
                        AppConstants.homeRoute,
                      );
                    }
                  },
                  icon: Image.asset(
                    'assets/icons/google.png',
                    height: 24,
                    width: 24,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.login, color: Colors.white);
                    },
                  ),
                  label: const Text(
                    'Continue with Google',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              
              const SizedBox(height: 16),
              
              // Error Message
              if (authProvider.errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    authProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
