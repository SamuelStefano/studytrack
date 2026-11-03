import 'package:flutter/material.dart';

import '../store.dart';
import '../widgets/task_tile.dart';

enum TaskFilter { all, open, done }

class TasksScreen extends StatefulWidget {
  final Store store;
  const TasksScreen({super.key, required this.store});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  TaskFilter _filter = TaskFilter.all;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final list = widget.store.tasks.where((t) {
      if (_filter == TaskFilter.open && t.done) return false;
      if (_filter == TaskFilter.done && !t.done) return false;
      return t.title.toLowerCase().contains(_query.toLowerCase());
    }).toList()
      ..sort((a, b) => a.due.compareTo(b.due));

    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: TextField(
          decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Buscar tarefa', isDense: true),
          onChanged: (v) => setState(() => _query = v),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SegmentedButton<TaskFilter>(
          segments: const [
            ButtonSegment(value: TaskFilter.all, label: Text('Todas')),
            ButtonSegment(value: TaskFilter.open, label: Text('Abertas')),
            ButtonSegment(value: TaskFilter.done, label: Text('Feitas')),
          ],
          selected: {_filter},
          onSelectionChanged: (s) => setState(() => _filter = s.first),
        ),
      ),
      const SizedBox(height: 8),
      Expanded(
        child: list.isEmpty
            ? const Center(child: Text('Nenhuma tarefa encontrada.'))
            : ListView(
                padding: const EdgeInsets.only(bottom: 96),
                children: [for (final t in list) TaskTile(store: widget.store, task: t)],
              ),
      ),
    ]);
  }
}
