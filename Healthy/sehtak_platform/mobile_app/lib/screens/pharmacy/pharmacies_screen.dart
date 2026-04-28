import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/constants.dart';

class PharmaciesScreen extends StatelessWidget {
  const PharmaciesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pharmacies = [
      {'name': 'صيدلية الشفاء', 'distance': '1.2 كم', 'rating': 4.8, 'time': '25 دقيقة'},
      {'name': 'صيدلية الصحة الوطنية', 'distance': '2.5 كم', 'rating': 4.5, 'time': '40 دقيقة'},
      {'name': 'صيدلية النور', 'distance': '0.8 كم', 'rating': 4.9, 'time': '15 دقيقة'},
      {'name': 'صيدلية الرحمة', 'distance': '3.1 كم', 'rating': 4.3, 'time': '50 دقيقة'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('الصيدليات القريبة')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pharmacies.length,
        itemBuilder: (context, i) {
          final p = pharmacies[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.local_pharmacy, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Row(children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      Text(' ${p['rating']}'),
                    ]),
                  ])),
                  Chip(label: Text(p['distance'] as String), backgroundColor: Colors.green.shade100),
                ]),
                const Divider(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('وقت التوصيل: ${p['time']}'),
                  ElevatedButton(
                    onPressed: () => context.push('/order-tracking/demo-order'),
                    child: const Text('اختيار'),
                  ),
                ]),
              ]),
            ),
          );
        },
      ),
    );
  }
}
