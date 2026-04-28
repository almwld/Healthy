import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../../models/user_model.dart';

abstract class AuthEvent {}
class LoginEvent extends AuthEvent { final String phone; final String password; LoginEvent(this.phone, this.password); }
class RegisterEvent extends AuthEvent { final Map<String, dynamic> data; RegisterEvent(this.data); }
class VerifyOtpEvent extends AuthEvent { final String userId; final String otp; VerifyOtpEvent(this.userId, this.otp); }
class ResendOtpEvent extends AuthEvent { final String userId; ResendOtpEvent(this.userId); }
class LogoutEvent extends AuthEvent {}
class CheckAuthEvent extends AuthEvent {}
class CompleteProfileEvent extends AuthEvent { final Map<String, dynamic> data; CompleteProfileEvent(this.data); }

abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class Authenticated extends AuthState { final UserModel user; final String token; Authenticated(this.user, this.token); }
class OtpRequired extends AuthState { final String userId; OtpRequired(this.userId); }
class ProfileIncomplete extends AuthState { final String userId; ProfileIncomplete(this.userId); }
class AuthError extends AuthState { final String message; AuthError(this.message); }
class Unauthenticated extends AuthState {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService _api;
  final StorageService _storage;

  AuthBloc(this._api, this._storage) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResendOtpEvent>(_onResendOtp);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthEvent>(_onCheckAuth);
    on<CompleteProfileEvent>(_onCompleteProfile);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await _api.login(event.phone, event.password);
      if (res.data['success'] == true) {
        final token = res.data['data']['token'];
        final user = UserModel.fromJson(res.data['data']['user']);
        await _storage.saveToken(token);
        await _storage.saveUserData(user.toJson().toString());
        emit(Authenticated(user, token));
      } else { emit(AuthError(res.data['message'] ?? 'Login failed')); }
    } catch (e) { emit(AuthError(e.toString())); }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await _api.register(event.data);
      if (res.data['success'] == true) {
        emit(OtpRequired(res.data['data']['user_id']));
      } else { emit(AuthError(res.data['message'] ?? 'Registration failed')); }
    } catch (e) { emit(AuthError(e.toString())); }
  }

  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await _api.verifyOtp(event.userId, event.otp);
      if (res.data['success'] == true) {
        final token = res.data['data']['token'];
        await _storage.saveToken(token);
        emit(ProfileIncomplete(event.userId));
      } else { emit(AuthError(res.data['message'] ?? 'OTP verification failed')); }
    } catch (e) { emit(AuthError(e.toString())); }
  }

  Future<void> _onResendOtp(ResendOtpEvent event, Emitter<AuthState> emit) async {
    try { await _api.resendOtp(event.userId); } catch (e) { emit(AuthError(e.toString())); }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    try { await _api.logout(); } catch (_) {}
    await _storage.clearAll();
    emit(Unauthenticated());
  }

  Future<void> _onCheckAuth(CheckAuthEvent event, Emitter<AuthState> emit) async {
    final token = _storage.getToken();
    if (token == null) { emit(Unauthenticated()); return; }
    try {
      final res = await _api.getProfile();
      if (res.data['success'] == true) {
        final user = UserModel.fromJson(res.data['data']);
        emit(Authenticated(user, token));
      } else { emit(Unauthenticated()); }
    } catch (_) { emit(Unauthenticated()); }
  }

  Future<void> _onCompleteProfile(CompleteProfileEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await _api.updateProfile(event.data);
      if (res.data['success'] == true) {
        final token = _storage.getToken() ?? '';
        final user = UserModel.fromJson(res.data['data']);
        emit(Authenticated(user, token));
      } else { emit(AuthError(res.data['message'] ?? 'Failed')); }
    } catch (e) { emit(AuthError(e.toString())); }
  }
}
