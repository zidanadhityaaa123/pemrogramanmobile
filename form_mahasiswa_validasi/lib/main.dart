import 'package:flutter/material.dart';

void main() {
  runApp(const FormMahasiswaApp());
}

class FormMahasiswaApp extends StatelessWidget {
  const FormMahasiswaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'form_mahasiswa_validasi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MahasiswaStepperFormPage(),
    );
  }
}

class MahasiswaStepperFormPage extends StatefulWidget {
  const MahasiswaStepperFormPage({super.key});

  @override
  State<MahasiswaStepperFormPage> createState() =>
      _MahasiswaStepperFormPageState();
}

class _MahasiswaStepperFormPageState extends State<MahasiswaStepperFormPage> {
  int _currentStep = 0;

  // Form keys per step
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();

  // Step 1: Data pribadi
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _hpController = TextEditingController();

  // Step 2: Akademik
  String? _selectedJurusan;
  int _semester = 1;

  final List<String> _jurusanList = [
    'Informatika',
    'Sistem Informasi',
    'Teknik Elektro',
    'Manajemen',
    'Akuntansi',
  ];

  // Step 3: Hobi & persetujuan
  bool _hobiMembaca = false;
  bool _hobiOlahraga = false;
  bool _hobiGaming = false;
  bool _hobiMusik = false;
  bool _setuju = false;

  String? _hobiError;
  String? _setujuError;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _hpController.dispose();
    super.dispose();
  }

  bool _validateStep1() {
    return _formKeyStep1.currentState!.validate();
  }

  bool _validateStep2() {
    return _formKeyStep2.currentState!.validate();
  }

  bool _validateStep3() {
    _hobiError = null;
    _setujuError = null;

    // Tidak ada TextFormField di step 3, jadi Form.validate() selalu true
    _formKeyStep3.currentState!.validate();

    bool isValid = true;

    if (!_hobiMembaca &&
        !_hobiOlahraga &&
        !_hobiGaming &&
        !_hobiMusik) {
      _hobiError = 'Pilih minimal satu hobi.';
      isValid = false;
    }

    if (!_setuju) {
      _setujuError = 'Anda harus menyetujui pernyataan ini.';
      isValid = false;
    }

    setState(() {});
    return isValid;
  }

  void _onStepContinue() {
    if (_currentStep == 0) {
      if (_validateStep1()) {
        setState(() {
          _currentStep = 1;
        });
      }
    } else if (_currentStep == 1) {
      if (_validateStep2()) {
        setState(() {
          _currentStep = 2;
        });
      }
    } else if (_currentStep == 2) {
      if (_validateStep3()) {
        _showSummaryDialog();
      }
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  void _showSummaryDialog() {
    final hobiList = <String>[];
    if (_hobiMembaca) hobiList.add('Membaca');
    if (_hobiOlahraga) hobiList.add('Olahraga');
    if (_hobiGaming) hobiList.add('Gaming');
    if (_hobiMusik) hobiList.add('Musik');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Data Mahasiswa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama     : ${_namaController.text}'),
              Text('Email    : ${_emailController.text}'),
              Text('No. HP   : ${_hpController.text}'),
              Text('Jurusan  : ${_selectedJurusan ?? '-'}'),
              Text('Semester : $_semester'),
              Text('Hobi     : ${hobiList.isEmpty ? '-' : hobiList.join(', ')}'),
              Text('Setuju   : ${_setuju ? 'Ya' : 'Tidak'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: const Text('Data Pribadi'),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.editing,
        content: Form(
          key: _formKeyStep1,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  if (value.trim().length < 3) {
                    return 'Nama minimal 3 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  final emailRegex =
                  RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
                  if (!emailRegex.hasMatch(text)) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _hpController,
                decoration: const InputDecoration(
                  labelText: 'Nomor HP',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return 'Nomor HP tidak boleh kosong';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(text)) {
                    return 'Nomor HP hanya boleh angka';
                  }
                  if (text.length < 10) {
                    return 'Nomor HP minimal 10 digit';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      Step(
        title: const Text('Akademik'),
        isActive: _currentStep >= 1,
        state: _currentStep > 1
            ? StepState.complete
            : (_currentStep == 1 ? StepState.editing : StepState.indexed),
        content: Form(
          key: _formKeyStep2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Jurusan',
                  border: OutlineInputBorder(),
                ),
                value: _selectedJurusan,
                items: _jurusanList
                    .map(
                      (j) => DropdownMenuItem(
                    value: j,
                    child: Text(j),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedJurusan = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jurusan harus dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Semester: $_semester',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Slider(
                value: _semester.toDouble(),
                min: 1,
                max: 14,
                divisions: 13,
                label: 'Semester $_semester',
                onChanged: (value) {
                  setState(() {
                    _semester = value.round();
                  });
                },
              ),
              const Text(
                'Pilih semester 1–14 menggunakan slider.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
      Step(
        title: const Text('Lainnya'),
        isActive: _currentStep >= 2,
        state: _currentStep == 2 ? StepState.editing : StepState.indexed,
        content: Form(
          key: _formKeyStep3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hobi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CheckboxListTile(
                title: const Text('Membaca'),
                value: _hobiMembaca,
                onChanged: (value) {
                  setState(() {
                    _hobiMembaca = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Olahraga'),
                value: _hobiOlahraga,
                onChanged: (value) {
                  setState(() {
                    _hobiOlahraga = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Gaming'),
                value: _hobiGaming,
                onChanged: (value) {
                  setState(() {
                    _hobiGaming = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Musik'),
                value: _hobiMusik,
                onChanged: (value) {
                  setState(() {
                    _hobiMusik = value ?? false;
                  });
                },
              ),
              if (_hobiError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                  child: Text(
                    _hobiError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const Divider(),
              SwitchListTile(
                title: const Text('Saya menyetujui bahwa data yang saya isi sudah benar'),
                value: _setuju,
                onChanged: (value) {
                  setState(() {
                    _setuju = value;
                  });
                },
              ),
              if (_setujuError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                  child: Text(
                    _setujuError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 8),
              const Text(
                'Klik "Lanjut" di bawah untuk submit data.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Mahasiswa (Stepper)'),
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        steps: _buildSteps(),
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        onStepTapped: (step) {
          setState(() {
            _currentStep = step;
          });
        },
        controlsBuilder: (context, details) {
          final isLastStep = _currentStep == _buildSteps().length - 1;
          return Row(
            children: [
              FilledButton(
                onPressed: details.onStepContinue,
                child: Text(isLastStep ? 'Submit' : 'Lanjut'),
              ),
              const SizedBox(width: 8),
              if (_currentStep > 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Kembali'),
                ),
            ],
          );
        },
      ),
    );
  }
}
