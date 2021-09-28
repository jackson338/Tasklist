import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/models/task_mod.dart';
import 'package:tasklist_app/widgets/task_list.dart';
import 'package:tasklist_app/widgets/task_list_reorderable.dart';
import 'package:tasklist_app/widgets/task_new.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({Key key}) : super(key: key);

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  bool buildCalled = false;
  List<TaskMod> _goalsList = [];
  List<String> goalsIdList = [];
  String _iconName = 'check_circle_outline';

  void _buildGoals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('page index', 1);
    print(prefs.getInt('page index'));
    if (prefs.getStringList('Goal ID List') != null) {
      String id;
      goalsIdList = prefs.getStringList('Goal ID List');
      for (id in goalsIdList) {
        if (prefs.getString('$id Icon Name') != 'check_circle') {
          final newGoal = TaskMod(
            task: prefs.getString('$id Goal Task'),
            iconName: _iconName,
            finish: null,
            id: id,
          );
          setState(() {
            _goalsList.add(newGoal);
            buildCalled = true;
            if (prefs.getString('${newGoal.id} Icon Name') != null) {
              newGoal.iconName = prefs.getString('${newGoal.id} Icon Name');
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

  void _deleteGoal(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('page index') == 1) {
      setState(() {
        _goalsList.removeWhere((goalR) => goalR.id == id);
        goalsIdList.remove(id);
        prefs.setStringList('Goal ID List', goalsIdList);
        prefs.remove('$id Goal Task');
      });
    }
  }

  List<String> journalidList = [];

  void _completeGoal(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('page index') == 1) {
      setState(() {
        List<String> goalidList = prefs.getStringList('Goal ID List');
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
        goalidList.remove(id);
        prefs.setStringList('Goal ID List', goalidList);
      });
    }
  }

  void _addNewGoal(
    String _goal,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('page index') == 1) {
      final newGoal = TaskMod(
        task: _goal,
        iconName: _iconName,
        finish: null,
        id: DateTime.now().toString(),
      );
      prefs.setString('${newGoal.id} Goal Task', newGoal.task);
      setState(() {
        _goalsList.add(newGoal);
        goalsIdList.add(newGoal.id);
        prefs.setStringList('Goal ID List', goalsIdList);
        buildCalled = true;
      });
    }
  }

  Future<Null> refreshList() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _goalsList = [];
      goalsIdList = [];
      buildCalled = false;
      // _buildTasks();
    });
    print('refreshed');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (buildCalled == false) {
      _buildGoals();
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 15,
        brightness: Brightness.light,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Goals",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: RefreshIndicator(
            child: TaskListWidget(_goalsList, _deleteGoal, _completeGoal),
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
          prefs.setInt('page index', 1);
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return GestureDetector(
                onTap: () {},
                child: NewTask(_addNewGoal),
                behavior: HitTestBehavior.opaque,
              );
            },
          );
        },
      ),
    );
  }
}
