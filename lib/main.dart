import 'package:flutter/material.dart';
import 'package:todo/models/todo_item.dart';

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
  final List<TodoItem> _todoItems = [];
  final TextEditingController _textFieldController = TextEditingController();

  int _selectedIndex = 0;

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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: (index) => {
          setState(() {
            _selectedIndex = index;
            })
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.open_in_new),
            title: Text('Unfinished'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.close),
            title: Text('Finished'),
          ),
        ]
      ),
    );
  }

  // Get all items
  Widget _buildTodoList() {
    List<TodoItem> filteredItems = getFilteredItems();

    return ReorderableListView(
      header: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Text(
            _selectedIndex == 0 ? "List of unfinished tasks" : "List of finished tasks",
            style: TextStyle(fontSize: 20),
          ),

        )
      ),
      children: [
        for (var i = 0; i < filteredItems.length; i++)
          _buildTodoItem(filteredItems[i], i)
      ],
      onReorder: _onReorder
    );
  }

  // Filtered Items
  List<TodoItem> getFilteredItems() {
    return _todoItems.where((item) {
      if (_selectedIndex == 0) {
        return !item.isFinished;
      } else {
        return item.isFinished;
      }
    }).toList();
  }

  // Build a single item
  Widget _buildTodoItem(TodoItem item, int index){
    return ListTile(
      key: Key(item.body), // a unique identifier, required by ReorderableListView, which will be used later
      title: Text(item.body),
      onTap: !item.isFinished ? () { _updateItemDialog(context, index, item); }  : null,
      trailing: Wrap(
        spacing: 12, // space between two icons
        children: <Widget>[
          IconButton(
            icon: Icon(item.isFinished ? Icons.check_box : Icons.check_box_outline_blank),
            onPressed: () => _promptToggleTodoItem(item),
          ),
          IconButton(icon: Icon(Icons.delete), onPressed: () => _confirmRemoveItem(index)),// icon-1
        ],
      ),
    );
  }

  // This will be called each time the + button is pressed
  void _addItem(String task){
    if(task.length > 0) {
      setState(() {
        _todoItems.add(TodoItem(body: task, isFinished: false, itemId: _todoItems.length + 1)
        );
      });
      _textFieldController.clear();
    }
  }

  // Check if task is finished
  void _toggleTodoItem(TodoItem item) {
    setState(() => item.isFinished = !item.isFinished);
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
      _todoItems[index] = TodoItem(body: task);
    });
  }

  // Show alert to confirm that task is done
  void _promptToggleTodoItem(TodoItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(item.isFinished ? 'Mark "${item.body}" as undone?' : 'Mark "${item.body}" as done?'),
          actions: <Widget>[
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                _toggleTodoItem(item);
                Navigator.of(context).pop();
              }
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      }
    );
  }

  // onReorder function
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      var getReplacedWidget = _todoItems.removeAt(oldIndex);
      _todoItems.insert(newIndex, getReplacedWidget);
    });
  }

  // Pop-up dialog to confirm removing item
  void _confirmRemoveItem(int index) {
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
  Future<AlertDialog> _updateItemDialog(BuildContext context, int index, TodoItem item) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update: ${item.body}"),
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

