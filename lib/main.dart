import 'package:flutter/material.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'ToDo List', home: ToDoList());
  }
}

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final List<String> _todoItems = <String>[];
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ToDo List")),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(context),
        tooltip: "Add Task",
        child: Icon(Icons.add),
      ),
    );
  }

  // Get all items
  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: _todoItems.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: _buildTodoItem(_todoItems[index], index)
        );
      }
    );
  }

  // Build a single item
  Widget _buildTodoItem(String title, int index){
    return ListTile(
      title: Text(title),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => _confirmRemoveItem(index),
      ),
    );
  }

  // This will be called each time the + button is pressed
  void _addItem(String title){
    setState(() {
      _todoItems.add(title);
    });
    _textFieldController.clear();
  }

  // Remove item from array
  void _removeItem(int index){
    setState(() {
      _todoItems.removeAt(index);
    });
  }

  void _confirmRemoveItem (int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Remove Task"),
          actions: <Widget>[
            FlatButton(
              child: const Text("Remove"),
              onPressed: () {
                _removeItem(index);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text("Cancel"),
              onPressed: () =>  Navigator.of(context).pop()
            )
          ],
        );
      }
    );
  }

  // Popup dialog for creating a single item
  Future<AlertDialog> _showDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add task to list"),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: "Enter task here..."),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text("Add"),
              onPressed: () {
                Navigator.of(context).pop();
                _addItem(_textFieldController.text);
              },
            ),
            FlatButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
                _textFieldController.clear();
              },
            )
          ],
        );
      }
    );
  }
}

