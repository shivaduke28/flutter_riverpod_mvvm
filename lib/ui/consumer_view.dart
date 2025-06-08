import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewRef<VM extends StateNotifier<S>, S> {
  final WidgetRef ref;
  final StateNotifierProvider<VM, S> provider;

  ViewRef(this.ref, this.provider);

  S readState() => ref.read(provider);

  S watchState() => ref.watch(provider);

  VM readModel() => ref.read(provider.notifier);

  VM watchModel() => ref.watch(provider.notifier);
}

abstract class ConsumerView<VM extends StateNotifier<S>, S>
    extends ConsumerWidget {
  const ConsumerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewRef = ViewRef<VM, S>(ref, provider);
    return buildView(context, viewRef);
  }

  StateNotifierProvider<VM, S> get provider;

  Widget buildView(BuildContext context, ViewRef<VM, S> ref);
}
