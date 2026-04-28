import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  const OrderTrackingScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'title': 'تم الشراء', 'done': true, 'time': '10:00 ص'},
      {'title': 'تم التجهيز', 'done': true, 'time': '10:15 ص'},
      {'title': 'في الطريق', 'done': true, 'time': '10:35 ص'},
      {'title': 'قريب منك', 'done': false, 'time': ''},
      {'title': 'تم التسليم', 'done': false, 'time': ''},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('تتبع الطلب')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Map placeholder
          Container(height: 200, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(16)),
            child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.map, size: 48, color: AppColors.textSecondary),
              const SizedBox(height: 8),
              Text('خريطة التتبع', style: TextStyle(color: Colors.grey.shade600)),
            ])),
          ),
          const SizedBox(height: 24),
          // Progress
          const Text('حالة الطلب', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...steps.asMap().entries.map((entry) {
            final i = entry.key;
            final step = entry.value;
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(children: [
                Container(width: 32, height: 32, decoration: BoxDecoration(
                  color: step['done'] == true ? AppColors.success : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ), child: Icon(step['done'] == true ? Icons.check : Icons.circle, size: 16, color: Colors.white)),
                if (i < steps.length - 1) Container(width: 2, height: 40, color: step['done'] == true ? AppColors.success : Colors.grey.shade300),
              ]),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(step['title'] as String, style: TextStyle(fontWeight: step['done'] == true ? FontWeight.bold : FontWeight.normal)),
                if ((step['time'] as String).isNotEmpty) Text(step['time'] as String, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ])),
            ]);
          }).toList(),
          const SizedBox(height: 24),
          // Delivery person
          Card(child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.delivery_dining)),
            title: const Text('سالم العتيبي'),
            subtitle: const Text('مندوب التوصيل'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: const Icon(Icons.phone, color: AppColors.primary), onPressed: () {}),
              IconButton(icon: const Icon(Icons.message, color: AppColors.primary), onPressed: () {}),
            ]),
          )),
          const SizedBox(height: 16),
          const Text('الوقت المتوقع للوصول: 10 دقائق', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: () {}, child: const Text('تأكيد الاستلام')),
        ]),
      ),
    );
  }
}
