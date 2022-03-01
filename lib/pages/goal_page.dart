import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/models/goal_mod.dart';
import 'package:tasklist_app/pages/goal_expanded_page.dart';
import 'package:tasklist_app/widgets/goal_list.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({Key key}) : super(key: key);

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  bool buildCalled = false;
  List<GoalMod> _goalsList = [];
  List<String> goalsIdList = [];
  List<String> journalidList = [];
  List<String> listLength = [];
  List<String> completedListLength = [];
  String _iconName = 'check_circle_outline';
  int listLengthInt = 0;
  int completedListLengthInt = 0;
  double percent = 0.0;

  void _buildGoals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('page index', 1);
    if (prefs.getStringList('Goal ID List') != null) {
      String id;
      goalsIdList = prefs.getStringList('Goal ID List');
      for (id in goalsIdList) {
        if (prefs.getString('$id Icon Name') != 'check_circle') {
          final newGoal = GoalMod(
            task: prefs.getString('$id Goal Task'),
            iconName: _iconName,
            finish: null,
            id: id,
          );
          setState(() {
            //  if (listLength == null || listLength == null) {
            //   percent = 1.0;
            //   prefs.setDouble('${newGoal.id} percent', percent);
            // } else {
            //   if (completedListLength.isEmpty || completedListLength == null) {
            //     percent = 0.0;
            //     prefs.setDouble('${newGoal.id} percent', percent);
            //   } else {
            //     listLengthInt = listLength.length;
            //     completedListLengthInt = completedListLength.length;
            //     percent = completedListLengthInt / listLengthInt;
            //     prefs.setDouble('${newGoal.id} percent', percent);
            //   }
            // }
            _goalsList.add(newGoal);
            buildCalled = true;
            if (prefs.getString('${newGoal.id} Icon Name') != null) {
              newGoal.iconName = prefs.getString('${newGoal.id} Icon Name');
            }
          });
        } 
        if (prefs.getString('$id Icon Name') == 'check_circle') {
          final newcGoal = GoalMod(
            task: prefs.getString('$id Goal Task'),
            iconName: _iconName,
            finish: prefs.getString('$id Goal Finish'),
            id: id,
          );
          setState(() {
            _goalsList.add(newcGoal);
            buildCalled = true;
            if (prefs.getString('${newcGoal.id} Icon Name') != null) {
              newcGoal.iconName = prefs.getString('${newcGoal.id} Icon Name');
            }
          });
        }
      }
    }
  }

  void _openGoal(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('expanded goal', id);
    prefs.setString('start goal id', id);
    // prefs.setString('$id expanded goal', id);
    // if (prefs.getInt('page index') == 1) {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => GoalExpandedPage(),
        ),
      );
    });
    // }
  }

  void _completeGoal(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //   List<String> goalidList = prefs.getStringList('Goal ID List');
      //   if (prefs.getStringList('Journal ID List') != null) {
      //     journalidList = prefs.getStringList('Journal ID List');
      //   }
      prefs.setString('$id Icon Name', 'check_circle');
      prefs.setString('$id Goal finish',
          DateFormat.yMMMd().format(DateTime.now()).toString());
      //   prefs.setString('$id Date Finished',
      //       DateFormat.yMMMd().format(DateTime.now()).toString());
      //   prefs.setString('$id Time Finished',
      //       DateFormat.jm().format(DateTime.now()).toString());
      //   journalidList.add(id);
      //   prefs.setStringList('Journal ID List', journalidList);
      //   goalidList.remove(id);
      //   prefs.setStringList('Goal ID List', goalidList);
    });
  }

  // void _addNewGoal(
  //   String _goal,
  // ) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.getInt('page index') == 1) {
  //     final newGoal = TaskMod(
  //       task: _goal,
  //       iconName: _iconName,
  //       finish: null,
  //       id: DateTime.now().toString(),
  //     );
  //     prefs.setString('${newGoal.id} Goal Task', newGoal.task);
  //     setState(() {
  //       _goalsList.add(newGoal);
  //       goalsIdList.add(newGoal.id);
  //       prefs.setStringList('Goal ID List', goalsIdList);
  //       buildCalled = true;
  //     });
  //   }
  // }

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
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: MediaQuery.of(context).size.height / 15,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          "Goals",
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: RefreshIndicator(
            color: Theme.of(context).dividerColor,
            child: GoalListWidget(_goalsList, _openGoal, _completeGoal),
            onRefresh: refreshList,
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   backgroundColor: Theme.of(context).primaryColor,
      //   splashColor: Theme.of(context).accentColor,
      //   onPressed: () async {
      //     SharedPreferences prefs = await SharedPreferences.getInstance();
      //     prefs.setInt('page index', 1);
      //     showModalBottomSheet(
      //       context: context,
      //       builder: (_) {
      //         return GestureDetector(
      //           onTap: () {},
      //           child: NewTask(_addNewGoal),
      //           behavior: HitTestBehavior.opaque,
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}
