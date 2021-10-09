import 'package:flutter/material.dart';
import 'package:tasklist_app/pages/goal_page.dart';
import 'package:tasklist_app/pages/home.dart';
import 'package:tasklist_app/pages/journal_folder_page.dart';
import './pages/daily.dart';
import 'pages/calendar_tasks.dart';
import './pages/today.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ride on ohv',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.tealAccent,
        primaryColorLight: Colors.lightBlue,
        primaryColorDark: Colors.blueGrey,
        backgroundColor: Colors.black54,
        dividerColor: Colors.teal,
        brightness: Brightness.dark,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          subtitle2: TextStyle(color: Colors.black54),
          subtitle1: TextStyle(color: Colors.white),
          headline2: TextStyle(color: Colors.white),
          headline3: TextStyle(color: Colors.white),
          headline4: TextStyle(color: Colors.white),
          headline5: TextStyle(color: Colors.white),
          headline6: TextStyle(color: Colors.white),
        ),
      ),
      home: Controller(title: 'ohv home'),
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
    HomePage(),
    GoalPage(),
    TodayPage(),
    FuturePage(),
    DailyPage(),
    JournalYearlyPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      initialIndex: 2,
      child: Scaffold(
        body: TabBarView(
          children: _pages,
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
        bottomNavigationBar: Container(
          // color: Theme.of(context).primaryColorDark,
          height: MediaQuery.of(context).size.height / 15,
          margin: EdgeInsets.only(bottom: 20),
          child: new TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.home,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.flag,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.list,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.event_note_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.loop,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.sticky_note_2_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
            unselectedLabelColor: Colors.black,
            labelColor: Theme.of(context).primaryColor,
            indicatorColor: Theme.of(context).primaryColor,
          ),
        ),
        //   floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add),
        //   onPressed: (){},
        // ),
      ),
    );
  }
}
