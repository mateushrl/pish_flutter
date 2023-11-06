import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoWidget extends StatelessWidget {
  double maxX;
  List<FlSpot> spots;
  Color corCurva;
  String titulo;
  GraficoWidget(
      {Key? key,
      required this.maxX,
      required this.spots,
      required this.corCurva,
      required this.titulo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(
                show: false,
                verticalInterval: 10,
                //horizontalInterval: 10,
              ),
              borderData: FlBorderData(
                show: false,
                border: Border.all(
                  color: const Color(0xff37434d),
                  width: 1,
                ),
              ),
              minX: 0,
              maxX: maxX,
              minY: 0,
              maxY: 75,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: corCurva,
                  barWidth: 3,
                  belowBarData:
                      BarAreaData(show: true, color: corCurva.withOpacity(0.2)),
                ),
              ],
              titlesData:  FlTitlesData(
                leftTitles: const AxisTitles(
                  axisNameWidget: Text("Resultado"),
                  axisNameSize: 24,
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 25,
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 0,
                  ),
                ),
                topTitles:  AxisTitles(
                    sideTitles: const SideTitles(
                      showTitles: false,
                      reservedSize: 0,
                    ),
                    axisNameWidget: Text(titulo, style: TextStyle(fontSize: 15),)),
              ),
              lineTouchData: LineTouchData(
                enabled: true,
                getTouchedSpotIndicator:
                    (LineChartBarData barData, List<int> spotIndexes) {
                  return spotIndexes.map((index) {
                    return TouchedSpotIndicatorData(
                      FlLine(
                        color: Color.fromARGB(255, 14, 10, 10).withOpacity(0.2),
                      ),
                      FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                          radius: 8,
                          color: Colors.red,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        ),
                      ),
                    );
                  }).toList();
                },
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.red,
                  tooltipRoundedRadius: 8,
                  getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                    return lineBarsSpot.map((lineBarSpot) {
                      return LineTooltipItem(
                        lineBarSpot.y.toString(),
                        const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
