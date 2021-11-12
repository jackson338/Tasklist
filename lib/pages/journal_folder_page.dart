import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/models/folder_mod.dart';
import 'package:tasklist_app/widgets/folder_list.dart';

class JournalYearlyPage extends StatefulWidget {
  @override
  _JournalYearlyPageState createState() => _JournalYearlyPageState();
}

class _JournalYearlyPageState extends State<JournalYearlyPage> {
  List<FolderMod> _folderItems = [];
  List<String> dateList = [];
  bool buildCalled = false;

  void _buildYearFolders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('page index', 5);
    print(prefs.getInt('page index'));
    if (prefs.getStringList('Home Date List') != null) {
      setState(() {
        dateList = prefs.getStringList('Home Date List').reversed.toList();
        String year = "";
        String date;
        for (date in dateList) {
          if (year == date.substring(8, 12))
            continue;
          year = date.substring(8, 12);
          final newFolder = FolderMod(date: year);
          _folderItems.add(newFolder);
          buildCalled = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (buildCalled == false) {
      _buildYearFolders();
    }
    // print(dateList);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 15,
        // brightness: Brightness.light,
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text(
          "Journal",
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: FolderList(_folderItems),
      ),
    );
  }
}

class JournalMonthlyPage extends StatefulWidget {
  @override
  _JournalMonthlyPage createState() => _JournalMonthlyPage();
}

class _JournalMonthlyPage extends State<JournalMonthlyPage> {
  List<FolderMod> _folderItems = [];
  List<String> dateList = [];
  bool buildCalled = false;
  String name;

  void _buildMonthFolders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('page index', 5);
    name = prefs.getString('Folder Name');
    if (prefs.getStringList('Home Date List') != null) {
      setState(() {
        dateList = prefs.getStringList('Home Date List').toList();
        String month = "";
        String date;
        for (date in dateList) {
          if (month == date.substring(0, 3))
            continue;
          month = date.substring(0, 3);
          final newFolder = FolderMod(date: month);
          _folderItems.add(newFolder);
          buildCalled = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (buildCalled == false) {
      _buildMonthFolders();
    }
    // print(dateList);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height / 15,
          // brightness: Brightness.light,
          backgroundColor: Theme.of(context).primaryColorDark,
          title: Text(
            name,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        body: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: FolderList(_folderItems),
            )
        )
    );
  }
}

class JournalFolderPage extends StatefulWidget {
  @override
  _JournalFolderPage createState() => _JournalFolderPage();
}

class _JournalFolderPage extends State<JournalFolderPage> {
  List<FolderMod> _folderItems = [];
  List<String> dateList = [];
  bool buildCalled = false;
  String name;

  void _buildFolders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('page index', 5);
    name = prefs.getString('Folder Name');
    if (prefs.getStringList('Home Date List') != null) {
      setState(() {
        dateList = prefs.getStringList('Home Date List').toList();
        print(dateList.length);
        String day = "";
        String date;
        for (date in dateList) {
          print(date);
          print(name.length);
          print(date.substring(0, 3).length);
          if (name != date.substring(0, 3))
            continue;
          if (day == date.substring(4, 6))
            continue;
          final newFolder = FolderMod(date: date);
          _folderItems.add(newFolder);
        }
        buildCalled = true;
      });
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
          toolbarHeight: MediaQuery.of(context).size.height / 15,
          // brightness: Brightness.light,
          backgroundColor: Theme.of(context).primaryColorDark,
          title: Text(
            name,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        body: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: FolderList(_folderItems),
            )
        )
    );
  }
}
