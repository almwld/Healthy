import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة تحكم الطبيب')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Stats
          Row(children: [
            _statCard('استشارات اليوم', '5', Icons.today, AppColors.primary),
            const SizedBox(width: 12),
            _statCard('النشطة', '2', Icons.chat_bubble, AppColors.success),
            const SizedBox(width: 12),
            _statCard('الإيرادات', '540', Icons.attach_money, AppColors.secondary),
          ]),
          const SizedBox(height: 24),
          // Availability
          const Text('حالتك', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(children: [
            _statusButton('متاح', Colors.green, () {}),
            const SizedBox(width: 8),
            _statusButton('مشغول', Colors.orange, () {}),
            const SizedBox(width: 8),
            _statusButton('خارج الخدمة', Colors.red, () {}),
          ]),
          const SizedBox(height: 24),
          // Pending cases
          const Text('حالات في الانتظار', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text('أحمد السلمان'),
            subtitle: const Text('صداع مستمر منذ يومين مع دوار'),
            trailing: ElevatedButton(onPressed: () {}, child: const Text('قبول')),
          )),
          Card(child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text('فاطمة الرحبي'),
            subtitle: const Text('ألم في البطن وغثيان'),
            trailing: ElevatedButton(onPressed: () {}, child: const Text('قبول')),
          )),
          const SizedBox(height: 24),
          // Active cases
          const Text('حالات نشطة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Card(child: ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.chat, color: Colors.white)),
            title: const Text('محمد الدوسري'),
            subtitle: const Text('استشارة نصية - 5 دقائق'),
            trailing: const Chip(label: Text('نشطة'), backgroundColor: Colors.green),
          )),
        ]),
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color), const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ]),
    ),
  );

  Widget _statusButton(String label, Color color, VoidCallback onTap) => Expanded(
    child: ElevatedButton(
      onPressed: onTap, style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(label),
    ),
  );
}
