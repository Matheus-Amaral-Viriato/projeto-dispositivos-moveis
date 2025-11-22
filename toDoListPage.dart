import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

class ToDoListPage extends StatefulWidget {
  final DateTime selectedDate;

  ToDoListPage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  DatabaseReference database = FirebaseDatabase.instance.ref();

  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasksFromFirebase();
  }

  void _loadTasksFromFirebase() async {
    String date =
        '${widget.selectedDate.day}-${widget.selectedDate.month}-${widget.selectedDate.year}';

    DatabaseReference dayRef = database.child("calendar/$date");

    dayRef.onValue.listen((event) {
      tasks.clear();

      if (event.snapshot.value != null) {
        Map data = event.snapshot.value as Map;

        data.forEach((key, value) {
          Task t = Task(
            name: value['name'],
            isCompleted: value['isCompleted'],
            idFirebase: key,
          );
          tasks.add(t);
        });
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lista de Tarefas - ${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}",
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: ListView.builder(
                key: ValueKey<int>(tasks.length),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      tasks[index].name,
                      style: TextStyle(
                        decoration: tasks[index].isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    leading: Icon(
                      tasks[index].isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: tasks[index].isCompleted
                          ? Colors.green
                          : Colors.red,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditTaskDialog(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () {
                            _toggleTaskCompletion(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _removeTask(index);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showAddTaskDialog(context);
                  },
                  child: Text("Adicionar Tarefa"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showRemoveAllTasksDialog(context);
                  },
                  child: Text("Remover Todas as Tarefas"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(int index) {
    String updatedName = tasks[index].name;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Tarefa'),
          content: TextField(
            controller: TextEditingController(text: tasks[index].name),
            onChanged: (value) {
              updatedName = value;
            },
            decoration: InputDecoration(hintText: "Novo nome da tarefa"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (updatedName.trim().isNotEmpty) {
                  _updateTaskName(index, updatedName.trim());
                }
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    String newTaskName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Tarefa'),
          content: TextField(
            onChanged: (value) {
              newTaskName = value;
            },
            decoration: InputDecoration(hintText: "Nome da Tarefa"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (newTaskName.isNotEmpty) {
                  _addTaskFirebase(newTaskName);
                }
                Navigator.pop(context);
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _updateTaskName(int index, String newName) {
    final task = tasks[index];

    String date =
        '${widget.selectedDate.day}-${widget.selectedDate.month}-${widget.selectedDate.year}';

    database.child("calendar/$date/${task.idFirebase}").update({
      'name': newName,
    });
  }

  void _addTaskFirebase(String name) {
    String date =
        '${widget.selectedDate.day}-${widget.selectedDate.month}-${widget.selectedDate.year}';

    DatabaseReference ref = database.child("calendar/$date").push();

    ref.set({"name": name, "isCompleted": false});
  }

  void _toggleTaskCompletion(int index) {
    Task task = tasks[index];
    bool newStatus = !task.isCompleted;

    String date =
        '${widget.selectedDate.day}-${widget.selectedDate.month}-${widget.selectedDate.year}';

    database.child("calendar/$date/${task.idFirebase}").update({
      "isCompleted": newStatus,
    });
  }

  void _removeTask(int index) {
    Task task = tasks[index];

    String date =
        '${widget.selectedDate.day}-${widget.selectedDate.month}-${widget.selectedDate.year}';

    database.child("calendar/$date/${task.idFirebase}").remove();
  }

  void _showRemoveAllTasksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remover Todas as Tarefas'),
          content: Text('Tem certeza que deseja remover todas as tarefas?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _removeAllTasksFirebase();
                Navigator.pop(context);
              },
              child: Text('Remover Todas'),
            ),
          ],
        );
      },
    );
  }

  void _removeAllTasksFirebase() {
    String date =
        '${widget.selectedDate.day}-${widget.selectedDate.month}-${widget.selectedDate.year}';

    database.child("calendar/$date").remove();
  }
}

class Task {
  String name;
  bool isCompleted;
  String idFirebase;

  Task({
    required this.name,
    required this.isCompleted,
    required this.idFirebase,
  });
}
