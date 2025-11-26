import 'package:flutter/material.dart';
import 'model/feedback_item.dart';
import 'feedback_detail_page.dart';

class FeedbackListPage extends StatefulWidget {
  static const routeName = '/list';
  const FeedbackListPage({super.key});

  @override
  State<FeedbackListPage> createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  @override
  Widget build(BuildContext context) {
    final items = FeedbackRepository.all();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Feedback'),
      ),
      body: items.isEmpty
          ? const _EmptyState()
          : ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final it = items[index];
          final (icon, tint) = _typeVisual(it.type, Theme.of(context).colorScheme);
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: tint.withOpacity(.15),
                child: Icon(icon, color: tint),
              ),
              title: Text(it.name),
              subtitle: Text('${it.faculty} • Nilai: ${it.satisfaction.toStringAsFixed(1)}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FeedbackDetailPage(item: it)),
                );
                setState(() {}); // refresh setelah kemungkinan dihapus
              },
            ),
          );
        },
      ),
    );
  }

  (IconData, Color) _typeVisual(String type, ColorScheme cs) {
    switch (type) {
      case 'Apresiasi':
        return (Icons.thumb_up_alt, cs.tertiary);
      case 'Saran':
        return (Icons.lightbulb_outline, cs.primary);
      default:
        return (Icons.report_problem_outlined, cs.error);
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, size: 64),
            const SizedBox(height: 12),
            Text(
              'Belum ada feedback',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            const Text('Kembali ke Beranda dan isi formulir terlebih dahulu.'),
          ],
        ),
      ),
    );
  }
}
