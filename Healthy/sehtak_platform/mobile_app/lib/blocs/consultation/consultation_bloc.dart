import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import '../../models/consultation_model.dart';

abstract class ConsultationEvent {}
class StartConsultationEvent extends ConsultationEvent { final String symptoms; final String? bodyPart; final String preferredType; StartConsultationEvent(this.symptoms, this.bodyPart, this.preferredType); }
class LoadConsultationsEvent extends ConsultationEvent {}
class LoadConsultationDetailEvent extends ConsultationEvent { final String id; LoadConsultationDetailEvent(this.id); }
class SendMessageEvent extends ConsultationEvent { final String id; final String content; SendMessageEvent(this.id, this.content); }
class EndConsultationEvent extends ConsultationEvent { final String id; EndConsultationEvent(this.id); }
class RateConsultationEvent extends ConsultationEvent { final String id; final int rating; final String? comment; RateConsultationEvent(this.id, this.rating, this.comment); }

abstract class ConsultationState {}
class ConsultationInitial extends ConsultationState {}
class ConsultationLoading extends ConsultationState {}
class ConsultationStarted extends ConsultationState { final ConsultationModel consultation; ConsultationStarted(this.consultation); }
class ConsultationsLoaded extends ConsultationState { final List<ConsultationModel> consultations; ConsultationsLoaded(this.consultations); }
class ConsultationDetailLoaded extends ConsultationState { final ConsultationModel consultation; final List<MessageModel> messages; ConsultationDetailLoaded(this.consultation, this.messages); }
class MessageSent extends ConsultationState { final MessageModel message; MessageSent(this.message); }
class ConsultationEnded extends ConsultationState {}
class ConsultationRated extends ConsultationState {}
class ConsultationError extends ConsultationState { final String message; ConsultationError(this.message); }

class ConsultationBloc extends Bloc<ConsultationEvent, ConsultationState> {
  final ApiService _api;
  ConsultationBloc(this._api) : super(ConsultationInitial()) {
    on<StartConsultationEvent>(_onStart);
    on<LoadConsultationsEvent>(_onLoad);
    on<LoadConsultationDetailEvent>(_onLoadDetail);
    on<SendMessageEvent>(_onSendMessage);
    on<EndConsultationEvent>(_onEnd);
    on<RateConsultationEvent>(_onRate);
  }

  Future<void> _onStart(StartConsultationEvent e, Emitter<ConsultationState> emit) async {
    emit(ConsultationLoading());
    try {
      final res = await _api.startConsultation({'symptoms': e.symptoms, 'body_part': e.bodyPart, 'preferred_type': e.preferredType});
      if (res.data['success'] == true) {
        emit(ConsultationStarted(ConsultationModel.fromJson(res.data['data'])));
      } else { emit(ConsultationError(res.data['message'])); }
    } catch (err) { emit(ConsultationError(err.toString())); }
  }

  Future<void> _onLoad(LoadConsultationsEvent e, Emitter<ConsultationState> emit) async {
    emit(ConsultationLoading());
    try {
      final res = await _api.getConsultations();
      if (res.data['success'] == true) {
        final list = (res.data['data'] as List).map((c) => ConsultationModel.fromJson(c)).toList();
        emit(ConsultationsLoaded(list));
      } else { emit(ConsultationError(res.data['message'])); }
    } catch (err) { emit(ConsultationError(err.toString())); }
  }

  Future<void> _onLoadDetail(LoadConsultationDetailEvent e, Emitter<ConsultationState> emit) async {
    emit(ConsultationLoading());
    try {
      final res = await _api.getConsultation(e.id);
      if (res.data['success'] == true) {
        final data = res.data['data'];
        final consultation = ConsultationModel.fromJson(data);
        final messages = (data['messages'] as List? ?? []).map((m) => MessageModel.fromJson(m)).toList();
        emit(ConsultationDetailLoaded(consultation, messages));
      } else { emit(ConsultationError(res.data['message'])); }
    } catch (err) { emit(ConsultationError(err.toString())); }
  }

  Future<void> _onSendMessage(SendMessageEvent e, Emitter<ConsultationState> emit) async {
    try {
      final res = await _api.sendMessage(e.id, e.content);
      if (res.data['success'] == true) {
        emit(MessageSent(MessageModel.fromJson(res.data['data'])));
      }
    } catch (err) { emit(ConsultationError(err.toString())); }
  }

  Future<void> _onEnd(EndConsultationEvent e, Emitter<ConsultationState> emit) async {
    try {
      await _api.endConsultation(e.id);
      emit(ConsultationEnded());
    } catch (err) { emit(ConsultationError(err.toString())); }
  }

  Future<void> _onRate(RateConsultationEvent e, Emitter<ConsultationState> emit) async {
    try {
      await _api.rateConsultation(e.id, e.rating, e.comment);
      emit(ConsultationRated());
    } catch (err) { emit(ConsultationError(err.toString())); }
  }
}
