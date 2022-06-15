import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/pages/goal_page.dart';
import 'package:tasklist_app/pages/home.dart';
import 'package:tasklist_app/widgets/task_new.dart';
import './pages/today.dart';
import 'package:tasklist_app/models/task_mod.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool darkTheme = false;
  bool buildCalled = false;

  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getBool('theme bool') != null) {
        darkTheme = prefs.getBool('theme bool');
      } else {
        darkTheme = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (buildCalled == false) {
      getTheme();
      buildCalled = true;
    }

    return darkTheme
    //dark theme.
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Tasklist App Dark',
            theme: ThemeData(
              primaryColor: Colors.blueGrey,
              cardColor: Colors.teal[300],
              primaryColorLight: Colors.tealAccent,
              backgroundColor: Colors.blueGrey[900],
              dividerColor: Colors.teal,
              hintColor: Colors.tealAccent,
              // brightness: Brightness.dark,
              textTheme: TextTheme(
                bodyText1: TextStyle(color: Colors.white),
                bodyText2: TextStyle(color: Colors.black),
                subtitle1: TextStyle(color: Colors.white),
                subtitle2: TextStyle(color: Colors.black54),
                headline2: TextStyle(color: Colors.white),
                headline3: TextStyle(color: Colors.white),
                headline4: TextStyle(color: Colors.white),
                headline5: TextStyle(color: Colors.white),
                headline6: TextStyle(color: Colors.white),
              ),
            ),
            home: Controller(title: 'tasklist home'),
          )
        : 
        //light theme
        MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Tasklist App Light',
            theme: ThemeData(
              cardColor: Colors.grey,
              primaryColor: Colors.black,
              primaryColorLight: Colors.white,
              backgroundColor: Colors.white,
              dividerColor: Colors.grey,
              // brightness: Brightness.dark,
              hintColor: Colors.black,
              textTheme: TextTheme(
                bodyText1: TextStyle(color: Colors.black),
                bodyText2: TextStyle(color: Colors.white),
                subtitle1: TextStyle(color: Colors.white),
                subtitle2: TextStyle(color: Colors.black),
                headline2: TextStyle(color: Colors.black),
                headline3: TextStyle(color: Colors.black),
                headline4: TextStyle(color: Colors.black),
                headline5: TextStyle(color: Colors.black),
                headline6: TextStyle(color: Colors.black),
              ),
            ),
            home: Controller(title: 'tasklist home'),
          );
  }
}

class Controller extends StatefulWidget {
  Controller({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ControllerState createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  List<Widget> _pages = [
    GoalPage(),
    TodayPage(),
    HomePage(),
    // FuturePage(),
    // DailyPage(),
    // JournalYearlyPage(),
  ];
  List<String> dateList = [];
  List<String> idList = [];
  List<String> dailyBuildList = [];
  List<String> dailyidList = [];
  List<String> goalsIdList = [];
  List<String> calendarIDlist = [];
  String _iconName = 'check_circle_outline';

  void _addNewTask(String _task, String _date, DateTime pickDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String selectedList = prefs.getString('selected list');
      if (selectedList == null) {
        setState(() {
          selectedList = "today";
          prefs.setString('selected list', selectedList);
        });
      }
      if (selectedList == 'calendar') {
        prefs.setInt('page index', 3);
        _addNewCalendarTask(_task, _date, pickDate);
      }
      if (selectedList == 'today') {
        prefs.setInt('page index', 2);
        _addTodayTask(_task);
      }
      if (selectedList == 'daily') {
        prefs.setInt('page index', 4);
        _addNewDailyTask(_task);
      }
      if (selectedList == 'goal') {
        prefs.setInt('page index', 1);
        _addNewGoal(_task);
      }
    });
  }

  void _addTodayTask(String _task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('ID List') != null) {
      idList = prefs.getStringList('ID List');
    }
    final newTask = TaskMod(
      task: _task,
      iconName: _iconName,
      finish: null,
      id: DateTime.now().toString(),
    );
    prefs.setString('${newTask.id} Task', newTask.task);
    setState(() {
      // _taskList.add(newTask);
      idList.add(newTask.id);
      prefs.setStringList('ID List', idList);
    });
  }

  void _addNewCalendarTask(
    String calendarTask,
    String date,
    DateTime _dateTime,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('Calendar ID List') != null) {
      calendarIDlist = prefs.getStringList('Calendar ID List');
    }
    final int _year = _dateTime.year;
    final int _month = _dateTime.month;
    final int _day = _dateTime.day;
    final newCalendarTask = TaskMod(
      task: calendarTask,
      iconName: _iconName,
      finish: date,
      id: DateTime.now().toString(),
      year: _year,
      month: _month,
      day: _day,
    );
    prefs.setString('${newCalendarTask.id} Calendar Task', newCalendarTask.task);
    prefs.setString('${newCalendarTask.id} Calendar Date', newCalendarTask.finish);
    prefs.setInt('${newCalendarTask.id} year', _year);
    prefs.setInt('${newCalendarTask.id} month', _month);
    prefs.setInt('${newCalendarTask.id} day', _day);
    setState(() {
      // calendarList.add(newCalendarTask);
      calendarIDlist.add(newCalendarTask.id);
      prefs.setStringList('Calendar ID List', calendarIDlist);
    });
  }

  void _addNewDailyTask(
    String _task,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('Daily ID List') != null) {
      dailyidList = prefs.getStringList('Daily ID List');
    }
    if (prefs.getStringList('Daily Build List') != null) {
      dailyBuildList = prefs.getStringList('Daily Build List');
    }
    if (prefs.getInt('page index') == 4) {
      final newTask = TaskMod(
        task: _task,
        iconName: _iconName,
        finish: null,
        id: DateTime.now().toString(),
      );
      prefs.setString('${newTask.id} Daily Task', newTask.task);
      setState(() {
        dailyidList.add(newTask.id);
        prefs.setStringList('Daily ID List', dailyidList);
        dailyBuildList.add(newTask.id);
        prefs.setStringList('Daily Build List', dailyBuildList);
      });
    }
  }

  void _addNewGoal(
    String _task,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('Goal ID List') != null) {
      goalsIdList = prefs.getStringList('Goal ID List');
    }
    if (prefs.getInt('page index') == 1) {
      final newGoal = TaskMod(
        task: _task,
        iconName: _iconName,
        finish: null,
        id: DateTime.now().toString(),
      );
      prefs.setString('${newGoal.id} Goal Task', newGoal.task);
      setState(() {
        // _goalsList.add(newGoal);
        goalsIdList.add(newGoal.id);
        prefs.setStringList('Goal ID List', goalsIdList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 2,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Theme.of(context).primaryColorLight,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          splashColor: Theme.of(context).primaryColorLight,
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setInt('page index', 2);
            showModalBottomSheet(
              context: context,
              builder: (_) {
                return GestureDetector(
                  onTap: () {},
                  child: NewTask(_addNewTask),
                  behavior: HitTestBehavior.opaque,
                );
              },
            );
          },
        ),
        body: TabBarView(
          children: _pages,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        bottomNavigationBar: Container(
          // color: Theme.of(context).primaryColor,
          height: MediaQuery.of(context).size.height / 15,
          margin: EdgeInsets.only(bottom: 20),
          child: new TabBar(
            overlayColor: MaterialStateProperty.all(Theme.of(context).primaryColorLight),
            tabs: [
              Tab(
                icon: Icon(
                  Icons.map_outlined,
                  color: Theme.of(context).hintColor,
                ),
                child: Text(
                  'Goals',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.list,
                  color: Theme.of(context).hintColor,
                ),
                child: Text(
                  'Today',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.home,
                  color: Theme.of(context).hintColor,
                ),
                child: Text(
                  'Home',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
            unselectedLabelColor: Colors.black,
            labelColor: Theme.of(context).primaryColor,
            indicatorColor: Theme.of(context).hintColor,
          ),
        ),
      ),
    );
  }
}
