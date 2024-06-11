import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tenis/pages/home.dart';
import 'package:flutter_tenis/pages/login.dart';
import 'package:flutter_tenis/pages/profile.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:elegant_notification/elegant_notification.dart';

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
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 223, 18, 18)),
        useMaterial3: true,
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color.fromARGB(255, 4, 21, 27),
          indicatorColor: const Color.fromARGB(255, 236, 17, 64),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.white),
          ),
          iconTheme: MaterialStateProperty.all(
            const IconThemeData(color: Colors.white),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginView(),
        '/home': (context) => MyHomePage(title: 'Flutter Demo Home Page'),
      },
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
  bool _isConnected = false;
  int currentPageIndex = 0;
  var data;
  late List<dynamic> alertsData = [];
  late List<dynamic> arrayData = [];

  void connectToServer() {
    try {
      debugPrint('Trying to connect to server...');
      socket = IO.io('ws://187.154.221.14:40000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      socket.connect();

      socket.onConnect((_) {
        debugPrint('Connected to server');
        setState(() {
          _isConnected = true;
        });
        socket.emit('userStats');
        socket.emit('alerts');
      });

      socket.on('clima', (data) {
        debugPrint('Received clima: $data');
      });

      socket.on('userData_leonardo', (data) {
        setState(() {
          this.data = data;
        });
        debugPrint('Received userData_leonardo: $data');
      });
      socket.on('userStats', (data) {
        setState(() {
          arrayData = data;
        });
        debugPrint('Received userStats: $data');
      });
      socket.on('alerts', (data) {
        setState(() {
          alertsData = data;
        });
        debugPrint('Received alerts: $data');
      });
      socket.on(
          "newAlerts",
          (data) => {
                setState(() {
                  alertsData = data;
                }),
                debugPrint('Received alerts: $data'),
                ElegantNotification.error(
                  width: 360,
                  toastDuration: const Duration(seconds: 5),
                  stackedOptions: StackedOptions(
                    key: 'topRight',
                    type: StackedType.below,
                    itemOffset: const Offset(0, 5),
                  ),
                  position: Alignment.topRight,
                  animation: AnimationType.fromRight,
                  title: const Text('Alerta de sensores'),
                  description: Text(data[data.length - 1]['data']),
                  onDismiss: () {},
                ).show(context),
              });
      socket.onDisconnect((_) {
        debugPrint('Disconnected from server');
        setState(() {
          _isConnected = false;
        });
      });

      socket.onConnectError((err) {
        debugPrint('Connect error: $err');
      });

      socket.onError((err) {
        debugPrint('Error: $err');
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
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color.fromARGB(255, 4, 21, 27),
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: const Color.fromARGB(255, 192, 59, 59),
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(
              Icons.home,
              color: Colors.white70,
            ),
            icon: Icon(
              Icons.home_outlined,
              color: Colors.white70,
            ),
            label: 'Inicio',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.mail,
              color: Colors.white70,
            ),
            icon: Badge(
              child: Icon(
                Icons.mail,
                color: Colors.white70,
              ),
            ),
            label: 'Alertas',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.person_2,
              color: Colors.white70,
            ),
            icon: Badge(
              label: Text('2'),
              child: Icon(
                Icons.person_2,
                color: Color.fromARGB(94, 255, 255, 255),
              ),
            ),
            label: 'Perfil',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        ExercisePage(data: data, arrayData: arrayData),

        /// Messages page
        ListView.builder(
          itemCount: alertsData.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('Alerta ${index + 1}'),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(alertsData[index]['data']),
                  Text(alertsData[index]['fecha'])
                ],
              ),
            );
          },
        ),

        UserProfilePage(isConected: _isConnected),
      ][currentPageIndex],
    );
  }
}
