import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smart_money_app/pages/spending/bar_graph/bar_data.dart';
import 'package:collection/collection.dart';
import 'dart:math';

class WeekdayBarChart extends StatelessWidget {
  final List<double> weeklySummary;
  const WeekdayBarChart({
    super.key,
    required this.weeklySummary,
  });

  @override
  Widget build(BuildContext context) {
    double chartMaxHeight = weeklySummary.reduce(max) * 1.1;
    BarData weekdayBarData = BarData(
      sunAmount: weeklySummary[0],
      monAmount: weeklySummary[1],
      tueAmount: weeklySummary[2],
      wedAmount: weeklySummary[3],
      thurAmount: weeklySummary[4],
      friAmount: weeklySummary[5],
      satAmount: weeklySummary[6],
    );
    weekdayBarData.initialiseBarData();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total This Week: ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              '£${weeklySummary.sum.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        SizedBox(
          height: 400,
          child: BarChart(BarChartData(
            maxY: chartMaxHeight,
            minY: 0,
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getBottomTitles,
              )),
            ),
            barGroups: weekdayBarData.barData
                .map(
                  (data) => BarChartGroupData(
                    x: data.x,
                    barRods: [
                      BarChartRodData(
                          toY: num.parse(data.y.toStringAsFixed(2)).toDouble(),
                          color: Colors.blue[900],
                          width: 25,
                          borderRadius: BorderRadius.circular(4),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: chartMaxHeight,
                            color: Colors.blue[100],
                          ))
                    ],
                  ),
                )
                .toList(),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (BarChartGroupData group) =>
                      Colors.blue.shade300),
            ),
          )),
        ),
      ],
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text("Mon", style: style);
    case 1:
      text = const Text("Tue", style: style);
    case 2:
      text = const Text("Wed", style: style);
    case 3:
      text = const Text("Thur", style: style);
    case 4:
      text = const Text("Fri", style: style);
    case 5:
      text = const Text("Sat", style: style);
    case 6:
      text = const Text("Sun", style: style);
    default:
      text = const Text("", style: style);
  }

  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
