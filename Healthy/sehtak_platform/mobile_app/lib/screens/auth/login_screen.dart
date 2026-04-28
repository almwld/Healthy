import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) { context.go('/home'); }
          else if (state is AuthError) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message))); }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 40),
              const Text(AppStrings.login, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              const Text('\u0633\u062c\u0651\u0644 \u062f\u062e\u0648\u0644\u0643 \u0644\u0644\u0645\u062a\u0627\u0628\u0639\u0629', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 40),
              TextField(controller: _phoneCtrl, keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: AppStrings.phone, prefixIcon: Icon(Icons.phone)),
              ),
              const SizedBox(height: 16),
              TextField(controller: _passCtrl, obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: AppStrings.password,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => _obscure = !_obscure)),
                ),
              ),
              const SizedBox(height: 8),
              Align(alignment: Alignment.centerLeft, child: TextButton(onPressed: () {}, child: const Text(AppStrings.forgotPassword))),
              const SizedBox(height: 24),
              BlocBuilder<AuthBloc, AuthState>(builder: (context, state) =>
                state is AuthLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () => context.read<AuthBloc>().add(LoginEvent(_phoneCtrl.text, _passCtrl.text)),
                      child: const Text(AppStrings.login),
                    ),
              ),
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('\u0644\u064a\u0633 \u0644\u062f\u064a\u0643 \u062d\u0633\u0627\u0628\u061f'),
                TextButton(onPressed: () => context.go('/register'), child: const Text('\u0633\u062c\u0651\u0644 \u0627\u0644\u0622\u0646')),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}
