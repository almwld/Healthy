class ConsultationModel {
  final String id;
  final String? patientId;
  final String? doctorId;
  final String symptoms;
  final String? bodyPart;
  final String? preferredType;
  final String status;
  final Map<String, dynamic>? aiTriageResult;
  final String urgencyLevel;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final DateTime createdAt;
  final String? doctorName;
  final String? patientName;
  final int? rating;
  final String? ratingComment;

  ConsultationModel({
    required this.id,
    this.patientId,
    this.doctorId,
    required this.symptoms,
    this.bodyPart,
    this.preferredType,
    required this.status,
    this.aiTriageResult,
    required this.urgencyLevel,
    this.startedAt,
    this.endedAt,
    required this.createdAt,
    this.doctorName,
    this.patientName,
    this.rating,
    this.ratingComment,
  });

  factory ConsultationModel.fromJson(Map<String, dynamic> json) => ConsultationModel(
    id: json['id'] ?? '',
    patientId: json['patient_id'],
    doctorId: json['doctor_id'],
    symptoms: json['symptoms'] ?? '',
    bodyPart: json['body_part'],
    preferredType: json['preferred_type'],
    status: json['status'] ?? 'pending',
    aiTriageResult: json['ai_triage_result'],
    urgencyLevel: json['urgency_level'] ?? 'low',
    startedAt: json['started_at'] != null ? DateTime.tryParse(json['started_at']) : null,
    endedAt: json['ended_at'] != null ? DateTime.tryParse(json['ended_at']) : null,
    createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    doctorName: json['doctor_name'],
    patientName: json['patient_name'],
    rating: json['rating'],
    ratingComment: json['rating_comment'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'patient_id': patientId,
    'doctor_id': doctorId,
    'symptoms': symptoms,
    'body_part': bodyPart,
    'preferred_type': preferredType,
    'status': status,
    'ai_triage_result': aiTriageResult,
    'urgency_level': urgencyLevel,
    'created_at': createdAt.toIso8601String(),
  };
}

class MessageModel {
  final String id;
  final String consultationId;
  final String senderId;
  final String senderType;
  final String content;
  final String? attachmentUrl;
  final DateTime sentAt;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.consultationId,
    required this.senderId,
    required this.senderType,
    required this.content,
    this.attachmentUrl,
    required this.sentAt,
    required this.isRead,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json['id'] ?? '',
    consultationId: json['consultation_id'] ?? '',
    senderId: json['sender_id'] ?? '',
    senderType: json['sender_type'] ?? '',
    content: json['content'] ?? '',
    attachmentUrl: json['attachment_url'],
    sentAt: DateTime.tryParse(json['sent_at'] ?? '') ?? DateTime.now(),
    isRead: json['is_read'] ?? false,
  );
}
