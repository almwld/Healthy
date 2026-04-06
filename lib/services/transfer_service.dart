class TransferService {
  Future<bool> transfer({
    required String fromWallet,
    required String toWallet,
    required double amount,
    required String pin,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
