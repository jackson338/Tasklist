import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  bool delete = false;
  String expandedTitle = "Expanded Goal Page";

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
          finish: prefs.getString('$id goal finish') == null
              ? null
              : prefs.getString('$id goal finish'),
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
      Navigator.of(context).pop();
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
      prefs.setString('$id goal finish',
          DateFormat.yMMMd().format(DateTime.now()).toString());
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

  void deleteGoal(String id, String mainId) async {
    setState(() {
      expandedTitle = "Hit the back button";
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('$id goal list') != null) {
      List<String> currentList = prefs.getStringList('$id goal list');
      String subId;
      for (subId in currentList) {
        if (prefs.getStringList('$subId goal list') != null) {
          deleteGoal(subId, null);
        }
        prefs.remove('$subId Goal Task');
      }
      prefs.remove('$id goal list');
    }
    List<String> goalsIdList = prefs.getStringList('Goal ID List');
    goalsIdList.remove(id);
    prefs.setStringList('Goal ID List', goalsIdList);
    prefs.remove('$id Goal Task');
    // prefs.remove('$mainId Goal Task');
    if (prefs.getStringList('$mainId goal list') != null) {
      List<String> goalsIdList = prefs.getStringList('$mainId goal list');
      goalsIdList.remove(id);
      prefs.setStringList('$mainId goal list', goalsIdList);
    }
    delete = true;
    goBack();
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
      setState(() {
        // startGoalList.remove(prefs.getString('expanded goal'));
        startGoalList.remove(gId);
        prefs.setStringList('$startId start goal list', startGoalList);
        prefs.setString('expanded goal', startGoalList.elementAt(index - 1));
        // prefs.setString('expanded goal', startGoalList.elementAt(index));
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => GoalExpandedPage(),
          ),
        );
      });
    } else {
      startGoalList = [];
      prefs.setStringList('$startId start goal list', startGoalList);
      if (delete == false) {
        Navigator.of(context).pop();
      } else {
        delete = false;
        // Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (buildCalled == false) {
      _buildGoals();
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: MediaQuery.of(context).size.height / 15,
        backgroundColor: Theme.of(context).backgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            delete = false;
            goBack();
          },
        ),
        title: Text(expandedTitle),
        // title: Text(
        //   '$index',
        //   style: Theme.of(context).textTheme.bodyText2,
        // ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteGoal(
                  gId, index > 0 ? startGoalList.elementAt(index - 1) : gId);
            },
          ),
        ],
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
          children: [
            Container(
              color: Colors.blueGrey[800],
              height: MediaQuery.of(context).size.height / 10,
                child: Center(
                  child: ListView(
                    children: [
                      Text(title != null ? title : 'no title data',
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                          ),
                    ],
                  ),
                ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 1.5,
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
