import 'package:flutter/material.dart';
import 'package:tasklist_app/models/goal_mod.dart';
import 'package:tasklist_app/widgets/goal_item.dart';

class GoalListWidget extends StatelessWidget {
  final List<GoalMod> goalItems;
  final Function _openGoal;
  final Function _completeGoal;
  // ValueKey key;

  GoalListWidget(this.goalItems, this._openGoal, this._completeGoal);

  @override
  Widget build(BuildContext context) {
    return goalItems.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Text(
              'No Goals',
              style: Theme.of(context).textTheme.bodyText1,
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return GoalItem(
                // taskKey: ValueKey(taskItems[index].id),
                goalItem: goalItems[index],
                openGoal: _openGoal,
                completeGoal: _completeGoal,
              );
            },
            itemCount: goalItems.length,
          );
  }
}
