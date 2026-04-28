import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/consultation/consultation_bloc.dart';
import '../../services/api_service.dart';
import '../../models/prescription_model.dart';
import '../../utils/constants.dart';

class PrescriptionScreen extends StatefulWidget {
  final String prescriptionId;
  const PrescriptionScreen({Key? key, required this.prescriptionId}) : super(key: key);
  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  PrescriptionModel? _prescription;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPrescription();
  }

  Future<void> _loadPrescription() async {
    try {
      final api = context.read<ApiService>();
      final res = await api.getPrescription(widget.prescriptionId);
      if (res.data['success'] == true) {
        setState(() { _prescription = PrescriptionModel.fromJson(res.data['data']); _loading = false; });
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_prescription == null) return const Scaffold(body: Center(child: Text('الوصفة غير موجودة')));

    return Scaffold(
      appBar: AppBar(title: const Text('الوصفة الطبية')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Card(color: AppColors.primary.withOpacity(0.1), child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.medical_services, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text('وصفة طبية', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
              ]),
              const SizedBox(height: 8),
              Text('التشخيص: ${_prescription!.diagnosis}', style: const TextStyle(fontSize: 16)),
              Text('التاريخ: ${_prescription!.issuedAt.toString().substring(0, 10)}'),
            ]),
          )),
          const SizedBox(height: 16),
          const Text('الأدوية الموصوفة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._prescription!.medicines.map((med) => Card(
            child: ListTile(
              leading: const Icon(Icons.medication, color: AppColors.primary),
              title: Text(med.name),
              subtitle: Text('${med.dosage} - ${med.frequency} - ${med.durationDays} أيام'),
            ),
          )),
          const SizedBox(height: 16),
          if (_prescription!.instructions.isNotEmpty) ...[
            const Text('التعليمات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(_prescription!.instructions),
            const SizedBox(height: 16),
          ],
          ElevatedButton.icon(
            onPressed: () => context.push('/pharmacies'),
            icon: const Icon(Icons.shopping_cart), label: const Text('شراء الدواء الآن'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {}, icon: const Icon(Icons.download), label: const Text('تنزيل PDF'),
          ),
        ]),
      ),
    );
  }
}
