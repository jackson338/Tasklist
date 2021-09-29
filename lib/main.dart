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
        accentColor: Colors.blueAccent,
        brightness: Brightness.light,
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
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height / 15,
          margin: EdgeInsets.only(bottom: 20),
          child: new TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                icon: Icon(Icons.flag),
              ),
              Tab(
                icon: Icon(Icons.list),
              ),
              Tab(
                icon: Icon(Icons.event_note_outlined),
              ),
              Tab(
                icon: Icon(Icons.loop),
              ),
              Tab(
                icon: Icon(Icons.sticky_note_2_outlined),
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
