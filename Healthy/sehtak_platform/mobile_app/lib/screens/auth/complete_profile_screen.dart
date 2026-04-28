import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../utils/constants.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);
  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  String _userType = 'patient';
  final _dobCtrl = TextEditingController();
  String _gender = 'male';
  String _bloodType = 'A+';
  final List<String> _chronicDiseases = [];
  final _allergiesCtrl = TextEditingController();
  final _specCtrl = TextEditingController();
  final _licenseCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _pharmNameCtrl = TextEditingController();
  final _pharmLicenseCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('استكمال الملف الشخصي')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) { context.go('/home'); }
          else if (state is AuthError) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message))); }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            DropdownButtonFormField<String>(
              value: _userType,
              decoration: const InputDecoration(labelText: 'نوع الحساب'),
              items: const [
                DropdownMenuItem(value: 'patient', child: Text('مريض')),
                DropdownMenuItem(value: 'doctor', child: Text('طبيب')),
                DropdownMenuItem(value: 'pharmacy', child: Text('صيدلية')),
              ],
              onChanged: (v) => setState(() => _userType = v!),
            ),
            const SizedBox(height: 24),
            if (_userType == 'patient') ...[
              TextField(controller: _dobCtrl, decoration: const InputDecoration(labelText: 'تاريخ الميلاد', prefixIcon: Icon(Icons.calendar_today))),
              const SizedBox(height: 16),
              DropdownButtonFormField(value: _gender, decoration: const InputDecoration(labelText: 'الجنس', prefixIcon: Icon(Icons.person)),
                items: const [DropdownMenuItem(value: 'male', child: Text('ذكر')), DropdownMenuItem(value: 'female', child: Text('أنثى'))],
                onChanged: (v) => setState(() => _gender = v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(value: _bloodType, decoration: const InputDecoration(labelText: 'فصيلة الدم', prefixIcon: Icon(Icons.water_drop)),
                items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _bloodType = v!),
              ),
              const SizedBox(height: 16),
              const Text('الأمراض المزمنة'),
              Wrap(spacing: 8, children: ['سكري', 'ضغط', 'قلب', 'ربو'].map((d) =>
                FilterChip(label: Text(d), selected: _chronicDiseases.contains(d),
                  onSelected: (s) => setState(() => s ? _chronicDiseases.add(d) : _chronicDiseases.remove(d)),
                ),
              ).toList()),
              const SizedBox(height: 16),
              TextField(controller: _allergiesCtrl, decoration: const InputDecoration(labelText: 'الحساسيات', prefixIcon: Icon(Icons.warning))),
            ] else if (_userType == 'doctor') ...[
              TextField(controller: _specCtrl, decoration: const InputDecoration(labelText: 'التخصص', prefixIcon: Icon(Icons.medical_services))),
              const SizedBox(height: 16),
              TextField(controller: _licenseCtrl, decoration: const InputDecoration(labelText: 'رقم الترخيص', prefixIcon: Icon(Icons.badge))),
              const SizedBox(height: 16),
              TextField(controller: _expCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'سنوات الخبرة', prefixIcon: Icon(Icons.timer))),
              const SizedBox(height: 16),
              TextField(controller: _bioCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'السيرة الذاتية', prefixIcon: Icon(Icons.description))),
            ] else ...[
              TextField(controller: _pharmNameCtrl, decoration: const InputDecoration(labelText: 'اسم الصيدلية', prefixIcon: Icon(Icons.local_pharmacy))),
              const SizedBox(height: 16),
              TextField(controller: _pharmLicenseCtrl, decoration: const InputDecoration(labelText: 'رقم الترخيص', prefixIcon: Icon(Icons.badge))),
              const SizedBox(height: 16),
              TextField(controller: _addressCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'العنوان الكامل', prefixIcon: Icon(Icons.location_on))),
            ],
            const SizedBox(height: 32),
            BlocBuilder<AuthBloc, AuthState>(builder: (context, state) =>
              state is AuthLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () {
                      Map<String, dynamic> data = {'user_type': _userType};
                      if (_userType == 'patient') {
                        data.addAll({
                          'dob': _dobCtrl.text, 'gender': _gender, 'blood_type': _bloodType,
                          'chronic_diseases': _chronicDiseases, 'allergies': _allergiesCtrl.text.isEmpty ? [] : [_allergiesCtrl.text],
                        });
                      } else if (_userType == 'doctor') {
                        data.addAll({
                          'specialization': _specCtrl.text, 'license_number': _licenseCtrl.text,
                          'years_experience': int.tryParse(_expCtrl.text) ?? 0, 'bio': _bioCtrl.text,
                        });
                      } else {
                        data.addAll({
                          'pharmacy_name': _pharmNameCtrl.text, 'license_number': _pharmLicenseCtrl.text, 'address': _addressCtrl.text,
                        });
                      }
                      context.read<AuthBloc>().add(CompleteProfileEvent(data));
                    },
                    child: const Text(AppStrings.save),
                  ),
            ),
          ]),
        ),
      ),
    );
  }
}
