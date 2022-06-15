import 'package:flutter/material.dart';
import 'package:tasklist_app/models/folder_mod.dart';
import 'package:tasklist_app/widgets/goal_folder_item.dart';

class GoalFolderList extends StatelessWidget {
  final List<FolderMod> goalFolderItems;

  GoalFolderList(this.goalFolderItems);
  @override
  Widget build(BuildContext context) {
    return goalFolderItems.isEmpty
        ? Text(
            'No Folders',
            style: Theme.of(context).textTheme.bodyText1,
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return GoalFolder(
                goalFolder: goalFolderItems[index],
              );
            },
            itemCount: goalFolderItems.length,
          );
  }
}
