import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/models/note_mod.dart';

class JournalNotePage extends StatefulWidget {
  const JournalNotePage({Key key}) : super(key: key);

  @override
  _JournalNotePageState createState() => _JournalNotePageState();
}

class _JournalNotePageState extends State<JournalNotePage> {
  TextEditingController controller = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  List<NoteMod> noteList = [];
  List<String> noteIds = [];
  String pageName;
  String test = 'Whay was today Good or Bad?';
  bool buildCalled = false;
  double scaleVal = 0;

  void _buildTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      pageName = prefs.getString('Folder Name');
      if (prefs.getStringList('$pageName note ids') != null) {
        noteIds = prefs.getStringList('$pageName note ids');
      } else if (prefs.getStringList('general note ids') != null) {
        noteIds = prefs.getStringList('general note ids');
      }
      for (String id in noteIds) {
        bool slideNum = prefs.getBool('$id slide/num');
        TextEditingController _noteController = TextEditingController();
        final newNote = NoteMod(
          question: prefs.getString('$id question'),
          start: slideNum == true ? prefs.getString('$id start') : '',
          end: slideNum == true ? prefs.getString('$id end') : '',
          note: prefs.getString('$id note'),
          id: id,
          scaleVal: slideNum == true ? prefs.getDouble('$id scaleVal') : 0,
          num: slideNum == false ? prefs.getInt('$id num') : 0,
          slide_num: prefs.getBool('$id slide/num'),
          noteController: _noteController,
        );
        noteList.add(newNote);
      }
      buildCalled = true;
    });
  }

  void _submit(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(text);
  }

  // bool slideNum = true;
  // bool slideNum2 = false;

  // void _onChanged(bool) {
  //   setState(() {
  //     if (slideNum == false) {
  //       slideNum = true;
  //       slideNum2 = false;
  //     } else {
  //       slideNum = false;
  //       slideNum2 = true;
  //     }
  //   });
  // }

  bool slideNum = true;

  void addNewNote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _question;
    String _start;
    String _end;
    String _id = DateTime.now().toString();
    String _note = 'testing';
    double _scaleVal = 0;
    int _num = 0;
    TextEditingController _noteController = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 8,
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColorDark),
                        ),
                        child: Text('Slider'),
                        onPressed: () {
                          setState(() {
                            slideNum = true;
                          });
                        },
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColorDark),
                        ),
                        child: Text('Number'),
                        onPressed: () {
                          setState(() {
                            slideNum = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                TextField(
                  style: Theme.of(context).textTheme.subtitle1,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    labelText: 'Question',
                    labelStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  controller: questionController,
                  onSubmitted: (_) {
                    setState(() {
                      _question = questionController.text;
                    });
                  },
                ),
                slideNum == true
                    ? TextField(
                        style: Theme.of(context).textTheme.subtitle1,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          labelText: 'Start',
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        controller: startController,
                        onSubmitted: (_) {
                          setState(() {
                            _start = startController.text;
                          });
                        },
                      )
                    : Text('nothing'),
                slideNum == true
                    ? TextField(
                        style: Theme.of(context).textTheme.subtitle1,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          labelText: 'End',
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        controller: endController,
                        onSubmitted: (_) {
                          setState(() {
                            _end = endController.text;
                          });
                        },
                      )
                    : Text('nothing'),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColorDark),
                    ),
                    child: Text('Done'),
                    onPressed: () {
                      setState(() {
                        _question = questionController.text;
                        _start = startController.text;
                        _end = endController.text;
                        final newNote = NoteMod(
                          question: _question,
                          start: _start,
                          end: _end,
                          note: _note,
                          id: _id,
                          scaleVal: _scaleVal,
                          num: _num,
                          slide_num: slideNum,
                          noteController: _noteController,
                        );
                        noteList.add(newNote);
                        noteIds.add(_id);
                        prefs.setStringList('$pageName note ids', noteIds);
                        prefs.setStringList('general note ids', noteIds);
                        prefs.setString('$_id question', _question);
                        prefs.setString('$_id note', _note);
                        prefs.setBool('$_id slide/num', slideNum);
                        if (slideNum == true) {
                          prefs.setString('$_id start', _start);
                          prefs.setString('$_id end', _end);
                          prefs.setDouble('$_id scaleVal', _scaleVal);
                        } else {
                          prefs.setInt('$_id num', _num);
                        }
                        buildCalled = true;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

//delete note func called "removeNote"
  void removeNote(NoteMod note) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      noteIds.remove(note.id);
      noteList.remove(note);
      prefs.setStringList('$pageName note ids', noteIds);
      prefs.setStringList('general note ids', noteIds);
      prefs.remove('${note.id} question');
      prefs.remove('${note.id} start');
      prefs.remove('${note.id} end');
      prefs.remove('${note.id} note');
      prefs.remove('${note.id} scaleVal');
      prefs.remove('${note.id} num');
      prefs.remove('${note.id} slide/num');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (buildCalled == false) {
      _buildTasks();
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).dividerColor),
        backgroundColor: Theme.of(context).primaryColorDark,
        title: pageName != null
            ? Text(
                pageName,
                style: Theme.of(context).textTheme.headline5,
              )
            : Text('Title...'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          addNewNote();
        },
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.2,
            child: noteList != null
                ? ListView.builder(
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          Text(noteList.elementAt(index).question),
                          noteList.elementAt(index).slide_num == true
                              ? Text('${noteList.elementAt(index).scaleVal}')
                              : Text('${noteList.elementAt(index).num}'),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(noteList.elementAt(index).start),
                              noteList.elementAt(index).slide_num == true
                                  ? Slider(
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      inactiveColor:
                                          Theme.of(context).dividerColor,
                                      label:
                                          '${noteList.elementAt(index).scaleVal}',
                                      value: noteList
                                          .elementAt(index)
                                          .scaleVal
                                          .roundToDouble(),
                                      onChanged: (newScale) async {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        setState(() =>
                                            noteList.elementAt(index).scaleVal =
                                                newScale.roundToDouble());
                                      },
                                      min: 0,
                                      max: 10,
                                    )
                                  : Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              noteList.elementAt(index).num -=
                                                  1;
                                            });
                                          },
                                          icon: Icon(Icons.remove),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              noteList.elementAt(index).num +=
                                                  1;
                                            });
                                          },
                                          icon: Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                              Text(noteList.elementAt(index).end),
                            ],
                          ),
                          TextFormField(
                            maxLines: 5,
                            cursorColor: Theme.of(context).primaryColor,
                            toolbarOptions: ToolbarOptions(
                              copy: true,
                              cut: true,
                              paste: true,
                              selectAll: true,
                            ),
                            controller:
                                noteList.elementAt(index).noteController,
                            autocorrect: true,
                            onFieldSubmitted: (_controller) {
                              _submit(_controller);
                            },
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColorDark),
                            ),
                            child: ListTile(
                              leading: Icon(
                                Icons.delete,
                                color: Theme.of(context).primaryColor,
                              ),
                              title: Text('delete'),
                            ),
                            onPressed: () {
                              removeNote(noteList.elementAt(index));
                            },
                          ),
                        ],
                      );
                    },
                    itemCount: noteList.length,
                  )
                : Text('No notes'),
          ),
        ],
      ),
    );
  }
}
