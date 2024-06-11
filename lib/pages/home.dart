import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ExercisePage extends StatelessWidget {
  final Map<String, dynamic>? data;
  final List<dynamic>? arrayData;

  ExercisePage({Key? key, this.data, this.arrayData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String temperatura = data?['temperatura']?.toString() ?? 'Offline';
    String humedad = data?['humedad']?.toString() ?? '';

    String ultimaActualizacion = '00-00';

    Map<DateTime, double> dailyMaxTemperatures = {};

    if (temperatura != 'Offline') {
      var time = DateTime.now().toIso8601String();
      ultimaActualizacion =
          'Hora: ${time.substring(11, 16)} Fecha: ${time.substring(5, 10)}';
    }

    if (arrayData != null) {
      for (var entry in arrayData!) {
        DateTime fecha = DateTime.parse(entry['fecha']);
        DateTime day = DateTime(fecha.year, fecha.month, fecha.day);
        double temp = double.parse(entry['temperatura'].toString());
        if (!dailyMaxTemperatures.containsKey(day) ||
            dailyMaxTemperatures[day]! < temp) {
          dailyMaxTemperatures[day] = temp;
        }
      }
    }

    List<BarChartGroupData> barGroups =
        dailyMaxTemperatures.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key.millisecondsSinceEpoch,
        barRods: [
          BarChartRodData(
            y: entry.value,
            colors: [Color.fromARGB(255, 230, 74, 35)],
            width: 20,
            borderRadius: BorderRadius.zero,
          ),
        ],
      );
    }).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Bienvenido, Leonardo!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 70),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Temperatura \n Actual',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 4, 5, 26),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 13.0,
                        animation: true,
                        percent: temperatura != 'Offline'
                            ? double.parse(temperatura) / 100
                            : 0,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              temperatura != 'Offline'
                                  ? '$temperatura °C'
                                  : 'Offline',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                            Text(
                              temperatura != 'Offline'
                                  ? 'Humedad: $humedad %'
                                  : '',
                              style: const TextStyle(
                                  fontSize: 11.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: const Color.fromARGB(255, 180, 34, 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Temperatura máxima por día',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(
                              bottomTitles: SideTitles(
                                showTitles: true,
                                getTitles: (value) {
                                  DateTime date =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          value.toInt());
                                  return "Dia. ${date.day}";
                                },
                                getTextStyles: (context, value) =>
                                    const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                                margin: 8,
                              ),
                              leftTitles: SideTitles(showTitles: false),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border:
                                  Border.all(color: const Color(0xff37434d)),
                            ),
                            barGroups: barGroups,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Última actualización:',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        temperatura != 'Offline'
                            ? ultimaActualizacion
                            : '00-00',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension ListExtensions<T> on List<T> {
  List<T> takeLast(int n) => length >= n ? sublist(length - n) : this;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: ExercisePage(
        arrayData: [
          {"temperatura": 25, "humedad": 50, "fecha": "2019-10-10 10:00:00"},
          {"temperatura": 38.24, "humedad": 26, "fecha": "2024-06-10 08:39:25"},
          {"temperatura": 38.24, "humedad": 26, "fecha": "2024-06-10 08:48:40"}
        ],
      ),
    );
  }
}
