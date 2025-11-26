import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'models/food_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Food> _favoriteFoods = [];

  void _toggleFavorite(Food food) {
    setState(() {
      if (_favoriteFoods.any((f) => f.id == food.id)) {
        _favoriteFoods.removeWhere((f) => f.id == food.id);
      } else {
        _favoriteFoods.add(food);
      }
    });
  }

  bool _isFavorite(Food food) {
    return _favoriteFoods.any((f) => f.id == food.id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodie Menu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: HomePage(
        favoriteFoods: _favoriteFoods,
        onToggleFavorite: _toggleFavorite,
        isFavorite: _isFavorite,
      ),
    );
  }
}