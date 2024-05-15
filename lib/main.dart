import 'package:flutter/material.dart';
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
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 223, 18, 18)),
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

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void connectToServer() {
    try {
      socket = IO.io('ws://189.141.178.191:40000', <String, dynamic>{
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
        title: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: _isConnected
                  ? Colors.green
                  : Theme.of(context).colorScheme.error,
              radius: 8,
            ),
            Text(widget.title),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => connectToServer(),
            tooltip: 'Connect to server',
            child: const Icon(Icons.wifi),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () => disconnectFromServer(),
            tooltip: 'Disconnect from server',
            child: const Icon(Icons.signal_wifi_connected_no_internet_4_sharp),
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
