import 'package:flutter/material.dart';
import 'package:tasklist_app/models/task_mod.dart';
import 'package:tasklist_app/widgets/task_item.dart';

class TaskListWidget extends StatelessWidget {
  final List<TaskMod> taskItems;
  final Function _deleteTask;
  final Function _completeTask;
  ValueKey key;

  TaskListWidget(this.taskItems, this._deleteTask, this._completeTask, this.key);

  @override
  Widget build(BuildContext context) {
    return taskItems.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Text('No Tasks');
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return TaskItem(
                taskItem: taskItems[index],
                deleteTask: _deleteTask,
                completeTask: _completeTask,
              );
            },
            itemCount: taskItems.length,
          );
  }
}
