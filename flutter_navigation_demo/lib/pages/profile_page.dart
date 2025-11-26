import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Lengkap'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Menggunakan Navigator.pop() untuk kembali
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur edit profile'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Profile
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context).colorScheme.surface,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        '👨‍🍳',
                        style: TextStyle(fontSize: 60),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Food Enthusiast',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'foodlover@email.com',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        avatar: const Text('⭐', style: TextStyle(fontSize: 16)),
                        label: const Text('Food Critic'),
                        backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                      ),
                      Chip(
                        avatar: const Text('👑', style: TextStyle(fontSize: 16)),
                        label: const Text('Premium Member'),
                        backgroundColor:
                        Theme.of(context).colorScheme.tertiaryContainer,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Stats Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      emoji: '🍽️',
                      value: '127',
                      label: 'Pesanan',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      emoji: '❤️',
                      value: '42',
                      label: 'Favorit',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      emoji: '✍️',
                      value: '38',
                      label: 'Review',
                    ),
                  ),
                ],
              ),
            ),

            // Info Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informasi Pribadi',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Text('📱', style: TextStyle(fontSize: 24)),
                          title: const Text('Phone'),
                          subtitle: const Text('+62 812 3456 7890'),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Text('📍', style: TextStyle(fontSize: 24)),
                          title: const Text('Alamat'),
                          subtitle: const Text('Jakarta Selatan, Indonesia'),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Text('🎂', style: TextStyle(fontSize: 24)),
                          title: const Text('Bergabung'),
                          subtitle: const Text('15 Januari 2023'),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Text('💳', style: TextStyle(fontSize: 24)),
                          title: const Text('Member Level'),
                          subtitle: const Text('Premium Gold'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Preferences Section
                  Text(
                    'Preferensi Makanan',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('❤️', style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 8),
                              Text(
                                'Makanan Favorit',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Nasi Goreng, Sushi, Rendang, Pizza',
                            style: TextStyle(height: 1.5),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Text('🚫', style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 8),
                              Text(
                                'Alergi',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Tidak ada',
                            style: TextStyle(height: 1.5),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Text('🌶️', style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 8),
                              Text(
                                'Level Pedas',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Medium - Suka pedas tapi tidak terlalu ekstrem',
                            style: TextStyle(height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Bio Section
                  Text(
                    'Tentang Saya',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Pecinta kuliner sejati yang selalu mencari pengalaman rasa baru. '
                            'Suka mencoba berbagai jenis makanan dari berbagai negara. '
                            'Food is not just fuel, it\'s an experience! 🍜🍕🍣',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Achievements
                  Text(
                    'Pencapaian',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildAchievement(
                            context,
                            emoji: '🏆',
                            title: 'Top Reviewer',
                            description: 'Menulis 50+ review',
                          ),
                          const Divider(height: 24),
                          _buildAchievement(
                            context,
                            emoji: '🌟',
                            title: 'Food Explorer',
                            description: 'Mencoba 100+ menu berbeda',
                          ),
                          const Divider(height: 24),
                          _buildAchievement(
                            context,
                            emoji: '💎',
                            title: 'Loyal Customer',
                            description: 'Member aktif selama 2 tahun',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Logout'),
                            content: const Text(
                                'Apakah Anda yakin ingin keluar?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Batal'),
                              ),
                              FilledButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Berhasil logout!'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Kembali'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, {
        required String emoji,
        required String value,
        required String label,
      }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievement(
      BuildContext context, {
        required String emoji,
        required String title,
        required String description,
      }) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}