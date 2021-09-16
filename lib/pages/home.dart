import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/models/task_mod.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TaskMod> tasks = [];
  int count = 1;
  bool buildCalled = false;

  void buildTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int i = 0;
    while (i < 10) {
      setState(() {
        final newTask = TaskMod(
          task: '$count',
          iconName: 'check_circle_outline',
          finish: null,
          id: '$count',
        );
        tasks.add(newTask);
        count++;
        i++;
      });
    }
  }

  Widget buildTaskList(int index, TaskMod task) => ListTile(
        key: ValueKey(task.id),
        title: Text(task.task),
        
      );

  @override
  Widget build(BuildContext context) {
    if (buildCalled == false) {
      buildTasks();
      buildCalled = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ReorderableListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return buildTaskList(index, task);
        },
        onReorder: (oldIndex, newIndex) => setState(() {
          final index = newIndex > oldIndex ? newIndex - 1 : newIndex;

          final task = tasks.removeAt(oldIndex);
          tasks.insert(index, task);
        }),
      ),
    );
  }
}
