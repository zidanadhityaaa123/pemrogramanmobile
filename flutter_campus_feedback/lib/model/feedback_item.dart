class FeedbackItem {
  final String name;
  final String nim;
  final String faculty;
  final List<String> facilities;
  final double satisfaction; // 1..5
  final String type; // Apresiasi / Saran / Keluhan
  final String? message;
  final bool agreed;
  final DateTime createdAt;

  FeedbackItem({
    required this.name,
    required this.nim,
    required this.faculty,
    required this.facilities,
    required this.satisfaction,
    required this.type,
    this.message,
    required this.agreed,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class FeedbackRepository {
  static final List<FeedbackItem> _items = [];

  static List<FeedbackItem> all() => List.unmodifiable(_items);

  static void add(FeedbackItem item) => _items.insert(0, item);

  static void remove(FeedbackItem item) => _items.remove(item);
}
