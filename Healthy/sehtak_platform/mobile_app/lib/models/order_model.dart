class OrderModel {
  final String id;
  final String? prescriptionId;
  final String? pharmacyId;
  final String patientAddress;
  final double deliveryFee;
  final double totalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final String? deliveryPersonName;
  final String? deliveryPersonPhone;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    this.prescriptionId,
    this.pharmacyId,
    required this.patientAddress,
    required this.deliveryFee,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    this.deliveryPersonName,
    this.deliveryPersonPhone,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['id'] ?? '',
    prescriptionId: json['prescription_id'],
    pharmacyId: json['pharmacy_id'],
    patientAddress: json['patient_address'] ?? '',
    deliveryFee: double.tryParse(json['delivery_fee']?.toString() ?? '0') ?? 0,
    totalAmount: double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0,
    paymentMethod: json['payment_method'] ?? 'cash',
    paymentStatus: json['payment_status'] ?? 'pending',
    orderStatus: json['order_status'] ?? 'ordered',
    deliveryPersonName: json['delivery_person_name'],
    deliveryPersonPhone: json['delivery_person_phone'],
    createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
  );
}

class PharmacyModel {
  final String id;
  final String pharmacyName;
  final String address;
  final double? distance;
  final double ratingAvg;
  final bool isOpen;

  PharmacyModel({
    required this.id,
    required this.pharmacyName,
    required this.address,
    this.distance,
    required this.ratingAvg,
    required this.isOpen,
  });

  factory PharmacyModel.fromJson(Map<String, dynamic> json) => PharmacyModel(
    id: json['id'] ?? '',
    pharmacyName: json['pharmacy_name'] ?? '',
    address: json['address'] ?? '',
    distance: json['distance'] != null ? double.tryParse(json['distance'].toString()) : null,
    ratingAvg: double.tryParse(json['rating_avg']?.toString() ?? '5') ?? 5,
    isOpen: json['is_open'] ?? true,
  );
}
