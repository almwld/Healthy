import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/consultation/consultation_bloc.dart';
import '../utils/constants.dart';

class SymptomsSelectorScreen extends StatefulWidget {
  const SymptomsSelectorScreen({Key? key}) : super(key: key);
  @override
  State<SymptomsSelectorScreen> createState() => _SymptomsSelectorScreenState();
}

class _SymptomsSelectorScreenState extends State<SymptomsSelectorScreen> {
  String? _selectedBodyPart;
  final _symptomsCtrl = TextEditingController();
  String _consultType = 'text';

  final List<Map<String, dynamic>> _bodyParts = [
    {'key': 'head', 'label': 'الرأس', 'icon': Icons.face},
    {'key': 'chest', 'label': 'الصدر', 'icon': Icons.favorite},
    {'key': 'stomach', 'label': 'البطن', 'icon': Icons.local_dining},
    {'key': 'bones', 'label': 'العظام', 'icon': Icons.accessibility_new},
    {'key': 'skin', 'label': 'الجلد', 'icon': Icons.texture},
    {'key': 'general', 'label': 'عام', 'icon': Icons.healing},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختيار الأعراض')),
      body: BlocListener<ConsultationBloc, ConsultationState>(
        listener: (context, state) {
          if (state is ConsultationStarted) {
            context.push('/consultation/${state.consultation.id}');
          } else if (state is ConsultationError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('اختر جزء الجسم المتأثر', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 3, childAspectRatio: 1.2,
              children: _bodyParts.map((part) => GestureDetector(
                onTap: () => setState(() => _selectedBodyPart = part['key']),
                child: Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _selectedBodyPart == part['key'] ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _selectedBodyPart == part['key'] ? AppColors.primary : AppColors.divider),
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(part['icon'], color: _selectedBodyPart == part['key'] ? Colors.white : AppColors.textSecondary),
                    const SizedBox(height: 4),
                    Text(part['label'], style: TextStyle(color: _selectedBodyPart == part['key'] ? Colors.white : AppColors.textPrimary)),
                  ]),
                ),
              )).toList(),
            ),
            const SizedBox(height: 24),
            const Text('صف أعراضك بالتفصيل *', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _symptomsCtrl, maxLines: 4,
              decoration: const InputDecoration(hintText: 'مثال: أشعر بصداع مستمر في الجهة اليمنى منذ يومين مع دوار خفيف...'),
            ),
            const SizedBox(height: 24),
            const Text('نوع الاستشارة المفضل', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(children: [
              _typeChip('محادثة نصية', 'text', Icons.chat),
              const SizedBox(width: 8),
              _typeChip('مكالمة صوتية', 'audio', Icons.phone),
              const SizedBox(width: 8),
              _typeChip('مكالمة فيديو', 'video', Icons.videocam),
            ]),
            const SizedBox(height: 32),
            BlocBuilder<ConsultationBloc, ConsultationState>(builder: (context, state) =>
              state is ConsultationLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _symptomsCtrl.text.isEmpty ? null : () {
                      context.read<ConsultationBloc>().add(StartConsultationEvent(
                        _symptomsCtrl.text, _selectedBodyPart, _consultType,
                      ));
                    },
                    child: const Text('ابدأ الاستشارة'),
                  ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _typeChip(String label, String value, IconData icon) => Expanded(
    child: GestureDetector(
      onTap: () => setState(() => _consultType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: _consultType == value ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _consultType == value ? AppColors.primary : AppColors.divider),
        ),
        child: Column(children: [
          Icon(icon, color: _consultType == value ? Colors.white : AppColors.textSecondary, size: 20),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: _consultType == value ? Colors.white : AppColors.textPrimary)),
        ]),
      ),
    ),
  );
}
