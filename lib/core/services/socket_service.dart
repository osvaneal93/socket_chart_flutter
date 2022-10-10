import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { offline, online, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;
  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    _socket = IO.io('http://192.168.0.13:3001', {
      'transports': ['websocket'],
      'autoConnect': true
    });

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      print('ONLINE');
      notifyListeners();
    });
    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
    _socket.on('message-server',
        (data) => print('message from server: ${data['message']}'));
  }
}
