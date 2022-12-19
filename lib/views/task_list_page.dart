import 'package:flutter/material.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/repositories/task_repository.dart';
import 'package:to_do_list/widgets/task_list_item.dart';

class ToDoListPage extends StatefulWidget {
  ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  final TextEditingController taskController = TextEditingController();
  final TaskRepository taskRepository = TaskRepository();

  String? errorMessage;

  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();

    taskRepository.getTaskList().then((value) {
      setState(() {
        tasks = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.deepPurple.shade900,
                        controller: taskController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple.shade900,
                              width: 2,
                            ),
                          ),
                          border: const OutlineInputBorder(),
                          labelText: 'Adicione uma Tarefa',
                          labelStyle: TextStyle(
                            color: Colors.deepPurple.shade900,
                          ),
                          hintText: 'Escreva aqui...',
                          errorText: errorMessage,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (taskController.text.isEmpty) {
                            setState(() {
                              errorMessage = "Campo Obrigatório!";
                            });
                            return;
                          }
                          setState(() {
                            Task task = Task(
                                title: taskController.text,
                                dateTime: DateTime.now());
                            tasks.add(task);
                          });
                          errorMessage = null;
                          taskController.clear();
                          taskRepository.saveTaskList(tasks);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.deepPurple.shade900,
                            padding: const EdgeInsets.all(14)),
                        child: const Icon(Icons.add, size: 30))
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Task task in tasks)
                        TaskListItem(
                          task: task,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Você tem ${tasks.length} tarefas pendentes',
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                        onPressed: showAllTasksDeleteConfirmationDialog,
                        style: ElevatedButton.styleFrom(
                            primary: Colors.deepPurple.shade900,
                            padding: const EdgeInsets.all(14)),
                        child: const Text(
                          'Limpar Tudo',
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Task task) {
    int index = tasks.indexOf(task);

    setState(() {
      tasks.remove(task);
    });
    taskRepository.saveTaskList(tasks);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Tarefa ${task.title} removida com sucesso!',
          style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.deepPurple.shade900,
      action: SnackBarAction(
        label: 'Desfazer',
        textColor: Colors.white,
        onPressed: () {
          setState(() {
            tasks.insert(index, task);
          });
          taskRepository.saveTaskList(tasks);
        },
      ),
      duration: const Duration(seconds: 5),
    ));
  }

  void showAllTasksDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar todas as Tarefas?'),
        content: const Text(
            'Você tem certeza de que deseja apagar todas as tarefas?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Color.fromARGB(255, 55, 52, 255)),
              )),
          TextButton(
              onPressed: () {
                setState(() {
                  tasks.clear();
                });
                taskRepository.saveTaskList(tasks);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Limpar Tudo',
                style: TextStyle(color: Color.fromARGB(255, 255, 17, 0)),
              )),
        ],
      ),
    );
  }
}
