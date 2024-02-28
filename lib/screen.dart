import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Arduino"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _connectAndSendData();
          },
          child: Text('Unlock Door'),
        ),
      ),
    );
  }


void _connectAndSendData() async {
    List<BluetoothDevice> devices = [];

    flutterBlue.startScan(timeout: Duration(seconds: 4));

    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        if (result.device.name == 'Your Arduino Device Name') {
          devices.add(result.device);
        }
      }
    });

    await Future.delayed(Duration(seconds: 4)); // Allow time for scanning

    for (BluetoothDevice device in devices) {
      await device.connect();
      await device.writeCharacteristic(
        device.characteristics.first,
        utf8.encode('unlock'), // Send a command to unlock the door
        type: CharacteristicWriteType.withoutResponse,
      );
      await device.disconnect();
    }
  }
}