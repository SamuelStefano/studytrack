import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';
import 'screens/home_shell.dart';
import 'store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = Store();
  await store.init();
  runApp(StudyTrackApp(store: store));
}

class StudyTrackApp extends StatelessWidget {
  final Store store;
  const StudyTrackApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF2563EB),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
      ),
      home: ListenableBuilder(
        listenable: store,
        builder: (context, _) => store.current == null ? AuthScreen(store: store) : HomeShell(store: store),
      ),
    );
  }
}
