import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('todoBox'); 
  await Hive.openBox('todo');// Opening the todoBox for storage
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoPage(),
    );
  }
}

class TodoPage extends StatelessWidget {
  final Box todoBox = Hive.box('todoBox');
  
  
  void _showDeleteDialog(BuildContext content , int index){
    showDialog(
      context: content, 
      builder: (BuildContext  content){
        return AlertDialog(
          title: Text("ARE YOU SURE?"),
          content: Text("Dop you really want to delete Your information? You will not be able to undo this action"),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(content).pop();
            }, child: Text("NO")),
            TextButton(
              onPressed: () {
                todoBox.deleteAt(index);  // Delete the item from the Hive box
                Navigator.of(content).pop();  // Close the dialog after deletion
              },
              child: Text('YES'),
            ),
          ],
        );
      });
  } // Accessing todoBox

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO APP' ,style: TextStyle(fontSize: 24),),
        actions: [Icon(Icons.calendar_today)],
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Container(
          decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 7, 32, 68), const Color.fromARGB(255, 182, 204, 223)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
            
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              // Button to add a task
              ElevatedButton(
                onPressed: () {
                  // Navigate to the Add Task screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddTaskPage()),
                  );
                },
                child: Text('Add Task'),
              ),
              // Display tasks
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: todoBox.listenable(),
                  builder: (context, Box box, _) {
                    List tasks = box.values.toList();
                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text(tasks[index]),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Edit button
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.orange),
                                  onPressed: () {
                                    // Navigate to the Edit Task screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditTaskPage(
                                          index: index,
                                          task: tasks[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // Delete button
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    // Delete task
                                    // box.deleteAt(index);
                                    _showDeleteDialog(context, index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _controller = TextEditingController();
  final Box todoBox = Hive.box('todoBox');

  void _addTask() {
    if (_controller.text.isNotEmpty) {
      todoBox.add(_controller.text);  // Add task to the todoBox
      Navigator.pop(context);  // Go back to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Container(
         
          decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 7, 32, 68), const Color.fromARGB(255, 182, 204, 223)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          ),  
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                
                controller: _controller,
                style: TextStyle(color: Colors.white ,),
                decoration: InputDecoration(
                  labelText: 'Task Detail',
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.edit)
                  ),
                  
                
                
              ),
              
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addTask,
                child: Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditTaskPage extends StatefulWidget {
  final int index;
  final String task;

  EditTaskPage({required this.index, required this.task});

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final TextEditingController _controller = TextEditingController();
  final Box todoBox = Hive.box('todoBox');

  @override
  void initState() {
    super.initState();
    _controller.text = widget.task;  // Pre-fill with the current task
  }

  void _editTask() {
    if (_controller.text.isNotEmpty) {
      todoBox.putAt(widget.index, _controller.text);  // Update task
      Navigator.pop(context);  // Go back to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Task')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Edit Task'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _editTask,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
