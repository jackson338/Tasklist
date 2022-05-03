import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/pages/goal_page.dart';

class NewGoal extends StatefulWidget {
  final Function addGoalFunc;
  NewGoal(this.addGoalFunc);

  @override
  _NewGoalState createState() => _NewGoalState();
}

class _NewGoalState extends State<NewGoal> {
  int pageIndex;
  bool buildCalled = false;
  final _goalController = TextEditingController();

  void _submitData() async {
    if (_goalController.text.isEmpty) {
      return;
    }
    final _enteredGoal = _goalController.text;

      widget.addGoalFunc(
        _enteredGoal,
      );
      Navigator.of(context).pop();
  }

  void _getInt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      pageIndex = prefs.getInt('page index');
      buildCalled = true;
    });
  }

  // void _presentDatePicker() {
  //   showDatePicker(
  //           context: context,
  //           initialDate: DateTime.now(),
  //           firstDate: DateTime.now(),
  //           lastDate: DateTime(2030))
  //       .then((pickedDate) {
  //     if (pickedDate == null) {
  //       return;
  //     }
  //     setState(() {
  //       _selectedDate = DateFormat.yMMMd().format(pickedDate).toString();
  //       pickDate = pickedDate;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    if (buildCalled == false) {
      _getInt();
    }
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: [
          TextField(
            style: Theme.of(context).textTheme.subtitle2,
            cursorColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
              labelText: 'Enter a new task',
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
              // hintStyle: TextStyle(color: Theme.of(context).dividerColor),
            ),
            controller: _goalController,
            onSubmitted: (_) => _submitData(),
          ),
          // calendarSelected == true
          //     ? Container(
          //         height: 70,
          //         // color: Theme.of(context).backgroundColor,
          //         child: Row(
          //           children: [
          //             Expanded(
          //               child: Text(
          //                 _selectedDate == null
          //                     ? 'No Date Chosen'
          //                     : 'Selected Date: ${DateFormat.yMMMd().format(pickDate)}',
          //               ),
          //             ),
          //           ],
          //         ),
          //       )
               Divider(
                  color: Theme.of(context).dividerColor,
                  thickness: MediaQuery.of(context).size.height / 50,
                  height: MediaQuery.of(context).size.height / 50,
                ),
          ElevatedButton(
            onPressed: () => _submitData(),
            child: Text(
              'Add Task',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
