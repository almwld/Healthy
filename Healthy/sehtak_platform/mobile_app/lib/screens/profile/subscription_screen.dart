import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/subscription/subscription_bloc.dart';
import '../../utils/constants.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final plans = [
      {'name': 'الأساسية', 'price': '49', 'features': ['5 استشارات شهرية', 'دعم نصي فقط', 'رد خلال 24 ساعة'], 'color': Colors.blue},
      {'name': 'الممتازة', 'price': '99', 'features': ['استشارات غير محدودة', 'مكالمات صوتية وفيديو', 'توصيل مجاني للعلاج'], 'color': AppColors.primary, 'popular': true},
      {'name': 'العائلية', 'price': '189', 'features': ['6 أفراد', 'نفس مواصفات الممتازة', 'متابعة أطفال'], 'color': Colors.orange},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('الباقات والاشتراكات')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plans.length,
        itemBuilder: (context, i) {
          final plan = plans[i];
          final isPopular = plan['popular'] == true;
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isPopular ? AppColors.primary : AppColors.divider, width: isPopular ? 2 : 1),
            ),
            child: Column(children: [
              if (isPopular) Container(
                width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: const BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
                child: const Text('الأكثر مبيعاً', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  Text(plan['name'] as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(plan['price'] as String, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const Text(' ريال/شهر', style: TextStyle(color: AppColors.textSecondary)),
                  ]),
                  const SizedBox(height: 16),
                  ...(plan['features'] as List<String>).map((f) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(children: [const Icon(Icons.check_circle, color: AppColors.success, size: 18), const SizedBox(width: 8), Text(f)]),
                  )),
                  const SizedBox(height: 20),
                  BlocBuilder<SubscriptionBloc, SubscriptionState>(builder: (context, state) =>
                    state is SubscriptionLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => context.read<SubscriptionBloc>().add(SubscribeEvent(plan['name'] == 'الأساسية' ? 'basic' : plan['name'] == 'الممتازة' ? 'premium' : 'family')),
                          style: ElevatedButton.styleFrom(backgroundColor: isPopular ? AppColors.primary : Colors.grey.shade700),
                          child: const Text('اشترك الآن'),
                        ),
                  ),
                ]),
              ),
            ]),
          );
        },
      ),
    );
  }
}
