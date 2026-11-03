import 'package:flutter/material.dart';

import '../main.dart';
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
      body: Container(
        decoration: const BoxDecoration(gradient: brandGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Container(
                    width: 72,
                    height: 72,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 38),
                  ),
                  const SizedBox(height: 16),
                  Text('StudyTrack',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text('Organize seu semestre em um só lugar.',
                      textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: 0.85))),
                  const SizedBox(height: 28),
                  _card(context, scheme),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _card(BuildContext context, ColorScheme scheme) {
    return Card(
              elevation: 12,
              shadowColor: Colors.black26,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(_registering ? 'Criar conta' : 'Entrar na sua conta',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 20),
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
            );
  }
}
