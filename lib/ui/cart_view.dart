import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../cart.dart';

// ViewModelが不要な場合は単一のStateNotifierをread/watchしてOK
class CartView extends ConsumerWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(cartProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Cart Items: ${viewModel.itemCount}'),
        Text('Total Price: ${viewModel.totalPrice}'),
        TextButton(
          onPressed: () {
            ref.read(cartProvider.notifier).clear();
          },
          child: const Text('Clear Cart'),
        ),
      ],
    );
  }
}
