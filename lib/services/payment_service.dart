import '../models/payment_model.dart';

class PaymentService {
  Future<PaymentModel?> processPayment({
    required double amount,
    required String method,
    required String walletId,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return PaymentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      status: 'completed',
    );
  }
}
