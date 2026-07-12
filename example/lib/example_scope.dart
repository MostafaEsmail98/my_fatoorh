import 'package:flutter/widgets.dart';

import 'app_state.dart';

final class ExampleScope extends InheritedNotifier<ExampleAppState> {
  const ExampleScope({
    required ExampleAppState super.notifier,
    required super.child,
    super.key,
  });

  static ExampleAppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ExampleScope>();
    assert(scope != null, 'ExampleScope was not found in the widget tree.');
    return scope!.notifier!;
  }
}
