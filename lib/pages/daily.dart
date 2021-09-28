import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/models/task_mod.dart';
import '../widgets/task_list.dart';
import '../widgets/task_new.dart';

class DailyPage extends StatefulWidget {
  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  List<TaskMod> _dailyList = [];
  List<String> dailyidList = [];
  List<String> dailyBuildList = [];
  bool buildCalled = false;
  String _iconName = 'check_circle_outline';

  void _deleteTask(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('page index') == 4) {
      setState(() {
        _dailyList.removeWhere((taskR) => taskR.id == id);
        dailyidList.remove(id);
        prefs.setStringList('Daily ID List', dailyidList);
        dailyBuildList.remove(id);
        prefs.setStringList('Daily Build List', dailyBuildList);
        prefs.remove('$id Daily Task');
      });
    }
  }

  void _completeTask(String id) async {
    print('daily complete task');
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   _dailyList.removeWhere((taskR) => taskR.id == id);
    //   dailyidList.remove(id);
    //   dailyBuildList.remove(id);
    //   prefs.setStringList('Daily Build List', dailyBuildList);
    //   prefs.setStringList('Daily ID List', dailyidList);
    //   prefs.remove('$id Daily Task');
    // });
  }

  void _addNewTask(
    String _task,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('page index') == 4) {
      final newTask = TaskMod(
        task: _task,
        iconName: _iconName,
        finish: null,
        id: DateTime.now().toString(),
      );
      prefs.setString('${newTask.id} Daily Task', newTask.task);
      setState(() {
        _dailyList.add(newTask);
        dailyidList.add(newTask.id);
        prefs.setStringList('Daily ID List', dailyidList);
        dailyBuildList.add(newTask.id);
        prefs.setStringList('Daily Build List', dailyBuildList);
        buildCalled = true;
      });
    }
  }

  void _buildTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('page index', 4);
    print(prefs.getInt('page index'));
    if (prefs.getStringList('Daily Build List') != null) {
      dailyBuildList = prefs.getStringList('Daily Build List');
    }
    if (prefs.getStringList('Daily ID List') != null) {
      String id;
      dailyidList = prefs.getStringList('Daily ID List');
      for (id in dailyidList) {
        if (prefs.getString('$id Icon Name') != 'check_circle') {
          final newTask = TaskMod(
            task: prefs.getString('$id Daily Task'),
            iconName: _iconName,
            finish: null,
            id: id,
          );
          setState(() {
            _dailyList.add(newTask);
            buildCalled = true;
            if (prefs.getString('${newTask.id} Icon Name') != null) {
              newTask.iconName = prefs.getString('${newTask.id} Icon Name');
            }
          });
        }
        // else {
        //   dailyidList.remove(id);
        //   prefs.setStringList('Daily ID List', dailyidList);
        //   List<String> journalIdList = prefs.getStringList('Journal ID List');
        //   journalIdList.add(id);
        //   prefs.setStringList('Journal ID List', journalIdList);
        // }
      }
    }
  }

  Future<Null> refreshList() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _dailyList = [];
      dailyidList = [];
      // dailyBuildList = [];
      buildCalled = false;
      // _buildTasks();
    });
    print('refreshed');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (buildCalled == false) {
      _buildTasks();
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 15,
        brightness: Brightness.light,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Daily Tasks",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: RefreshIndicator(
            child: TaskListWidget(_dailyList, _deleteTask, _completeTask),
            onRefresh: refreshList,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        splashColor: Theme.of(context).accentColor,
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt('page index', 4);
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return GestureDetector(
                onTap: () {},
                child: NewTask(_addNewTask),
                behavior: HitTestBehavior.opaque,
              );
            },
          );
        },
      ),
    );
  }
}
