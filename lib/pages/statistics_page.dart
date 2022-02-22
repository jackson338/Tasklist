// import 'package:charts_flutter/flutter.dart' as charts;
// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsPage extends StatefulWidget {
  @override
  State<StatisticsPage> createState() => _StatisticsPage();
}

class _StatisticsPage extends State<StatisticsPage> {
  double totalDaily = 0.0;
  bool buildCalled = false;
  int listD = 0;
  double dateLengthD = 0.0;
  List<FlSpot> points = [];
  List<String> chartIds = [];
  List<String> percentageIds = [];
  List<Color> chartColors = [];
  double totalCompleted = 0.0;
  double dayCompleted = 0;
  double xLength = 0;
  String percentage;
  int buildLength;
  int dailyLength;
  int dif;
  double average;

  void getChartValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getStringList('total percentage ids') != null) {
        // prefs.setStringList('daily percentages', []);
        String percentId;
        for (percentId in prefs.getStringList('total percentage ids')) {
          percentage = prefs.getString('$percentId percentage');
          print(percentage);
        }
      }
      if (prefs.getStringList('daily average ids') != null) {
        List<String> allIds = prefs.getStringList('daily average ids');
        String id;
        int totalLength = allIds.length;
        double addedTogether = 0.0;
        for (id in allIds) {
          addedTogether += prefs.getDouble('$id average percentage');
        }
        average = (addedTogether / totalLength);
      }
      if (prefs.getStringList('total percentage ids') != null) {
        chartIds = prefs.getStringList('total percentage ids');
      }
      String id;
      for (id in chartIds) {
        buildLength = prefs.getInt('$id daily build count');
        dailyLength = prefs.getInt('$id daily count');
        if (buildLength != null) {
          dif = dailyLength - buildLength;
        }
        if (prefs.getString('$id percentage') != null) {
          totalCompleted = double.parse(prefs.getString('$id percentage')).roundToDouble();
        }

        dayCompleted += 1;
        points.add(
          FlSpot(dayCompleted, totalCompleted < 1 ? 1 : totalCompleted),
        );
        xLength += 1;
        if (prefs.getDouble('max val') == null) {
          prefs.setDouble('max val', totalCompleted);
        }
        if (totalCompleted >= prefs.getDouble('max val')) {
          prefs.setDouble('max val', totalCompleted);
        }
      }
      List<String> list = prefs.getStringList('Daily ID List');
      listD = list.length;
      // if (totalDaily == 0.0) {
      if (listD >= prefs.getDouble('max val')) {
        totalDaily += listD;
      } else {
        totalDaily = prefs.getDouble('max val');
      }
      // }
      // String date = DateFormat.yMMMd().format(DateTime.now());
      DateTime date = DateTime.now();
      int day = date.day;
      dateLengthD += day;
      buildCalled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    chartColors = [Theme.of(context).dividerColor, Colors.teal[300], Theme.of(context).primaryColor];
    if (buildCalled == false) {
      getChartValues();
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text('Chart'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 30,
          right: 10,
        ),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: LineChart(
                LineChartData(
                  backgroundColor: Theme.of(context).backgroundColor,
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData:
                        LineTouchTooltipData(tooltipRoundedRadius: 30.0),
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: SideTitles(showTitles: false),
                    topTitles: SideTitles(showTitles: false),
                    leftTitles: SideTitles(
                      interval: 20,
                      showTitles: true,
                    ),
                  ),
                  axisTitleData: FlAxisTitleData(
                    topTitle: AxisTitle(
                      titleText: 'Daily Stats',
                      showTitle: true,
                      textStyle: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  minX: 1,
                  maxX: xLength,
                  minY: 1,
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
            // Padding(
            //   padding: const EdgeInsets.only(top: 18.0),
            //   child: Text(
            //     '$dif/$dailyLength Daily Tasks Completed',
            //     style: Theme.of(context).textTheme.bodyText1,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: average != null
                  ? Text(
                      'Average Daily Task Completion Rate: ${average.roundToDouble()}%',
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  : Text('nothing'),
            ),
          ],
        ),
      ),
    );
  }
}


// class SimpleTimeSeriesChart extends StatelessWidget {
//   final List<charts.Series> seriesList;
//   final bool animate;

//   SimpleTimeSeriesChart(this.seriesList, {this.animate});

//   /// Creates a [TimeSeriesChart] with sample data and no transition.
//   factory SimpleTimeSeriesChart.withSampleData() {
//     return new SimpleTimeSeriesChart(
//       _createSampleData(),
//       // Disable animations for image tests.
//       animate: false,
//     );
//   }


//   @override
//   Widget build(BuildContext context) {
//     return new charts.TimeSeriesChart(
//       seriesList,
//       animate: animate,
//       // Optionally pass in a [DateTimeFactory] used by the chart. The factory
//       // should create the same type of [DateTime] as the data provided. If none
//       // specified, the default creates local date time.
//       dateTimeFactory: const charts.LocalDateTimeFactory(),
//     );
//   }

//   /// Create one series with sample hard coded data.
//   static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
//     final data = [
//       new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
//       new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
//       new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
//       new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
//     ];

//     return [
//       new charts.Series<TimeSeriesSales, DateTime>(
//         id: 'Sales',
//         colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//         domainFn: (TimeSeriesSales sales, _) => sales.time,
//         measureFn: (TimeSeriesSales sales, _) => sales.sales,
//         data: data,
//       )
//     ];
//   }
// }

// /// Sample time series data type.
// class TimeSeriesSales {
//   final DateTime time;
//   final int sales;

//   TimeSeriesSales(this.time, this.sales);
// }