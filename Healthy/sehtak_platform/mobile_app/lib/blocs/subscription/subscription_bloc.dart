import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';

abstract class SubscriptionEvent {}
class LoadSubscriptionEvent extends SubscriptionEvent {}
class SubscribeEvent extends SubscriptionEvent { final String planType; final int? durationMonths; SubscribeEvent(this.planType, {this.durationMonths}); }

abstract class SubscriptionState {}
class SubscriptionInitial extends SubscriptionState {}
class SubscriptionLoading extends SubscriptionState {}
class SubscriptionLoaded extends SubscriptionState { final Map<String, dynamic>? subscription; SubscriptionLoaded(this.subscription); }
class SubscribedSuccess extends SubscriptionState {}
class SubscriptionError extends SubscriptionState { final String message; SubscriptionError(this.message); }

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final ApiService _api;
  SubscriptionBloc(this._api) : super(SubscriptionInitial()) {
    on<LoadSubscriptionEvent>(_onLoad);
    on<SubscribeEvent>(_onSubscribe);
  }

  Future<void> _onLoad(LoadSubscriptionEvent e, Emitter<SubscriptionState> emit) async {
    emit(SubscriptionLoading());
    try {
      final res = await _api.getSubscriptionStatus();
      if (res.data['success'] == true) { emit(SubscriptionLoaded(res.data['data'])); }
      else { emit(SubscriptionError(res.data['message'])); }
    } catch (err) { emit(SubscriptionError(err.toString())); }
  }

  Future<void> _onSubscribe(SubscribeEvent e, Emitter<SubscriptionState> emit) async {
    emit(SubscriptionLoading());
    try {
      final res = await _api.subscribe(e.planType, durationMonths: e.durationMonths);
      if (res.data['success'] == true) { emit(SubscribedSuccess()); }
      else { emit(SubscriptionError(res.data['message'])); }
    } catch (err) { emit(SubscriptionError(err.toString())); }
  }
}
