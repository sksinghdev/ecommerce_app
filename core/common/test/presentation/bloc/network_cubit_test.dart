import 'dart:async';
import 'package:common/presentation/bloc/network_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late MockConnectivity mockConnectivity;
  late StreamController<ConnectivityResult> connectivityStreamController;

  setUpAll(() {
    registerFallbackValue(ConnectivityResult.wifi);
  });

  setUp(() {
    mockConnectivity = MockConnectivity();
    connectivityStreamController =
        StreamController<ConnectivityResult>.broadcast();

    when(() => mockConnectivity.onConnectivityChanged)
        .thenAnswer((_) => connectivityStreamController.stream.map((e) => [e]));
  });

  tearDown(() async {
    await connectivityStreamController.close();
  });

  blocTest<ConnectivityCubit, NetworkStatus>(
    'emits [connected] when checkConnectivity returns wifi',
    build: () {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      return ConnectivityCubit(mockConnectivity);
    },
    expect: () => [NetworkStatus.connected],
  );

  blocTest<ConnectivityCubit, NetworkStatus>(
    'emits [disconnected] when checkConnectivity returns none',
    build: () {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);

      return ConnectivityCubit(mockConnectivity);
    },
    expect: () => [NetworkStatus.disconnected],
  );

 blocTest<ConnectivityCubit, NetworkStatus>(
  'emits [connected, disconnected] on stream change (no duplicate connected)',
  build: () {
    when(() => mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.wifi]);

    when(() => mockConnectivity.onConnectivityChanged)
        .thenAnswer((_) => connectivityStreamController.stream.map((e) => [e]));

    return ConnectivityCubit(mockConnectivity);
  },
  act: (cubit) async {
    connectivityStreamController.add(ConnectivityResult.none);   // disconnected
  },
  expect: () => [
    NetworkStatus.connected,       // initial
    NetworkStatus.disconnected,    // from stream
  ],
);


}
