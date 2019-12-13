import 'dart:isolate';

import 'package:flutter/material.dart';

class ThreadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Theading"),
      ),
      body: Text("BodyText"),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.dashboard),
        onPressed: threadTest,
      ),
    );
  }

  void threadTest() async {
    print("thread test");
    var receivePort = ReceivePort();
    Isolate.spawn(dataLoader, receivePort.sendPort);
    SendPort sendPort = await receivePort.first;
    sendPort.send(["message from thread Test", receivePort.sendPort]);
    await for (var msg in receivePort) {
    
       print("msg ${msg.toString()}");
    
    }
  }

  static void dataLoader(SendPort sendPort) async {
    print(" dataLoader: ======");
    var receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    await for (var msg in receivePort) {
      String data = msg[0];
      SendPort sendPort = msg[1];
      print("msg $data");
      await Future.delayed(Duration(seconds: 2), () {
        sendPort.send("this message from Isolate");
      }); 
      print("completed");
    }
  }
}
