import 'package:flutter/material.dart';

import '../models.dart';
import '../store.dart';
import '../widgets/task_tile.dart';

Future<void> showTaskForm(BuildContext context, Store store, {Task? existing}) {
  if (store.subjects.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cadastre uma matéria primeiro.')));
    return Future.value();
  }
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _TaskForm(store: store, existing: existing),
  );
}

class _TaskForm extends StatefulWidget {
  final Store store;
  final Task? existing;
  const _TaskForm({required this.store, this.existing});

  @override
  State<_TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<_TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.existing?.title);
  late int _subjectId = widget.existing?.subjectId ?? widget.store.subjects.first.id;
  late DateTime _due = widget.existing?.due ?? DateTime.now().add(const Duration(days: 7));

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _due,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) setState(() => _due = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    widget.store.saveTask(existing: widget.existing, title: _title.text.trim(), subjectId: _subjectId, due: _due);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.existing == null ? 'Nova tarefa' : 'Editar tarefa', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _title,
              autofocus: widget.existing == null,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (v) => (v == null || v.trim().length < 3) ? 'Mínimo de 3 caracteres.' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: _subjectId,
              decoration: const InputDecoration(labelText: 'Matéria'),
              items: [
                for (final s in widget.store.subjects) DropdownMenuItem(value: s.id, child: Text(s.name)),
              ],
              onChanged: (v) => setState(() => _subjectId = v!),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.event),
              label: Text('Entrega: ${formatDate(_due)}/${_due.year}'),
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: _save, child: const Text('Salvar')),
          ],
        ),
      ),
    );
  }
}
