import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/consultation/consultation_bloc.dart';
import '../../utils/constants.dart';

class ConsultationHistoryScreen extends StatelessWidget {
  const ConsultationHistoryScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سجل الاستشارات')),
      body: BlocBuilder<ConsultationBloc, ConsultationState>(
        builder: (context, state) {
          if (state is ConsultationsLoaded) {
            if (state.consultations.isEmpty) {
              return const Center(child: Text('لا توجد استشارات سابقة'));
            }
            return ListView.builder(
              itemCount: state.consultations.length,
              itemBuilder: (context, i) {
                final c = state.consultations[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: c.status == 'completed' ? AppColors.success : c.status == 'cancelled' ? AppColors.error : AppColors.primary,
                      child: Icon(c.status == 'completed' ? Icons.check : c.status == 'cancelled' ? Icons.close : Icons.chat, color: Colors.white),
                    ),
                    title: Text('استشارة ${c.doctorName != null ? 'مع د. ${c.doctorName}' : 'جديدة'}'),
                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(c.symptoms.length > 40 ? '${c.symptoms.substring(0, 40)}...' : c.symptoms),
                      Text(c.createdAt.toString().substring(0, 16), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ]),
                    trailing: Chip(
                      label: Text(c.status, style: const TextStyle(fontSize: 12)),
                      backgroundColor: c.status == 'completed' ? Colors.green.shade100 : c.status == 'active' ? Colors.blue.shade100 : Colors.grey.shade200,
                    ),
                    onTap: () => context.push('/consultation/${c.id}'),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
