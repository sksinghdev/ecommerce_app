import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/service/network_service.dart';
  
abstract class NetworkState {}
class NetworkInitial extends NetworkState {}
class NetworkConnected extends NetworkState {}
class NetworkDisconnected extends NetworkState {}

class NetworkCubit extends Cubit<NetworkState> {
  final NetworkService _service;
  NetworkCubit(this._service) : super(NetworkInitial());

  Future<void> checkConnection() async {
    final isConnected = await _service.hasConnection();
    if (isConnected) {
      emit(NetworkConnected());
    } else {
      emit(NetworkDisconnected());
    }
  }
}
