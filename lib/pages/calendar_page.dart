import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/models/task_mod.dart';
import 'package:tasklist_app/widgets/task_list.dart';
import 'package:tasklist_app/widgets/task_new.dart';

class FuturePage extends StatefulWidget {
  @override
  _FuturePageState createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  List<TaskMod> calendarList = [];
  List<String> calendarIDlist = [];
  List<String> journalidList = [];
  List<String> dailyidList = [];
  List<String> dailyBuildList = [];
  List<String> dateList = [];
  List<String> idList = [];
  List<String> goalsIdList = [];
  String _iconName = 'check_circle_outline';
  String _dateTime = DateFormat.yMMMEd().format(DateTime.now()).toString();
  bool buildCalled = false;
  bool initialRefresh = false;

  void _deleteTask(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.getInt('page index') == 3) {
    setState(() {
      calendarList.removeWhere((taskR) => taskR.id == id);
      calendarIDlist.remove(id);
      prefs.setStringList('Calendar ID List', calendarIDlist);
      prefs.remove('$id Calendar Task');
      prefs.remove('$id Calendar Date');
    });
    // }
  }

  void _completeCalendarTask(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('page index') == 3) {
      setState(() {
        List<String> calendaridList = prefs.getStringList('Calendar ID List');
        if (prefs.getStringList('Journal ID List') != null) {
          journalidList = prefs.getStringList('Journal ID List');
        }
        prefs.setString('$id Icon Name', 'check_circle');
        prefs.setString(
            '$id Date Finished', DateFormat.yMMMd().format(DateTime.now()).toString());
        prefs.setString(
            '$id Time Finished', DateFormat.jm().format(DateTime.now()).toString());
        journalidList.add(id);
        prefs.setStringList('Journal ID List', journalidList);
        calendaridList.remove(id);
        prefs.setStringList('Calendar ID List', calendaridList);
      });
    }
  }

  void _addNewTask(String _task, String _date, DateTime pickDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String selectedList = prefs.getString('selected list');
      if (selectedList == 'calendar') {
        prefs.setInt('page index', 3);
        _addNewCalendarTask(_task, _date, pickDate);
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
    DateTime _dateTime,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('Calendar ID List') != null) {
      calendarIDlist = prefs.getStringList('Calendar ID List');
    }
    final int _year = _dateTime.year;
    final int _month = _dateTime.month;
    final int _day = _dateTime.day;
    // print(_dateTime.day);
    final newCalendarTask = TaskMod(
      task: calendarTask,
      iconName: _iconName,
      finish: date,
      id: DateTime.now().toString(),
      year: _year,
      month: _month,
      day: _day,
    );
    prefs.setString('${newCalendarTask.id} Calendar Task', newCalendarTask.task);
    prefs.setString('${newCalendarTask.id} Calendar Date', newCalendarTask.finish);
    prefs.setInt('${newCalendarTask.id} year', _year);
    prefs.setInt('${newCalendarTask.id} month', _month);
    prefs.setInt('${newCalendarTask.id} day', _day);
    setState(() {
      // calendarList.add(newCalendarTask);
      calendarIDlist.add(newCalendarTask.id);
      prefs.setStringList('Calendar ID List', calendarIDlist);
    });
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

  void reorderTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int i = 0;
    while (i < (calendarIDlist.length)) {
      i++;
      List<String> newList = calendarIDlist;
      for (String sortingTask in newList) {
        if (prefs.getInt('$sortingTask year') != null) {
          int yearCount = prefs.getInt('$sortingTask year');
          int monthCount = prefs.getInt('$sortingTask month');
          int dayCount = prefs.getInt('$sortingTask day');
          bool moved = false;
          for (String comparingTask in calendarIDlist) {
            if (prefs.getInt('$comparingTask year') != null) {
              if (yearCount < prefs.getInt('$comparingTask year') && moved == false) {
                int newInd =
                    calendarIDlist.indexWhere((element) => element == comparingTask);
                calendarIDlist.remove(sortingTask);
                calendarIDlist.insert(newInd == 0 ? newInd : newInd - 1, sortingTask);
                moved = true;
              } else if (yearCount == prefs.getInt('$comparingTask year') &&
                  moved == false) {
                if (monthCount < prefs.getInt('$comparingTask month')) {
                  int newInd =
                      calendarIDlist.indexWhere((element) => element == comparingTask);
                  calendarIDlist.remove(sortingTask);
                  calendarIDlist.insert(newInd == 0 ? newInd : newInd - 1, sortingTask);
                  moved = true;
                } else if (monthCount == prefs.getInt('$comparingTask month') &&
                    moved == false) {
                  // print('dayCount: $dayCount');
                  // print('compareDayCount: ${prefs.getInt('$comparingTask day')}');
                  if (dayCount < prefs.getInt('$comparingTask day')) {
                    int newInd =
                        calendarIDlist.indexWhere((element) => element == comparingTask);
                    calendarIDlist.remove(sortingTask);
                    calendarIDlist.insert(newInd == 0 ? newInd : newInd - 1, sortingTask);
                    // print('day inserted at index: $newInd day val: ${prefs.getInt('${calendarIDlist[newInd -1]} day')}');
                    moved = true;
                  } else if (dayCount == prefs.getInt('$comparingTask day') &&
                      moved == false) {
                    int newInd =
                        calendarIDlist.indexWhere((element) => element == comparingTask);
                    calendarIDlist.remove(sortingTask);
                    calendarIDlist.insert(newInd, sortingTask);
                    // print('day inserted at index: $newInd day val: ${prefs.getInt('${calendarIDlist[newInd -1]} day')}');
                    moved = true;
                  }
                }
              }
            }
          }
        }
      }
    }
    prefs.setStringList('Calendar ID List', calendarIDlist);
  }

  void _buildCalendarTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('page index', 3);
    if (prefs.getStringList('Calendar ID List') != null) {
      calendarIDlist = prefs.getStringList('Calendar ID List');
      reorderTasks();
      for (String id in calendarIDlist) {
        if (prefs.getString('$id Icon Name') != 'check_circle') {
          final newCalendarTask = TaskMod(
            task: prefs.getString('$id Calendar Task'),
            iconName: _iconName,
            finish: prefs.getString('$id Calendar Date'),
            id: id,
            year: prefs.getInt('$id year') != null ? prefs.getInt('$id year') : 0,
          );
          setState(() {
            // _dateTime = DateFormat.yMMMd().format(DateTime.now()).toString();
            calendarList.add(newCalendarTask);
            buildCalled = true;
            if (prefs.getString('${newCalendarTask.id} Icon Name') != null) {
              newCalendarTask.iconName =
                  prefs.getString('${newCalendarTask.id} Icon Name');
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
      calendarList = [];
      calendarIDlist = [];
      buildCalled = false;
      // _buildTasks();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (buildCalled == false) {
      _buildCalendarTasks();
      if (initialRefresh == false) {
        refreshList();
        initialRefresh = true;
      }
    }
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 15,
        // brightness: Brightness.light,
        backgroundColor: Theme.of(context).backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).dividerColor,
          ),
        ),
        elevation: 0,
        title: Text(
          "Calendar Tasks",
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: RefreshIndicator(
        color: Theme.of(context).dividerColor,
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  _dateTime,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1.35,
                child: TaskListWidget(calendarList, _deleteTask, _completeCalendarTask),
              ),
            ],
          ),
        ),
        onRefresh: refreshList,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        splashColor: Theme.of(context).dividerColor,
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt('page index', 3);
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
