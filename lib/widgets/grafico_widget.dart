import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GraficoWidget extends StatelessWidget {
  double maxX;
  List<FlSpot> spots;
  List<DateTime>? datas;
  bool mostrarIntervalo;

  Color corCurva;
  String titulo;
  GraficoWidget(
      {Key? key,
      required this.maxX,
      required this.spots,
      required this.corCurva,
      required this.titulo,
      this.datas,
      required this.mostrarIntervalo})
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
              maxY: 100,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: corCurva,
                  barWidth: 3,
                  belowBarData: BarAreaData(
                    show: true,
                    color: corCurva.withOpacity(0.2),
                  ),
                  dotData: const FlDotData(
                    show: false,
                  ),
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  axisNameWidget: Text("Resultados"),
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
                topTitles: AxisTitles(
                  sideTitles: const SideTitles(
                    showTitles: false,
                    reservedSize: 0,
                  ),
                  axisNameWidget: Text(titulo, style: TextStyle(fontSize: 15)),
                ),
                bottomTitles: AxisTitles(
                  axisNameWidget: const Text("Datas"),
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      return bottomTitleWidgets(
                        value,
                        meta,
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
              ),
              lineTouchData: LineTouchData(),
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      //color: AppColors.contentColorPink,
      fontFamily: 'Digital',
      fontSize: 10,
    );
    String text = '';
    try {
      for (var item in datas!) {
        if (!mostrarIntervalo) {
          text = formatData(datas![value.toInt()]);
        } else {
          if (value.toInt() % 10 == 0) {
            text = formatData(datas![value.toInt()]);
          }
        }
      }
    } catch (error) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: const Text('', style: style),
      );
    }

    return Transform.rotate(
      angle: 6,
      child: SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(text, style: style),
      ),
    );
  }

  String formatData(DateTime? data) {
    if (data == null) {
      return "";
    }
    return DateFormat('dd/MM/yyyy  HH:mm').format(data).toString();
  }
}
