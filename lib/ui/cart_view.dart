import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../cart.dart';

class CartViewModel {
  final Ref ref;
  final CartState cartState;

  CartViewModel(this.ref, this.cartState);

  void clearCart() {
    final cart = ref.read(cartProvider.notifier);
    cart.clear();
  }
}

// CartViewModelは自身のstateを持たないのでProviderにする
// 代わりにcartProviderをwatchすることで更新が走る
final cartViewModelProvider = Provider<CartViewModel>((ref) {
  final cartState = ref.watch(cartProvider);
  return CartViewModel(ref, cartState);
});

class CartView extends ConsumerWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(cartViewModelProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Cart Items: ${viewModel.cartState.itemCount}'),
        Text('Total Price: ${viewModel.cartState.totalPrice}'),
        TextButton(
          onPressed: () {
            viewModel.clearCart();
          },
          child: const Text('Clear Cart'),
        ),
      ],
    );
  }
}
