import 'package:flutter/material.dart';

import '../models.dart';
import '../store.dart';

class SubjectsScreen extends StatelessWidget {
  final Store store;
  const SubjectsScreen({super.key, required this.store});

  Future<void> _confirmDelete(BuildContext context, Subject s) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir matéria?'),
        content: Text('"${s.name}" e todas as suas tarefas serão removidas.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
        ],
      ),
    );
    if (ok == true) store.deleteSubject(s);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSubjectForm(context, store),
        icon: const Icon(Icons.add),
        label: const Text('Nova matéria'),
      ),
      body: store.subjects.isEmpty
          ? const Center(child: Text('Nenhuma matéria cadastrada.'))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                for (final s in store.subjects)
                  Card(
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Container(
                    decoration: BoxDecoration(border: Border(left: BorderSide(color: s.color, width: 6))),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(color: s.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                            child: Icon(Icons.menu_book_rounded, color: s.color),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(s.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
                          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => _showSubjectForm(context, store, existing: s)),
                          IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _confirmDelete(context, s)),
                        ]),
                        Text(s.teacher, style: const TextStyle(color: Color(0xFF6B7280))),
                        const SizedBox(height: 8),
                        Text('${store.tasks.where((t) => t.subjectId == s.id).length} tarefas · '
                            '${(store.progressOf(s) * 100).round()}% concluído'),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: store.progressOf(s), color: s.color, backgroundColor: s.color.withValues(alpha: 0.12), minHeight: 8, borderRadius: BorderRadius.circular(8)),
                      ]),
                    ),
                    ),
                  ),
              ],
            ),
    );
  }
}

Future<void> _showSubjectForm(BuildContext context, Store store, {Subject? existing}) {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController(text: existing?.name);
  final teacher = TextEditingController(text: existing?.teacher);
  var color = existing?.colorIndex ?? store.subjects.length % subjectColors.length;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Form(
          key: formKey,
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(existing == null ? 'Nova matéria' : 'Editar matéria', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Nome da matéria'),
              validator: (v) => (v == null || v.trim().length < 2) ? 'Informe o nome.' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: teacher,
              decoration: const InputDecoration(labelText: 'Professor(a)'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o professor.' : null,
            ),
            const SizedBox(height: 16),
            Wrap(spacing: 10, children: [
              for (var i = 0; i < subjectColors.length; i++)
                GestureDetector(
                  onTap: () => setState(() => color = i),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: subjectColors[i],
                    child: color == i ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                  ),
                ),
            ]),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                store.saveSubject(existing: existing, name: name.text.trim(), teacher: teacher.text.trim(), colorIndex: color);
                Navigator.pop(ctx);
              },
              child: const Text('Salvar'),
            ),
          ]),
        ),
      ),
    ),
  );
}
