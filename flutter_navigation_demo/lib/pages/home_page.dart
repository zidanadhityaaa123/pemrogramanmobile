import 'package:flutter/material.dart';
import '../models/food_model.dart';
import 'detail_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  final List<Food> favoriteFoods;
  final Function(Food) onToggleFavorite;
  final bool Function(Food) isFavorite;

  const HomePage({
    super.key,
    required this.favoriteFoods,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeContent(
        onToggleFavorite: widget.onToggleFavorite,
        isFavorite: widget.isFavorite,
      ),
      FavoriteContent(
        favoriteFoods: widget.favoriteFoods,
        onToggleFavorite: widget.onToggleFavorite,
        isFavorite: widget.isFavorite,
      ),
      const ProfileContent(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🍽️ Foodie Menu'),
        centerTitle: true,
        elevation: 2,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Konten untuk tab Menu
class HomeContent extends StatefulWidget {
  final Function(Food) onToggleFavorite;
  final bool Function(Food) isFavorite;

  const HomeContent({
    super.key,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Indonesian', 'Japanese', 'Italian', 'Western', 'Thai', 'Drinks'];

    final filteredFoods = _selectedCategory == 'All'
        ? foodList
        : foodList.where((food) => food.category == _selectedCategory).toList();

    return Column(
      children: [
        // Category Filter
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category == _selectedCategory;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  backgroundColor: isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                ),
              );
            },
          ),
        ),

        // Food List
        Expanded(
          child: filteredFoods.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant,
                  size: 80,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada menu',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredFoods.length,
            itemBuilder: (context, index) {
              final food = filteredFoods[index];
              final isFavorite = widget.isFavorite(food);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          food: food,
                          isFavorite: isFavorite,
                          onToggleFavorite: () {
                            widget.onToggleFavorite(food);
                          },
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Food Image
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              food.image,
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Food Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                food.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.category,
                                    size: 14,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outline,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    food.category,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(
                                    Icons.star,
                                    size: 14,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    food.rating.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${food.price.toStringAsFixed(0)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Favorite Button
                        IconButton(
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                          ),
                          onPressed: () {
                            widget.onToggleFavorite(food);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Konten untuk tab Favorite
class FavoriteContent extends StatelessWidget {
  final List<Food> favoriteFoods;
  final Function(Food) onToggleFavorite;
  final bool Function(Food) isFavorite;

  const FavoriteContent({
    super.key,
    required this.favoriteFoods,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (favoriteFoods.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 100,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada makanan favorit',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan makanan favorit dari menu',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favoriteFoods.length,
      itemBuilder: (context, index) {
        final food = favoriteFoods[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    food: food,
                    isFavorite: true,
                    onToggleFavorite: () {
                      onToggleFavorite(food);
                    },
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Food Image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        food.image,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Food Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.category,
                              size: 14,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              food.category,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                color:
                                Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              food.rating.toString(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rp ${food.price.toStringAsFixed(0)}',
                          style:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Favorite Button
                  IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      onToggleFavorite(food);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Konten untuk tab Profile
class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 16),
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  '👨‍🍳',
                  style: const TextStyle(fontSize: 50),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Food Lover',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'foodie@email.com',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.restaurant),
                title: const Text('Pesanan Saya'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Alamat Pengiriman'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.payment),
                title: const Text('Metode Pembayaran'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Pengaturan'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Bantuan'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Tentang Aplikasi'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Foodie Menu',
                    applicationVersion: '1.0.0',
                    applicationIcon: const Text('🍽️', style: TextStyle(fontSize: 48)),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            );
          },
          icon: const Icon(Icons.person),
          label: const Text('Lihat Profile Lengkap'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}