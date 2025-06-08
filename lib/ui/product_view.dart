import 'package:flutter/material.dart';
import 'package:flutter_counter/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../cart.dart';

class ProductViewState {
  final Product product;
  final int count;

  ProductViewState({required this.product, this.count = 0});
}

class ProductViewModel extends StateNotifier<ProductViewState> {
  final Ref ref;

  ProductViewModel(super.state, this.ref) {
    ref.listen<int>(
      cartProvider.select((cartState) {
        return cartState.items[state.product.id]?.count ?? 0;
      }),
      (previous, next) {
        state = ProductViewState(product: state.product, count: next);
      },
    );
  }

  void incrementCount() {
    final cart = ref.read(cartProvider.notifier);
    cart.addItem(state.product);
  }

  void decrementCount() {
    if (state.count <= 0) return;
    final cart = ref.read(cartProvider.notifier);
    cart.removeItem(state.product);
  }
}

final productViewModelProvider =
    StateNotifierProvider.family<ProductViewModel, ProductViewState, Product>(
      (ref, product) =>
          ProductViewModel(ProductViewState(product: product), ref),
    );

class ProductView extends ConsumerWidget {
  final Product product;

  const ProductView({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productViewModelProvider(product));
    return Card(
      child: ListTile(
        title: Text(state.product.name),
        subtitle: Text('Price: ${state.product.price}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: ref
                  .read(productViewModelProvider(product).notifier)
                  .decrementCount,
            ),
            Text(state.count.toString()),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: ref
                  .read(productViewModelProvider(product).notifier)
                  .incrementCount,
            ),
          ],
        ),
      ),
    );
  }
}
