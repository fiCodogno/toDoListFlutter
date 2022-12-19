import 'package:flutter/material.dart';
import 'package:to_do_list/views/task_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.deepPurple.shade900,
      debugShowCheckedModeBanner: false,
      home: ToDoListPage(),
      title: 'Lista de Tarefas',
    );
  }
}
