import 'package:flutter/material.dart';
import 'package:tasklist_app/models/task_mod.dart';
import 'package:tasklist_app/widgets/task_item.dart';

class TaskListWidgetReorderable extends StatefulWidget {
  final List<TaskMod> taskItems;
  final Function _deleteTask;
  final Function _completeTask;
  // final ValueKey valKey;

  TaskListWidgetReorderable(
      this.taskItems, this._deleteTask, this._completeTask);

  @override
  State<TaskListWidgetReorderable> createState() =>
      _TaskListWidgetReorderableState();
}

class _TaskListWidgetReorderableState extends State<TaskListWidgetReorderable> {
  // Widget buildTaskList(int index, TaskMod task) => TaskItem(
  //       taskItem: widget.taskItems[index],
  //       deleteTask: widget._deleteTask,
  //       completeTask: widget._completeTask,
  //     );

  // Widget buildTaskList(int index, TaskMod task) => Container(
  //       height: MediaQuery.of(context).size.height,
  //       child: ListTile(
  //         key: ValueKey(task.id),
  //         leading: TaskItem(
  //             taskItem: widget.taskItems[index],
  //             deleteTask: widget._deleteTask,
  //             completeTask: widget._completeTask),
  //       ),
  //     );

  @override
  Widget build(BuildContext context) {
    return widget.taskItems.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Text('No Tasks');
          })
        : ReorderableListView.builder(
          key: ValueKey(DateTime.now()),
            itemCount: widget.taskItems.length,
            itemBuilder: (ctx, index) {
              final task = widget.taskItems[index];
              return TaskItem(
                  // taskKey: ValueKey(task.id),
                  taskItem: task,
                  deleteTask: widget._deleteTask,
                  completeTask: widget._completeTask);
            },
            onReorder: (oldIndex, newIndex) => setState(() {
              final index = newIndex > oldIndex ? newIndex - 1 : newIndex;

              final task = widget.taskItems.removeAt(oldIndex);
              widget.taskItems.insert(index, task);
            }),
          );
  }
}
