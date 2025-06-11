import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

    

enum NetworkStatus { connected, disconnected }

class ConnectivityCubit extends Cubit<NetworkStatus> {
  final Connectivity _connectivity;

  ConnectivityCubit(this._connectivity) : super(NetworkStatus.connected) {
    _initConnectivity();
    _connectivity.onConnectivityChanged.listen((result) {
      _emitStatus(result);
    });
  }

  void _initConnectivity() async {
final result = await _connectivity.checkConnectivity();
    _emitStatus(result);
  }

  void _emitStatus(List<ConnectivityResult>  result) {
    
    if (result.contains(ConnectivityResult.none) || result.contains(ConnectivityResult.bluetooth)) {
      emit(NetworkStatus.disconnected);
    } else {
      emit(NetworkStatus.connected);
    }
  }
}
