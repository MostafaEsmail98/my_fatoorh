import 'package:flutter/material.dart';

import 'app_state.dart';
import 'example_scope.dart';
import 'widgets/example_shell.dart';

void main() {
  runApp(const MyFatoorahExampleApp());
}

class MyFatoorahExampleApp extends StatefulWidget {
  const MyFatoorahExampleApp({super.key});

  @override
  State<MyFatoorahExampleApp> createState() => _MyFatoorahExampleAppState();
}

class _MyFatoorahExampleAppState extends State<MyFatoorahExampleApp> {
  late final ExampleAppState _state;

  @override
  void initState() {
    super.initState();
    _state = ExampleAppState();
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExampleScope(
      notifier: _state,
      child: MaterialApp(
        title: 'MyFatoorah SDK Example',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        home: const ExampleShell(),
      ),
    );
  }
}
