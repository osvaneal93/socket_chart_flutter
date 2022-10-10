import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_chart/core/services/socket_service.dart';
import 'package:socket_chart/ui/views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SocketService(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomeView(),
      ),
    );
  }
}
