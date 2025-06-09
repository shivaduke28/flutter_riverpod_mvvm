import 'package:flutter/material.dart';
import 'package:flutter_counter/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../cart.dart';
import 'consumer_view.dart';

typedef ProductViewState = ({Product product, int count, bool favorite});

class ProductViewModel extends FamilyNotifier<ProductViewState, Product> {
  @override
  ProductViewState build(Product product) {
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

    final cart = ref.read(cartProvider);
    final initialCount = cart.items[product.id]?.count ?? 0;
    return (product: product, count: initialCount, favorite: false);
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
    NotifierProvider.family<ProductViewModel, ProductViewState, Product>(
      ProductViewModel.new,
    );

class ProductView
    extends FamilyConsumerView<ProductViewModel, ProductViewState, Product> {

  const ProductView({required super.arg, super.key});

  @override
  NotifierProviderFamily<ProductViewModel, ProductViewState, Product>
  get provider => productViewModelProviderFamily;

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
