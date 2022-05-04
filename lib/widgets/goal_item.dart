import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:tasklist_app/models/goal_mod.dart';

class GoalItem extends StatefulWidget {
  const GoalItem({
    Key key,
    @required this.goalItem,
    @required this.openGoal,
    @required this.completeGoal,
    // @required this.taskKey,
  }) : super(key: key);

  final GoalMod goalItem;
  final Function openGoal;
  final Function completeGoal;
  // final ValueKey taskKey;

  @override
  _GoalItemState createState() => _GoalItemState();
}

class _GoalItemState extends State<GoalItem> {
  List<String> goalIdList = [];
  List<String> journalidList = [];
  List<String> folderNames = [];
  List<String> listLength = [];
  List<String> completedListLength = [];
  bool buildCalled = false;
  int listlengthInt = 0;
  int completedListLengthInt = 0;
  double percent = 1;

  void buildList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('goal id list') != null) {
      setState(() {
        if (prefs.getStringList('${widget.goalItem.id} completed goals') !=
            null) {
          completedListLengthInt = prefs
              .getStringList('${widget.goalItem.id} completed goals')
              .length;
        }
        if (prefs.getStringList('${widget.goalItem.id} goal list') != null) {
          listlengthInt =
              prefs.getStringList('${widget.goalItem.id} goal list').length;
        }
        print(percent);
        goalIdList = prefs.getStringList('goal id list');
        if (prefs.getStringList('Journal ID List') != null) {
          journalidList = prefs.getStringList('Journal ID List');
        }
        buildCalled = true;
      });
    }
    setState(() {
      // percent = prefs.getDouble('${widget.goalItem.id} percent');
      if (prefs.getStringList('${widget.goalItem.id} completed goals') !=
          null) {
        completedListLengthInt =
            prefs.getStringList('${widget.goalItem.id} completed goals').length;
      }
      if (prefs.getStringList('${widget.goalItem.id} goal list') != null) {
        listlengthInt =
            prefs.getStringList('${widget.goalItem.id} goal list').length;
      }
      if (completedListLengthInt == 0 && listlengthInt > 0) {
        percent = 0;
      }
      if (completedListLengthInt > 0 && listlengthInt > 0) {
        percent = completedListLengthInt / listlengthInt;
      }
      if (listlengthInt == 0) {
        percent = 1;
      }
      buildCalled = true;
    });
  }

  List<String> dateList = [];
  String _dateTime;
  bool dateCalled = false;

  void datePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString('Prefs Date') != null &&
          prefs.getString('Prefs Date') != _dateTime) {
        if (prefs.getStringList('Home Date List') != null) {
          dateList = prefs.getStringList('Home Date List');
        }
        dateList.add(DateFormat.yMMMd().format(DateTime.now()).toString());
        prefs.setStringList('Home Date List', dateList);
        prefs.setString(
            'Prefs Date', DateFormat.yMMMd().format(DateTime.now()).toString());
        if (prefs.getStringList('Folder Names') != null) {
          folderNames = prefs.getStringList('Folder Names');
        }
        folderNames.add(DateFormat.yMMMd().format(DateTime.now()).toString());
        prefs.setStringList('Folder Names', folderNames);
        // print('date prefs');
      } else {
        prefs.setString(
            'Prefs Date', DateFormat.yMMMd().format(DateTime.now()).toString());
        // print('date prefs else');
      }
      // if (prefs.getStringList('Folder Names') == null) {
      //   folderNames.add(DateFormat.yMMMd().format(DateTime.now()).toString());
      //   prefs.setStringList('Folder Names', folderNames);
      // }
      dateCalled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _dateTime = DateFormat.yMMMd().format(DateTime.now()).toString();
    if (buildCalled == false) {
      buildList();
    }
    return Card(
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: Column(
        children: [
          ListTile(
            key: ValueKey(widget.goalItem.id),
            leading: widget.goalItem.iconName == 'check_circle_outline'
                ? IconButton(
                    icon: Icon(
                      Icons.check_circle_outline,
                    ),
                    color: Theme.of(context).primaryColorLight,
                    splashColor: Theme.of(context).primaryColorLight,
                    onPressed: () async {
                      HapticFeedback.mediumImpact();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      // print(prefs.getStringList('Folder Names'));

                      if (prefs.getStringList('Home Date List') == null) {
                        dateList.add(DateFormat.yMMMd()
                            .format(DateTime.now())
                            .toString());
                        prefs.setStringList('Home Date List', dateList);
                      }

                      if (prefs.getStringList('Folder Names') == null) {
                        folderNames.add(DateFormat.yMMMd()
                            .format(DateTime.now())
                            .toString());
                        prefs.setStringList('Folder Names', folderNames);
                      }

                      if (dateCalled == false) {
                        datePrefs();
                        // print('calling dateprefs');
                      }
                      setState(() {
                        widget.goalItem.iconName = 'check_circle';
                      });
                      widget.completeGoal(widget.goalItem.id);
                    },
                  )
                : IconButton(
                    icon: Icon(
                      Icons.check_circle,
                    ),
                    color: Theme.of(context).primaryColorLight,
                    splashColor: Theme.of(context).primaryColorLight,
                    onPressed: () {
                      widget.goalItem.iconName = 'check_circle_outline';
                    },
                  ),
            title: Center(
              child: Text(
                '${widget.goalItem.task}',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            subtitle: widget.goalItem.finish == null
                ? Center(
                    child: Text(
                      '',
                    ),
                  )
                : Center(
                    child: Text(
                      widget.goalItem.finish,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
            trailing: IconButton(
              icon: Icon(Icons.list),
              color: Theme.of(context).primaryColorLight,
              splashColor: Theme.of(context).primaryColorLight,
              onPressed: () {
                HapticFeedback.lightImpact();
                widget.openGoal(widget.goalItem.id);
              },
            ),
          ),
          Container(
            height: 20,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 8,
                  child: Text('$completedListLengthInt/$listlengthInt',style: TextStyle(color: Colors.white),),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.18,
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    heightFactor: 1.0,
                    widthFactor: percent == null
                        ? 0
                        : percent > 1
                            ? 1
                            : percent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
