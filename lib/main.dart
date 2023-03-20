import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:toast/toast.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Список справ',
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  final TextEditingController textFieldController = TextEditingController();
  final List<Todo> todosave = <Todo>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: const Text('Список справ'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: todosave.map((Todo todo) {
          return TodoElement(
            todo: todo,
            onTodoChanged: todoChange,
            onTodoRemove: todoRemove,
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => addDialog(),
          tooltip: 'Додати задачу',
          child: const Icon(Icons.add)),
    );
  }

  void todoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }

  void todoRemove(Todo todo) {
    setState(() {
      todosave.remove(todo);
    });
  }

  void addTodoElement(String name) {
    setState(() {
      todosave.add(Todo(name: name, checked: false));
    });
    textFieldController.clear();
  }

  Future<void> addDialog() async {
    // ToastContext().init(context);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Додавання справи'),
          content: TextField(
            controller: textFieldController,
            decoration:
                const InputDecoration(hintText: 'Введіть нове завдання'),
          ),
          actions: [
            TextButton(
              child: const Text('Додати'),
              onPressed: () {
                if (textFieldController.text.trim().isNotEmpty) {
                  Navigator.of(context).pop();
                  addTodoElement(textFieldController.text.trim());
                } else {
                  // Toast.show("Are you nuts?", gravity: Toast.center);
                  // Navigator.of(context).pop();
                  // Fluttertoast.showToast(
                  //     msg: "Are you nuts?",
                  //     toastLength: Toast.LENGTH_SHORT,
                  //     gravity: ToastGravity.CENTER,
                  //     timeInSecForIosWeb: 1,
                  //     backgroundColor: Colors.red,
                  //     textColor: Colors.white,
                  //     fontSize: 16.0);
                  FlutterToastr.show(
                    "Неможна додати порожнє поле. Введіть текст або натисніть \"Скасувати\"",
                    context,
                    duration: FlutterToastr.lengthShort,
                    position: FlutterToastr.center,
                  );
                }
              },
            ),
            TextButton(
              child: const Text(
                'Скасувати',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class Todo {
  Todo({required this.name, required this.checked});
  final String name;
  bool checked;
}

class TodoElement extends StatelessWidget {
  final Todo todo;
  final onTodoChanged;
  final onTodoRemove;

  TodoElement({
    required this.todo,
    required this.onTodoChanged,
    required this.onTodoRemove,
  });

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTodoChanged(todo);
      },
      onLongPress: () {
        onTodoRemove(todo);
      },
      child: ListTile(
        leading: CircleAvatar(
          child: Text(todo.name.isEmpty ? '?' : todo.name[0]),
        ),
        title: Text(
          todo.name,
          style:
              // todo.name.toUpperCase() == 'ВБИТИ ПУТІНА'
              //     ? const TextStyle(
              //         fontSize: 24,
              //         color: Colors.red,
              //         fontWeight: FontWeight.w700)
              // :
              _getTextStyle(todo.checked),
        ),
      ),
    );
  }
}
