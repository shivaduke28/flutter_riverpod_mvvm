import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class ViewRef<VM, S> {
  S readState();

  S watchState();

  VM readModel();

  VM watchModel();
}

class ViewRefImpl<VM extends Notifier<S>, S> extends ViewRef<VM, S> {
  final WidgetRef ref;
  final NotifierProvider<VM, S> provider;

  ViewRefImpl(this.ref, this.provider);

  @override
  S readState() => ref.read(provider);

  @override
  S watchState() => ref.watch(provider);

  @override
  VM readModel() => ref.read(provider.notifier);

  @override
  VM watchModel() => ref.watch(provider.notifier);
}

class FamilyViewRefImpl<VM extends FamilyNotifier<S, Arg>, S, Arg>
    extends ViewRef<VM, S> {
  final WidgetRef ref;
  final NotifierProviderFamily<VM, S, Arg> provider;
  final Arg arg;

  FamilyViewRefImpl(this.ref, this.provider, this.arg);

  @override
  S readState() => ref.read(provider(arg));

  @override
  S watchState() => ref.watch(provider(arg));

  @override
  VM readModel() => ref.read(provider(arg).notifier);

  @override
  VM watchModel() => ref.watch(provider(arg).notifier);
}

abstract class FamilyConsumerView<VM extends FamilyNotifier<S, Arg>, S, Arg>
    extends ConsumerWidget {
  const FamilyConsumerView({required this.arg, super.key});

  final Arg arg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewRef = FamilyViewRefImpl<VM, S, Arg>(ref, provider, arg);
    return buildView(context, viewRef);
  }

  // NOTE: Providerをコンストラクタで渡すと継承クラスのコンストラクタをconstにできなくなるので
  // getterを継承する形でProviderを宣言させる
  NotifierProviderFamily<VM, S, Arg> get provider;

  Widget buildView(BuildContext context, FamilyViewRefImpl<VM, S, Arg> ref);
}

abstract class ConsumerView<VM extends Notifier<S>, S> extends ConsumerWidget {
  const ConsumerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewRef = ViewRefImpl<VM, S>(ref, provider);
    return buildView(context, viewRef);
  }

  // NOTE: Providerをコンストラクタで渡すと継承クラスのコンストラクタをconstにできなくなるので
  // getterを継承する形でProviderを宣言させる
  NotifierProvider<VM, S> get provider;

  Widget buildView(BuildContext context, ViewRef<VM, S> ref);
}

abstract class HookConsumerView<VM extends Notifier<S>, S>
    extends HookConsumerWidget {
  const HookConsumerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewRef = ViewRefImpl<VM, S>(ref, provider);
    return buildView(context, viewRef);
  }

  NotifierProvider<VM, S> get provider;

  Widget buildView(BuildContext context, ViewRef<VM, S> ref);
}
