import 'package:flutter/material.dart';

import '../store.dart';
import '../widgets/task_tile.dart';

class DashboardScreen extends StatelessWidget {
  final Store store;
  const DashboardScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final open = store.tasks.where((t) => !t.done).toList()..sort((a, b) => a.due.compareTo(b.due));
    final done = store.tasks.where((t) => t.done).length;
    final urgent = open.where((t) => daysUntil(t.due) <= 3).length;
    final firstName = store.current!.name.split(' ').first;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        Text('Olá, $firstName 👋', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.9,
          children: [
            _Stat(label: 'Em aberto', value: open.length, icon: Icons.pending_actions, color: const Color(0xFF2563EB)),
            _Stat(label: 'Concluídas', value: done, icon: Icons.task_alt, color: const Color(0xFF12B76A)),
            _Stat(label: 'Matérias', value: store.subjects.length, icon: Icons.menu_book, color: const Color(0xFF7C3AED)),
            _Stat(label: 'Urgentes', value: urgent, icon: Icons.local_fire_department, color: const Color(0xFFD92D20)),
          ],
        ),
        const SizedBox(height: 20),
        Text('Próximos prazos', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          child: open.isEmpty
              ? const Padding(padding: EdgeInsets.all(24), child: Text('Nada pendente. 🎉'))
              : Column(children: [for (final t in open.take(5)) TaskTile(store: store, task: t)]),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  const _Stat({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 12),
          Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('$value', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            Text(label),
          ]),
        ]),
      ),
    );
  }
}
