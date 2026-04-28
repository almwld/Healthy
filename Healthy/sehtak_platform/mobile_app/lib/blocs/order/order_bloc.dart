import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import '../../models/order_model.dart';

abstract class OrderEvent {}
class CreateOrderEvent extends OrderEvent { final Map<String, dynamic> data; CreateOrderEvent(this.data); }
class TrackOrderEvent extends OrderEvent { final String orderId; TrackOrderEvent(this.orderId); }
class LoadNearbyPharmaciesEvent extends OrderEvent { final double lat; final double lng; LoadNearbyPharmaciesEvent(this.lat, this.lng); }
class UpdateOrderStatusEvent extends OrderEvent { final String orderId; final String status; UpdateOrderStatusEvent(this.orderId, this.status); }

abstract class OrderState {}
class OrderInitial extends OrderState {}
class OrderLoading extends OrderState {}
class OrderCreated extends OrderState { final OrderModel order; OrderCreated(this.order); }
class OrderTracked extends OrderState { final OrderModel order; OrderTracked(this.order); }
class PharmaciesLoaded extends OrderState { final List<PharmacyModel> pharmacies; PharmaciesLoaded(this.pharmacies); }
class OrderStatusUpdated extends OrderState {}
class OrderError extends OrderState { final String message; OrderError(this.message); }

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final ApiService _api;
  OrderBloc(this._api) : super(OrderInitial()) {
    on<CreateOrderEvent>(_onCreate);
    on<TrackOrderEvent>(_onTrack);
    on<LoadNearbyPharmaciesEvent>(_onLoadPharmacies);
    on<UpdateOrderStatusEvent>(_onUpdateStatus);
  }

  Future<void> _onCreate(CreateOrderEvent e, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final res = await _api.createOrder(e.data);
      if (res.data['success'] == true) { emit(OrderCreated(OrderModel.fromJson(res.data['data']))); }
      else { emit(OrderError(res.data['message'])); }
    } catch (err) { emit(OrderError(err.toString())); }
  }

  Future<void> _onTrack(TrackOrderEvent e, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final res = await _api.trackOrder(e.orderId);
      if (res.data['success'] == true) { emit(OrderTracked(OrderModel.fromJson(res.data['data']))); }
      else { emit(OrderError(res.data['message'])); }
    } catch (err) { emit(OrderError(err.toString())); }
  }

  Future<void> _onLoadPharmacies(LoadNearbyPharmaciesEvent e, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final res = await _api.getNearbyPharmacies(e.lat, e.lng);
      if (res.data['success'] == true) {
        final list = (res.data['data'] as List).map((p) => PharmacyModel.fromJson(p)).toList();
        emit(PharmaciesLoaded(list));
      } else { emit(OrderError(res.data['message'])); }
    } catch (err) { emit(OrderError(err.toString())); }
  }

  Future<void> _onUpdateStatus(UpdateOrderStatusEvent e, Emitter<OrderState> emit) async {
    try {
      await _api.updateOrderStatus(e.orderId, e.status);
      emit(OrderStatusUpdated());
    } catch (err) { emit(OrderError(err.toString())); }
  }
}
