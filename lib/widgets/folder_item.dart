import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/models/folder_mod.dart';
<<<<<<< HEAD
import 'package:tasklist_app/pages/journal_navigator.dart';
import 'package:tasklist_app/pages/journal_tasks.dart';
=======
import 'package:tasklist_app/pages/journal.dart';
import 'package:tasklist_app/pages/journal_folder_page.dart';
>>>>>>> main

class FolderItem extends StatelessWidget {
  const FolderItem({
    Key key,
    @required this.folderItem,
  }) : super(key: key);
  final FolderMod folderItem;
  // List<String> folderIdList = [];
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(Theme.of(context).primaryColorDark),
      ),
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('Folder Name', folderItem.date);
        dynamic page;
        if (folderItem.date.length == 4){
          page = JournalMonthlyPage();
        }
        else if (folderItem.date.length == 3) {
          page = JournalFolderPage();
        }
        else{
          page = JournalPage();
        }
        Navigator.push(
          context,
          MaterialPageRoute(
<<<<<<< HEAD
            builder: (context) => JournalTasksPage(),
=======
            builder: (context) => page,
>>>>>>> main
          ),
        );
      },
      child: Column(
        children: [
          Icon(
            Icons.folder,
            color: Theme.of(context).dividerColor,
          ),
          Text(
            folderItem.date,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
