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
  String _iconName = 'check_circle_outline';
  String _dateTime = DateFormat.yMMMd().format(DateTime.now()).toString();
  bool buildCalled = false;

  void _deleteTask(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('page index') == 3) {
      setState(() {
        calendarList.removeWhere((taskR) => taskR.id == id);
        calendarIDlist.remove(id);
        prefs.setStringList('Calendar ID List', calendarIDlist);
        prefs.remove('$id Calendar Task');
        prefs.remove('$id Calendar Date');
      });
    }
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
        prefs.setString('$id Date Finished',
            DateFormat.yMMMd().format(DateTime.now()).toString());
        prefs.setString('$id Time Finished',
            DateFormat.jm().format(DateTime.now()).toString());
        journalidList.add(id);
        prefs.setStringList('Journal ID List', journalidList);
        calendaridList.remove(id);
        prefs.setStringList('Calendar ID List', calendaridList);
      });
    }
  }

  void _addNewCalendarTask(
    String calendarTask,
    String date,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('page index') == 3) {
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
        calendarList.add(newCalendarTask);
        calendarIDlist.add(newCalendarTask.id);
        prefs.setStringList('Calendar ID List', calendarIDlist);
        buildCalled = true;
      });
    }
  }

  void _buildCalendarTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('page index', 3);
    print(prefs.getInt('page index'));
    if (prefs.getStringList('Calendar ID List') != null) {
      String id;
      calendarIDlist = prefs.getStringList('Calendar ID List');
      for (id in calendarIDlist) {
        if (prefs.getString('$id Icon Name') != 'check_circle') {
          final newCalendarTask = TaskMod(
            task: prefs.getString('$id Calendar Task'),
            iconName: _iconName,
            finish: prefs.getString('$id Calendar Date'),
            id: id,
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
    print('refreshed');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (buildCalled == false) {
      _buildCalendarTasks();
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 15,
        brightness: Brightness.light,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Calendar Tasks",
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
              Container(
                height: MediaQuery.of(context).size.height / 1.35,
                child: TaskListWidget(
                    calendarList, _deleteTask, _completeCalendarTask),
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
          prefs.setInt('page index', 3);
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return GestureDetector(
                onTap: () {},
                child: NewTask(_addNewCalendarTask),
                behavior: HitTestBehavior.opaque,
              );
            },
          );
        },
      ),
    );
  }
}
