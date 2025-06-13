

import 'package:cart_detail/core/injection/cart_details_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:common/common.dart';
import 'package:auto_route/auto_route.dart'; 
import '../bloc/cart_cubit.dart';
import '../bloc/cart_state.dart';

class AnimatedCartButton extends StatelessWidget {
  const AnimatedCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        int count = 0;

        if (state is CartLoaded) {
          count = state.cartItems.length;
        }

        return Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
            if (state is CartLoading)
              const Positioned(
                right: 6,
                top: 6,
                child: SizedBox(
                  height: 14,
                  width: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            if (state is CartLoaded && count > 0)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: GestureDetector(
                  onTap: (){
                    context.pushRoute(  CartDetails(products: state.cartItems));
                  },
                  child: CircleAvatar(
                    key: ValueKey<int>(count),
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$count',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            if (state is CartError)
              const Positioned(
                right: 6,
                top: 6,
                child: Icon(Icons.error, color: Colors.red, size: 16),
              ),
          ],
        );
      },
    );
  }
}
