import 'package:common/common.dart';
import 'package:common/data/repository/auth_repository.dart';
import 'package:common/presentation/bloc/auth_cubit.dart';
import 'package:common/presentation/bloc/network_cubit.dart';
final sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton(() => Connectivity());
  sl.registerFactory(() => ConnectivityCubit(sl()));
  sl.registerLazySingleton(() => AuthRepository());
  sl.registerFactory(() => AuthCubit(sl()));
}
