import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/models/task_mod.dart';
import 'package:tasklist_app/widgets/task_item.dart';
import 'package:tasklist_app/widgets/task_list.dart';
import 'package:tasklist_app/widgets/task_list_reorderable.dart';
import 'package:tasklist_app/widgets/task_new.dart';
import 'package:intl/intl.dart';

class TodayPage extends StatefulWidget {
  @override
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  List<TaskMod> _taskList = [];
  List<TaskMod> _dailyList = [];
  List<String> dateList = [];
  List<String> idList = [];
  List<String> dailyBuildList = [];
  String _iconName = 'check_circle_outline';
  String _dateTime;
  bool buildCalled = false;
  bool dateCalled = false;

  void _addNewTask(
    String _task,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final newTask = TaskMod(
      task: _task,
      iconName: _iconName,
      finish: null,
      id: DateTime.now().toString(),
    );
    prefs.setString('${newTask.id} Task', newTask.task);
    setState(() {
      _taskList.add(newTask);
      idList.add(newTask.id);
      prefs.setStringList('ID List', idList);
      buildCalled = true;
    });
  }

  void _deleteTask(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('page index') == 2) {
      setState(() {
        _taskList.removeWhere((taskR) => taskR.id == id);
        idList.remove(id);
        prefs.setStringList('ID List', idList);
        prefs.remove('$id Task');
      });
    }
  }

  void _deleteTask2(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('page index') == 2) {
      setState(() {
        _dailyList.removeWhere((taskR) => taskR.id == id);
        dailyBuildList.remove(id);
        prefs.setStringList('Daily Build List', dailyBuildList);
      });
    }
  }

  List<String> journalidList = [];
  void _completeTask(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('page index') == 2) {
      setState(() {
        List<String> taskidList = prefs.getStringList('ID List');
        if (prefs.getStringList('Journal ID List') != null) {
          journalidList = prefs.getStringList('Journal ID List');
        }
        prefs.setString('$id Icon Name', 'check_circle');
        prefs.setString('$id Date Finished',
            DateFormat.yMMMd().format(DateTime.now()).toString());
        prefs.setString('$id Time Finished',
            DateFormat.jm().format(DateTime.now()).toString());
        journalidList.add(id);
        prefs.setStringList('Journal ID List', journalidList);
        taskidList.remove(id);
        prefs.setStringList('ID List', taskidList);
      });
    }
  }

  void _completeTask2(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('page index') == 2) {
      setState(() {
        List<String> dailybuildList = prefs.getStringList('Daily Build List');
        if (prefs.getStringList('Journal ID List') != null) {
          journalidList = prefs.getStringList('Journal ID List');
          // print(journalidList);
        }
        String newId = DateTime.now().toString();
        prefs.setString('$newId Daily Task', prefs.getString('$id Daily Task'));
        // prefs.setString('$id Icon Name', 'check_circle');
        prefs.setString('$newId Date Finished',
            DateFormat.yMMMd().format(DateTime.now()).toString());
        prefs.setString('$newId Time Finished',
            DateFormat.jm().format(DateTime.now()).toString());
        journalidList.add(newId);
        prefs.setStringList('Journal ID List', journalidList);
        // print(journalidList);
        dailybuildList.remove(id);
        prefs.setStringList('Daily Build List', dailybuildList);
      });
    }
  }

  int count = 0;
  List<String> newBuildList = [];
  void datePrefs() async {
    setState(() {
      _dateTime = DateFormat.yMMMd().format(DateTime.now()).toString();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('Home Date List') != null) {
      dateList = prefs.getStringList('Home Date List');
    }
    setState(() {
      if (prefs.getString('Home Date') != null &&
          prefs.getString('Home Date') != _dateTime) {
        if (prefs.getStringList('Daily ID List') != null) {
          dailyBuildList = prefs.getStringList('Daily ID List');
          prefs.setStringList('Daily Build List', dailyBuildList);
        }

        // print('date prefs');

        prefs.setString(
            'Home Date', DateFormat.yMMMd().format(DateTime.now()).toString());
      } else {
        prefs.setString(
            'Home Date', DateFormat.yMMMd().format(DateTime.now()).toString());
      }
      dateCalled = true;
    });
  }

  bool buildDaily = false;
  void buildDailyListFunc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('Daily Build List') != null) {
      String id;
      dailyBuildList = prefs.getStringList('Daily Build List');
      for (id in dailyBuildList) {
        if (prefs.getString('$id Icon Name') != 'check_circle') {
          final dailyTask = TaskMod(
            task: prefs.getString('$id Daily Task'),
            iconName: _iconName,
            finish: null,
            id: id,
          );
          setState(() {
            _dailyList.add(dailyTask);
            buildCalled = true;
            if (prefs.getString('${dailyTask.id} Icon Name') != null) {
              dailyTask.iconName = prefs.getString('${dailyTask.id} Icon Name');
            }
          });
        } else {
          dailyBuildList.remove(id);
          prefs.setStringList('Daily Build List', dailyBuildList);
          List<String> journalIdList = prefs.getStringList('Journal ID List');
          journalIdList.add(id);
          prefs.setStringList('Journal ID List', journalIdList);
        }
      }
    }
    setState(() {
      buildDaily = true;
    });
  }

  void _buildTasks() async {
    buildCalled = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> calendarIdList = [];
    List<String> calendarIdList2 = [];
    String id;
    if (prefs.getStringList('Calendar ID List') != null) {
      calendarIdList = prefs.getStringList('Calendar ID List');
      calendarIdList2 = prefs.getStringList('Calendar ID List');
      for (id in calendarIdList) {
        if (prefs.getString('$id Calendar Date') == _dateTime) {
          setState(() {
            idList = prefs.getStringList('ID List');
            idList.add(id);
            prefs.setStringList('ID List', idList);
            calendarIdList2.remove(id);
            prefs.setStringList('Calendar ID List', calendarIdList2);
            prefs.setString('$id Task', prefs.getString('$id Calendar Task'));
            prefs.remove('$id Calendar Task');
            prefs.remove('$id Calendar Date');
          });
        }
      }
    }
    // List<String> dateList = prefs.getStringList('Home Date List');
    //     dateList.add(DateFormat.yMMMd().format(DateTime.now()).toString());
    //     prefs.setStringList('Home Date List', dateList);
    //     print('added 13');
    prefs.setInt('page index', 2);
    print(prefs.getInt('page index'));
    if (dailyBuildList != null) {
      if (buildDaily = false) {
        buildDailyListFunc();
      }
    }
    if (prefs.getStringList('ID List') != null) {
      String id;
      idList = prefs.getStringList('ID List');
      for (id in idList) {
        if (prefs.getString('$id Icon Name') != 'check_circle') {
          final newTask = TaskMod(
            task: prefs.getString('$id Task'),
            iconName: _iconName,
            finish: null,
            id: id,
          );
          setState(() {
            _taskList.add(newTask);
            buildCalled = true;
            if (prefs.getString('${newTask.id} Icon Name') != null) {
              newTask.iconName = prefs.getString('${newTask.id} Icon Name');
            }
          });
        } else {
          idList.remove(id);
          prefs.setStringList('ID List', idList);
          if (prefs.getStringList('Journal ID List') != null) {
            List<String> journalIdList = prefs.getStringList('Journal ID List');
            journalIdList.add(id);
            prefs.setStringList('Journal ID List', journalIdList);
          }
        }
      }
    }
  }

  Future<Null> refreshList() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      dailyBuildList = [];
      idList = [];
      _taskList = [];
      _dailyList = [];
      buildCalled = false;
      // _buildTasks();
    });
    print('refreshed');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    if (dateCalled == false) {
      datePrefs();
    }
    if (buildCalled == false) {
      _buildTasks();
      buildDailyListFunc();
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 15,
        brightness: Brightness.light,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Today's Tasks",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: RefreshIndicator(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Text(_dateTime),
              ),
              // Text(DateFormat.yMMMd().format(DateTime.now()).toString()),
              Container(
                height: MediaQuery.of(context).size.height / 2.8,
                child: TaskListWidget(_taskList, _deleteTask, _completeTask),
              ),
              Divider(
                height: MediaQuery.of(context).size.height / 50,
                color: Theme.of(context).accentColor,
                thickness: MediaQuery.of(context).size.height / 50,
                endIndent: 4.0,
                indent: 4.0,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2.73,
                child: TaskListWidget(_dailyList, _deleteTask2, _completeTask2),
              ),
            ],
          ),
        ),
        onRefresh: refreshList,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        splashColor: Theme.of(context).accentColor,
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt('page index', 2);
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
