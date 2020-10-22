import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThreadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      appBar: AppBar(
        title: Text("Theading"),
      ),
      body: Text("BodyText"),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.dashboard),
        onPressed: sendMsg,
      ),
    );
  }

  void sendMsg() {
    sendPort.send("send from onPressed");
  }

  SendPort sendPort;

  var receivePort = ReceivePort();
  void init() async {
    print("thread test");
    Isolate.spawn(dataLoader, receivePort.sendPort);
    receivePort.listen((message) {
      if (message is SendPort) {
        sendPort = message;
      }
      print("Main Got Message: $message");
    });
  }

  static void dataLoader(SendPort sendPort) async {
    print(" dataLoader: ======");
    var receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    //receivePort.listen((message) => print("Got Message"));
    await for (var msg in receivePort) {
      print("loader Got msg:$msg");
      sendPort.send("Reply for Msg: $msg");
    }
  }
}
