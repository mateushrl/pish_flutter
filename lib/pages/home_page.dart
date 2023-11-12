import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../Util/app_theme .dart';
import '../widgets/grafico_widget.dart';

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

  List<DateTime> datasUmidadeSoloLast60Minutes = [];
  List<DateTime> datasUmidadeSoloLast24Hours = [];
  List<DateTime> datasTemperaturaLast60Minutes = [];
  List<DateTime> datasTemperaturaLast24Hours = [];
  List<DateTime> datasUmidadeArLast60Minutes = [];
  List<DateTime> datasUmidadeArLast24Hours = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    refUmidadeSolo =
        FirebaseDatabase.instance.reference().child('umidade_solo_5');
    refTemperatura =
        FirebaseDatabase.instance.reference().child('temperatura_5');
    refUmidadeAr = FirebaseDatabase.instance.reference().child('umidade_ar_5');

    refUmidadeSolo.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final Map<String, dynamic> data =
            (event.snapshot.value as Map<String, dynamic>);

        final now = DateTime.now();

        umidadeSoloLast60Minutes.clear();
        umidadeSoloLast24Hours.clear();

        data.forEach((key, value) {
          final umidade = value as double;
          final timestamp = DateTime.parse(key);
          final difference = now.difference(timestamp);

          if (difference.inMinutes <= 60) {
            umidadeSoloLast60Minutes.add(
                FlSpot(umidadeSoloLast60Minutes.length.toDouble(), umidade));
            datasUmidadeSoloLast60Minutes.add(timestamp);
          }

          if (difference.inHours <= 24) {
            umidadeSoloLast24Hours
                .add(FlSpot(umidadeSoloLast24Hours.length.toDouble(), umidade));

            datasUmidadeSoloLast24Hours.add(timestamp);
          }
        });

        setState(() {});
      } else {
        print('Não foi possível obter dados de umidade do solo');
      }
    });

    refTemperatura.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final Map<String, dynamic> data =
            (event.snapshot.value as Map<String, dynamic>);

        final now = DateTime.now();

        temperaturaLast60Minutes.clear();
        temperaturaLast24Hours.clear();

        data.forEach((key, value) {
          final temperatura = value as double;
          final timestamp = DateTime.parse(key);
          final difference = now.difference(timestamp);

          if (difference.inMinutes <= 60) {
            temperaturaLast60Minutes.add(FlSpot(
                temperaturaLast60Minutes.length.toDouble(), temperatura));
            datasTemperaturaLast60Minutes.add(timestamp);
          }

          if (difference.inHours <= 24) {
            temperaturaLast24Hours.add(
                FlSpot(temperaturaLast24Hours.length.toDouble(), temperatura));

            datasTemperaturaLast24Hours.add(timestamp);
          }
        });

        setState(() {});
      } else {
        print('Não foi possível obter dados de temperatura');
      }
    });

    refUmidadeAr.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final Map<String, dynamic> data =
            (event.snapshot.value as Map<String, dynamic>);

        final now = DateTime.now();

        umidadeArLast60Minutes.clear();
        umidadeArLast24Hours.clear();

        data.forEach((key, value) {
          final umidadeAr = value as double;
          final timestamp = DateTime.parse(key);
          final difference = now.difference(timestamp);

          if (difference.inMinutes <= 60) {
            umidadeArLast60Minutes.add(
                FlSpot(umidadeArLast60Minutes.length.toDouble(), umidadeAr));
            datasUmidadeArLast60Minutes.add(timestamp);
          }

          if (difference.inHours <= 24) {
            umidadeArLast24Hours
                .add(FlSpot(umidadeArLast24Hours.length.toDouble(), umidadeAr));

            datasUmidadeArLast24Hours.add(timestamp);
          }
        });

        setState(() {});
      } else {
        print('Não foi possível obter dados de umidade do ar');
      }
    });
  }

  bool mostrarPadding1 = false;
  bool mostrarPadding2 = false;
  bool mostrarPadding3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'ByteBank',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ),
            ),
          )
        ],
        leading: Text(""),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.all(70.0),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/bytelogo.png'),
                    fit: BoxFit.fitHeight,
                    opacity: 0.2),
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.09), // Opacidade de 50%
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Seja bem vindo, Mateus!",
                        style: TextStyle(fontSize: 34),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 10.0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                mostrarPadding1 = !mostrarPadding1;
                              });
                            },
                            child: Text("Umidade do Solo"),
                          ),
                          Visibility(
                            visible: mostrarPadding1,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: GraficoWidget(
                                        maxX: umidadeSoloLast60Minutes.length
                                                .toDouble() -
                                            1,
                                        spots: umidadeSoloLast60Minutes,
                                        corCurva: Colors.blue,
                                        titulo: "Última hora de medições",
                                        datas: datasUmidadeSoloLast60Minutes,
                                        mostrarIntervalo: false,
                                      ),
                                    ),
                                    Expanded(
                                      child: GraficoWidget(
                                        maxX: umidadeSoloLast24Hours.length
                                                .toDouble() -
                                            1,
                                        spots: umidadeSoloLast24Hours,
                                        corCurva: Colors.green,
                                        titulo: "Últimas 24 horas de medições",
                                        datas: datasUmidadeSoloLast24Hours,
                                        mostrarIntervalo: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 10.0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                mostrarPadding2 = !mostrarPadding2;
                              });
                            },
                            child: Text("Temperatura"),
                          ),
                          Visibility(
                            visible: mostrarPadding2,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: GraficoWidget(
                                        maxX: temperaturaLast60Minutes.length
                                                .toDouble() -
                                            1,
                                        spots: temperaturaLast60Minutes,
                                        corCurva: Colors.blue,
                                        titulo: "Última hora de medições",
                                        datas: datasTemperaturaLast60Minutes,
                                        mostrarIntervalo: false,
                                      ),
                                    ),
                                    Expanded(
                                      child: GraficoWidget(
                                        maxX: temperaturaLast24Hours.length
                                                .toDouble() -
                                            1,
                                        spots: temperaturaLast24Hours,
                                        corCurva: Colors.green,
                                        titulo: "Últimas 24 horas de medições",
                                        datas: datasTemperaturaLast24Hours,
                                        mostrarIntervalo: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 10.0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                mostrarPadding3 = !mostrarPadding3;
                              });
                            },
                            child: Text("Umidade do Ar"),
                          ),
                          Visibility(
                            visible: mostrarPadding3,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: GraficoWidget(
                                        maxX: umidadeArLast60Minutes.length
                                                .toDouble() -
                                            1,
                                        spots: umidadeArLast60Minutes,
                                        corCurva: Colors.blue,
                                        titulo: "Última hora de medições",
                                        datas: datasUmidadeArLast60Minutes,
                                        mostrarIntervalo: false,
                                      ),
                                    ),
                                    Expanded(
                                      child: GraficoWidget(
                                        maxX: umidadeArLast24Hours.length
                                                .toDouble() -
                                            1,
                                        spots: umidadeArLast24Hours,
                                        corCurva: Colors.green,
                                        titulo: "Últimas 24 horas de medições",
                                        datas: datasUmidadeArLast24Hours,
                                        mostrarIntervalo: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
