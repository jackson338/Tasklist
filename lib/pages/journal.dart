import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_mod.dart';
import 'package:tasklist_app/widgets/task_list.dart';

class JournalPage extends StatefulWidget {
  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<String> journalidList = [];
  List<TaskMod> _taskList = [];
  bool buildCalled = false;
  String name;

  void _buildTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('Folder Name');
    if (prefs.getStringList('Journal ID List') != null) {
      setState(() {
        journalidList =
            prefs.getStringList('Journal ID List').reversed.toList();
      });
      String id;
      // List<String> compare = [];
      // List<String> compare2 =
      //     prefs.getStringList('Journal ID List').reversed.toList();
      // for (id in compare2) {
      //   if (compare.contains(id)) {
      //     journalidList.remove(id);
      //     prefs.setStringList('Journal ID List', journalidList);
      //   }
      //   compare.add(id);
      // }

      for (id in journalidList) {
        if (prefs.getString('$id Date Finished') ==
            prefs.getString('Folder Name')) {
              //set task text
              String taskText;
              if (prefs.getString('$id Task') != null) {
                taskText = prefs.getString('$id Task');
              }
              if (prefs.getString('$id Daily Task') != null) {
                taskText = prefs.getString('$id Daily Task');
              }
              if (prefs.getString('$id Calendar Task') != null) {
                taskText = prefs.getString('$id Calendar Task');
              }
              if (prefs.getString('$id Goal Task') != null) {
                taskText = prefs.getString('$id Goal Task');
              }

          final newTask = TaskMod(
            task: taskText,
            iconName: 'check_circle',
            finish: prefs.getString('$id Time Finished'),
            id: id,
          );
          setState(() {
            _taskList.add(newTask);
            buildCalled = true;
          });
        }
      }
    }
  }

  void _deleteTask(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('page index') == 5) {
      setState(() {
        _taskList.removeWhere((taskR) => taskR.id == id);
        journalidList.remove(id);
        prefs.setStringList('Journal ID List', journalidList);
      });
    }
  }

  void _completeTask(String id) {
    print('complete');
  }

  @override
  Widget build(BuildContext context) {
    if (buildCalled == false) {
      _buildTasks();
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          name,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: TaskListWidget(_taskList, _deleteTask, _completeTask,ValueKey(1)),
    );
  }
}
