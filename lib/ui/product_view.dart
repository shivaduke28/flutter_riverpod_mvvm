import 'package:flutter/material.dart';
import 'package:flutter_counter/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../cart.dart';
import 'consumer_view.dart';

typedef ProductViewState = ({Product product, int count, bool favorite});

class ProductViewModel extends StateNotifier<ProductViewState> {
  final Ref ref;

  ProductViewModel(super.state, this.ref) {
    ref.listen<CartItem?>(
      cartProvider.select((cartState) {
        return cartState.items[state.product.id];
      }),
      (previous, next) {
        state = (
          product: state.product,
          count: next?.count ?? 0,
          favorite: state.favorite,
        );
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

  void toggleFavorite() {
    state = (
      product: state.product,
      count: state.count,
      favorite: !state.favorite,
    );
  }
}

final productViewModelProviderFamily =
    StateNotifierProvider.family<ProductViewModel, ProductViewState, Product>((
      ref,
      product,
    ) {
      final cart = ref.read(cartProvider);
      final initialCount = cart.items[product.id]?.count ?? 0;
      return ProductViewModel((
        product: product,
        count: initialCount,
        favorite: false,
      ), ref);
    });

class ProductView extends ConsumerView<ProductViewModel, ProductViewState> {
  final Product product;

  const ProductView({super.key, required this.product});

  @override
  StateNotifierProvider<ProductViewModel, ProductViewState> get provider =>
      productViewModelProviderFamily(product);

  @override
  Widget buildView(
    BuildContext context,
    ViewRef<ProductViewModel, ProductViewState> ref,
  ) {
    final state = ref.watchState();
    return Card(
      child: ListTile(
        title: Text(state.product.name),
        subtitle: Text('Price: ${state.product.price}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: ref.readModel().decrementCount,
            ),
            Text(state.count.toString()),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: ref.readModel().incrementCount,
            ),
            Checkbox(
              value: state.favorite,
              onChanged: (_) {
                ref.readModel().toggleFavorite();
              },
            ),
          ],
        ),
      ),
    );
  }
}
