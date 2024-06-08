import 'package:flutter/material.dart';
import 'package:flutter_tenis/pages/home.dart';
import 'package:flutter_tenis/pages/profile.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 223, 18, 18)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Smart Shoes App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late IO.Socket socket;
  late bool _isConnected = false;
  int currentPageIndex = 0;

  void connectToServer() {
    try {
      debugPrint('trying to connect to server...');
      socket = IO.io('ws://192.168.1.76:40000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      socket.connect();

      socket.onConnect((_) {
        debugPrint('connect');
        setState(() {
          _isConnected = true;
        });
        socket.emit('insertSensorData', 'Hello server!'); // Pedir datos
      });

      socket.on('insertSensorData', (data) {
        debugPrint('Received data: $data');
      });

      socket.onDisconnect((_) => {
            debugPrint('disconnect'),
            setState(() {
              _isConnected = false;
            })
          });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void disconnectFromServer() {
    try {
      socket.disconnect();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: _isConnected
                      ? Colors.green
                      : Theme.of(context).colorScheme.error,
                  radius: 8,
                ),
                const SizedBox(width: 8),
                Text(
                  _isConnected ? 'Conectado' : 'Desconectado',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          )),

      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Color.fromARGB(255, 236, 17, 64),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.home_outlined,
            ),
            label: 'Inicio',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.show_chart,
              color: Colors.white,
            ),
            icon: Badge(child: Icon(Icons.show_chart)),
            label: 'Rendimiento',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.person_2,
              color: Colors.white,
            ),
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.person_2),
            ),
            label: 'Perfil',
          ),
        ],
      ),

      body: <Widget>[
        /// Home page

        ExercisePage(),

        /// Messages page
        ListView.builder(
          reverse: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text('Hello',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          )),
                ),
              );
            }
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text('Hi!',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        )),
              ),
            );
          },
        ),

        UserProfilePage(),
      ][currentPageIndex],
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     FloatingActionButton(
      //       onPressed: () => connectToServer(),
      //       tooltip: 'Connect to server',
      //       child: const Icon(Icons.wifi),
      //     ),
      //     const SizedBox(width: 16),
      //     FloatingActionButton(
      //       onPressed: () => disconnectFromServer(),
      //       tooltip: 'Disconnect from server',
      //       child: const Icon(Icons.signal_wifi_connected_no_internet_4_sharp),
      //     )
      //   ],
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
