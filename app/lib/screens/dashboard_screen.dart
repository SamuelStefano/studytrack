import 'package:flutter/material.dart';

import '../main.dart';
import '../store.dart';
import '../widgets/task_tile.dart';

class DashboardScreen extends StatelessWidget {
  final Store store;
  const DashboardScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final open = store.tasks.where((t) => !t.done).toList()..sort((a, b) => a.due.compareTo(b.due));
    final done = store.tasks.where((t) => t.done).length;
    final total = store.tasks.length;
    final ratio = total == 0 ? 0.0 : done / total;
    final urgent = open.where((t) => daysUntil(t.due) <= 3).length;
    final firstName = store.current!.name.split(' ').first;
    final text = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: brandGradient,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [BoxShadow(color: brandPrimary.withValues(alpha: 0.35), blurRadius: 24, offset: const Offset(0, 10))],
          ),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Olá, $firstName 👋', style: text.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  urgent == 0 ? 'Nenhum prazo apertado. Bom ritmo!' : 'Você tem $urgent entrega${urgent > 1 ? 's' : ''} nos próximos dias.',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                ),
              ]),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 72,
              height: 72,
              child: Stack(fit: StackFit.expand, children: [
                CircularProgressIndicator(
                  value: ratio,
                  strokeWidth: 8,
                  color: Colors.white,
                  backgroundColor: Colors.white24,
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Text('${(ratio * 100).round()}%',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                ),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.75,
          children: [
            _Stat(label: 'Em aberto', value: open.length, icon: Icons.pending_actions_rounded, color: const Color(0xFF2563EB)),
            _Stat(label: 'Concluídas', value: done, icon: Icons.task_alt_rounded, color: const Color(0xFF12B76A)),
            _Stat(label: 'Matérias', value: store.subjects.length, icon: Icons.menu_book_rounded, color: const Color(0xFF7C3AED)),
            _Stat(label: 'Urgentes', value: urgent, icon: Icons.local_fire_department_rounded, color: const Color(0xFFF04438)),
          ],
        ),
        const SizedBox(height: 24),
        Text('Próximos prazos', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Card(
          clipBehavior: Clip.antiAlias,
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
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('$value', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, height: 1)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
          ]),
        ]),
      ),
    );
  }
}
