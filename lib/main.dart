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
  final List<String> _todoItems = [];
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
  Widget _buildTodoItem(String taskTitle, int index){
    return ListTile(
      title: Text(taskTitle),
      trailing: Wrap(
        spacing: 12, // space between two icons
        children: <Widget>[
          IconButton(icon: Icon(Icons.delete), onPressed: () => _confirmRemoveItem(index)), // icon-1
          IconButton(icon: Icon(Icons.edit), onPressed: () => _updateItemDialog(context, index, taskTitle)), // icon-2
        ],
      ),
    );
  }

  // This will be called each time the + button is pressed
  void _addItem(String task){
    setState(() {
      _todoItems.add(task);
    });
    _textFieldController.clear();
  }

  // Remove item from array
  void _removeItem(int index){
    setState(() {
      _todoItems.removeAt(index);
    });
  }

  // Update item in array
  void _updateItem(int index, String task){
    setState(() {
      _todoItems[index] = task;
    });
  }

  // Pop-up dialog to confirm removing item
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

  // Update Item dialog
  Future<AlertDialog> _updateItemDialog(BuildContext context, int index, String taskTitle) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        print("$taskTitle");
        return AlertDialog(
          title: Text("Update: $taskTitle"),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Enter new value here..."),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text("Add"),
              onPressed: () {
                _updateItem(index, _textFieldController.text);
                _textFieldController.clear();
                Navigator.of(context).pop();
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

