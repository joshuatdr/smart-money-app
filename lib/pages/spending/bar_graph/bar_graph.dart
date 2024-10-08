import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smart_money_app/pages/spending/bar_graph/bar_data.dart';
import 'dart:math';

class WeekdayBarChart extends StatelessWidget {
  final List<double> weeklySummary;
  const WeekdayBarChart({
    super.key,
    required this.weeklySummary,
  });

  @override
  Widget build(BuildContext context) {
    double chartMaxHeight = weeklySummary.reduce(max);
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

    return SizedBox(
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
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
      )),
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
      text = const Text("S", style: style);
    case 1:
      text = const Text("M", style: style);
    case 2:
      text = const Text("T", style: style);
    case 3:
      text = const Text("W", style: style);
    case 4:
      text = const Text("T", style: style);
    case 5:
      text = const Text("F", style: style);
    case 6:
      text = const Text("S", style: style);
    default:
      text = const Text("", style: style);
  }

  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
