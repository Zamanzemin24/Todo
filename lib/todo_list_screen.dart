import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do App'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<String>('todoBox').listenable(),
        builder: (context, Box<String> box, _) {
          var tasks = box.values.toList();
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(tasks[index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _controller.text = tasks[index];
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Edit Task'),
                            content: TextField(
                              controller: _controller,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  if (_controller.text.isNotEmpty) {
                                    box.putAt(index, _controller.text);
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text('Save'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        box.deleteAt(index);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.clear();
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Add New Task'),
              content: TextField(
                controller: _controller,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      var box = Hive.box<String>('todoBox');
                      box.add(_controller.text);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Add'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
