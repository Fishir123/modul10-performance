import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// Detail Screen dummy (Tugas Mandiri).
///
/// Menerima [title] & [description] dari screen pemanggil lewat Navigator.
class DetailScreen extends StatelessWidget {
  const DetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(icon, size: 96, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: AppConstants.spacingL),
            Text(title, style: theme.textTheme.headlineMedium),
            const SizedBox(height: AppConstants.spacingS),
            Text(description, style: theme.textTheme.bodyLarge),
            const SizedBox(height: AppConstants.spacingL),
            FilledButton.tonalIcon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}
