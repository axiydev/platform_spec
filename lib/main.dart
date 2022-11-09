import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platform_spec/constants/constants.dart';

/*
Created by Axmadjon Isaqov on 15:38:01 09.11.2022
© 2022 @axi_dev 
*/
/*
Theme:::Platform Spacefic code
*/
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Connectivity? connectivity;
  late final StreamSubscription? subscription;
  Connection? connectionType = Connection.disconnected;

  @override
  void initState() {
    connectivity = Connectivity();
    listenConnection();
    super.initState();
  }

  void listenConnection() async {
    assert(connectivity != null);
    try {
      subscription = connectivity!.onConnectivityChanged.listen((result) {
        switch (result) {
          case ConnectivityResult.bluetooth:
            connectionType = Connection.unknown;
            break;
          case ConnectivityResult.wifi:
            connectionType = Connection.wifi;
            break;
          case ConnectivityResult.ethernet:
            connectionType = Connection.unknown;
            break;
          case ConnectivityResult.mobile:
            connectionType = Connection.mobile;
            break;
          case ConnectivityResult.none:
            connectionType = Connection.disconnected;
            break;
          case ConnectivityResult.vpn:
            connectionType = Connection.unknown;
            break;
        }

        setState(() {});
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void dispose() {
    subscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const NetworkStreamWidget(),
          Text(
            connectionType!.toString(),
            style: const TextStyle(
                fontSize: 30, fontWeight: FontWeight.w600, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}

class NetworkStreamWidget extends StatelessWidget {
  const NetworkStreamWidget({super.key});
  final eventChannel =
      const EventChannel('com.example.platform_spec/connectivity');
  @override
  Widget build(BuildContext context) {
    final networkEventStream = eventChannel
        .receiveBroadcastStream()
        .distinct()
        .map((event) => intToConnection(event));
    return StreamBuilder<Connection>(
      initialData: Connection.disconnected,
      stream: networkEventStream,
      builder: (context, snapshot) {
        final String message = snapshot.data.toString();
        final Color color = getColor(snapshot.data!);
        log(snapshot.data.toString());
        return ConnectionWidget(
          message: message,
          color: color,
          connectionType: snapshot.data,
        );
      },
    );
  }
}

class ConnectionWidget extends StatelessWidget {
  const ConnectionWidget(
      {super.key,
      required this.message,
      required this.color,
      required this.connectionType});
  final String? message;
  final Color? color;
  final Connection? connectionType;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message!,
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w600, color: color!),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: connectionType == Connection.wifi
                  ? color
                  : Colors.transparent,
              child: const Icon(Icons.wifi),
            ),
            const SizedBox(
              width: 10,
            ),
            CircleAvatar(
              backgroundColor: connectionType == Connection.mobile
                  ? color
                  : Colors.transparent,
              child: const Icon(Icons.mobile_friendly),
            ),
            const SizedBox(
              width: 10,
            ),
            CircleAvatar(
              backgroundColor: connectionType == Connection.disconnected
                  ? color
                  : Colors.transparent,
              child: const Icon(Icons.sync_problem),
            ),
          ],
        ),
        const Text('connection with Package'),
      ],
    );
  }
}
