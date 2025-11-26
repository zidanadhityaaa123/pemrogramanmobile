import 'package:flutter/material.dart';
import '../../models/food_model.dart';

class DetailPage extends StatefulWidget {
  final Food food;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const DetailPage({
    super.key,
    required this.food,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Makanan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Menggunakan Navigator.pop() untuk kembali
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: widget.isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              widget.onToggleFavorite();
              setState(() {}); // Update UI
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan gambar makanan
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context).colorScheme.secondaryContainer,
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  widget.food.image,
                  style: const TextStyle(fontSize: 120),
                ),
              ),
            ),

            // Konten
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama dan Rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.food.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.food.rating.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Kategori
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.food.category,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Info Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          context,
                          icon: Icons.local_fire_department,
                          label: 'Kalori',
                          value: '${widget.food.calories} kcal',
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          context,
                          icon: Icons.timer,
                          label: 'Waktu',
                          value: widget.food.cookingTime,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),

                  // Deskripsi
                  Text(
                    'Deskripsi',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.food.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Harga dan Quantity
                  Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Harga',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rp ${widget.food.price.toStringAsFixed(0)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: _quantity > 1
                                          ? () {
                                        setState(() {
                                          _quantity--;
                                        });
                                      }
                                          : null,
                                    ),
                                    Container(
                                      width: 40,
                                      alignment: Alignment.center,
                                      child: Text(
                                        _quantity.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          _quantity++;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (_quantity > 1) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Total: Rp ${(widget.food.price * _quantity).toStringAsFixed(0)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
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
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: FilledButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${widget.food.name} (${_quantity}x) ditambahkan ke keranjang!',
                                ),
                                behavior: SnackBarBehavior.floating,
                                action: SnackBarAction(
                                  label: 'OK',
                                  onPressed: () {},
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text('Tambah ke Keranjang'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String value,
        required Color color,
      }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}