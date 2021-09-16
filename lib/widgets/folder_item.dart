import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/models/folder_mod.dart';
import 'package:tasklist_app/pages/journal.dart';

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
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('Folder Name', folderItem.date);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JournalPage(),
          ),
        );
      },
      child: Column(
        children: [
          Icon(
            Icons.folder,
            color: Colors.black,
          ),
          Text(
            folderItem.date,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
