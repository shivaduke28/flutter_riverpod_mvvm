import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class ViewRef<NotifierT, T> {
  T readState();

  T watchState();

  NotifierT readModel();

  NotifierT watchModel();
}

class ViewRefImpl<NotifierT extends Notifier<T>, T>
    extends ViewRef<NotifierT, T> {
  final WidgetRef ref;
  final NotifierProvider<NotifierT, T> provider;

  ViewRefImpl(this.ref, this.provider);

  @override
  T readState() => ref.read(provider);

  @override
  T watchState() => ref.watch(provider);

  @override
  NotifierT readModel() => ref.read(provider.notifier);

  @override
  NotifierT watchModel() => ref.watch(provider.notifier);
}

class FamilyViewRefImpl<NotifierT extends FamilyNotifier<T, Arg>, T, Arg>
    extends ViewRef<NotifierT, T> {
  final WidgetRef ref;
  final NotifierProviderFamily<NotifierT, T, Arg> provider;
  final Arg arg;

  FamilyViewRefImpl(this.ref, this.provider, this.arg);

  @override
  T readState() => ref.read(provider(arg));

  @override
  T watchState() => ref.watch(provider(arg));

  @override
  NotifierT readModel() => ref.read(provider(arg).notifier);

  @override
  NotifierT watchModel() => ref.watch(provider(arg).notifier);
}

abstract class FamilyConsumerView<
  NotifierT extends FamilyNotifier<T, Arg>,
  T,
  Arg
>
    extends ConsumerWidget {
  const FamilyConsumerView({required this.arg, super.key});

  final Arg arg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewRef = FamilyViewRefImpl<NotifierT, T, Arg>(ref, provider, arg);
    return buildView(context, viewRef);
  }

  // NOTE: Providerをコンストラクタで渡すと継承クラスのコンストラクタをconstにできなくなるので
  // getterを継承する形でProviderを宣言させる
  NotifierProviderFamily<NotifierT, T, Arg> get provider;

  Widget buildView(
    BuildContext context,
    FamilyViewRefImpl<NotifierT, T, Arg> ref,
  );
}

abstract class ConsumerView<NotifierT extends Notifier<T>, T>
    extends ConsumerWidget {
  const ConsumerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewRef = ViewRefImpl<NotifierT, T>(ref, provider);
    return buildView(context, viewRef);
  }

  // NOTE: Providerをコンストラクタで渡すと継承クラスのコンストラクタをconstにできなくなるので
  // getterを継承する形でProviderを宣言させる
  NotifierProvider<NotifierT, T> get provider;

  Widget buildView(BuildContext context, ViewRef<NotifierT, T> ref);
}

abstract class HookConsumerView<NotifierT extends Notifier<T>, T>
    extends HookConsumerWidget {
  const HookConsumerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewRef = ViewRefImpl<NotifierT, T>(ref, provider);
    return buildView(context, viewRef);
  }

  NotifierProvider<NotifierT, T> get provider;

  Widget buildView(BuildContext context, ViewRef<NotifierT, T> ref);
}

abstract class FamilyHookConsumerView<
  NotifierT extends FamilyNotifier<T, Arg>,
  T,
  Arg
>
    extends HookConsumerWidget {
  final Arg arg;

  const FamilyHookConsumerView({required this.arg, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewRef = FamilyViewRefImpl<NotifierT, T, Arg>(ref, provider, arg);
    return buildView(context, viewRef);
  }

  NotifierProviderFamily<NotifierT, T, Arg> get provider;

  Widget buildView(
    BuildContext context,
    FamilyViewRefImpl<NotifierT, T, Arg> ref,
  );
}

abstract class StatefulConsumerView<NotifierT extends Notifier<T>, T>
    extends ConsumerStatefulWidget {
  const StatefulConsumerView({super.key});

  NotifierProvider<NotifierT, T> get provider;

  @override
  ConsumerState<StatefulConsumerView<NotifierT, T>> createState() =>
      _StatefulConsumerViewState<NotifierT, T>();

  // サブクラスでbuildViewを実装
  Widget buildView(
    BuildContext context,
    ViewRef<NotifierT, T> ref,
    ConsumerState state,
  );
}

// 実装用のStateクラス
class _StatefulConsumerViewState<NotifierT extends Notifier<T>, T>
    extends ConsumerState<StatefulConsumerView<NotifierT, T>> {
  @override
  void initState() {
    super.initState();
    // WidgetRefはbuild内でのみ有効なので、viewRefはbuildで初期化
  }

  @override
  Widget build(BuildContext context) {
    final viewRef = ViewRefImpl<NotifierT, T>(ref, widget.provider);
    return widget.buildView(context, viewRef, this);
  }
}

abstract class FamilyStatefulConsumerView<
  NotifierT extends FamilyNotifier<T, Arg>,
  T,
  Arg
>
    extends ConsumerStatefulWidget {
  final Arg arg;

  const FamilyStatefulConsumerView({required this.arg, super.key});

  NotifierProviderFamily<NotifierT, T, Arg> get provider;

  @override
  ConsumerState<FamilyStatefulConsumerView<NotifierT, T, Arg>> createState() =>
      _FamilyStatefulConsumerViewState<NotifierT, T, Arg>();

  // サブクラスでbuildViewを実装
  Widget buildView(
    BuildContext context,
    ViewRef<NotifierT, T> ref,
    ConsumerState state,
  );
}

class _FamilyStatefulConsumerViewState<
  NotifierT extends FamilyNotifier<T, Arg>,
  T,
  Arg
>
    extends ConsumerState<FamilyStatefulConsumerView<NotifierT, T, Arg>> {
  _FamilyStatefulConsumerViewState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewRef = FamilyViewRefImpl(ref, widget.provider, widget.arg);
    return widget.buildView(context, viewRef, this);
  }
}
