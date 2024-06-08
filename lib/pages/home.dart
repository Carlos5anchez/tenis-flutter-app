import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.history_rounded,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenido, Carlos!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Calorias',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 4, 5, 26),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Consumidas hoy',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 235, 76, 76),
                                    fontSize: 20,
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
                        percent: 0.7,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "10023",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                            Text(
                              "560/120",
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Color.fromARGB(255, 180, 34, 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              show: false,
                            ),
                            gridData: FlGridData(show: false),
                            barGroups: [
                              BarChartGroupData(x: 1, barRods: [
                                BarChartRodData(
                                    y: 200,
                                    colors: [Color.fromARGB(255, 192, 129, 13)])
                              ]),
                              BarChartGroupData(x: 3, barRods: [
                                BarChartRodData(
                                    y: 300,
                                    colors: [Color.fromARGB(255, 233, 30, 64)])
                              ]),
                              BarChartGroupData(x: 5, barRods: [
                                BarChartRodData(
                                    y: 150,
                                    colors: [Color.fromARGB(255, 233, 30, 57)])
                              ]),
                              BarChartGroupData(x: 7, barRods: [
                                BarChartRodData(y: 250, colors: [
                                  const Color.fromARGB(255, 233, 54, 30)
                                ])
                              ]),
                              BarChartGroupData(x: 9, barRods: [
                                BarChartRodData(y: 300, colors: [
                                  const Color.fromARGB(255, 243, 159, 33)
                                ])
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ultima actualización:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '14:20 PM',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
      home: const ExercisePage(),
    );
  }
}
