class PrescriptionModel {
  final String id;
  final String consultationId;
  final String doctorId;
  final String patientId;
  final String diagnosis;
  final List<Medicine> medicines;
  final String instructions;
  final String? digitalSignature;
  final DateTime issuedAt;

  PrescriptionModel({
    required this.id,
    required this.consultationId,
    required this.doctorId,
    required this.patientId,
    required this.diagnosis,
    required this.medicines,
    required this.instructions,
    this.digitalSignature,
    required this.issuedAt,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) => PrescriptionModel(
    id: json['id'] ?? '',
    consultationId: json['consultation_id'] ?? '',
    doctorId: json['doctor_id'] ?? '',
    patientId: json['patient_id'] ?? '',
    diagnosis: json['diagnosis'] ?? '',
    medicines: (json['medicines'] as List? ?? []).map((m) => Medicine.fromJson(m)).toList(),
    instructions: json['instructions'] ?? '',
    digitalSignature: json['digital_signature'],
    issuedAt: DateTime.tryParse(json['issued_at'] ?? '') ?? DateTime.now(),
  );
}

class Medicine {
  final String name;
  final String dosage;
  final String frequency;
  final int durationDays;

  Medicine({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.durationDays,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) => Medicine(
    name: json['name'] ?? '',
    dosage: json['dosage'] ?? '',
    frequency: json['frequency'] ?? '',
    durationDays: json['duration_days'] ?? 7,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'dosage': dosage,
    'frequency': frequency,
    'duration_days': durationDays,
  };
}
