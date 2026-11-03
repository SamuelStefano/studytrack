import 'package:flutter/material.dart';

import '../models.dart';
import '../screens/task_form.dart';
import '../store.dart';

String formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

int daysUntil(DateTime due) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return DateTime(due.year, due.month, due.day).difference(today).inDays;
}

class TaskTile extends StatelessWidget {
  final Store store;
  final Task task;
  const TaskTile({super.key, required this.store, required this.task});

  (String, Color) _badge() {
    if (task.done) return ('Concluída', const Color(0xFF12B76A));
    final d = daysUntil(task.due);
    if (d < 0) return ('Atrasada', const Color(0xFFD92D20));
    if (d == 0) return ('Hoje', const Color(0xFFD92D20));
    if (d <= 3) return ('$d dia${d > 1 ? 's' : ''}', const Color(0xFFF79009));
    return ('$d dias', const Color(0xFF475467));
  }

  @override
  Widget build(BuildContext context) {
    final subject = store.subjectOf(task.subjectId);
    final (label, color) = _badge();
    return Dismissible(
      key: ValueKey('task-${task.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.shade400,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        store.deleteTask(task);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tarefa "${task.title}" excluída')));
      },
      child: ListTile(
        onTap: () => showTaskForm(context, store, existing: task),
        leading: Checkbox(value: task.done, onChanged: (_) => store.toggleTask(task)),
        title: Text(
          task.title,
          style: TextStyle(decoration: task.done ? TextDecoration.lineThrough : null),
        ),
        subtitle: Row(children: [
          Icon(Icons.circle, size: 10, color: subject?.color ?? Colors.grey),
          const SizedBox(width: 6),
          Flexible(child: Text('${subject?.name ?? '-'} · entrega ${formatDate(task.due)}', overflow: TextOverflow.ellipsis)),
        ]),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
          child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
        ),
      ),
    );
  }
}
