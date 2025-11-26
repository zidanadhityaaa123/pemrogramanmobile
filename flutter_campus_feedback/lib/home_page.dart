import 'package:flutter/material.dart';
import 'about_page.dart';
import 'feedback_form_page.dart';
import 'feedback_list_page.dart';
import 'model/feedback_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final hasData = FeedbackRepository.all().isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Beranda')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // [Logo UIN]
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/uin_logo.png',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),

                // [Title]
                Text(
                  'Campus Feedback',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Opacity(
                  opacity: .8,
                  child: Text(
                    'Bantu kampus meningkatkan fasilitas & layanan dengan mengisi feedback.',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),

                // [Formulir Feedback]
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.edit_note),
                    onPressed: () => Navigator.pushNamed(context, FeedbackFormPage.routeName),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    label: const Text('Formulir Feedback'),
                  ),
                ),
                const SizedBox(height: 12),

                // [Daftar Feedback]
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.list_alt),
                    onPressed: hasData
                        ? () => Navigator.pushNamed(context, FeedbackListPage.routeName)
                        : null, // disable kalau belum ada data
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    label: const Text('Daftar Feedback'),
                  ),
                ),
                const SizedBox(height: 12),

                // [Tentang Aplikasi]
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () => Navigator.pushNamed(context, AboutPage.routeName),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    label: const Text('Tentang Aplikasi'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
