import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/pages/journal_note.dart';
import 'package:tasklist_app/pages/journal_tasks.dart';
import '../models/task_mod.dart';
import 'package:tasklist_app/widgets/task_list.dart';

class JournalNavigatorPage extends StatefulWidget {
  @override
  _JournalNavigatorPageState createState() => _JournalNavigatorPageState();
}

class _JournalNavigatorPageState extends State<JournalNavigatorPage> {
  bool buildCalled = false;
  String name;

  void _buildTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('Folder Name');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (buildCalled == false) {
      _buildTasks();
    }
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).dividerColor),
        backgroundColor: Theme.of(context).primaryColorDark,
        title: name != null
            ? Text(
                name,
                style: Theme.of(context).textTheme.headline5,
              )
            : Text('Title...'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColorDark),
                ),
                child: Center(
                  child: Text('Tasks Completed Today'),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => JournalTasksPage(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColorDark),
                ),
                child: Center(
                  child: Text('Notes For Today'),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => JournalNotePage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
