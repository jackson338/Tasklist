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

  void _buildFolders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('page index', 5);
    print(prefs.getInt('page index'));
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
        width: MediaQuery.of(context).size.width / 3,
        child: FolderList(_folderItems),
      ),
    );
  }
}
