import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist_app/models/note_mod.dart';
import 'package:tasklist_app/pages/calendar_page.dart';
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
  int listD = 0;
  double dateLengthD = 0.0;
  List<FlSpot> points = [];
  List<String> chartIds = [];
  List<String> weekIds = [];
  List<String> percentageIds = [];
  List<String> percentages = [];
  List<String> allIds = [];
  List<String> noteIdsList = [];
  List<NoteMod> noteList = [];
  double totalCompleted = 0.0;
  double dayCompleted = 0;
  double percentage = 0.0;
  TextEditingController moneyController = TextEditingController();
  String moneyString = "";

  void getChartValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('general note ids') != null) {
      noteIdsList = prefs.getStringList('general note ids');
    }
    int count = 0;
    setState(() {
      for (String id in noteIdsList) {
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
      if (prefs.getString('weekly money text') != null) {
        moneyString = prefs.getString('weekly money text');
      }
      if (prefs.getStringList('chart ids') != null) {
        chartIds = prefs.getStringList('chart ids');
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
      for (String ids in chartIds) {
        int buildLength = prefs.getInt('$ids daily build count');
        int dailyLength = prefs.getInt('$ids daily count');
        if (buildLength != null) {
          percentage = ((dailyLength - buildLength) * 100) / dailyLength;
          prefs.setString('$ids percentage', '$percentage');
          percentageIds.add('$ids');
          prefs.setStringList('total percentage ids', percentageIds);
        }
      }

      for (id in weekIds) {
        listD = prefs.getInt('$id daily count') == null
            ? prefs.getStringList('Daily ID List').length
            : prefs.getInt('$id daily count');

        int buildLength = prefs.getInt('$id daily build count');
        int dailyLength = prefs.getInt('$id daily count');
        if (buildLength != null) {
          percentage = ((dailyLength - buildLength) * 100) / dailyLength;

          if (prefs.getStringList('daily percentages') != null) {
            percentages = prefs.getStringList('daily percentages');
          }
          percentages.contains(percentage)
              ? print('already added')
              : percentages.add('${(percentage).roundToDouble()}');
          prefs.setStringList('daily percentages', percentages);
          // print('BuildLength: $buildLength, DailyLength: $dailyLength, percent: $percentage');
        }
        totalCompleted = percentage != null
            ? buildLength != null
                ? percentage.roundToDouble()
                : totalCompleted =
                    (prefs.getDouble('$id total completed') * 100) / listD
            : percentage.roundToDouble();
        // totalCompleted = (prefs.getDouble('$id total completed') * 10) / listD;
        dayCompleted += 1;
        if (totalCompleted > 100) {
          totalCompleted = 100;
        }
        if (totalCompleted < 1) {
          totalCompleted = 1;
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
      // String date = DateFormat.yMMMd().format(DateTime.now());
      DateTime date = DateTime.now();
      int day = date.day;
      dateLengthD += day;
      buildCalled = true;
    });
  }

  void setMoneyString(String _moneyText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      moneyString = _moneyText;
      prefs.setString('weekly money text', _moneyText);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (buildCalled == false) {
      getChartValues();
    }
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 15,
        // brightness: Brightness.light,
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text(
          "Home",
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: Container(
        // color: Theme.of(context).backgroundColor,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: moneyController,
                cursorColor: Theme.of(context).dividerColor,
                decoration: InputDecoration(
                  labelText: moneyString,
                  contentPadding: EdgeInsets.only(left: 170),
                ),
                onSubmitted: setMoneyString,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    noteIdsList != null
                        ? Container(
                            height: MediaQuery.of(context).size.height / 4,
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx, index) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height / 4,
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: LineChart(
                                      LineChartData(
                                        backgroundColor:
                                            Theme.of(context).backgroundColor,
                                        lineTouchData: LineTouchData(
                                          enabled: true,
                                          touchTooltipData:
                                              LineTouchTooltipData(
                                                  tooltipRoundedRadius: 30.0),
                                        ),
                                        axisTitleData: FlAxisTitleData(
                                          topTitle: AxisTitle(
                                            titleText: noteList
                                                .elementAt(index)
                                                .question,
                                            showTitle: true,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          ),
                                        ),
                                        titlesData: FlTitlesData(
                                          rightTitles:
                                              SideTitles(showTitles: false),
                                          topTitles:
                                              SideTitles(showTitles: false),
                                          leftTitles: SideTitles(
                                              interval: 20,
                                              showTitles: true,
                                              margin: 8.0),
                                        ),
                                        minX: 1,
                                        maxX: 10,
                                        minY: 0,
                                        maxY: 10,
                                        gridData: FlGridData(
                                          drawHorizontalLine: false,
                                          drawVerticalLine: false,
                                        ),
                                        lineBarsData: [
                                          LineChartBarData(
                                            spots: points,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: noteIdsList.length,
                            ),
                          )
                        : Text('No notes'),
                    // LineChart(
                    //   LineChartData(
                    //     backgroundColor: Theme.of(context).backgroundColor,
                    //     lineTouchData: LineTouchData(
                    //       enabled: true,
                    //       touchTooltipData:
                    //           LineTouchTooltipData(tooltipRoundedRadius: 30.0),
                    //     ),
                    //     axisTitleData: FlAxisTitleData(
                    //       topTitle: AxisTitle(
                    //         titleText: 'This Week\'s Stats',
                    //         showTitle: true,
                    //         textStyle: Theme.of(context).textTheme.headline6,
                    //       ),
                    //     ),
                    //     titlesData: FlTitlesData(
                    //       rightTitles: SideTitles(showTitles: false),
                    //       topTitles: SideTitles(showTitles: false),
                    //       leftTitles: SideTitles(
                    //           interval: 20, showTitles: true, margin: 8.0),
                    //     ),
                    //     minX: 1,
                    //     maxX: 7,
                    //     minY: 0,
                    //     maxY: 99,
                    //     gridData: FlGridData(
                    //       drawHorizontalLine: false,
                    //       drawVerticalLine: false,
                    //     ),
                    //     lineBarsData: [
                    //       LineChartBarData(
                    //         spots: points,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColorDark),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).primaryColor,
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
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColorDark),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.loop,
                    color: Theme.of(context).primaryColor,
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
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColorDark),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.sticky_note_2_outlined,
                    color: Theme.of(context).primaryColor,
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
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColorDark),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.data_saver_off_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text('Statistics'),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => StatisticsPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
