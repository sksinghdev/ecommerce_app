import 'package:common/presentation/bloc/order_local_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/src/application/di/injection_container.dart';

import '../widgets/order_history.dart';

@RoutePage()
class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => injector<OrderLocalCubit>()..loadOrders(),
      child: const OrderHistoryView(),
    );
  }
}
