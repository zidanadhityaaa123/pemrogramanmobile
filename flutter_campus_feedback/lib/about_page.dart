import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  static const routeName = '/about';
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/uin_logo.png',
                      width: 90, height: 90, fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Campus Feedback', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Mata Kuliah: Pemrograman Perangkat Bergerak\n'
                        'Dosen: Ahmad Nasukha, S.Hum., M.S.I\n'
                        'Pengembang: Zidan Adhitya Dafa\n'
                        'Tahun Akademik: 2025/2026',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('UIN STS Jambi', style: TextStyle(color: cs.onPrimaryContainer)),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Kembali ke Beranda'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
