import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/consultation/consultation_bloc.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ConsultationBloc>().add(LoadConsultationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _buildBody()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: AppStrings.home),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: AppStrings.consultations),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: AppStrings.orders),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: AppStrings.profile),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0: return _buildHomeTab();
      case 1: return _buildConsultationsTab();
      case 2: return _buildOrdersTab();
      case 3: return _buildProfileTab();
      default: return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          String name = '\u0645\u0633\u062a\u062e\u062f\u0645';
          if (state is Authenticated) name = state.user.fullName;
          return Row(children: [
            const CircleAvatar(radius: 24, backgroundColor: AppColors.primary, child: Icon(Icons.person, color: Colors.white)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('\u0645\u0631\u062d\u0628\u0627\u064b\u060c $name', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text('\u0643\u064a\u0641 \u062a\u0634\u0639\u0631 \u0627\u0644\u064a\u0648\u0645\u061f', style: TextStyle(color: AppColors.textSecondary)),
            ])),
            Stack(children: [
              IconButton(icon: const Icon(Icons.notifications, color: AppColors.textPrimary), onPressed: () {}),
              Positioned(top: 8, right: 8, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
            ]),
          ]);
        }),
        const SizedBox(height: 24),

        // AI Health Card
        Card(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.health_and_safety, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              const Expanded(child: Text('\u0645\u0644\u062e\u0635 \u0635\u062d\u062a\u0643 \u0627\u0644\u064a\u0648\u0645\u064a', style: TextStyle(fontWeight: FontWeight.w600))),
            ]),
            const SizedBox(height: 12),
            const Text('\u0627\u0634\u062a\u0631\u0643 8 \u0643\u0624\u0648\u0633 \u0645\u0646 \u0627\u0644\u0645\u0627\u0621\u060c \u0648\u0627\u0646\u0645 \u0628\u0634\u0643\u0644 \u0645\u0646\u062a\u0638\u0645. \u062a\u0630\u0643\u0631 \u0623\u0646 \u062a\u0623\u062e\u0630 \u062f\u0648\u0627\u0621\u0643 \u0628\u0627\u0646\u062a\u0638\u0627\u0645.', style: TextStyle(color: AppColors.textSecondary)),
          ]),
        )),
        const SizedBox(height: 24),

        // CTA Button
        ElevatedButton(
          onPressed: () => context.push('/symptoms'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 18)),
          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.chat_bubble), SizedBox(width: 8), Text('\u062a\u062d\u062f\u062b \u0645\u0639 \u0637\u0628\u064a\u0628 \u0627\u0644\u0622\u0646', style: TextStyle(fontSize: 18)),
          ]),
        ),
        const SizedBox(height: 24),

        // Quick Symptoms
        const Text('\u0627\u0644\u0623\u0639\u0631\u0627\u0636 \u0627\u0644\u0633\u0631\u064a\u0639\u0629', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(height: 90, child: ListView(scrollDirection: Axis.horizontal, children: [
          _symptomChip('\u0635\u062f\u0627\u0639', Icons.sentiment_dissatisfied, Colors.orange),
          _symptomChip('\u062d\u0631\u0627\u0631\u0629', Icons.thermostat, Colors.red),
          _symptomChip('\u0623\u0644\u0645 \u0628\u0637\u0646', Icons.sick, Colors.teal),
          _symptomChip('\u0633\u0639\u0627\u0644', Icons.air, Colors.blue),
          _symptomChip('\u0623\u0644\u0645 \u0645\u0641\u0627\u0635\u0644', Icons.accessibility_new, Colors.purple),
        ])),
        const SizedBox(height: 24),

        // Recent Consultations
        const Text('\u0627\u0644\u0627\u0633\u062a\u0634\u0627\u0631\u0627\u062a \u0627\u0644\u062d\u062f\u064a\u062b\u0629', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        BlocBuilder<ConsultationBloc, ConsultationState>(builder: (context, state) {
          if (state is ConsultationsLoaded && state.consultations.isNotEmpty) {
            return Column(children: state.consultations.take(3).map((c) =>
              ListTile(
                leading: CircleAvatar(backgroundColor: c.status == 'completed' ? AppColors.success : AppColors.primary, child: const Icon(Icons.chat, color: Colors.white, size: 16)),
                title: Text('\u0627\u0633\u062a\u0634\u0627\u0631\u0629 \u0645\u0639 \u062f. ${c.doctorName ?? '\u063a\u064a\u0631 \u0645\u0639\u0631\u0641'}'),
                subtitle: Text(c.symptoms.substring(0, c.symptoms.length > 30 ? 30 : c.symptoms.length) + '...'),
                trailing: Text(c.status, style: TextStyle(color: c.status == 'completed' ? AppColors.success : AppColors.warning)),
                onTap: () => context.push('/consultation/${c.id}'),
              ),
            ).toList());
          }
          return const Card(child: ListTile(leading: Icon(Icons.info), title: Text('\u0644\u0627 \u062a\u0648\u062c\u062f \u0627\u0633\u062a\u0634\u0627\u0631\u0627\u062a \u0633\u0627\u0628\u0642\u0629'), subtitle: Text('\u0627\u0628\u062f\u0623 \u0627\u0633\u062a\u0634\u0627\u0631\u062a\u0643 \u0627\u0644\u0623\u0648\u0644\u0649 \u0627\u0644\u0622\u0646!')));
        }),
      ]),
    );
  }

  Widget _symptomChip(String label, IconData icon, Color color) => GestureDetector(
    onTap: () => context.push('/symptoms'),
    child: Container(width: 70, margin: const EdgeInsets.only(right: 12),
      child: Column(children: [
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
      ]),
    ),
  );

  Widget _buildConsultationsTab() => BlocBuilder<ConsultationBloc, ConsultationState>(
    builder: (context, state) {
      if (state is ConsultationsLoaded) {
        return ListView.builder(
          itemCount: state.consultations.length,
          itemBuilder: (context, i) {
            final c = state.consultations[i];
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.chat)),
              title: Text('\u0627\u0633\u062a\u0634\u0627\u0631\u0629 \u0645\u0639 \u062f. ${c.doctorName ?? ''}'),
              subtitle: Text(c.createdAt.toString().substring(0, 16)),
              trailing: Chip(label: Text(c.status), backgroundColor: c.status == 'completed' ? Colors.green.shade100 : Colors.orange.shade100),
              onTap: () => context.push('/consultation/${c.id}'),
            );
          },
        );
      }
      return const Center(child: CircularProgressIndicator());
    },
  );

  Widget _buildOrdersTab() => const Center(child: Text('\u0627\u0644\u0637\u0644\u0628\u0627\u062a', style: TextStyle(fontSize: 18)));

  Widget _buildProfileTab() => Column(children: [
    ListTile(leading: const Icon(Icons.person), title: const Text('\u0627\u0644\u0645\u0644\u0641 \u0627\u0644\u0634\u062e\u0635\u064a'), onTap: () => context.push('/profile')),
    ListTile(leading: const Icon(Icons.subscriptions), title: const Text('\u0627\u0644\u0627\u0634\u062a\u0631\u0627\u0643'), onTap: () => context.push('/subscription')),
    ListTile(leading: const Icon(Icons.history), title: const Text('\u0633\u062c\u0644 \u0627\u0644\u0627\u0633\u062a\u0634\u0627\u0631\u0627\u062a'), onTap: () => context.push('/consultation-history')),
    ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text(AppStrings.logout, style: TextStyle(color: Colors.red)),
      onTap: () => context.read<AuthBloc>().add(LogoutEvent()),
    ),
  ]);
}
