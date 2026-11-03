import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

/// Persists users and per-user data (subjects + tasks) on the device.
class Store extends ChangeNotifier {
  static const demoEmail = 'professor@studytrack.app';
  static const demoPassword = 'uninga2026';

  late SharedPreferences _prefs;
  final Map<String, AppUser> _users = {};
  AppUser? current;
  List<Subject> subjects = [];
  List<Task> tasks = [];

  static String hash(String email, String password) =>
      sha256.convert(utf8.encode('${email.toLowerCase()}::$password')).toString();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs.getString('users');
    if (raw != null) {
      for (final u in (jsonDecode(raw) as List)) {
        final user = AppUser.fromJson(u);
        _users[user.email] = user;
      }
    }
    if (!_users.containsKey(demoEmail)) {
      _users[demoEmail] = AppUser(name: 'Professor', email: demoEmail, passwordHash: hash(demoEmail, demoPassword));
      _saveUsers();
    }
    final session = _prefs.getString('session');
    if (session != null && _users.containsKey(session)) {
      _openSession(_users[session]!);
    }
  }

  void _saveUsers() => _prefs.setString('users', jsonEncode(_users.values.map((u) => u.toJson()).toList()));

  /// Returns an error message, or null on success.
  String? login(String email, String password) {
    final e = email.trim().toLowerCase();
    final user = _users[e];
    if (user == null || user.passwordHash != hash(e, password)) return 'E-mail ou senha incorretos.';
    _openSession(user);
    notifyListeners();
    return null;
  }

  String? register(String name, String email, String password) {
    final e = email.trim().toLowerCase();
    if (name.trim().length < 2) return 'Informe seu nome.';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(e)) return 'E-mail inválido.';
    if (password.length < 6) return 'A senha precisa de pelo menos 6 caracteres.';
    if (_users.containsKey(e)) return 'Já existe uma conta com esse e-mail.';
    final user = AppUser(name: name.trim(), email: e, passwordHash: hash(e, password));
    _users[e] = user;
    _saveUsers();
    _openSession(user);
    notifyListeners();
    return null;
  }

  void logout() {
    current = null;
    _prefs.remove('session');
    notifyListeners();
  }

  void _openSession(AppUser user) {
    current = user;
    _prefs.setString('session', user.email);
    final raw = _prefs.getString('data:${user.email}');
    if (raw == null) {
      _seed();
      _save();
    } else {
      final j = jsonDecode(raw);
      subjects = (j['subjects'] as List).map((s) => Subject.fromJson(s)).toList();
      tasks = (j['tasks'] as List).map((t) => Task.fromJson(t)).toList();
    }
  }

  void _save() {
    if (current == null) return;
    _prefs.setString(
      'data:${current!.email}',
      jsonEncode({
        'subjects': subjects.map((s) => s.toJson()).toList(),
        'tasks': tasks.map((t) => t.toJson()).toList(),
      }),
    );
  }

  int _nextId(Iterable<int> ids) => ids.isEmpty ? 1 : ids.reduce((a, b) => a > b ? a : b) + 1;

  Subject? subjectOf(int id) {
    for (final s in subjects) {
      if (s.id == id) return s;
    }
    return null;
  }

  void saveSubject({Subject? existing, required String name, required String teacher, required int colorIndex}) {
    if (existing == null) {
      subjects.add(Subject(id: _nextId(subjects.map((s) => s.id)), name: name, teacher: teacher, colorIndex: colorIndex));
    } else {
      existing
        ..name = name
        ..teacher = teacher
        ..colorIndex = colorIndex;
    }
    _save();
    notifyListeners();
  }

  void deleteSubject(Subject s) {
    subjects.remove(s);
    tasks.removeWhere((t) => t.subjectId == s.id);
    _save();
    notifyListeners();
  }

  void saveTask({Task? existing, required String title, required int subjectId, required DateTime due}) {
    if (existing == null) {
      tasks.add(Task(id: _nextId(tasks.map((t) => t.id)), title: title, subjectId: subjectId, due: due));
    } else {
      existing
        ..title = title
        ..subjectId = subjectId
        ..due = due;
    }
    _save();
    notifyListeners();
  }

  void toggleTask(Task t) {
    t.done = !t.done;
    t.doneAt = t.done ? DateTime.now() : null;
    _save();
    notifyListeners();
  }

  void deleteTask(Task t) {
    tasks.remove(t);
    _save();
    notifyListeners();
  }

  double progressOf(Subject s) {
    final list = tasks.where((t) => t.subjectId == s.id).toList();
    if (list.isEmpty) return 0;
    return list.where((t) => t.done).length / list.length;
  }

  void _seed() {
    final now = DateTime.now();
    DateTime d(int days) => DateTime(now.year, now.month, now.day).add(Duration(days: days));
    subjects = [
      Subject(id: 1, name: 'Dispositivos Móveis', teacher: 'Prof. Vinicius', colorIndex: 0),
      Subject(id: 2, name: 'Banco de Dados II', teacher: 'Profa. Helena Costa', colorIndex: 1),
      Subject(id: 3, name: 'Redes de Computadores', teacher: 'Prof. Marcos Lima', colorIndex: 2),
      Subject(id: 4, name: 'Engenharia de Software', teacher: 'Profa. Ana Ribeiro', colorIndex: 3),
      Subject(id: 5, name: 'Estrutura de Dados', teacher: 'Prof. Paulo Nunes', colorIndex: 4),
    ];
    tasks = [
      Task(id: 1, title: 'Entrega final do app em Flutter', subjectId: 1, due: d(2)),
      Task(id: 2, title: 'Prova de Estrutura de Dados', subjectId: 5, due: d(1)),
      Task(id: 3, title: 'Modelagem ER do trabalho final', subjectId: 2, due: d(6)),
      Task(id: 4, title: 'Relatório de sub-redes', subjectId: 3, due: d(9)),
      Task(id: 5, title: 'Documento de requisitos', subjectId: 4, due: d(12)),
      Task(id: 6, title: 'Lista de árvores binárias', subjectId: 5, due: d(-1)),
      Task(id: 7, title: 'Backend com rotas GET e POST', subjectId: 1, due: d(-10), done: true, doneAt: d(-11)),
      Task(id: 8, title: 'Consultas com JOIN', subjectId: 2, due: d(-5), done: true, doneAt: d(-6)),
      Task(id: 9, title: 'Mapa do modelo OSI', subjectId: 3, due: d(-8), done: true, doneAt: d(-8)),
      Task(id: 10, title: 'Diagrama de casos de uso', subjectId: 4, due: d(-3), done: true, doneAt: d(-4)),
    ];
  }
}
