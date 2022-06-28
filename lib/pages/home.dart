import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/pages/calendar_page.dart';
import 'package:tasklist_app/pages/settings.dart';
import 'package:tasklist_app/pages/daily.dart';
import 'package:tasklist_app/pages/journal_folder_page.dart';
import 'package:tasklist_app/widgets/hint_popups.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool buildCalled = false;
  bool dateChange = false;
  bool resetDateChange = false;
  int listD = 0;
  int streak = 0;
  int stars = 0;
  List<FlSpot> points = [];
  List<String> chartIds = [];
  List<String> weekIds = [];
  List<String> percentages = [];
  List<String> allIds = [];
  List<Color> chartColors = [];
  double totalCompleted = 0.0;
  double dayCompleted = 0;
  double percentage = 0.0;
  double dateLengthD = 0.0;
  double streakWidthFactor = 0.0;
  Color streakColor = Colors.grey;
  Color streakProgress = Colors.blueGrey;
  String todayDate = 'today';
  String resetTodayDate = 'today';
  String _dateTime;

  void getChartValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = 0;
    setState(() {
      if (prefs.getInt('streak') != null) {
        streak = prefs.getInt('streak');
      }
      if (prefs.getString('today date') != null) {
        todayDate = prefs.getString('today date');
      }
      if (prefs.getString('reset today date') != null) {
        resetTodayDate = prefs.getString('reset today date');
      }
      if (todayDate != DateTime.now().day.toString()) {
        dateChange = true;
        prefs.setBool('dateChange', dateChange);
      }
      if (resetTodayDate != DateTime.now().day.toString()) {
        resetDateChange = true;
        prefs.setBool('reset date change', resetDateChange);
      }
      dateChange = prefs.getBool('dateChange');
      resetDateChange = prefs.getBool('reset date change');
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
      int count2 = 0;
      for (id in weekIds) {
        count2 += 1;
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
        if (totalCompleted >= 75 && dateChange == true && count2 == weekIds.length) {
          streak += 1;
          prefs.setInt('streak', streak);
          dateChange = false;
          prefs.setBool('dateChange', dateChange);
          todayDate = DateTime.now().day.toString();
          prefs.setString('today date', todayDate);
        }
        if (count2 == (weekIds.length - 1) && resetDateChange == true) {
          if (totalCompleted < 75) {
            streak = 0;
            prefs.setInt('streak', streak);
            resetDateChange = false;
            prefs.setBool('reset date change', resetDateChange);
            resetTodayDate = DateTime.now().day.toString();
            prefs.setString('reset today date', resetTodayDate);
          }
        }

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
      streakProgress = Colors.teal;
    } else {
      streakWidthFactor = ((streak * 100) / 7) / 100;
    }
    if (colorStreak >= 21) {
      stars = 1;
      streakColor = Colors.teal;
      streakProgress = Colors.tealAccent;
    } else if (colorStreak >= 7) {
      streakWidthFactor = ((streak * 100) / 21) / 100;
    }
    if (colorStreak >= 42) {
      streakColor = Colors.tealAccent;
      streakProgress = Colors.amber;
    } else if (colorStreak >= 21) {
      streakWidthFactor = ((streak * 100) / 42) / 100;
    }
    if (colorStreak >= 100) {
      stars = 2;
      streakColor = Colors.amber;
      streakProgress = Colors.orange;
    } else if (colorStreak >= 42) {
      streakWidthFactor = ((streak * 100) / 100) / 100;
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
                  return HintPopUps();
                },
              );
            },
            icon: Icon(Icons.help),
            color: Theme.of(context).hintColor,
          ),
        ],
        toolbarHeight: MediaQuery.of(context).size.height / 15,
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Icon(
                    Icons.star,
                    color: Theme.of(context).hintColor,
                  );
                },
                itemCount: stars,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ],
        ),
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
                                  'Complete 75% or more of your daily tasks to add 1 point to your STREAK!',
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
                                  tooltipBgColor: Colors.white,
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
