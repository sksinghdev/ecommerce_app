

import 'package:cart_detail/data/order_repository.dart';
import 'package:cart_detail/data/payment_repository.dart';
import 'package:cart_detail/presentation/block/order_cubit.dart';
import 'package:cart_detail/presentation/block/product_list_cubit.dart';
import 'package:common/common.dart';
import 'package:flutter/services.dart';
import 'package:product_listing/data/repositories/product_repository_impl.dart';
import 'package:product_listing/domain/repository/product_repository.dart';
import 'package:common/data/repository/auth_repository.dart';
import 'package:common/presentation/bloc/auth_cubit.dart';
import 'package:common/presentation/bloc/network_cubit.dart';
import 'package:product_listing/presentation/bloc/product_cubit.dart';
 import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
final injector = GetIt.instance;

Future<void> init() async {

  await dotenv.load(fileName: "assets/.env");

   final stripeKey = dotenv.maybeGet('STRIPE_PUBLISHABLE_KEY');
  if (stripeKey == null || stripeKey.isEmpty) {
     throw Exception('STRIPE_PUBLISHABLE_KEY not found');
  }
   
   Stripe.publishableKey = stripeKey;

   try {
  await Stripe.instance.applySettings();
  print('Stripe settings applied successfully!');
} on PlatformException catch (e) {
  print('Platform Exception during Stripe initialization: ${e.message}');
  print('Details: ${e.details}');
} catch (e) {
  print('General Error during Stripe initialization: $e');
}
   //await Stripe.instance.applySettings();

// Firebase & Auth
injector.registerLazySingleton(() => FirebaseAuth.instance);
injector.registerLazySingleton(() => GoogleSignIn());
injector.registerLazySingleton(() => AuthRepository());
injector.registerFactory(() => AuthCubit(injector()));

// Network & API
injector.registerLazySingleton<Dio>(() => DioClient().dio);
injector.registerLazySingleton(() => Connectivity());
injector.registerFactory(() => ConnectivityCubit(injector()));
injector.registerLazySingleton(() => ApiService(injector()));

// Product
injector.registerLazySingleton<ProductRepository>(
  () => ProductRepositoryImpl(apiService: injector()),
);
injector.registerFactory(() => ProductCubit(injector()));

// Cart & Order
injector.registerLazySingleton<PaymentRepository>(
  () => PaymentRepository(injector()),
);
injector.registerLazySingleton<OrderRepository>(
  () => OrderRepository(injector()),
);
injector.registerFactory(() => OrderCubit(injector()));
injector.registerFactory(() => ProductListCubit(injector(), injector<OrderCubit>()));


}