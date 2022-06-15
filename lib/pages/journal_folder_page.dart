import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/models/folder_mod.dart';
import 'package:tasklist_app/widgets/folder_list.dart';
import 'package:tasklist_app/widgets/goal_folder_list%20copy.dart';

class JournalYearlyPage extends StatefulWidget {
  @override
  _JournalYearlyPageState createState() => _JournalYearlyPageState();
}

class _JournalYearlyPageState extends State<JournalYearlyPage> {
  List<FolderMod> _folderItems = [];
  List<FolderMod> _goalFolderItems = [];
  List<String> dateList = [];
  List<String> goalDateList = [];
  bool buildCalled = false;

  void _buildFolders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('page index', 5);
    if (prefs.getStringList('Home Date List') != null) {
      setState(() {
        dateList = prefs.getStringList('Home Date List').reversed.toList();
        String id;
        for (id in dateList) {
          final newFolder = FolderMod(date: id);
          _folderItems.add(newFolder);
          buildCalled = true;
        }
      });
      if (prefs.getStringList('goal dates') != null) {
        goalDateList = prefs.getStringList('goal dates').reversed.toList();
        String id;
        for (id in goalDateList) {
          final newFolder = FolderMod(date: id);
          setState(() {
            _goalFolderItems.add(newFolder);
          });
          buildCalled = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (buildCalled == false) {
      _buildFolders();
    }
    // print(dateList);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).dividerColor,
          ),
        ),
        toolbarHeight: MediaQuery.of(context).size.height / 15,
        // brightness: Brightness.light,
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        title: Text(
          "Journal",
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height,
                child: FolderList(_folderItems)),
            SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height,
                child: GoalFolderList(_goalFolderItems)),
          ],
        ),
      ),
    );
  }
}
