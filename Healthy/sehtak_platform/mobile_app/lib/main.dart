import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/consultation/consultation_bloc.dart';
import 'blocs/order/order_bloc.dart';
import 'blocs/subscription/subscription_bloc.dart';
import 'services/api_service.dart';
import 'services/storage_service.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/auth/complete_profile_screen.dart';
import 'screens/home_screen.dart';
import 'screens/symptoms_selector_screen.dart';
import 'screens/consultation/active_consultation_screen.dart';
import 'screens/consultation/consultation_history_screen.dart';
import 'screens/consultation/prescription_screen.dart';
import 'screens/pharmacy/pharmacies_screen.dart';
import 'screens/pharmacy/order_tracking_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/subscription_screen.dart';
import 'screens/doctor/doctor_dashboard_screen.dart';
import 'utils/constants.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final storageService = await StorageService.init();
  final apiService = ApiService(storageService);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(SehtakApp(storageService: storageService, apiService: apiService));
}

class SehtakApp extends StatelessWidget {
  final StorageService storageService;
  final ApiService apiService;

  const SehtakApp({Key? key, required this.storageService, required this.apiService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(apiService, storageService)),
        BlocProvider(create: (_) => ConsultationBloc(apiService)),
        BlocProvider(create: (_) => OrderBloc(apiService)),
        BlocProvider(create: (_) => SubscriptionBloc(apiService)),
      ],
      child: MaterialApp.router(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar', 'SA')],
        locale: const Locale('ar', 'SA'),
        routerConfig: _router,
      ),
    );
  }

  GoRouter get _router => GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(path: '/otp', builder: (context, state) => OtpScreen(userId: state.extra as String?)),
      GoRoute(path: '/complete-profile', builder: (context, state) => const CompleteProfileScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/symptoms', builder: (context, state) => const SymptomsSelectorScreen()),
      GoRoute(path: '/consultation/:id', builder: (context, state) => ActiveConsultationScreen(consultationId: state.pathParameters['id']!)),
      GoRoute(path: '/consultation-history', builder: (context, state) => const ConsultationHistoryScreen()),
      GoRoute(path: '/prescription/:id', builder: (context, state) => PrescriptionScreen(prescriptionId: state.pathParameters['id']!)),
      GoRoute(path: '/pharmacies', builder: (context, state) => const PharmaciesScreen()),
      GoRoute(path: '/order-tracking/:id', builder: (context, state) => OrderTrackingScreen(orderId: state.pathParameters['id']!)),
      GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
      GoRoute(path: '/subscription', builder: (context, state) => const SubscriptionScreen()),
      GoRoute(path: '/doctor-dashboard', builder: (context, state) => const DoctorDashboardScreen()),
    ],
  );
}
