import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class Product {
  final int id;
  final String name;
  final double price;

  const Product({required this.id, required this.name, required this.price});
}

final productListProvider = Provider<List<Product>>((ref) {
  return [
    const Product(id: 1, name: 'Product 1', price: 10.0),
    const Product(id: 2, name: 'Product 2', price: 20.0),
    const Product(id: 3, name: 'Product 3', price: 30.0),
    const Product(id: 4, name: 'Product 4', price: 40.0),
    const Product(id: 5, name: 'Product 5', price: 50.0),
  ];
});

