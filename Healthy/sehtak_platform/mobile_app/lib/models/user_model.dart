class UserModel {
  final String id;
  final String fullName;
  final String phone;
  final String? email;
  final String userType;
  final String? avatar;
  final bool isVerified;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
    required this.userType,
    this.avatar,
    required this.isVerified,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? '',
    fullName: json['full_name'] ?? '',
    phone: json['phone'] ?? '',
    email: json['email'],
    userType: json['user_type'] ?? 'patient',
    avatar: json['avatar'],
    isVerified: json['is_verified'] ?? false,
    createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'phone': phone,
    'email': email,
    'user_type': userType,
    'avatar': avatar,
    'is_verified': isVerified,
    'created_at': createdAt.toIso8601String(),
  };
}

class MedicalInfo {
  final String? dob;
  final String? gender;
  final String? bloodType;
  final List<String> chronicDiseases;
  final List<String> allergies;
  final List<String> currentMedications;

  MedicalInfo({
    this.dob,
    this.gender,
    this.bloodType,
    this.chronicDiseases = const [],
    this.allergies = const [],
    this.currentMedications = const [],
  });

  factory MedicalInfo.fromJson(Map<String, dynamic> json) => MedicalInfo(
    dob: json['dob'],
    gender: json['gender'],
    bloodType: json['blood_type'],
    chronicDiseases: List<String>.from(json['chronic_diseases'] ?? []),
    allergies: List<String>.from(json['allergies'] ?? []),
    currentMedications: List<String>.from(json['current_medications'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'dob': dob,
    'gender': gender,
    'blood_type': bloodType,
    'chronic_diseases': chronicDiseases,
    'allergies': allergies,
    'current_medications': currentMedications,
  };
}
