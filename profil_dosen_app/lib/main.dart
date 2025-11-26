import 'package:flutter/material.dart';

void main() {
  runApp(const ProfilDosenApp());
}

class ProfilDosenApp extends StatelessWidget {
  const ProfilDosenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Dosen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        // ✅ Fix: gunakan CardThemeData, bukan CardTheme
        cardTheme: const CardThemeData(
          elevation: 3,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      home: const DosenListPage(),
    );
  }
}

/* =========================
   MODEL
========================= */
class Dosen {
  final String nama;
  final String nidn;
  final String prodi;
  final String email;
  final String gender; // "L" atau "P"
  final String deskripsi;

  const Dosen({
    required this.nama,
    required this.nidn,
    required this.prodi,
    required this.email,
    required this.gender,
    required this.deskripsi,
  });
}

/* =========================
   DATA DUMMY
========================= */
const List<Dosen> daftarDosen = [
  Dosen(
    nama: 'Wahyu Anggoro M.Kom.',
    nidn: '1571082309960021',
    prodi: 'Sistem informasi',
    email: 'anggoro.wahyu@uin.ac.id',
    gender: 'L',
    deskripsi:
    'Belajar manajemen resiko. '
        ,
  ),
  Dosen(
    nama: 'Pol Metra, M.Kom.',
    nidn: '19910615010122045',
    prodi: 'Sistem Informasi',
    email: 'polmetra@uin.ac.id',
    gender: 'L',
    deskripsi:
    'MULTIMEDIA ASIK. '
        'WAKIL KAPRODI  SI sejak 2024.',
  ),
  Dosen(
    nama: 'Ahmad Nasukha, S.Hum., M.S.I.',
    nidn: '1988072220171009',
    prodi: 'Sistem Informasi',
    email: 'nasukha,ahmad@uin.ac.id',
    gender: 'L',
    deskripsi:
    'Belajar pengembangan pemograman mobile.',
  ),
  Dosen(
    nama: 'Dila Nurlaila, M.Kom.',
    nidn: '1571015201960020',
    prodi: 'Sistem Informasi',
    email: 'mur.dila@uin.ac.id',
    gender: 'P',
    deskripsi:
    'membuat projek rekayasa perangkat lunak.',
  ),
];

/* =========================
   HALAMAN 1: LIST DOSEN
========================= */
class DosenListPage extends StatefulWidget {
  const DosenListPage({super.key});

  @override
  State<DosenListPage> createState() => _DosenListPageState();
}

class _DosenListPageState extends State<DosenListPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = daftarDosen.where((d) {
      final q = _query.toLowerCase();
      return d.nama.toLowerCase().contains(q) ||
          d.prodi.toLowerCase().contains(q) ||
          d.nidn.contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Dosen'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Cari nama / prodi / NIDN',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 720;
                if (isWide) {
                  return GridView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      childAspectRatio: 3.2,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) => DosenCard(dosen: filtered[i]),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) => DosenCard(dosen: filtered[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/* =========================
   KOMPONEN: KARTU DOSEN
========================= */
class DosenCard extends StatelessWidget {
  final Dosen dosen;
  const DosenCard({super.key, required this.dosen});

  @override
  Widget build(BuildContext context) {
    final isFemale = dosen.gender.toUpperCase() == 'P';
    final avatarColor = isFemale ? Colors.pinkAccent : Colors.indigo;
    // ✅ Ikon kompatibel lintas versi
    final iconData = isFemale ? Icons.female : Icons.male;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DosenDetailPage(dosen: dosen),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Hero(
                tag: 'avatar_${dosen.nidn}',
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: avatarColor.withOpacity(0.12),
                  child: Icon(iconData, color: avatarColor, size: 32),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dosen.nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${dosen.prodi} • NIDN: ${dosen.nidn}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      dosen.deskripsi,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.grey.shade500),
            ],
          ),
        ),
      ),
    );
  }
}

/* =========================
   HALAMAN 2: DETAIL DOSEN
========================= */
class DosenDetailPage extends StatelessWidget {
  final Dosen dosen;
  const DosenDetailPage({super.key, required this.dosen});

  @override
  Widget build(BuildContext context) {
    final isFemale = dosen.gender.toUpperCase() == 'P';
    final avatarColor = isFemale ? Colors.pinkAccent : Colors.indigo;
    final iconData = isFemale ? Icons.female : Icons.male;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Dosen'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;

          final avatar = Hero(
            tag: 'avatar_${dosen.nidn}',
            child: CircleAvatar(
              radius: 56,
              backgroundColor: avatarColor.withOpacity(0.12),
              child: Icon(iconData, color: avatarColor, size: 60),
            ),
          );

          final info = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dosen.nama,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _InfoChip(icon: Icons.badge, label: 'NIDN: ${dosen.nidn}'),
                  _InfoChip(icon: Icons.school, label: dosen.prodi),
                  _InfoChip(icon: Icons.email, label: dosen.email),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                dosen.deskripsi,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: () {
                      print('📧 Kirim email ke ${dosen.email}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Membuka email: ${dosen.email}')),
                      );
                    },
                    icon: const Icon(Icons.send),
                    label: const Text('Kirim Email'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      print('⭐ Simpan dosen favorit: ${dosen.nama}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ditandai favorit')),
                      );
                    },
                    icon: const Icon(Icons.star_border),
                    label: const Text('Favorit'),
                  ),
                ],
              )
            ],
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isWide
                  ? Row(
                key: const ValueKey('wide'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: _DecorPanel(child: Center(child: avatar)),
                  ),
                  const SizedBox(width: 20),
                  Expanded(flex: 7, child: _DecorPanel(child: info)),
                ],
              )
                  : Column(
                key: const ValueKey('narrow'),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DecorPanel(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(child: avatar),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _DecorPanel(child: info),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/* =========================
   WIDGET BANTUAN
========================= */
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
      label: Text(label),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}

class _DecorPanel extends StatelessWidget {
  final Widget child;
  const _DecorPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.06),
            Theme.of(context).colorScheme.secondary.withOpacity(0.04),
          ],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}
