import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ShoppingListApp());
}

class ShoppingListApp extends StatelessWidget {
  const ShoppingListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ShoppingListPage(),
    );
  }
}

class ShoppingItem {
  final String id;
  final String name;
  final int quantity;
  final String category;
  final bool isBought;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    required this.isBought,
  });

  ShoppingItem copyWith({
    String? id,
    String? name,
    int? quantity,
    String? category,
    bool? isBought,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      isBought: isBought ?? this.isBought,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'category': category,
      'isBought': isBought,
    };
  }

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'] as String,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      category: map['category'] as String,
      isBought: map['isBought'] as bool,
    );
  }
}

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final List<ShoppingItem> _items = [];
  bool _isLoading = true;

  static const _storageKey = 'shopping_items';
  final List<String> _categories = [
    'Makanan',
    'Minuman',
    'Elektronik',
    'Perlengkapan Rumah',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      _items.clear();
      _items.addAll(decoded
          .map((e) => ShoppingItem.fromMap(e as Map<String, dynamic>))
          .toList());
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_items.map((e) => e.toMap()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  void _addItemDialog() {
    final nameController = TextEditingController();
    final qtyController = TextEditingController(text: '1');
    String selectedCategory = _categories.first;
    bool isBought = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tambah Item Belanja',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Item',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map(
                      (c) => DropdownMenuItem(
                    value: c,
                    child: Text(c),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  selectedCategory = value;
                },
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Sudah dibeli'),
                value: isBought,
                onChanged: (value) {
                  setState(() {
                    isBought = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final qty = int.tryParse(qtyController.text.trim()) ?? 1;

                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Nama item tidak boleh kosong')),
                      );
                      return;
                    }

                    final newItem = ShoppingItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      quantity: qty,
                      category: selectedCategory,
                      isBought: isBought,
                    );

                    setState(() {
                      _items.add(newItem);
                    });
                    _saveItems();
                    Navigator.pop(context);
                  },
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleStatus(ShoppingItem item) {
    final index = _items.indexWhere((e) => e.id == item.id);
    if (index == -1) return;

    setState(() {
      _items[index] = _items[index].copyWith(isBought: !item.isBought);
    });
    _saveItems();
  }

  void _deleteItem(ShoppingItem item) {
    setState(() {
      _items.removeWhere((e) => e.id == item.id);
    });
    _saveItems();
  }

  int get _totalBought =>
      _items.where((item) => item.isBought == true).length;

  int get _totalNotBought =>
      _items.where((item) => item.isBought == false).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Belanja'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Ringkasan total item
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Sudah dibeli'),
                          const SizedBox(height: 4),
                          Text(
                            _totalBought.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Belum dibeli'),
                          const SizedBox(height: 4),
                          Text(
                            _totalNotBought.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          Expanded(
            child: _items.isEmpty
                ? const Center(
              child: Text('Belum ada item. Tambahkan dulu, Bro!'),
            )
                : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Checkbox(
                      value: item.isBought,
                      onChanged: (_) => _toggleStatus(item),
                    ),
                    title: Text(
                      '${item.name} (x${item.quantity})',
                      style: TextStyle(
                        decoration: item.isBought
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(
                      '${item.category} • ${item.isBought ? 'Sudah dibeli' : 'Belum dibeli'}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _deleteItem(item),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addItemDialog,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}
