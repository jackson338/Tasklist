import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import '../models/task_mod.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    Key key,
    @required this.taskItem,
    @required this.deleteTask,
    @required this.completeTask,
    // @required this.taskKey,
  }) : super(key: key);

  final TaskMod taskItem;
  final Function deleteTask;
  final Function completeTask;
  // final ValueKey taskKey;

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  List<String> taskidList = [];
  List<String> journalidList = [];
  List<String> folderNames = [];
  List<String> dateList = [];
  String _dateTime;
  bool dateCalled = false;
  bool buildCalled = false;

  void buildList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('ID List') != null) {
      setState(() {
        taskidList = prefs.getStringList('ID List');
        if (prefs.getStringList('Journal ID List') != null) {
          journalidList = prefs.getStringList('Journal ID List');
        }
        buildCalled = true;
      });
    }
  }

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
        print('date prefs');
      } else {
        prefs.setString(
            'Prefs Date', DateFormat.yMMMd().format(DateTime.now()).toString());
        print('date prefs else');
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        key: ValueKey(widget.taskItem.id),
        leading: widget.taskItem.iconName == 'check_circle_outline'
            ? IconButton(
                icon: Icon(
                  Icons.check_circle_outline,
                ),
                color: Theme.of(context).primaryColorLight,
                splashColor: Theme.of(context).primaryColor,
                onPressed: () async {
                  HapticFeedback.heavyImpact();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  print(prefs.getStringList('Folder Names'));

                  if (prefs.getStringList('Home Date List') == null) {
                    dateList.add(
                        DateFormat.yMMMd().format(DateTime.now()).toString());
                    prefs.setStringList('Home Date List', dateList);
                  }

                  if (prefs.getStringList('Folder Names') == null) {
                    folderNames.add(
                        DateFormat.yMMMd().format(DateTime.now()).toString());
                    prefs.setStringList('Folder Names', folderNames);
                  }

                  if (dateCalled == false) {
                    datePrefs();
                    print('calling dateprefs');
                  }
                  setState(() {
                    widget.taskItem.iconName = 'check_circle';
                  });
                  widget.completeTask(widget.taskItem.id);
                },
              )
            : IconButton(
                icon: Icon(
                  Icons.check_circle,
                ),
                color: Theme.of(context).primaryColorLight,
                splashColor: Theme.of(context).primaryColor,
                onPressed: () {
                  widget.taskItem.iconName = 'check_circle_outline';
                },
              ),
        title: Center(
          child: Text(
            '${widget.taskItem.task}',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        subtitle: widget.taskItem.finish == null
            ? Center(
                child: Text(
                  '',
                ),
              )
            : Center(
                child: Text(
                  widget.taskItem.finish,
                  style: TextStyle(color: Colors.white),
                ),
              ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
          ),
          color: Theme.of(context).primaryColorLight,
          splashColor: Theme.of(context).primaryColorLight,
          onPressed: () {
            HapticFeedback.vibrate();
            widget.deleteTask(widget.taskItem.id);
          },
        ),
      ),
    );
  }
}
