import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../utils/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profile)),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                CircleAvatar(radius: 50, backgroundColor: AppColors.primary, child: Text(state.user.fullName.substring(0, 1), style: const TextStyle(fontSize: 32, color: Colors.white))),
                const SizedBox(height: 16),
                Text(state.user.fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(state.user.phone, style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 24),
                Card(child: Column(children: [
                  ListTile(leading: const Icon(Icons.person_outline), title: const Text('تعديل الملف الشخصي'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
                  const Divider(height: 1),
                  ListTile(leading: const Icon(Icons.medical_information), title: const Text('البيانات الطبية'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
                  const Divider(height: 1),
                  ListTile(leading: const Icon(Icons.notifications_none), title: const Text('الإشعارات'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
                  const Divider(height: 1),
                  ListTile(leading: const Icon(Icons.subscriptions_outlined), title: const Text('الاشتراك'), trailing: const Chip(label: Text('مجاني')), onTap: () => context.push('/subscription')),
                ])),
                const SizedBox(height: 16),
                Card(child: Column(children: [
                  ListTile(leading: const Icon(Icons.help_outline), title: const Text('مركز المساعدة'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
                  const Divider(height: 1),
                  ListTile(leading: const Icon(Icons.support_agent), title: const Text('تواصل مع الدعم'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
                  const Divider(height: 1),
                  ListTile(leading: const Icon(Icons.report_problem_outlined), title: const Text('تقرير مشكلة'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
                ])),
                const SizedBox(height: 24),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(AppStrings.logout, style: TextStyle(color: Colors.red)),
                  onTap: () {
                    showDialog(context: context, builder: (ctx) => AlertDialog(
                      title: const Text('تأكيد'), content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(AppStrings.cancel)),
                        TextButton(onPressed: () {
                          context.read<AuthBloc>().add(LogoutEvent());
                          context.go('/login');
                        }, child: const Text(AppStrings.logout)),
                      ],
                    ));
                  },
                ),
              ]),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
