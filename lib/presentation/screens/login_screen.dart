import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/storage/local_storage.dart';
import 'home_screen.dart';

/// Login Screen dummy (Tugas Mandiri).
///
/// Belum ada autentikasi nyata; tombol Masuk menavigasi ke [HomeScreen].
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Persist status login + username ke penyimpanan lokal (Modul 6).
      await LocalStorage.saveLoginStatus(true);
      await LocalStorage.saveUsername(_emailController.text.trim());
      if (!mounted) return;
      // Navigator sederhana: ganti ke Home setelah login.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingL),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Masuk ke ${AppConstants.appName}',
                  style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppConstants.spacingL),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Email wajib diisi' : null,
              ),
              const SizedBox(height: AppConstants.spacingM),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Password wajib diisi' : null,
              ),
              const SizedBox(height: AppConstants.spacingL),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _onLogin,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppConstants.spacingS),
                    child: Text('Masuk'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
