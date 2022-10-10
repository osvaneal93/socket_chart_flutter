import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:socket_chart/core/services/socket_service.dart';
import 'package:socket_chart/data/models/signature_model.dart';

class MyHomeView extends StatefulWidget {
  const MyHomeView({super.key});

  @override
  State<MyHomeView> createState() => _MyHomeViewState();
}

class _MyHomeViewState extends State<MyHomeView> {
  List<SignatureModel> model = [];
  List<SignatureModel> models = [
    SignatureModel(id: '456789', name: 'HOLIS', counter: 3),
    SignatureModel(id: '456789', name: 'HOLIS', counter: 3),
    SignatureModel(id: '456789', name: 'HOLIS', counter: 3),
    SignatureModel(id: '456789', name: 'HOLIS', counter: 3),
  ];

  final GlobalKey dissmisible = GlobalKey();
  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    Future.delayed(Duration(seconds: 2));
    socketService.socket.on('item-request', (data) async {
      model =
          await (data as List).map((e) => SignatureModel.fromMap(e)).toList();
      print('MODELS: ${model.length}');
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SocketService>(
      builder: (_, socketService, __) {
        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Text(
                'Chart Sockets',
                style: TextStyle(color: Colors.amber.shade900),
              ),
              backgroundColor: Colors.white,
              actions: [
                if (socketService.serverStatus == ServerStatus.online)
                  const Center(
                    child: Text(
                      'Connected',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                if (socketService.serverStatus == ServerStatus.offline)
                  const Center(
                    child: Text(
                      'Offline',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                const SizedBox(
                  width: 25,
                )
              ],
            ),
            body: Column(
              children: [
                _buildChart(),
                Center(
                  child: Text(model.length.toString()),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) => listTileItem(model[index]),
                    itemCount: model.length,
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: showAddDialog,
              child: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }

  Widget listTileItem(SignatureModel model) => Consumer<SocketService>(
        builder: (_, socketService, __) => Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            socketService.socket.emit('delete-item', {'idItem': model.id});
          },
          child: InkWell(
            onTap: () {
              socketService.socket.emit('plus-item', {'idItem': model.id});
            },
            child: ListTile(
              title: Text(model.name),
              leading: CircleAvatar(
                backgroundColor: Colors.amber.withOpacity(.6),
                child: Text(
                  model.name.substring(0, 2),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              trailing: Text(model.counter.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      );

  showAddDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          final TextEditingController signatureController =
              TextEditingController();

          return AlertDialog(
            title: const Text('Add Signature'),
            actions: [
              Consumer<SocketService>(
                builder: (_, socketService, __) => MaterialButton(
                  onPressed: () {
                    socketService.socket
                        .emit('add-item', {'name': signatureController.text});
                    Navigator.pop(context);
                  },
                  color: Colors.amber,
                  elevation: 0,
                  child: const Text('Agregar'),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: const Color.fromARGB(255, 253, 228, 139),
                child: const Text('Cancelar'),
              ),
            ],
            content: TextField(
              controller: signatureController,
              decoration: const InputDecoration(
                label: Text(
                  'New Signature: ',
                ),
              ),
            ),
          );
        });
  }

  _buildChart() {
    Map<String, double> dataMap = Map();

    model.forEach((element) {
      dataMap.putIfAbsent(element.name, () => element.counter.toDouble());
    });

    return SizedBox(
      height: 250,
      width: double.infinity,
      child: PieChart(dataMap: dataMap),
    );
  }
}
