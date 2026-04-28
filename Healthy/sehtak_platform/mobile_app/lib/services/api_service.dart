import 'package:dio/dio.dart';
import 'storage_service.dart';
import '../utils/constants.dart';

class ApiService {
  late final Dio _dio;
  final StorageService _storage;

  ApiService(this._storage) {
    _dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = _storage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          _storage.clearAll();
        }
        handler.next(error);
      },
    ));
  }

  // Auth
  Future<Response> login(String phone, String password) =>
    _dio.post(ApiEndpoints.login, data: {'phone': phone, 'password': password});

  Future<Response> register(Map<String, dynamic> data) =>
    _dio.post(ApiEndpoints.register, data: data);

  Future<Response> verifyOtp(String userId, String otp) =>
    _dio.post(ApiEndpoints.verifyOtp, data: {'user_id': userId, 'otp': otp});

  Future<Response> resendOtp(String userId) =>
    _dio.post(ApiEndpoints.resendOtp, data: {'user_id': userId});

  Future<Response> forgotPassword(String phone) =>
    _dio.post(ApiEndpoints.forgotPassword, data: {'phone': phone});

  Future<Response> logout() => _dio.post(ApiEndpoints.logout);

  // User
  Future<Response> getProfile() => _dio.get(ApiEndpoints.profile);
  Future<Response> updateProfile(Map<String, dynamic> data) => _dio.put(ApiEndpoints.profile, data: data);
  Future<Response> updateMedicalHistory(Map<String, dynamic> data) =>
    _dio.put(ApiEndpoints.medicalHistory, data: data);

  // Consultations
  Future<Response> startConsultation(Map<String, dynamic> data) =>
    _dio.post('${ApiEndpoints.consultations}/start', data: data);
  Future<Response> getConsultations() => _dio.get(ApiEndpoints.consultations);
  Future<Response> getConsultation(String id) => _dio.get('${ApiEndpoints.consultations}/$id');
  Future<Response> sendMessage(String id, String content) =>
    _dio.post('${ApiEndpoints.consultations}/$id/messages', data: {'content': content});
  Future<Response> endConsultation(String id) =>
    _dio.post('${ApiEndpoints.consultations}/$id/end');
  Future<Response> rateConsultation(String id, int rating, String? comment) =>
    _dio.post('${ApiEndpoints.consultations}/$id/rate', data: {'rating': rating, 'comment': comment});

  // Prescriptions
  Future<Response> getPrescription(String id) => _dio.get('${ApiEndpoints.prescriptions}/$id');
  Future<Response> getPrescriptionByConsultation(String consultationId) =>
    _dio.get('${ApiEndpoints.prescriptions}/consultation/$consultationId');

  // Orders
  Future<Response> createOrder(Map<String, dynamic> data) =>
    _dio.post('${ApiEndpoints.orders}/create', data: data);
  Future<Response> trackOrder(String id) => _dio.get('${ApiEndpoints.orders}/$id/track');
  Future<Response> updateOrderStatus(String id, String status) =>
    _dio.put('${ApiEndpoints.orders}/$id/status', data: {'status': status});
  Future<Response> getNearbyPharmacies(double lat, double lng, {double? radius}) =>
    _dio.get('${ApiEndpoints.orders}/pharmacies/nearby', queryParameters: {'lat': lat, 'lng': lng, 'radius': radius});

  // Payments
  Future<Response> initiatePayment(Map<String, dynamic> data) =>
    _dio.post('${ApiEndpoints.payments}/initiate', data: data);
  Future<Response> verifyPayment(String orderId) =>
    _dio.post('${ApiEndpoints.payments}/verify', data: {'order_id': orderId});
  Future<Response> getSubscriptionStatus() => _dio.get('${ApiEndpoints.payments}/subscription-status');
  Future<Response> subscribe(String planType, {int? durationMonths}) =>
    _dio.post('${ApiEndpoints.payments}/subscribe', data: {'plan_type': planType, 'duration_months': durationMonths});

  // Notifications
  Future<Response> getNotifications() => _dio.get('${ApiEndpoints.notifications}/user');
  Future<Response> markNotificationRead(String id) => _dio.put('${ApiEndpoints.notifications}/$id/read');

  // AI
  Future<Response> aiTriage(String symptoms, String? bodyPart) =>
    _dio.post(ApiEndpoints.aiTriage, data: {'symptoms': symptoms, 'body_part': bodyPart});
  Future<Response> aiChatbot(String message) =>
    _dio.post(ApiEndpoints.aiChatbot, data: {'message': message});
}
