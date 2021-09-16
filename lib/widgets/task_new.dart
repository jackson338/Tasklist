import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewTask extends StatefulWidget {
  final Function addTaskFunc;
  NewTask(this.addTaskFunc);

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  int pageIndex;
  bool buildCalled = false;
  String _selectedDate;
  DateTime pickDate;
  final _nameController = TextEditingController();

  void _submitData() {
    if (  _nameController.text.isEmpty) {
      return;
    }
    final _enteredName = _nameController.text;
    final _enteredDate = _selectedDate.toString();

    if (pageIndex == 3) {
      widget.addTaskFunc(
        _enteredName,
        _enteredDate,
      );
      Navigator.of(context).pop();
    } else {
      widget.addTaskFunc(
        _enteredName,
      );
      Navigator.of(context).pop();
    }
  }

  void _getInt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      pageIndex = prefs.getInt('page index');
      buildCalled = true;
    });
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime(2022))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = DateFormat.yMMMd().format(pickedDate).toString();
        pickDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (buildCalled == false) {
      _getInt();
    }
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Enter a new task'),
          controller: _nameController,
          onSubmitted: (_) => _submitData(),
        ),
        pageIndex == 3
            ? Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen'
                            : 'Selected Date: ${DateFormat.yMMMd().format(pickDate)}',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _presentDatePicker,
                      child: Icon(Icons.calendar_today),
                    ),
                  ],
                ),
              )
            : Divider(
                color: Theme.of(context).accentColor,
                thickness: MediaQuery.of(context).size.height / 50,
                height: MediaQuery.of(context).size.height / 50,
              ),
        ElevatedButton(
          onPressed: _submitData,
          child: Text('Add Item'),
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
