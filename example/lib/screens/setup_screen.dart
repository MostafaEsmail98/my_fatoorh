import 'package:flutter/material.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

import '../example_scope.dart';
import '../widgets/common.dart';

final class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

final class _SetupScreenState extends State<SetupScreen> {
  final _backendBaseUrlController = TextEditingController();
  var _environment = MyFatoorahEnvironment.test;
  var _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final state = ExampleScope.of(context);
    _environment = state.environment;
    _backendBaseUrlController.text = state.backendBaseUrl;
    _initialized = true;
  }

  @override
  void dispose() {
    _backendBaseUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ExampleScope.of(context);
    return ExamplePage(
      children: [
        const Text(
          'Configure your backend proxy for the demos. Values are stored in memory only.',
        ),
        const InfoBox(
          icon: Icons.dns_outlined,
          message:
              'The Flutter package only calls your backend. Keep the MyFatoorah API key on the server.',
        ),
        SegmentedButton<MyFatoorahEnvironment>(
          segments: const [
            ButtonSegment(
              value: MyFatoorahEnvironment.test,
              label: Text('test'),
            ),
            ButtonSegment(
              value: MyFatoorahEnvironment.live,
              label: Text('live'),
            ),
          ],
          selected: {_environment},
          onSelectionChanged: (selection) {
            setState(() => _environment = selection.single);
          },
        ),
        TextField(
          controller: _backendBaseUrlController,
          decoration: const InputDecoration(
            labelText: 'Backend base URL',
            helperText: 'Example: http://localhost:8080',
          ),
        ),
        FilledButton.icon(
          onPressed: () {
            state.save(
              environment: _environment,
              backendBaseUrl: _backendBaseUrlController.text,
            );
            final message = state.configurationError ?? 'Configuration saved.';
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          },
          icon: const Icon(Icons.save_outlined),
          label: const Text('Save configuration'),
        ),
        AnimatedBuilder(
          animation: state,
          builder: (context, child) {
            return ResultPanel(
              title: 'Current configuration',
              children: [
                const FieldRow(label: 'Transport mode', value: 'backendProxy'),
                FieldRow(label: 'Environment', value: state.environment.name),
                FieldRow(label: 'Country', value: state.country.code),
                FieldRow(
                  label: 'Backend base URL',
                  value: state.backendBaseUrl,
                ),
                if (state.configurationError case final error?)
                  ErrorText(error),
              ],
            );
          },
        ),
      ],
    );
  }
}
