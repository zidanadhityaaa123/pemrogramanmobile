import 'package:flutter/material.dart';
import 'model/feedback_item.dart';
import 'feedback_list_page.dart';

class FeedbackFormPage extends StatefulWidget {
  static const routeName = '/form';
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _nimC = TextEditingController();
  final _messageC = TextEditingController();

  String? _faculty;
  double _satisfaction = 3;
  String _type = 'Apresiasi';
  bool _agree = false;

  final _facilities = <String, bool>{
    'Perpustakaan': false,
    'Laboratorium': false,
    'Ruang Kelas': false,
    'Kantin': false,
    'Wifi Kampus': false,
  };

  final _faculties = const [
    'Sains & Teknologi',
    'Syariah',
    'Ekonomi & Bisnis Islam',
    'Ushuluddin & Humaniora',
    'Tarbiyah',
  ];

  @override
  void dispose() {
    _nameC.dispose();
    _nimC.dispose();
    _messageC.dispose();
    super.dispose();
  }

  void _save() {
    if (!_agree) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Aktifkan persetujuan S&K sebelum menyimpan.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() != true) return;

    final selectedFacilities =
    _facilities.entries.where((e) => e.value).map((e) => e.key).toList();

    final item = FeedbackItem(
      name: _nameC.text.trim(),
      nim: _nimC.text.trim(),
      faculty: _faculty ?? '-',
      facilities: selectedFacilities,
      satisfaction: _satisfaction,
      type: _type,
      message: _messageC.text.trim().isEmpty ? null : _messageC.text.trim(),
      agreed: _agree,
    );

    FeedbackRepository.add(item);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback disimpan')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const FeedbackListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Feedback'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _Section(title: 'Identitas'),
                  TextFormField(
                    controller: _nameC,
                    decoration: const InputDecoration(
                      labelText: 'Nama Mahasiswa',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nimC,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'NIM',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Wajib diisi';
                      if (int.tryParse(v) == null) return 'Harus angka';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _faculty,
                    items: _faculties
                        .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                        .toList(),
                    onChanged: (v) => setState(() => _faculty = v),
                    decoration: const InputDecoration(
                      labelText: 'Fakultas',
                      prefixIcon: Icon(Icons.school),
                    ),
                    validator: (v) => v == null ? 'Pilih salah satu' : null,
                  ),

                  const SizedBox(height: 20),
                  _Section(title: 'Penilaian Fasilitas'),

                  ..._facilities.keys.map((k) {
                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _facilities[k],
                      onChanged: (v) => setState(() => _facilities[k] = v ?? false),
                      title: Text(k),
                    );
                  }),

                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Nilai Kepuasan'),
                    subtitle: Slider(
                      min: 1,
                      max: 5,
                      divisions: 8,
                      value: _satisfaction,
                      label: _satisfaction.toStringAsFixed(1),
                      onChanged: (v) => setState(() => _satisfaction = v),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(_satisfaction.toStringAsFixed(1)),
                    ),
                  ),

                  const SizedBox(height: 12),
                  _Section(title: 'Jenis Feedback'),
                  RadioListTile(
                    value: 'Apresiasi',
                    groupValue: _type,
                    onChanged: (v) => setState(() => _type = v as String),
                    title: const Text('Apresiasi'),
                  ),
                  RadioListTile(
                    value: 'Saran',
                    groupValue: _type,
                    onChanged: (v) => setState(() => _type = v as String),
                    title: const Text('Saran'),
                  ),
                  RadioListTile(
                    value: 'Keluhan',
                    groupValue: _type,
                    onChanged: (v) => setState(() => _type = v as String),
                    title: const Text('Keluhan'),
                  ),

                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _messageC,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Pesan tambahan (opsional)',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.message_outlined),
                    ),
                  ),

                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _agree,
                    onChanged: (v) => setState(() => _agree = v),
                    title: const Text('Saya setuju dengan Syarat & Ketentuan'),
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.save_outlined),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Simpan Feedback'),
                      ),
                    ),
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

class _Section extends StatelessWidget {
  final String title;
  const _Section({required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: cs.primary,
          ),
        ),
      ),
    );
  }
}
