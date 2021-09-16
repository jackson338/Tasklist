import 'package:flutter/material.dart';
import 'package:tasklist_app/models/folder_mod.dart';
import 'package:tasklist_app/widgets/folder_item.dart';

class FolderList extends StatelessWidget {
  final List<FolderMod> folderItems;

  FolderList(this.folderItems);
  @override
  Widget build(BuildContext context) {
    return folderItems.isEmpty
        ? Text('No Folders')
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return FolderItem(
                folderItem: folderItems[index],
              );
            },
            itemCount: folderItems.length,
          );
  }
}
