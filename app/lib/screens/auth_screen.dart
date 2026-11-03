import 'package:flutter/material.dart';

import '../store.dart';

class AuthScreen extends StatefulWidget {
  final Store store;
  const AuthScreen({super.key, required this.store});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _registering = false;
  bool _hidePassword = true;
  String? _error;

  void _submit() {
    final error = _registering
        ? widget.store.register(_name.text, _email.text, _password.text)
        : widget.store.login(_email.text, _password.text);
    setState(() => _error = error);
  }

  void _fillDemo() {
    _email.text = Store.demoEmail;
    _password.text = Store.demoPassword;
    setState(() => _registering = false);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(children: [
                      CircleAvatar(
                        backgroundColor: scheme.primary,
                        child: const Text('S', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('StudyTrack', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const Text('Organize seu semestre em um só lugar.'),
                      ]),
                    ]),
                    const SizedBox(height: 24),
                    if (_registering) ...[
                      TextField(controller: _name, decoration: const InputDecoration(labelText: 'Nome')),
                      const SizedBox(height: 12),
                    ],
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'E-mail'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _password,
                      obscureText: _hidePassword,
                      onSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        suffixIcon: IconButton(
                          icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _hidePassword = !_hidePassword),
                        ),
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(_error!, style: TextStyle(color: scheme.error)),
                    ],
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: Text(_registering ? 'Criar conta' : 'Entrar'),
                    ),
                    TextButton(
                      onPressed: () => setState(() {
                        _registering = !_registering;
                        _error = null;
                      }),
                      child: Text(_registering ? 'Já tenho conta' : 'Criar uma conta'),
                    ),
                    const Divider(height: 32),
                    OutlinedButton.icon(
                      onPressed: _fillDemo,
                      icon: const Icon(Icons.school_outlined),
                      label: const Text('Usar conta de avaliação'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
