import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/models/folder_mod.dart';
import 'package:tasklist_app/pages/journal_goal_page.dart';

class GoalFolder extends StatelessWidget {
  const GoalFolder({
    Key key,
    @required this.goalFolder,
  }) : super(key: key);
  final FolderMod goalFolder;
  // List<String> folderIdList = [];
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
      ),
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('Folder Name', goalFolder.date);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JournalGoalPage(
              folderDate: goalFolder.date,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Icon(
            Icons.folder,
            color: Theme.of(context).primaryColorLight,
          ),
          Text(
            goalFolder.date,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
