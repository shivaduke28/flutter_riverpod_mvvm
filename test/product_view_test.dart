import 'package:flutter_counter/cart.dart';
import 'package:flutter_counter/product.dart';
import 'package:flutter_counter/ui/product_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;
  late Product testProduct;

  setUp(() {
    container = ProviderContainer();
    testProduct = const Product(id: 1, name: 'Test Product', price: 10.0);
    container.read(productListProvider);
  });

  tearDown(() {
    container.dispose();
  });

  test('初期状態はcount=0', () {
    final state = container.read(productViewModelProviderFamily(testProduct));
    expect(state.count, 0);
    expect(state.product, testProduct);
  });

  test('カートに商品が追加される', () {
    final notifier = container.read(
      productViewModelProviderFamily(testProduct).notifier,
    );
    notifier.incrementCount();

    // カートの状態を確認
    final cartState = container.read(cartProvider);
    expect(cartState.items[testProduct.id]!.count, 1);
  });

  test('カートから商品が削除される', () {
    final notifier = container.read(
      productViewModelProviderFamily(testProduct).notifier,
    );
    notifier.incrementCount(); // まずは1つ追加
    notifier.decrementCount(); // 1つ削除

    // カートの状態を確認
    final cartState = container.read(cartProvider);
    expect(cartState.items[testProduct.id], null);

    // カウントが0になっていることを確認
    final state = container.read(productViewModelProviderFamily(testProduct));
    expect(state.count, 0);
  });

  test('カートに商品が追加されるとcountが増える', () {
    final cart = container.read(cartProvider.notifier);
    cart.addItem(testProduct);

    final state = container.read(productViewModelProviderFamily(testProduct));
    expect(state.count, 1);
  });

  test('カートから商品が削除されるとcountが減る', () {
    final cart = container.read(cartProvider.notifier);
    cart.addItem(testProduct); // 1つ追加
    cart.removeItem(testProduct); // 1つ削除

    final state = container.read(productViewModelProviderFamily(testProduct));
    expect(state.count, 0);
  });

  test('カートを空にするとcountが0になる', () {
    final cart = container.read(cartProvider.notifier);
    cart.addItem(testProduct); // 1つ追加
    cart.clear(); // カートを空にする

    final state = container.read(productViewModelProviderFamily(testProduct));
    expect(state.count, 0);
  });

  test('お気に入りの切り替えができる', () {
    final notifier = container.read(
      productViewModelProviderFamily(testProduct).notifier,
    );
    notifier.toggleFavorite();

    expect(container.read(productViewModelProviderFamily(testProduct)).favorite, true);

    notifier.toggleFavorite();
    expect(container.read(productViewModelProviderFamily(testProduct)).favorite, false);
  });
}
