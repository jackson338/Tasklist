import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewTask extends StatefulWidget {
  final Function addTaskFunc;
  NewTask(this.addTaskFunc);

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  int pageIndex;
  bool buildCalled = false;
  String _selectedDate;
  String currentDate;
  DateTime pickDate;
  final _nameController = TextEditingController();

  void _submitData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_nameController.text.isEmpty) {
      return;
    }
    if (prefs.getString('selected list') == null) {
      prefs.setString('selected list', 'today');
      return;
    }
    final _enteredName = _nameController.text;
    final _enteredDate = _selectedDate;
    final _currentDate = DateFormat.yMMMd().format(DateTime.now()).toString();

    if (pageIndex == 3) {
      widget.addTaskFunc(
        _enteredName,
        _enteredDate,
        pickDate,
      );
      Navigator.of(context).pop();
    } else {
      widget.addTaskFunc(
        _enteredName,
        _selectedDate == null ? _currentDate : _selectedDate,
        pickDate,
      );
      Navigator.of(context).pop();
    }
  }

  void _getInt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      pageIndex = prefs.getInt('page index');
      buildCalled = true;
    });
  }

  void _presentDatePicker() {
    showDatePicker(
            builder: (BuildContext context, Widget child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Theme.of(context).hintColor,
                    primary: Theme.of(context).primaryColor,
                  ),
                  buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                ),
                child: child,
              );
            },
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2030))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = DateFormat.yMMMEd().format(pickedDate).toString();
        pickDate = pickedDate;
      });
    });
  }

  bool calendarSelected = false;
  bool todaySelected = false;
  bool dailySelected = false;
  bool goalSelected = false;
  bool getPrefs = false;
  String selected;

  void _getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selected = prefs.getString('selected list');
      if (selected == 'calendar') {
        calendarSelected = true;
        todaySelected = false;
        dailySelected = false;
        goalSelected = false;
      }
      if (selected == 'today') {
        calendarSelected = false;
        todaySelected = true;
        dailySelected = false;
        goalSelected = false;
      }
      if (selected == 'daily') {
        calendarSelected = false;
        todaySelected = false;
        dailySelected = true;
        goalSelected = false;
      }
      if (selected == 'goal') {
        calendarSelected = false;
        todaySelected = false;
        dailySelected = false;
        goalSelected = true;
      }
      getPrefs = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (buildCalled == false) {
      _getInt();
    }
    if (getPrefs == false) {
      _getPrefs();
    }
    return Container(
      color: Theme.of(context).backgroundColor,
      child: ListView(
        children: [
          Row(
            children: [
              //Calendar Button
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(calendarSelected == true
                      ? Theme.of(context).primaryColorLight
                      : Theme.of(context).primaryColor),
                ),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  setState(() {
                    calendarSelected = true;
                    todaySelected = false;
                    dailySelected = false;
                    goalSelected = false;
                    prefs.setString('selected list', 'calendar');
                    prefs.setInt('page index', 3);
                    _presentDatePicker();
                  });
                },
                child: Column(
                  children: [
                    Icon(Icons.calendar_today,
                        color: calendarSelected == true
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).primaryColorLight),
                    Text(
                      'Calendar',
                      style: calendarSelected
                          ? Theme.of(context).textTheme.subtitle2
                          : Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
              //End of Calendar Button
              //Today Button
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(todaySelected == true
                      ? Theme.of(context).primaryColorLight
                      : Theme.of(context).primaryColor),
                ),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  setState(() {
                    calendarSelected = false;
                    todaySelected = true;
                    dailySelected = false;
                    goalSelected = false;
                    prefs.setString('selected list', 'today');
                  });
                },
                child: Column(
                  children: [
                    Icon(Icons.list,
                        color: todaySelected == true
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).primaryColorLight),
                    Text(
                      'Today',
                      style: todaySelected
                          ? Theme.of(context).textTheme.subtitle2
                          : Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ),

              //End of Today Button
              //Daily Button
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(dailySelected == true
                      ? Theme.of(context).primaryColorLight
                      : Theme.of(context).primaryColor),
                ),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  setState(() {
                    calendarSelected = false;
                    todaySelected = false;
                    dailySelected = true;
                    goalSelected = false;
                    prefs.setString('selected list', 'daily');
                  });
                },
                child: Column(
                  children: [
                    Icon(Icons.loop,
                        color: dailySelected == true
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).primaryColorLight),
                    Text(
                      'Daily',
                      style: dailySelected
                          ? Theme.of(context).textTheme.subtitle2
                          : Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
              //End of Daily Button
              //Goals Button/Text
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    goalSelected == true
                        ? Theme.of(context).primaryColorLight
                        : Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  setState(() {
                    calendarSelected = false;
                    todaySelected = false;
                    dailySelected = false;
                    goalSelected = true;
                    prefs.setString('selected list', 'goal');
                  });
                },
                child: Column(
                  children: [
                    Icon(Icons.map_outlined,
                        color: goalSelected == true
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).primaryColorLight),
                    Text(
                      'Goals',
                      style: goalSelected
                          ? Theme.of(context).textTheme.subtitle2
                          : Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
              //End of Goal Button
            ],
          ),
          TextField(
            style: Theme.of(context).textTheme.bodyText1,
            cursorColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
              labelText: 'Enter a new task',
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
              focusColor: Theme.of(context).primaryColor
              // hintStyle: TextStyle(color: Theme.of(context).dividerColor),
            ),
            controller: _nameController,
            onSubmitted: (_) => _submitData(),
          ),
          calendarSelected == true
              ? Container(
                  height: 70,
                  // color: Theme.of(context).backgroundColor,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'No Date Chosen'
                              : 'Selected Date: ${DateFormat.yMMMEd().format(pickDate)}',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      // ElevatedButton(
                      // style: ButtonStyle(
                      //   backgroundColor: MaterialStateProperty.all(
                      //       Theme.of(context).primaryColor),
                      //   ),
                      //   onPressed: _presentDatePicker,
                      //   child: Icon(Icons.calendar_today,
                      //       color: Theme.of(context).backgroundColor),
                      // ),
                    ],
                  ),
                )
              : Divider(
                  color: Theme.of(context).dividerColor,
                  thickness: MediaQuery.of(context).size.height / 50,
                  height: MediaQuery.of(context).size.height / 50,
                ),
          ElevatedButton(
            onPressed: () => _submitData(),
            child: Text(
              'Add Task',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
