# Flutter Riverpod MVVM example

## MVVM

- Viewが複数のModelをProviderを通して取得するのを避け、ViewModelを使用する
  - `ConsumerView<ViewModel, ViewState>`を使うことでRefを制限する
- ViewModelは`StateNotifier<ViewState>`として実装する
- ModelとViewModelに対してテストを書く
- ModelがViewModelとして使える場合はViewModelとViewStateを省略してよい
  - e.g. `CartView`
- トランザクション的にatomicにしたい状態は一つのStateにまとめる
  - e.g. `CartState`
- StateはImmutableにする
- 親Viewは子ViewのViewModelを知らないようにする
  - `ProductListView`は`ProductView`に`Product`を渡すが、`ProductViewModel`のことは知らない
- ViewModelのProviderで別のProviderを`watch`しない
  - ViewModelとViewのライフサイクルを合わせてStateだけを更新する