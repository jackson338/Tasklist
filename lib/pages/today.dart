// import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/models/goal_mod.dart';
import 'package:tasklist_app/models/task_mod.dart';
// import 'package:tasklist_app/widgets/task_item.dart';
import 'package:tasklist_app/widgets/task_list.dart';
// import 'package:tasklist_app/widgets/task_list_reorderable.dart';
import 'package:intl/intl.dart';

class TodayPage extends StatefulWidget {
  @override
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  List<TaskMod> _dailyList = [];
  List<TaskMod> _taskList = [];
  List<String> idList = [];
  List<String> dateList = [];
  List<String> dailyBuildList = [];
  List<String> dailyidList = [];
  List<String> goalsIdList = [];
  List<String> newBuildList = [];
  // List<TaskMod> calendarList = [];
  List<String> calendarIDlist = [];
  String _iconName = 'check_circle_outline';
  String _dateTime;
  bool buildCalled = false;
  bool dateCalled = false;
  bool dailySelected = false;
  bool todaySelected = true;
  int count = 0;

  void _deleteTask(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.getInt('page index') == 2) {
    setState(() {
      _taskList.removeWhere((taskR) => taskR.id == id);
      idList.remove(id);
      prefs.setStringList('ID List', idList);
      prefs.remove('$id Task');
    });
    // }
  }

  void _deleteTask2(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.getInt('page index') == 2) {
    setState(() {
      _dailyList.removeWhere((taskR) => taskR.id == id);
      dailyBuildList.remove(id);
      prefs.setStringList('Daily Build List', dailyBuildList);
    });
    // }
  }

  List<String> journalidList = [];
  void _completeTask(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
      _taskList.removeWhere((taskC) => taskC.id == id);
    });
  }

  List<String> chartIds = [];
  double totalCompleted = 0.0;
  void _completeTask2(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _taskList.removeWhere((taskC) => taskC.id == id);
      prefs.setBool('dateChange', false);
      // String idc = DateTime.now().toString();
      if (prefs.getStringList('chart ids') != null) {
        chartIds = prefs.getStringList('chart ids');
      }
      if (chartIds.contains(_dateTime) == false) {
        chartIds.add(_dateTime);
        prefs.setStringList('chart ids', chartIds);
      }

      if (prefs.getStringList('Daily Build List').length != null) {
        int totalCompletedInt = prefs.getStringList('Daily ID List').length -
            prefs.getStringList('Daily Build List').length;
        totalCompleted = 0;
        totalCompleted += totalCompletedInt;
      } else {
        int totalCompletedInt = prefs.getStringList('Daily ID List').length;
        totalCompleted = 0;
        totalCompleted += totalCompletedInt;
      }
      prefs.setInt('$_dateTime daily build count',
          prefs.getStringList('Daily Build List').length);
      prefs.setDouble('$_dateTime total completed', totalCompleted);
      List<String> dailybuildList = prefs.getStringList('Daily Build List');
      if (prefs.getStringList('Journal ID List') != null) {
        journalidList = prefs.getStringList('Journal ID List');
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
      dailybuildList.remove(id);
      prefs.setStringList('Daily Build List', dailybuildList);
      _dailyList.removeWhere((taskC) => taskC.id == id);
    });
  }

  void datePrefs() async {
    print('date prefs called');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getBool('today list selected') == true) {
        todaySelected = true;
        dailySelected = false;
      } else {
        todaySelected = false;
        dailySelected = true;
      }
      // _dateTime = DateFormat.yMMMd().format(
      //   DateTime.utc(2021, 10, 5),
      // );
      if (prefs.getStringList('Home Date List') != null) {
        dateList = prefs.getStringList('Home Date List');
      }
      _dateTime = DateFormat.yMMMEd().format(DateTime.now()).toString();
      if (prefs.getString('Home Date') != null &&
          prefs.getString('Home Date') != _dateTime) {
            prefs.setBool('dateChange', false);
        //setting daily count max number
        if (prefs.getStringList('Daily ID List') != null) {
          prefs.setInt('$_dateTime daily count',
              prefs.getStringList('Daily ID List').length);
        }
        if (prefs.getStringList('Daily Build List') != null) {
          prefs.setInt('$_dateTime daily build count',
              prefs.getStringList('Daily Build List').length);
        }
        if (prefs.getStringList('Daily ID List') != null) {
          dailyBuildList = prefs.getStringList('Daily ID List');
          prefs.setStringList('Daily Build List', dailyBuildList);
          // buildDailyListFunc();
        }

        prefs.setString(
            'Home Date', DateFormat.yMMMEd().format(DateTime.now()).toString());
      } else {
        prefs.setString(
            'Home Date', DateFormat.yMMMEd().format(DateTime.now()).toString());
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
            buildDaily = true;
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
  }

  void _buildTasks() async {
    print('build Tasks Called');
    buildCalled = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('Daily Build List') != null) {
      prefs.setInt('$_dateTime daily build count',
          prefs.getStringList('Daily Build List').length);
    }
    if (prefs.getStringList('Daily ID List') != null) {
      prefs.setInt('$_dateTime daily count',
          prefs.getStringList('Daily ID List').length);
    }
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
            // idList.add(id);
            idList.insert(0, id);
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
    prefs.setInt('page index', 2);
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

  void _onChanged(bool) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (todaySelected == false) {
        todaySelected = true;
        dailySelected = false;
        prefs.setBool('today list selected', true);
      } else {
        todaySelected = false;
        dailySelected = true;
        prefs.setBool('today list selected', false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (dateCalled == false) {
      datePrefs();
    }
    if (buildCalled == false) {
      _buildTasks();
      buildDailyListFunc();
    }
    print('id list length: ${idList.length}');
    print('tasklist length: ${_taskList.length}');
    return Scaffold(
      backgroundColor: dailySelected == true
          ? Theme.of(context).dividerColor
          : Theme.of(context).backgroundColor,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 15,
        // brightness: Brightness.light,
        elevation: 0,
        backgroundColor: dailySelected == true
            ? Theme.of(context).dividerColor
            : Theme.of(context).backgroundColor,
        title: dailySelected == true
            ? Text(
                "Daily Tasks",
                style: Theme.of(context).textTheme.headline5,
              )
            : Text(
                "Today's Tasks",
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
                child: _dateTime != null ? Text(_dateTime) : Text(''),
              ),
              // Text(DateFormat.yMMMd().format(DateTime.now()).toString()),
              Container(
                height: MediaQuery.of(context).size.height / 1.5,
                child: todaySelected == true
                    ? TaskListWidget(_taskList, _deleteTask, _completeTask)
                    : TaskListWidget(_dailyList, _deleteTask2, _completeTask2),
              ),
              // Divider(
              //   height: MediaQuery.of(context).size.height / 50,
              //   color: Theme.of(context).dividerColor,
              //   thickness: MediaQuery.of(context).size.height / 50,
              //   endIndent: 4.0,
              //   indent: 4.0,
              // ),
              // Container(
              //   height: MediaQuery.of(context).size.height / 3,
              //   child: TaskListWidget(_dailyList, _deleteTask2, _completeTask2),
              // ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Text('Today'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Switch(
                          value: dailySelected,
                          onChanged: _onChanged,
                          inactiveThumbColor:
                              Theme.of(context).cardColor,
                          activeColor: Theme.of(context).primaryColor,
                          activeTrackColor: Theme.of(context).primaryColor,
                          inactiveTrackColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Text('Daily'),
                      ),
                    ],
                  )
                  // Row(
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 60.0),
                  //       child: ElevatedButton(
                  //         style: ButtonStyle(
                  //           backgroundColor: MaterialStateProperty.all(
                  //             Theme.of(context).backgroundColor,
                  //           ),
                  //         ),
                  //         child: Column(
                  //           children: [
                  //             Icon(Icons.list,
                  //                 color: todaySelected
                  //                     ? Theme.of(context).primaryColor
                  //                     : Theme.of(context).dividerColor),
                  //             Text(
                  //               'Today',
                  //               style: Theme.of(context).textTheme.bodyText2,
                  //             ),
                  //           ],
                  //         ),
                  //         onPressed: () async {
                  //           SharedPreferences prefs = await SharedPreferences.getInstance();
                  //           setState(() {
                  //             prefs.setBool('today list selected', true);
                  //             todaySelected = true;
                  //             dailySelected = false;
                  //           });
                  //         },
                  //       ),
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 140.0),
                  //       child: ElevatedButton(
                  //         style: ButtonStyle(
                  //           backgroundColor: MaterialStateProperty.all(
                  //             Theme.of(context).backgroundColor,
                  //           ),
                  //         ),
                  //         child: Column(
                  //           children: [
                  //             Icon(Icons.loop,
                  //                 color: dailySelected
                  //                     ? Theme.of(context).primaryColor
                  //                     : Theme.of(context).dividerColor),
                  //             Text(
                  //               'Daily',
                  //               style: Theme.of(context).textTheme.bodyText2,
                  //             ),
                  //           ],
                  //         ),
                  //         onPressed: () async {
                  //           SharedPreferences prefs = await SharedPreferences.getInstance();
                  //           setState(() {
                  //             prefs.setBool('today list selected', false);
                  //             dailySelected = true;
                  //             todaySelected = false;
                  //           });
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  )
            ],
          ),
        ),
        onRefresh: refreshList,
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   backgroundColor: Theme.of(context).primaryColor,
      //   splashColor: Theme.of(context).primaryColor,
      //   onPressed: () async {
      //     SharedPreferences prefs = await SharedPreferences.getInstance();
      //     prefs.setInt('page index', 2);
      //     showModalBottomSheet(
      //       context: context,
      //       builder: (_) {
      //         return GestureDetector(
      //           onTap: () {},
      //           child: NewTask(_addNewTask),
      //           behavior: HitTestBehavior.opaque,
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}
