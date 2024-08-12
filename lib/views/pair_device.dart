import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothView extends StatefulWidget {
  const BluetoothView({super.key});

  @override
  State<BluetoothView> createState() => _MainBluetoothView();
}

class _MainBluetoothView extends State<BluetoothView> {
  final _bluetooth = FlutterBluetoothSerial.instance;
  bool _bluetoothState = false;
  bool _isConnecting = false;
  List<BluetoothConnection?> _connections = [null, null];
  List<BluetoothDevice?> _deviceConnected = [null, null];
  List<BluetoothDevice> _devices = [];
  List<int> times = [0, 0];

  @override
  void dispose() {
    // Cierra las conexiones Bluetooth y limpia cualquier recurso
    for (var connection in _connections) {
      connection?.close();
    }
    _connections.clear();

    // Llama a super.dispose() para completar el ciclo de vida del widget
    super.dispose();
  }

  void _getDevices() async {
    var res = await _bluetooth.getBondedDevices();
    if (mounted) {
      setState(() => _devices = res);
    }
  }

  void _receiveData(int deviceIndex) {
    _connections[deviceIndex]?.input?.listen((event) {
      // Procesamiento de datos recibidos
      if (mounted) {
        setState(() {
          // Lógica para manejar los datos recibidos
        });
      }
    });
  }

  void _requestPermission() async {
    await Permission.bluetoothConnect.request();
    await Permission.location.request();
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();

    _bluetooth.state.then((state) {
      setState(() => _bluetoothState = state.isEnabled);
    });

    _bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BluetoothState.STATE_OFF:
          setState(() => _bluetoothState = false);
          break;
        case BluetoothState.STATE_ON:
          setState(() => _bluetoothState = true);
          break;
        // case BluetoothState.STATE_TURNING_OFF:
        //   break;
        // case BluetoothState.STATE_TURNING_ON:
        //   break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        _controlBT(),
        _infoDeviceCard(0),
        _infoDeviceCard(1),
        _inputSerial(0),
        _inputSerial(1),
      ]),
    );
  }

  Widget _controlBT() {
    return SwitchListTile(
      value: _bluetoothState,
      onChanged: (bool value) async {
        if (value) {
          await _bluetooth.requestEnable();
        } else {
          await _bluetooth.requestDisable();
        }
      },
      tileColor: Colors.black26,
      title: Text(
        _bluetoothState ? "Bluetooth encendido" : "Bluetooth apagado",
      ),
    );
  }

  Widget _infoDeviceCard(int deviceIndex) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      elevation: 5.0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dispositivo ${deviceIndex + 1}",
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Text(
              "Conectado a: ${_deviceConnected[deviceIndex]?.name ?? "ninguno"}",
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10.0),
            _connections[deviceIndex]?.isConnected ?? false
                ? TextButton.icon(
                    onPressed: () async {
                      await _connections[deviceIndex]?.finish();
                      setState(() {
                        _deviceConnected[deviceIndex] = null;
                      });
                    },
                    icon: const Icon(CupertinoIcons.hand_raised_slash),
                    label: const Text("Desconectar"),
                  )
                : ExpansionTile(
                    title: const Text("Ver dispositivos",
                        style: TextStyle(color: Colors.blueGrey)),
                    leading: const Icon(
                      CupertinoIcons.bluetooth,
                      color: Colors.blueGrey,
                    ),
                    children: [
                      SizedBox(
                        height: 200.0,
                        child: SingleChildScrollView(
                            child: _getCardDevices(deviceIndex)),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _getCardDevices(deviceIndex) {
    _getDevices();
    return Column(
      children: _devices.map((device) {
        return ListTile(
          title: Text(device.name ?? device.address),
          trailing: TextButton(
            child: const Text('Conectar'),
            onPressed: () async {
              setState(() => _isConnecting = true);

              var connection =
                  await BluetoothConnection.toAddress(device.address);
              setState(() {
                _connections[deviceIndex] = connection;
                _deviceConnected[deviceIndex] = device;
                _devices = [];
                _isConnecting = false;
              });

              _receiveData(deviceIndex);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _inputSerial(int deviceIndex) {
    return ListTile(
      trailing: TextButton(
        child: const Text('Reiniciar'),
        onPressed: () => setState(() => times[deviceIndex] = 0),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          "Pulsador presionado en dispositivo $deviceIndex (x${times[deviceIndex]})",
          style: const TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
