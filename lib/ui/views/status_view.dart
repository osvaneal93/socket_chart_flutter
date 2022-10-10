import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_chart/core/services/socket_service.dart';

class StatusView extends StatelessWidget {
  const StatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SocketService>(
      builder: (_, socketService, __) {
        return Scaffold(
          body: Center(
            child: Text('Socket Service State: ${socketService.serverStatus}'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              socketService.socket.emit('message-client', {
                'nombre': 'Osvaldo',
                'mensaje': 'Saludos desde Flutter',
              });
            },
          ),
        );
      },
    );
  }
}
