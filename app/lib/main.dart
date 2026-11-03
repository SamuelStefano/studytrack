import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/auth_screen.dart';
import 'screens/home_shell.dart';
import 'store.dart';

const brandPrimary = Color(0xFF4F46E5);
const brandAccent = Color(0xFF7C3AED);
const brandGradient = LinearGradient(
  colors: [brandPrimary, brandAccent],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

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
    final scheme = ColorScheme.fromSeed(
      seedColor: brandPrimary,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    ).copyWith(primary: brandPrimary, surface: Colors.white);
    final base = ThemeData(colorScheme: scheme, useMaterial3: true);
    return MaterialApp(
      title: 'StudyTrack',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        textTheme: GoogleFonts.interTextTheme(base.textTheme),
        scaffoldBackgroundColor: const Color(0xFFF4F5FA),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFF4F5FA),
          surfaceTintColor: Colors.transparent,
          titleTextStyle: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: const Color(0xFF111827)),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFFE7E8F0)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF6F7FB),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE7E8F0))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: brandPrimary, width: 2)),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: brandPrimary,
          foregroundColor: Colors.white,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: brandPrimary.withValues(alpha: 0.12),
          iconTheme: WidgetStateProperty.resolveWith(
            (s) => IconThemeData(color: s.contains(WidgetState.selected) ? brandPrimary : const Color(0xFF6B7280)),
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
          showDragHandle: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        ),
      ),
      home: ListenableBuilder(
        listenable: store,
        builder: (context, _) => store.current == null ? AuthScreen(store: store) : HomeShell(store: store),
      ),
    );
  }
}
