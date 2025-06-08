import 'package:flutter/cupertino.dart';
import 'package:flutter_counter/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class CartItem {
  final Product product;
  final int count;

  const CartItem({required this.product, this.count = 0});

  double get totalPrice => product.price * count;
}

class CartState {
  final int itemCount;
  final double totalPrice;
  final Map<int, CartItem> items;

  const CartState(
    this.items, {
    required this.itemCount,
    required this.totalPrice,
  });
}

class Cart extends StateNotifier<CartState> {
  final Map<int, CartItem> _items = {};

  Cart(super.state);

  Iterable<CartItem> get items => _items.values;

  CartItem? getItem(Product product) {
    return _items[product.id];
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      final existingItem = _items[product.id]!;
      _items[product.id] = CartItem(
        product: product,
        count: existingItem.count + 1,
      );
    } else {
      _items[product.id] = CartItem(product: product, count: 1);
    }
    _updateState();
  }

  void removeItem(Product product) {
    if (_items.containsKey(product.id)) {
      final existingItem = _items[product.id]!;
      if (existingItem.count <= 1) {
        _items.remove(product.id);
      } else {
        _items[product.id] = CartItem(
          product: product,
          count: existingItem.count - 1,
        );
      }
    }
    _updateState();
  }

  void clear() {
    _items.clear();
    _updateState();
  }

  void _updateState() {
    int itemCount = _items.values.fold(0, (sum, item) => sum + item.count);
    double totalPrice = _items.values.fold(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
    state = CartState(
      Map.unmodifiable(_items),
      itemCount: itemCount,
      totalPrice: totalPrice,
    );
  }
}

final cartProvider = StateNotifierProvider<Cart, CartState>(
  (ref) => Cart(const CartState(<int, CartItem>{}, itemCount: 0, totalPrice: 0.0)),
);
