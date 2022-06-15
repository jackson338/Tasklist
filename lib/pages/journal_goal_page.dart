import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/models/goal_mod.dart';
import 'package:tasklist_app/pages/goal_expanded_page.dart';
import 'package:tasklist_app/widgets/goal_list.dart';

class JournalGoalPage extends StatefulWidget {
  final String folderDate;
  const JournalGoalPage({Key key, this.folderDate}) : super(key: key);

  @override
  _JournalGoalPageState createState() => _JournalGoalPageState();
}

class _JournalGoalPageState extends State<JournalGoalPage> {
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
    print('buildGoals');
    if (prefs.getStringList('journal goals ids') != null) {
      String id;
      goalsIdList = prefs.getStringList('journal goals ids');
      for (id in goalsIdList) {
        print('id: $id');
        print('widget.folderDate: ${widget.folderDate} goal completed date: ${prefs.getString('$id goal complete date')}');
        if (widget.folderDate == prefs.getString('$id goal complete date')) {
          final newGoal = GoalMod(
            task: prefs.getString('$id Goal Task'),
            iconName: _iconName,
            finish: prefs.getString('$id Goal Finish'),
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
      }
    }
  }

  void _openGoal(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('expanded goal', id);
    prefs.setString('start goal id', id);
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => GoalExpandedPage(),
        ),
      );
    });
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
    print('made it');
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
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: RefreshIndicator(
            color: Theme.of(context).dividerColor,
            child: _goalsList.isNotEmpty
                ? GoalListWidget(_goalsList, _openGoal, () {})
                : Text('No Completed Goals For Today'),
            onRefresh: refreshList,
          ),
        ),
      ),
    );
  }
}
