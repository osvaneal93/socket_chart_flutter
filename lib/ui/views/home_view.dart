import 'dart:math';

import 'package:flutter/material.dart';
import 'package:socket_chart/data/models/signature_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<SignatureModel> model = [
    SignatureModel(id: 1, name: 'Quimica', counter: 5),
    SignatureModel(id: 2, name: 'Fisica', counter: 9),
    SignatureModel(id: 3, name: 'Biologia', counter: 12),
    SignatureModel(id: 4, name: 'Matematicas', counter: 15)
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView.builder(
          itemBuilder: (context, index) => listTileItem(model[index]),
          itemCount: model.length,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: showAddDialog,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  ListTile listTileItem(SignatureModel model) => ListTile(
        title: Text(model.name),
        leading: CircleAvatar(
          backgroundColor: Colors.amber.withOpacity(.6),
          child: Text(
            model.id.toString(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        trailing: Text(model.counter.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold)),
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
              MaterialButton(
                onPressed: () {
                  addToList(signatureController);
                  Navigator.pop(context);
                },
                color: Colors.amber,
                elevation: 0,
                child: const Text('Agregar'),
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

  void addToList(TextEditingController controller) {
    Random random = Random();
    model.add(
      SignatureModel(
        id: model.length + 1,
        name: controller.text,
        counter: random.nextInt(15),
      ),
    );
  }
}
