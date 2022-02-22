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
  List<String> dateList = [];
  List<String> idList = [];
  List<String> goalsIdList = [];
  List<String> calendarIDlist = [];
  bool buildCalled = false;
  String _iconName = 'check_circle_outline';

  void _deleteTask(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.getInt('page index') == 4) {
    setState(() {
      _dailyList.removeWhere((taskR) => taskR.id == id);
      dailyidList.remove(id);
      prefs.setStringList('Daily ID List', dailyidList);
      dailyBuildList.remove(id);
      prefs.setStringList('Daily Build List', dailyBuildList);
      prefs.remove('$id Daily Task');
    });
    // }
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

  void _addNewTask(String _task, String _date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String selectedList = prefs.getString('selected list');
      if (selectedList == 'calendar') {
        prefs.setInt('page index', 3);
        _addNewCalendarTask(_task, _date);
      }
      if (selectedList == 'today') {
        prefs.setInt('page index', 2);
        _addTodayTask(_task);
      }
      if (selectedList == 'daily') {
        prefs.setInt('page index', 4);
        _addNewDailyTask(_task);
      }
      if (selectedList == 'goal') {
        prefs.setInt('page index', 1);
        _addNewGoal(_task);
      }
    });
  }

  void _addTodayTask(String _task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('ID List') != null) {
      idList = prefs.getStringList('ID List');
    }
    final newTask = TaskMod(
      task: _task,
      iconName: _iconName,
      finish: null,
      id: DateTime.now().toString(),
    );
    prefs.setString('${newTask.id} Task', newTask.task);
    setState(() {
      // _taskList.add(newTask);
      idList.add(newTask.id);
      prefs.setStringList('ID List', idList);
    });
  }

  void _addNewCalendarTask(
    String calendarTask,
    String date,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('Calendar ID List') != null) {
      calendarIDlist = prefs.getStringList('Calendar ID List');
    }
    // if (prefs.getInt('page index') == 3) {
    final newCalendarTask = TaskMod(
      task: calendarTask,
      iconName: _iconName,
      finish: date,
      id: DateTime.now().toString(),
    );
    prefs.setString(
        '${newCalendarTask.id} Calendar Task', newCalendarTask.task);
    prefs.setString(
        '${newCalendarTask.id} Calendar Date', newCalendarTask.finish);
    setState(() {
      // calendarList.add(newCalendarTask);
      calendarIDlist.add(newCalendarTask.id);
      prefs.setStringList('Calendar ID List', calendarIDlist);
    });
    // }
  }

  void _addNewDailyTask(
    String _task,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('Daily ID List') != null) {
      dailyidList = prefs.getStringList('Daily ID List');
    }
    if (prefs.getStringList('Daily Build List') != null) {
      dailyBuildList = prefs.getStringList('Daily Build List');
    }
    if (prefs.getInt('page index') == 4) {
      final newTask = TaskMod(
        task: _task,
        iconName: _iconName,
        finish: null,
        id: DateTime.now().toString(),
      );
      prefs.setString('${newTask.id} Daily Task', newTask.task);
      setState(() {
        dailyidList.add(newTask.id);
        prefs.setStringList('Daily ID List', dailyidList);
        dailyBuildList.add(newTask.id);
        prefs.setStringList('Daily Build List', dailyBuildList);
      });
    }
  }

  void _addNewGoal(
    String _task,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('Goal ID List') != null) {
      goalsIdList = prefs.getStringList('Goal ID List');
    }
    if (prefs.getInt('page index') == 1) {
      final newGoal = TaskMod(
        task: _task,
        iconName: _iconName,
        finish: null,
        id: DateTime.now().toString(),
      );
      prefs.setString('${newGoal.id} Goal Task', newGoal.task);
      setState(() {
        // _goalsList.add(newGoal);
        goalsIdList.add(newGoal.id);
        prefs.setStringList('Goal ID List', goalsIdList);
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
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 15,
        // brightness: Brightness.light,
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        title: Text(
          "Daily Tasks",
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: RefreshIndicator(
            color: Theme.of(context).dividerColor,
            child: TaskListWidget(_dailyList, _deleteTask, _completeTask),
            onRefresh: refreshList,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
