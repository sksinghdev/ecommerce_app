

 import 'package:cart_detail/core/service/stripe_service.dart';
import 'package:cart_detail/data/payment_repository.dart';
import 'package:cart_detail/data/repositories/order_repository_impl.dart';
import 'package:cart_detail/domain/repository/order_repository.dart';
import 'package:cart_detail/presentation/bloc/order_cubit.dart';
import 'package:cart_detail/presentation/bloc/product_list_cubit.dart';
import 'package:common/common.dart';
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

  await Stripe.instance.applySettings();

// Firebase & Auth
injector.registerLazySingleton(() => FirebaseAuth.instance);
injector.registerLazySingleton(() => GoogleSignIn());
injector.registerLazySingleton(() => AuthRepository());
injector.registerFactory(() => AuthCubit(injector()));
 

injector.registerLazySingleton<Stripe>(() => Stripe.instance);
injector.registerLazySingleton<StripeService>(
  () => StripeService(stripeInstance: injector<Stripe>())
);

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
injector.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(injector<ApiService>()));
injector.registerFactory(() => OrderCubit(injector()));
injector.registerFactory(() => ProductListCubit(injector(), injector<OrderCubit>(),injector()));


}