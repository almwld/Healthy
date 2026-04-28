import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../utils/constants.dart';

class OtpScreen extends StatefulWidget {
  final String? userId;
  const OtpScreen({Key? key, this.userId}) : super(key: key);
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  int _timer = 60;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _timer > 0) { setState(() => _timer--); _startTimer(); }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.otpCode)),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ProfileIncomplete) { context.go('/complete-profile'); }
          else if (state is AuthError) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message))); }
        },
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: 40),
            const Text('أدخل رمز التحقق', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('لقد أرسلنا رمزاً من 6 أرقام إلى جوالك', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 40),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(6, (i) =>
              Container(width: 48, height: 56, margin: const EdgeInsets.symmetric(horizontal: 4),
                child: TextField(
                  controller: _controllers[i], focusNode: _focusNodes[i], textAlign: TextAlign.center,
                  keyboardType: TextInputType.number, maxLength: 1,
                  onChanged: (v) { if (v.isNotEmpty && i < 5) _focusNodes[i + 1].requestFocus(); },
                  decoration: InputDecoration(counterText: '', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
            )),
            const SizedBox(height: 32),
            BlocBuilder<AuthBloc, AuthState>(builder: (context, state) =>
              state is AuthLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      final otp = _controllers.map((c) => c.text).join();
                      if (widget.userId != null) context.read<AuthBloc>().add(VerifyOtpEvent(widget.userId!, otp));
                    },
                    child: const Text(AppStrings.verify),
                  ),
            ),
            const SizedBox(height: 24),
            _timer > 0
              ? Text('إعادة الإرسال بعد $_timer ثانية', style: const TextStyle(color: AppColors.textSecondary))
              : TextButton(onPressed: () { if (widget.userId != null) context.read<AuthBloc>().add(ResendOtpEvent(widget.userId!)); }, child: const Text(AppStrings.resendOtp)),
          ]),
        ),
      ),
    );
  }
}
