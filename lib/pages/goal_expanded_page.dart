import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/models/goal_mod.dart';
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
  List<String> startGoalList = [];
  String _iconName = 'check_circle_outline';
  int listLengthInt = 0;
  int completedListLengthInt = 0;
  int index;
  double percent = 0.0;
  String title;
  String gId;
  String startId;
  bool buildCalled = false;

  void _buildGoals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('selected list', 'goal');
      gId = prefs.getString('expanded goal');
      startId = prefs.getString('start goal id');
      if (prefs.getStringList('$startId start goal list') != null) {
        startGoalList = prefs.getStringList('$startId start goal list');
      }
      if (startGoalList.contains(gId) == false) {
        startGoalList.add(gId);
        prefs.setStringList('$startId start goal list', startGoalList);
      }
      print('start goal list: $startGoalList');
      getIndex();
      title = prefs.getString('$gId Goal Task') == null
          ? prefs.getString('$gId goal task')
          : prefs.getString('$gId Goal Task');
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
    // prefs.setString('$id expanded goal', id);
    // if (prefs.getInt('page index') == 1) {
    setState(() {
      prefs.setString('expanded goal', id);
      if (startGoalList.contains(id) == false) {
        startGoalList.add(id);
        prefs.setStringList('$startId start goal list', startGoalList);
      }
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
    List<String> removePrevGoal = [];
    if (index > 0) {
      removePrevGoal = prefs
          .getStringList('${startGoalList.elementAt(index - 2)} goal list');
      if (removePrevGoal != null) {
        removePrevGoal.remove(startGoalList.elementAt(index - 1));
        prefs.setStringList(
            '${startGoalList.elementAt(index - 2)} goal list', removePrevGoal);
      }
    }
    // List<String> subRemovalList = prefs.getStringList('$gId goal list');
    if (prefs.getStringList('$gId goal list') != null) {
      for (id in prefs.getStringList('$gId goal list')) {
        prefs.remove('$id goal task');
      }
    }

    prefs.remove('$gId goal list');
    prefs.remove('$gId Goal Task');
    startGoalList.remove(gId);
    startGoalList.remove(startGoalList.elementAt(index - 1));
    prefs.setStringList('$startId start goal list', startGoalList);
    removalId.remove(gId);
    prefs.setStringList('Goal ID List', removalId);
    // subRemovalList.remove(gId);
    prefs.remove('$gId completed goals');
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

  void getIndex() {
    setState(() {
      if (startGoalList.isEmpty == false) {
        String id;
        List<String> indexLength = [];
        bool stopAdding = false;
        for (id in startGoalList) {
          if (id != gId) {
            if (stopAdding == false) {
              indexLength.add(id);
              print('index list: $indexLength');
            }
          } else {
            stopAdding = true;
          }
        }
        index = indexLength.length;
        // print('index: $index');
      }
    });
  }

  void goBack() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (index > 0) {
      startGoalList.remove(prefs.getString('expanded goal'));
      startGoalList.remove(gId);
      prefs.setStringList('$startId start goal list', startGoalList);
      prefs.setString('expanded goal', startGoalList.elementAt(index - 1));
    } else {
      startGoalList = [];
      prefs.setStringList('$startId start goal list', startGoalList);
    }

    Navigator.of(context).pop();
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: goBack,
        ),
        title: Text(
          '$index',
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
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 25,
              child: Text(title != null ? title : 'no title data',
                  style: Theme.of(context).textTheme.bodyText1),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 1.2,
              child: RefreshIndicator(
                color: Theme.of(context).dividerColor,
                child: GoalListWidget(_goalsList, _openGoal, _completeGoal),
                onRefresh: refreshList,
              ),
            ),
          ],
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
