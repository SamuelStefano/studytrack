import 'package:flutter/material.dart';

const subjectColors = <Color>[
  Color(0xFF2563EB),
  Color(0xFF7C3AED),
  Color(0xFF0891B2),
  Color(0xFFDB2777),
  Color(0xFFF79009),
  Color(0xFF12B76A),
];

class Subject {
  final int id;
  String name;
  String teacher;
  int colorIndex;

  Subject({required this.id, required this.name, required this.teacher, required this.colorIndex});

  Color get color => subjectColors[colorIndex % subjectColors.length];

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'teacher': teacher, 'color': colorIndex};

  factory Subject.fromJson(Map<String, dynamic> j) =>
      Subject(id: j['id'], name: j['name'], teacher: j['teacher'], colorIndex: j['color']);
}

class Task {
  final int id;
  String title;
  int subjectId;
  DateTime due;
  bool done;
  DateTime? doneAt;

  Task({required this.id, required this.title, required this.subjectId, required this.due, this.done = false, this.doneAt});

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subjectId': subjectId,
        'due': due.toIso8601String(),
        'done': done,
        'doneAt': doneAt?.toIso8601String(),
      };

  factory Task.fromJson(Map<String, dynamic> j) => Task(
        id: j['id'],
        title: j['title'],
        subjectId: j['subjectId'],
        due: DateTime.parse(j['due']),
        done: j['done'] ?? false,
        doneAt: j['doneAt'] == null ? null : DateTime.parse(j['doneAt']),
      );
}

class AppUser {
  final String name;
  final String email;
  final String passwordHash;

  AppUser({required this.name, required this.email, required this.passwordHash});

  Map<String, dynamic> toJson() => {'name': name, 'email': email, 'hash': passwordHash};

  factory AppUser.fromJson(Map<String, dynamic> j) =>
      AppUser(name: j['name'], email: j['email'], passwordHash: j['hash']);
}
