import 'package:authentication/core/injections/auth_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:common/presentation/bloc/network_cubit.dart';
import 'package:flutter/material.dart';
import 'package:common/common.dart';
import '../../application/di/injection_container.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: injector<ConnectivityCubit>(),
      child: BlocConsumer<ConnectivityCubit, NetworkStatus>(
        listener: (context, state) {
          if (state == NetworkStatus.connected) {
            Future.delayed(const Duration(seconds: 2), () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.replaceRoute(const LoginRoute());
              });
            });
          }

         
        },
        builder: (context, state){
           return Scaffold(
            body: Center(
              child: state == NetworkStatus.disconnected
                  ? const Text("No Internet Connection")
                  : const CircularProgressIndicator(),
            ),
          );
        }
      ),
    );
  }
}
