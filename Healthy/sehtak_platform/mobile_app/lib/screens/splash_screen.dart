import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      final storage = StorageService.instance;
      if (storage.isOnboardingSeen()) {
        final token = storage.getToken();
        if (token != null) { context.go('/home'); }
        else { context.go('/login'); }
      } else { context.go('/onboarding'); }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                child: const Icon(Icons.local_hospital, size: 60, color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              const Text(AppStrings.appName, style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              const Text('\u0631\u0639\u0627\u064a\u062a\u0643 \u0627\u0644\u0635\u062d\u064a\u0629 \u0628\u064a\u0646 \u064a\u062f\u064a\u0643', style: TextStyle(fontSize: 16, color: Colors.white70)),
              const SizedBox(height: 48),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
