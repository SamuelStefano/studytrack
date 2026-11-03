import 'package:flutter/material.dart';

import '../store.dart';
import 'dashboard_screen.dart';
import 'progress_screen.dart';
import 'subjects_screen.dart';
import 'tasks_screen.dart';
import 'task_form.dart';

class HomeShell extends StatefulWidget {
  final Store store;
  const HomeShell({super.key, required this.store});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _titles = ['Dashboard', 'Matérias', 'Tarefas', 'Progresso'];

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    final pages = [
      DashboardScreen(store: store),
      SubjectsScreen(store: store),
      TasksScreen(store: store),
      ProgressScreen(store: store),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: [
          PopupMenuButton<String>(
            icon: CircleAvatar(child: Text(store.current!.name[0].toUpperCase())),
            onSelected: (_) => store.logout(),
            itemBuilder: (_) => [
              PopupMenuItem(enabled: false, child: Text(store.current!.email)),
              const PopupMenuItem(value: 'logout', child: Text('Sair')),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(child: pages[_index]),
      floatingActionButton: _index == 1
          ? null
          : FloatingActionButton.extended(
              onPressed: () => showTaskForm(context, store),
              icon: const Icon(Icons.add),
              label: const Text('Nova tarefa'),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Início'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), label: 'Matérias'),
          NavigationDestination(icon: Icon(Icons.checklist), label: 'Tarefas'),
          NavigationDestination(icon: Icon(Icons.insights_outlined), label: 'Progresso'),
        ],
      ),
    );
  }
}
