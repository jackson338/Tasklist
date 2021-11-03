import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/models/goal_mod.dart';
import 'package:tasklist_app/pages/goal_page.dart';
import 'package:tasklist_app/widgets/goal_list.dart';
import 'package:tasklist_app/widgets/goal_new.dart';

class GoalExpandedPage extends StatefulWidget {
  const GoalExpandedPage({Key key}) : super(key: key);

  @override
  _GoalExpandedPageState createState() => _GoalExpandedPageState();
}

class _GoalExpandedPageState extends State<GoalExpandedPage> {
  List<GoalMod> _goalsList = [];
  List<String> goalsIdList = [];
  List<String> journalidList = [];
  List<String> listLength = [];
  List<String> completedListLength = [];
  String _iconName = 'check_circle_outline';
  int listLengthInt = 0;
  int completedListLengthInt = 0;
  double percent = 0.0;
  String title;
  String gId;
  bool buildCalled = false;

  void _buildGoals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('selected list', 'goal');
      gId = prefs.getString('expanded goal');
      title = prefs.getString('$gId Goal Task');
      buildCalled = true;
    });
    if (prefs.getStringList('$gId goal list') != null) {
      String id;
      goalsIdList = prefs.getStringList('$gId goal list');
      // prefs.setStringList(
      //   '$gId goal list length',
      //   prefs.getStringList('$gId goal list'),
      // );
      for (id in goalsIdList) {
        final newGoal = GoalMod(
          task: prefs.getString('$id goal task'),
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
        // else {
        //   dailyidList.remove(id);
        //   prefs.setStringList('Daily ID List', dailyidList);
        //   List<String> journalIdList = prefs.getStringList('Journal ID List');
        //   journalIdList.add(id);
        //   prefs.setStringList('Journal ID List', journalIdList);
        // }
      }
    } else {
      setState(() {
        percent = 1.0;
        prefs.setDouble('$gId percent', percent);
      });
    }
  }

  void _openGoal(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('expanded goal', id);
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

  List<String> completedGoals = [];

  void _completeGoal(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getStringList('$gId completed goals') != null) {
        completedGoals = prefs.getStringList('$gId completed goals');
      }
      if (completedGoals.contains(id) == false) {
        completedGoals.add(id);
        prefs.setStringList('$gId completed goals', completedGoals);
      }
      prefs.setString('$id Icon Name', 'check_circle');
      // List<String> goalidList = prefs.getStringList('$gId goal list');
      // if (prefs.getStringList('Journal ID List') != null) {
      //   journalidList = prefs.getStringList('Journal ID List');
      // }
      // prefs.setString('$id Date Finished',
      //     DateFormat.yMMMd().format(DateTime.now()).toString());
      // prefs.setString('$id Time Finished',
      //     DateFormat.jm().format(DateTime.now()).toString());
      // journalidList.add(id);
      // prefs.setStringList('Journal ID List', journalidList);
      // goalidList.remove(id);
      // prefs.setStringList('$gId goal list', goalidList);
    });
  }

  void _addNewGoal(
    String _task,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('$gId goal list') != null) {
      goalsIdList = prefs.getStringList('$gId goal list');
    }

    final newGoal = GoalMod(
      task: _task,
      iconName: _iconName,
      finish: null,
      id: DateTime.now().toString(),
    );
    prefs.setString('${newGoal.id} goal task', newGoal.task);
    setState(() {
      _goalsList.add(newGoal);
      goalsIdList.add(newGoal.id);
      prefs.setStringList('$gId goal list', goalsIdList);
    });
  }

  void deleteGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id;
    List<String> removalId = prefs.getStringList('Goal ID List');
    for (id in prefs.getStringList('$gId goal list')) {
      prefs.remove('$id goal task');
    }
    prefs.setStringList('$gId goal list', []);
    prefs.remove('$gId Goal Task');
    removalId.remove(gId);
    prefs.setStringList('Goal ID List', removalId);
    prefs.setStringList('$gId completed goals', []);
    setState(() {
      Navigator.of(context).pop();
    });
  }

  Future<Null> refreshList() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _goalsList = [];
      goalsIdList = [];
      buildCalled = false;
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
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text(
          title == null ? 'no title' : title,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteGoal();
            },
          ),
        ],
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
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
                child: NewGoal(_addNewGoal),
                behavior: HitTestBehavior.opaque,
              );
            },
          );
        },
      ),
    );
  }
}
