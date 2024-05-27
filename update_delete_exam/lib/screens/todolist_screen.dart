import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../models/todo.dart';

class TodoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo List'),
      ),
      body: todoProvider.todos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: todoProvider.todos.length,
              itemBuilder: (context, index) {
                final todo = todoProvider.todos[index];
                return ListTile(
                  title: Text(todo.title),
                  leading: Checkbox(
                    value: todo.completed,
                    onChanged: (value) {
                      todoProvider.toggleTodoCompletion(todo);
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editTodoDialog(context, todo),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => todoProvider.deleteTodo(todo.id),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  void _editTodoDialog(BuildContext context, Todo todo) {
    final titleController = TextEditingController(text: todo.title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ToDo'),
        content: TextField(
          controller: titleController,
          decoration: InputDecoration(labelText: 'Title'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                todo.title = titleController.text;
                await Provider.of<TodoProvider>(context, listen: false)
                    .updateTodo(todo);
                Navigator.of(context).pop();
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
