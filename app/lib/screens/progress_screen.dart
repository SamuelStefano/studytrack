import 'package:flutter/material.dart';

import '../store.dart';
import '../widgets/task_tile.dart';

class ProgressScreen extends StatelessWidget {
  final Store store;
  const ProgressScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final total = store.tasks.length;
    final done = store.tasks.where((t) => t.done).toList()
      ..sort((a, b) => (b.doneAt ?? b.due).compareTo(a.doneAt ?? a.due));
    final ratio = total == 0 ? 0.0 : done.length / total;
    final atRisk = store.subjects.where((s) {
      return store.tasks.any((t) => t.subjectId == s.id && !t.done && daysUntil(t.due) < 0);
    }).toList();
    final text = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(children: [
              SizedBox(
                width: 110,
                height: 110,
                child: Stack(fit: StackFit.expand, children: [
                  CircularProgressIndicator(value: ratio, strokeWidth: 12, backgroundColor: Colors.grey.shade200),
                  Center(child: Text('${(ratio * 100).round()}%', style: text.headlineSmall?.copyWith(fontWeight: FontWeight.bold))),
                ]),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Conclusão do semestre', style: text.titleMedium),
                  const SizedBox(height: 4),
                  Text('${done.length} de $total tarefas concluídas'),
                ]),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        Text('Progresso por matéria', style: text.titleMedium),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              for (final s in store.subjects)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [Expanded(child: Text(s.name)), Text('${(store.progressOf(s) * 100).round()}%')]),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(value: store.progressOf(s), color: s.color, minHeight: 8, borderRadius: BorderRadius.circular(8)),
                  ]),
                ),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        Text('Matérias que precisam de atenção', style: text.titleMedium),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          child: atRisk.isEmpty
              ? const ListTile(leading: Icon(Icons.verified, color: Colors.green), title: Text('Nenhuma tarefa atrasada.'))
              : Column(children: [
                  for (final s in atRisk)
                    ListTile(
                      leading: Icon(Icons.warning_amber, color: s.color),
                      title: Text(s.name),
                      subtitle: const Text('Possui tarefa atrasada'),
                    ),
                ]),
        ),
        const SizedBox(height: 16),
        Text('Concluídas recentemente', style: text.titleMedium),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          child: Column(children: [for (final t in done.take(5)) TaskTile(store: store, task: t)]),
        ),
      ],
    );
  }
}
