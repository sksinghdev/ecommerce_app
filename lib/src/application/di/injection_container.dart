

import 'package:common/common.dart';
import 'package:product_listing/data/repositories/product_repository_impl.dart';
import 'package:product_listing/domain/repository/product_repository.dart';
import 'package:common/data/repository/auth_repository.dart';
import 'package:common/presentation/bloc/auth_cubit.dart';
import 'package:common/presentation/bloc/network_cubit.dart';
import 'package:product_listing/presentation/bloc/product_cubit.dart';


final injector = GetIt.instance;

Future<void> init() async {
  injector.registerLazySingleton(() => FirebaseAuth.instance);
  injector.registerLazySingleton(() => GoogleSignIn());

  // Dio
  injector.registerLazySingleton<Dio>(() => DioClient().dio);
  injector.registerLazySingleton(() => Connectivity());
  injector.registerFactory(() => ConnectivityCubit(injector()));
  injector.registerLazySingleton(() => AuthRepository());
  injector.registerFactory(() => AuthCubit(injector()));
   // API Service
  injector.registerLazySingleton(() => ApiService(injector()));


  // Repositories
  injector.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(apiService: injector()),
  );
  injector.registerFactory(() => ProductCubit(repository:injector()));

 

}