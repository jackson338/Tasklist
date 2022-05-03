import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/pages/calendar_page.dart';
import 'package:tasklist_app/pages/settings.dart';
import 'package:tasklist_app/pages/statistics_page.dart';
import 'package:tasklist_app/pages/daily.dart';
import 'package:tasklist_app/pages/journal_folder_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool buildCalled = false;
  bool dateChange = false;
  int listD = 0;
  int streak = 0;
  List<FlSpot> points = [];
  List<String> chartIds = [];
  List<String> weekIds = [];
  List<String> percentages = [];
  List<String> allIds = [];
  List<Color> chartColors = [];
  String _dateTime;
  double totalCompleted = 0.0;
  double dayCompleted = 0;
  double percentage = 0.0;
  double dateLengthD = 0.0;
  double streakWidthFactor = 0.0;
  Color streakColor = Colors.grey;
  Color streakProgress = Colors.blueGrey;

  void getChartValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = 0;
    setState(() {
      if (prefs.getInt('streak') != null) {
        streak = prefs.getInt('streak');
      }
      dateChange = prefs.getBool('dateChange');
      if (prefs.getStringList('chart ids') != null) {
        chartIds = prefs.getStringList('chart ids');
      }
      if (chartIds.contains(_dateTime) == false) {
        chartIds.add(_dateTime);
        prefs.setStringList('chart ids', chartIds);
      }
      count = chartIds.length - 1;
      if (count > 6) {
        weekIds.add(chartIds.elementAt(count - 6));
        weekIds.add(chartIds.elementAt(count - 5));
        weekIds.add(chartIds.elementAt(count - 4));
        weekIds.add(chartIds.elementAt(count - 3));
        weekIds.add(chartIds.elementAt(count - 2));
        weekIds.add(chartIds.elementAt(count - 1));
        weekIds.add(chartIds.elementAt(count));
      } else {
        weekIds = chartIds;
      }
      String id;
      int count2 = count;
      for (id in weekIds) {
        count2 -= 1;
        if (prefs.getStringList('Daily ID List') == null) {
          prefs.setStringList('Daily ID List', ['test']);
        }
        listD = prefs.getInt('$id daily count') == null
            ? prefs.getStringList('Daily ID List').length
            : prefs.getInt('$id daily count');

        int buildLength = prefs.getInt('$id daily build count');
        int dailyLength = prefs.getInt('$id daily count');
        // print(prefs.getStringList('Daily ID List'));
        if (buildLength != null) {
          percentage = ((dailyLength - buildLength) * 100) / dailyLength;
          if (prefs.getStringList('daily percentages') != null) {
            percentages = prefs.getStringList('daily percentages');
          }
          if (percentages.contains(percentage) == false) {
            percentages.add('${(percentage).roundToDouble()}');
            prefs.setStringList('daily percentages', percentages);
          }
          // print('BuildLength: $buildLength, DailyLength: $dailyLength, percent: $percentage');
        }
        if (prefs.getDouble('$id total completed') == null) {
          prefs.setDouble('$id total completed', 0);
        }
        totalCompleted = percentage != null
            ? buildLength != null
                ? percentage.roundToDouble()
                : totalCompleted = (prefs.getDouble('$id total completed') * 100) / listD
            : percentage.roundToDouble();
        // totalCompleted = (prefs.getDouble('$id total completed') * 10) / listD;
        dayCompleted += 1;
        if (totalCompleted > 100) {
          totalCompleted = 100;
        }
        if (totalCompleted < 1) {
          totalCompleted = 1;
        }
        if (totalCompleted >= 75 && dateChange == false && count2 == 0) {
          streak += 1;
          prefs.setInt('streak', streak);
          dateChange = true;
          prefs.setBool('dateChange', dateChange);
        }
        if (count2 == 1) {
          if (totalCompleted < 75 && dateChange == false) {
            streak = 0;
            prefs.setInt('streak', streak);
          }
          print('count in list: $count2 total complete: $totalCompleted');
        }
        print('count: $count2 total complete: $totalCompleted');

        prefs.setDouble('$id average percentage', totalCompleted);
        if (prefs.getStringList('daily average ids') != null) {
          allIds = prefs.getStringList('daily average ids');
        }
        allIds.add(id);
        prefs.setStringList('daily average ids', allIds);
        points.add(
          FlSpot(dayCompleted, totalCompleted),
        );
      }
      DateTime date = DateTime.now();
      int day = date.day;
      dateLengthD += day;
      buildCalled = true;
    });
  }

  void getStreakColors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int colorStreak = 0;
    if (prefs.getInt('streak') != null) {
      colorStreak = prefs.getInt('streak');
    }
    if (colorStreak >= 7) {
      streakColor = Colors.blueGrey;
      streakProgress = Colors.blue;
    } else {
      streakWidthFactor = ((streak * 100) / 7) / 100;
    }
    if (colorStreak >= 21) {
      streakColor = Colors.blue;
      streakProgress = Colors.yellow;
    } else if (colorStreak >= 7) {
      streakWidthFactor = ((streak * 100) / 21) / 100;
    }
    if (colorStreak >= 42) {
      streakColor = Colors.yellow;
      streakProgress = Colors.orange;
    } else if (colorStreak >= 21) {
      streakWidthFactor = ((streak * 100) / 42) / 100;
    }
    if (colorStreak >= 100) {
      streakColor = Colors.red;
      streakProgress = Colors.amber;
    } else if (colorStreak >= 42) {
      streakWidthFactor = 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    chartColors = [
      Theme.of(context).dividerColor,
      Theme.of(context).cardColor,
      Theme.of(context).primaryColorLight
    ];
    _dateTime = DateFormat.yMMMEd().format(DateTime.now()).toString();
    if (buildCalled == false) {
      getChartValues();
      getStreakColors();
    }
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Home Page'),
                    backgroundColor: Theme.of(context).backgroundColor,
                    actions: [
                      Text(
                        'Welcome to the Home Page! This is where you\'ll see a chart for the percentage of daily tasks you\'ve completed this week.',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          'You will also be able to navigate to your Calendar, Daily Task, Journal, and Statistics pages!',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).dividerColor),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Dismiss',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).dividerColor),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Adding Tasks'),
                                      backgroundColor: Theme.of(context).backgroundColor,
                                      actions: [
                                        Text(
                                          'Hit the \"+\" button to add a new:',
                                          style: Theme.of(context).textTheme.headline6,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  'Calendar Task',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  'Today Task',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  'Daily Task',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  'Goal Task',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty.all(
                                                                Theme.of(context)
                                                                    .dividerColor),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text(
                                                        'Dismiss',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty.all(
                                                                Theme.of(context)
                                                                    .dividerColor),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                        showDialog(
                                                          barrierDismissible: true,
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title:
                                                                  Text('Calendar Tasks'),
                                                              backgroundColor:
                                                                  Theme.of(context)
                                                                      .backgroundColor,
                                                              actions: [
                                                                Text(
                                                                  'Calendar tasks add to your today list automatically on their set date.',
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .bodyText1,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(8.0),
                                                                      child:
                                                                          ElevatedButton(
                                                                        style:
                                                                            ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(
                                                                                  Theme.of(context)
                                                                                      .dividerColor),
                                                                        ),
                                                                        onPressed: () {
                                                                          Navigator.of(
                                                                                  context)
                                                                              .pop();
                                                                        },
                                                                        child: Text(
                                                                          'Dismiss',
                                                                          style: Theme.of(
                                                                                  context)
                                                                              .textTheme
                                                                              .bodyText1,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(8.0),
                                                                      child:
                                                                          ElevatedButton(
                                                                        style:
                                                                            ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(
                                                                                  Theme.of(context)
                                                                                      .dividerColor),
                                                                        ),
                                                                        onPressed: () {
                                                                          Navigator.of(
                                                                                  context)
                                                                              .pop();
                                                                          showDialog(
                                                                            barrierDismissible:
                                                                                true,
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (context) {
                                                                              return AlertDialog(
                                                                                title: Text(
                                                                                    'Today Task'),
                                                                                backgroundColor:
                                                                                    Theme.of(context)
                                                                                        .backgroundColor,
                                                                                actions: [
                                                                                  Text(
                                                                                    'Today Tasks add to your Today List. They will stay there until completed or deleted. You shouldn\'t have a today task for more than a couple days. ',
                                                                                    style: Theme.of(context)
                                                                                        .textTheme
                                                                                        .bodyText1,
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: ElevatedButton(
                                                                                          style: ButtonStyle(
                                                                                            backgroundColor: MaterialStateProperty.all(Theme.of(context).dividerColor),
                                                                                          ),
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                          child: Text(
                                                                                            'Dismiss',
                                                                                            style: Theme.of(context).textTheme.bodyText1,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: ElevatedButton(
                                                                                          style: ButtonStyle(
                                                                                            backgroundColor: MaterialStateProperty.all(Theme.of(context).dividerColor),
                                                                                          ),
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop();
                                                                                            showDialog(
                                                                                              barrierDismissible: true,
                                                                                              context: context,
                                                                                              builder: (context) {
                                                                                                return AlertDialog(
                                                                                                  title: Text('Daily Task'),
                                                                                                  backgroundColor: Theme.of(context).backgroundColor,
                                                                                                  actions: [
                                                                                                    Text(
                                                                                                      'Daily Tasks will add to your Daily Today list. These will repeat every day. Use these to set a routine.',
                                                                                                      style: Theme.of(context).textTheme.bodyText1,
                                                                                                    ),
                                                                                                    Row(
                                                                                                      children: [
                                                                                                        Padding(
                                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                                          child: ElevatedButton(
                                                                                                            style: ButtonStyle(
                                                                                                              backgroundColor: MaterialStateProperty.all(Theme.of(context).dividerColor),
                                                                                                            ),
                                                                                                            onPressed: () {
                                                                                                              Navigator.of(context).pop();
                                                                                                            },
                                                                                                            child: Text(
                                                                                                              'Dismiss',
                                                                                                              style: Theme.of(context).textTheme.bodyText1,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Padding(
                                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                                          child: ElevatedButton(
                                                                                                            style: ButtonStyle(
                                                                                                              backgroundColor: MaterialStateProperty.all(Theme.of(context).dividerColor),
                                                                                                            ),
                                                                                                            onPressed: () {
                                                                                                              Navigator.of(context).pop();
                                                                                                              showDialog(
                                                                                                                barrierDismissible: true,
                                                                                                                context: context,
                                                                                                                builder: (context) {
                                                                                                                  return AlertDialog(
                                                                                                                    title: Text('Goal Task'),
                                                                                                                    backgroundColor: Theme.of(context).backgroundColor,
                                                                                                                    actions: [
                                                                                                                      Text(
                                                                                                                        'Goal tasks add to your Goals list. You can go into a Goal Task and add sub-goals through the list icon on the right. You can add and track an infinite amount of sub goals! Use these to help you achieve your goals. To delete a goal or sub goal with all of it\'s sub goals hit the delete icon in the top right of the expanded goal page.',
                                                                                                                        style: Theme.of(context).textTheme.bodyText1,
                                                                                                                      ),
                                                                                                                      Row(
                                                                                                                        children: [
                                                                                                                          Padding(
                                                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                                                            child: ElevatedButton(
                                                                                                                              style: ButtonStyle(
                                                                                                                                backgroundColor: MaterialStateProperty.all(Theme.of(context).dividerColor),
                                                                                                                              ),
                                                                                                                              onPressed: () {
                                                                                                                                Navigator.of(context).pop();
                                                                                                                              },
                                                                                                                              child: Text(
                                                                                                                                'Dismiss',
                                                                                                                                style: Theme.of(context).textTheme.bodyText1,
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                          Padding(
                                                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                                                            child: ElevatedButton(
                                                                                                                              style: ButtonStyle(
                                                                                                                                backgroundColor: MaterialStateProperty.all(Theme.of(context).dividerColor),
                                                                                                                              ),
                                                                                                                              onPressed: () {
                                                                                                                                Navigator.of(context).pop();
                                                                                                                              },
                                                                                                                              child: Text(
                                                                                                                                'Done',
                                                                                                                                style: Theme.of(context).textTheme.bodyText1,
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                        ],
                                                                                                                      ),
                                                                                                                      Row(
                                                                                                                        children: [
                                                                                                                          Icon(
                                                                                                                            Icons.circle_outlined,
                                                                                                                            color: Theme.of(context).dividerColor,
                                                                                                                          ),
                                                                                                                          Icon(
                                                                                                                            Icons.circle_outlined,
                                                                                                                            color: Theme.of(context).dividerColor,
                                                                                                                          ),
                                                                                                                          Icon(
                                                                                                                            Icons.circle_outlined,
                                                                                                                            color: Theme.of(context).dividerColor,
                                                                                                                          ),
                                                                                                                          Icon(
                                                                                                                            Icons.circle_outlined,
                                                                                                                            color: Theme.of(context).dividerColor,
                                                                                                                          ),
                                                                                                                          Icon(
                                                                                                                            Icons.circle_outlined,
                                                                                                                            color: Theme.of(context).dividerColor,
                                                                                                                          ),
                                                                                                                          Icon(
                                                                                                                            Icons.circle,
                                                                                                                            color: Theme.of(context).hintColor,
                                                                                                                          ),
                                                                                                                        ],
                                                                                                                      ),
                                                                                                                    ],
                                                                                                                  );
                                                                                                                },
                                                                                                              );
                                                                                                            },
                                                                                                            child: Text(
                                                                                                              'Next',
                                                                                                              style: Theme.of(context).textTheme.bodyText1,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                    Row(
                                                                                                      children: [
                                                                                                        Icon(
                                                                                                          Icons.circle_outlined,
                                                                                                          color: Theme.of(context).dividerColor,
                                                                                                        ),
                                                                                                        Icon(
                                                                                                          Icons.circle_outlined,
                                                                                                          color: Theme.of(context).dividerColor,
                                                                                                        ),
                                                                                                        Icon(
                                                                                                          Icons.circle_outlined,
                                                                                                          color: Theme.of(context).dividerColor,
                                                                                                        ),
                                                                                                        Icon(
                                                                                                          Icons.circle_outlined,
                                                                                                          color: Theme.of(context).dividerColor,
                                                                                                        ),
                                                                                                        Icon(
                                                                                                          Icons.circle,
                                                                                                          color: Theme.of(context).hintColor,
                                                                                                        ),
                                                                                                        Icon(
                                                                                                          Icons.circle_outlined,
                                                                                                          color: Theme.of(context).dividerColor,
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ],
                                                                                                );
                                                                                              },
                                                                                            );
                                                                                          },
                                                                                          child: Text(
                                                                                            'Next',
                                                                                            style: Theme.of(context).textTheme.bodyText1,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Icon(
                                                                                        Icons.circle_outlined,
                                                                                        color: Theme.of(context).dividerColor,
                                                                                      ),
                                                                                      Icon(
                                                                                        Icons.circle_outlined,
                                                                                        color: Theme.of(context).dividerColor,
                                                                                      ),
                                                                                      Icon(
                                                                                        Icons.circle_outlined,
                                                                                        color: Theme.of(context).dividerColor,
                                                                                      ),
                                                                                      Icon(
                                                                                        Icons.circle,
                                                                                        color: Theme.of(context).hintColor,
                                                                                      ),
                                                                                      Icon(
                                                                                        Icons.circle_outlined,
                                                                                        color: Theme.of(context).dividerColor,
                                                                                      ),
                                                                                      Icon(
                                                                                        Icons.circle_outlined,
                                                                                        color: Theme.of(context).dividerColor,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                        child: Text(
                                                                          'Next',
                                                                          style: Theme.of(
                                                                                  context)
                                                                              .textTheme
                                                                              .bodyText1,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .circle_outlined,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .dividerColor,
                                                                    ),
                                                                    Icon(
                                                                        Icons
                                                                            .circle_outlined,
                                                                        color: Theme.of(
                                                                                context)
                                                                            .dividerColor),
                                                                    Icon(Icons.circle,
                                                                        color: Theme.of(
                                                                                context)
                                                                            .hintColor),
                                                                    Icon(
                                                                      Icons
                                                                          .circle_outlined,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .dividerColor,
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .circle_outlined,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .dividerColor,
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .circle_outlined,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .dividerColor,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Text(
                                                        'Next',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.circle_outlined,
                                                    color: Theme.of(context).dividerColor,
                                                  ),
                                                  Icon(
                                                    Icons.circle,
                                                    color: Theme.of(context).hintColor,
                                                  ),
                                                  Icon(
                                                    Icons.circle_outlined,
                                                    color: Theme.of(context).dividerColor,
                                                  ),
                                                  Icon(
                                                    Icons.circle_outlined,
                                                    color: Theme.of(context).dividerColor,
                                                  ),
                                                  Icon(
                                                    Icons.circle_outlined,
                                                    color: Theme.of(context).dividerColor,
                                                  ),
                                                  Icon(
                                                    Icons.circle_outlined,
                                                    color: Theme.of(context).dividerColor,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'Next',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: Theme.of(context).hintColor,
                          ),
                          Icon(
                            Icons.circle_outlined,
                            color: Theme.of(context).dividerColor,
                          ),
                          Icon(
                            Icons.circle_outlined,
                            color: Theme.of(context).dividerColor,
                          ),
                          Icon(
                            Icons.circle_outlined,
                            color: Theme.of(context).dividerColor,
                          ),
                          Icon(
                            Icons.circle_outlined,
                            color: Theme.of(context).dividerColor,
                          ),
                          Icon(
                            Icons.circle_outlined,
                            color: Theme.of(context).dividerColor,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.help),
            color: Theme.of(context).hintColor,
          )
        ],
        toolbarHeight: MediaQuery.of(context).size.height / 15,
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        title: Text(
          "Home",
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 33.0),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 300,
                                child: Text(
                                  'Complete 75% or more of your daily tasks to add 1 to your STREAK!',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Container(
                                decoration: ShapeDecoration(
                                  color: streakColor,
                                  shape: CircleBorder(
                                    side: BorderSide(
                                        color: streakColor,
                                        width: MediaQuery.of(context).size.width / 16),
                                  ),
                                ),
                                child: Text(
                                  '$streak',
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20))),
                                width: MediaQuery.of(context).size.width / 2,
                                height: MediaQuery.of(context).size.height / 50,
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  heightFactor: 1.0,
                                  widthFactor: streakWidthFactor,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: streakProgress,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width - 40,
                          child: LineChart(
                            LineChartData(
                              backgroundColor: Theme.of(context).backgroundColor,
                              lineTouchData: LineTouchData(
                                enabled: true,
                                touchTooltipData: LineTouchTooltipData(
                                  tooltipRoundedRadius: 30.0,
                                  tooltipBgColor: Theme.of(context).primaryColor,
                                ),
                              ),
                              axisTitleData: FlAxisTitleData(
                                topTitle: AxisTitle(
                                  titleText: 'This Week\'s Daily Stats',
                                  showTitle: true,
                                  textStyle: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              titlesData: FlTitlesData(
                                rightTitles: SideTitles(showTitles: false),
                                topTitles: SideTitles(showTitles: false),
                                leftTitles: SideTitles(
                                    interval: 20,
                                    showTitles: true,
                                    margin: 8.0,
                                    reservedSize: 25.0),
                                bottomTitles:
                                    SideTitles(interval: 1, showTitles: true, margin: 8),
                              ),
                              minX: 1,
                              maxX: 7,
                              minY: 0,
                              maxY: 100,
                              gridData: FlGridData(
                                drawHorizontalLine: false,
                                drawVerticalLine: false,
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: points,
                                  colors: chartColors,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  title: Text('Calendar'),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => FuturePage(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.loop,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  title: Text('Daily'),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => DailyPage(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.sticky_note_2_outlined,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  title: Text('Journal'),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => JournalYearlyPage(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  title: Text('Settings'),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SettingsPage(),
                    ),
                  );
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(5.0),
            //   child: ElevatedButton(
            //     style: ButtonStyle(
            //       backgroundColor: MaterialStateProperty.all(
            //           Theme.of(context).primaryColor),
            //     ),
            //     child: ListTile(
            //       leading: Icon(
            //         Icons.data_saver_off_outlined,
            //         color: Theme.of(context).primaryColorLight,
            //       ),
            //       title: Text('Statistics'),
            //     ),
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (BuildContext context) => StatisticsPage(),
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
