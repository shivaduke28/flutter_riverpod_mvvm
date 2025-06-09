import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../cart.dart';
import 'consumer_view.dart';

// ViewModelが不要な場合は単一のStateNotifierをread/watchしてOK
class CartView extends ConsumerView<Cart, CartState> {
  const CartView({super.key});

  @override
  NotifierProvider<Cart, CartState> get provider => cartProvider;

  @override
  Widget buildView(BuildContext context, ViewRef<Cart, CartState> ref) {
    final state = ref.watchState();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Cart Items: ${state.itemCount}'),
        Text('Total Price: ${state.totalPrice}'),
        TextButton(
          onPressed: () {
            ref.readModel().clear();
          },
          child: const Text('Clear Cart'),
        ),
      ],
    );
  }
}
