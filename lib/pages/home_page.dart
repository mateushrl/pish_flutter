import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class UmidadeSoloData {
  final Map<String, dynamic> data;

  UmidadeSoloData(this.data);

  factory UmidadeSoloData.fromSnapshot(DataSnapshot snapshot) {
    final dynamic value = snapshot.value;
    if (value is Map<String, dynamic>) {
      return UmidadeSoloData(value);
    } else {
      throw Exception("Invalid data format");
    }
  }
}

class TemperaturaData {
  final Map<String, dynamic> data;

  TemperaturaData(this.data);

  factory TemperaturaData.fromSnapshot(DataSnapshot snapshot) {
    final dynamic value = snapshot.value;
    if (value is Map<String, dynamic>) {
      return TemperaturaData(value);
    } else {
      throw Exception("Invalid data format");
    }
  }
}

class UmidadeArData {
  final Map<String, dynamic> data;

  UmidadeArData(this.data);

  factory UmidadeArData.fromSnapshot(DataSnapshot snapshot) {
    final dynamic value = snapshot.value;
    if (value is Map<String, dynamic>) {
      return UmidadeArData(value);
    } else {
      throw Exception("Invalid data format");
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseReference refUmidadeSolo;
  late DatabaseReference refTemperatura;
  late DatabaseReference refUmidadeAr;
  List<FlSpot> umidadeSoloLast60Minutes = [];
  List<FlSpot> umidadeSoloLast24Hours = [];
  List<FlSpot> temperaturaLast60Minutes = [];
  List<FlSpot> temperaturaLast24Hours = [];
  List<FlSpot> umidadeArLast60Minutes = [];
  List<FlSpot> umidadeArLast24Hours = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    refUmidadeSolo = FirebaseDatabase.instance.reference().child('umidade_solo_5');
    refTemperatura = FirebaseDatabase.instance.reference().child('temperatura_5');
    refUmidadeAr = FirebaseDatabase.instance.reference().child('umidade_ar_5');

    refUmidadeSolo.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final Map<String, dynamic> data = (event.snapshot.value as Map<String, dynamic>);

        final now = DateTime.now();

        umidadeSoloLast60Minutes.clear();
        umidadeSoloLast24Hours.clear();

        data.forEach((key, value) {
          final umidade = value as double;
          final timestamp = DateTime.parse(key);
          final difference = now.difference(timestamp);

          if (difference.inMinutes <= 60) {
            umidadeSoloLast60Minutes.add(FlSpot(umidadeSoloLast60Minutes.length.toDouble(), umidade));
          }

          if (difference.inHours <= 24) {
            umidadeSoloLast24Hours.add(FlSpot(umidadeSoloLast24Hours.length.toDouble(), umidade));
          }
        });

        setState(() {});
      } else {
        print('Não foi possível obter dados de umidade do solo');
      }
    });

    refTemperatura.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final Map<String, dynamic> data = (event.snapshot.value as Map<String, dynamic>);

        final now = DateTime.now();

        temperaturaLast60Minutes.clear();
        temperaturaLast24Hours.clear();

        data.forEach((key, value) {
          final temperatura = value as double;
          final timestamp = DateTime.parse(key);
          final difference = now.difference(timestamp);

          if (difference.inMinutes <= 60) {
            temperaturaLast60Minutes.add(FlSpot(temperaturaLast60Minutes.length.toDouble(), temperatura));
          }

          if (difference.inHours <= 24) {
            temperaturaLast24Hours.add(FlSpot(temperaturaLast24Hours.length.toDouble(), temperatura));
          }
        });

        setState(() {});
      } else {
        print('Não foi possível obter dados de temperatura');
      }
    });

    refUmidadeAr.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final Map<String, dynamic> data = (event.snapshot.value as Map<String, dynamic>);

        final now = DateTime.now();

        umidadeArLast60Minutes.clear();
        umidadeArLast24Hours.clear();

        data.forEach((key, value) {
          final umidadeAr = value as double;
          final timestamp = DateTime.parse(key);
          final difference = now.difference(timestamp);

          if (difference.inMinutes <= 60) {
            umidadeArLast60Minutes.add(FlSpot(umidadeArLast60Minutes.length.toDouble(), umidadeAr));
          }

          if (difference.inHours <= 24) {
            umidadeArLast24Hours.add(FlSpot(umidadeArLast24Hours.length.toDouble(), umidadeAr));
          }
        });

        setState(() {});
      } else {
        print('Não foi possível obter dados de umidade do ar');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráficos de Umidade'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Umidade do solo - Gráfico da última hora de medições
            Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: const Color(0xff37434d),
                  width: 1,
                ),
              ),
              minX: 0,
              maxX: umidadeSoloLast60Minutes.length.toDouble() - 1,
              minY: 0,
              maxY: 100, // Ajuste o valor máximo conforme necessário
              lineBarsData: [
                LineChartBarData(
                  spots: umidadeSoloLast60Minutes,
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 3,
                  belowBarData: BarAreaData(show: true),
                ),
              ],
            ),
          ),
        ),
      ),
            // Umidade do solo - Gráfico das últimas 24 horas de medições
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: const Color(0xff37434d),
                        width: 1,
                      ),
                    ),
                    minX: 0,
                    maxX: umidadeSoloLast24Hours.length.toDouble() - 1,
                    minY: 0,
                    maxY: 100, // Ajuste o valor máximo conforme necessário
                    lineBarsData: [
                      LineChartBarData(
                        spots: umidadeSoloLast24Hours,
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 3,
                        belowBarData: BarAreaData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Temperatura - Gráfico da última hora de medições
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: const Color(0xff37434d),
                        width: 1,
                      ),
                    ),
                    minX: 0,
                    maxX: temperaturaLast60Minutes.length.toDouble() - 1,
                    minY: 0,
                    maxY: 100, // Ajuste o valor máximo conforme necessário
                    lineBarsData: [
                      LineChartBarData(
                        spots: temperaturaLast60Minutes,
                        isCurved: true,
                        color: Colors.red,
                        barWidth: 3,
                        belowBarData: BarAreaData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Temperatura - Gráfico das últimas 24 horas de medições
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: const Color(0xff37434d),
                        width: 1,
                      ),
                    ),
                    minX: 0,
                    maxX: temperaturaLast24Hours.length.toDouble() - 1,
                    minY: 0,
                    maxY: 100, // Ajuste o valor máximo conforme necessário
                    lineBarsData: [
                      LineChartBarData(
                        spots: temperaturaLast24Hours,
                        isCurved: true,
                        color: Colors.red,
                        barWidth: 3,
                        belowBarData: BarAreaData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Temperatura - Gráfico da última hora de medições
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: const Color(0xff37434d),
                        width: 1,
                      ),
                    ),
                    minX: 0,
                    maxX: umidadeArLast60Minutes.length.toDouble() - 1,
                    minY: 0,
                    maxY: 100, // Ajuste o valor máximo conforme necessário
                    lineBarsData: [
                      LineChartBarData(
                        spots: umidadeArLast60Minutes,
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 3,
                        belowBarData: BarAreaData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Temperatura - Gráfico das últimas 24 horas de medições
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: const Color(0xff37434d),
                        width: 1,
                      ),
                    ),
                    minX: 0,
                    maxX: umidadeArLast24Hours.length.toDouble() - 1,
                    minY: 0,
                    maxY: 100, // Ajuste o valor máximo conforme necessário
                    lineBarsData: [
                      LineChartBarData(
                        spots: umidadeArLast24Hours,
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 3,
                        belowBarData: BarAreaData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
