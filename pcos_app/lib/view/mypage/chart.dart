import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Data> data;

  const Chart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        color: Colors.white,
        width: data.length <= 5 ? 350 : data.length * 60,
        height: 200,
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 150,
            minX: 0,
            maxX: data.length - 1,
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                  return touchedSpots.map((spot) {
                    final y = spot.y;
                    final date = data[spot.x.toInt()].date;
                    return LineTooltipItem(
                      'Date: ${DateFormat.yMd().format(date)}\nValue: $y',
                      const TextStyle(color: Colors.white),
                    );
                  }).toList();
                },
              ),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  interval: 1,
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final date = data[value.toInt()].date;
                    return Text(
                      DateFormat('MM/dd\nyyyy').format(date),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: data
                    .asMap()
                    .map((i, d) => MapEntry(i, FlSpot(i.toDouble(), d.value)))
                    .values
                    .toList(),
                isCurved: true,
                color: Colors.grey,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                    radius: 4,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Data {
  final DateTime date;
  final double value;

  Data({required this.date, required this.value});
}
