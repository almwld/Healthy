import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../utils/constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  String _userType = 'patient';
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.register)),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpRequired) { context.go('/otp', extra: state.userId); }
          else if (state is AuthError) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message))); }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: AppStrings.fullName, prefixIcon: Icon(Icons.person))),
            const SizedBox(height: 16),
            TextField(controller: _phoneCtrl, keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: AppStrings.phone, prefixIcon: Icon(Icons.phone), hintText: '+966xxxxxxxxx'),
            ),
            const SizedBox(height: 16),
            TextField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: AppStrings.email, prefixIcon: Icon(Icons.email)),
            ),
            const SizedBox(height: 16),
            TextField(controller: _passCtrl, obscureText: _obscure,
              decoration: InputDecoration(labelText: AppStrings.password, prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => _obscure = !_obscure)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(controller: _confirmCtrl, obscureText: true,
              decoration: const InputDecoration(labelText: AppStrings.confirmPassword, prefixIcon: Icon(Icons.lock_outline)),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _userType,
              decoration: const InputDecoration(labelText: AppStrings.userType, prefixIcon: Icon(Icons.person_outline)),
              items: [
                DropdownMenuItem(value: 'patient', child: Text(AppStrings.patient)),
                DropdownMenuItem(value: 'doctor', child: Text(AppStrings.doctor)),
                DropdownMenuItem(value: 'pharmacy', child: Text(AppStrings.pharmacy)),
              ],
              onChanged: (v) => setState(() => _userType = v!),
            ),
            const SizedBox(height: 24),
            BlocBuilder<AuthBloc, AuthState>(builder: (context, state) =>
              state is AuthLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      if (_passCtrl.text != _confirmCtrl.text) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('\u0643\u0644\u0645\u062a\u0627 \u0627\u0644\u0645\u0631\u0648\u0631 \u063a\u064a\u0631 \u0645\u062a\u0637\u0627\u0628\u0642\u062a\u064a\u0646')));
                        return;
                      }
                      context.read<AuthBloc>().add(RegisterEvent({
                        'full_name': _nameCtrl.text, 'phone': _phoneCtrl.text,
                        'email': _emailCtrl.text.isEmpty ? null : _emailCtrl.text,
                        'password': _passCtrl.text, 'user_type': _userType,
                      }));
                    },
                    child: const Text(AppStrings.register),
                  ),
            ),
          ]),
        ),
      ),
    );
  }
}
