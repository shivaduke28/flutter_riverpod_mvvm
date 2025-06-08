import 'package:flutter/material.dart';
import 'package:flutter_counter/product.dart';
import 'package:flutter_counter/ui/cart_view.dart';
import 'package:flutter_counter/ui/product_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CartView(),
              const Text('Product List:'),
              ...ref.watch(productListProvider).map((product) {
                return ProductView(product: product);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
