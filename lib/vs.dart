import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CountState with ChangeNotifier {
  int _count = 0;
  get count => _count;
  void increment() {
    _count++;
    notifyListeners();
  }
}

class TestHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final count = CountState();
    return Scaffold(
      appBar: AppBar(title:Text("Test Home")),
          body: MultiProvider(
        providers: [ChangeNotifierProvider.value(value: count)],
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              RedBox(),
              YellowBox(),
              BlueBox(),
              GreenBox(),
            ],
          ),
        ),
        floatingActionButton: Consumer<CountState>(
            builder: (ctx, stat, child) => FloatingActionButton(
                  onPressed: () {
                    stat.increment();
                  },
                  child: Icon(Icons.add),
                )));
  }
}

class RedBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("---------RedBox---------build---------");
    return Container(
      color: Colors.red,
      width: 150,
      height: 150,
      alignment: Alignment.center,
      child: Consumer<CountState>(
        builder: (ctx, stat, child) => Text(
          "Red:${stat.count}",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class YellowBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("---------YellowBox---------build---------");
    return Container(
        color: Colors.yellow,
        width: 150,
        height: 150,
        alignment: Alignment.center,
        child: Consumer<CountState>(
          builder: (ctx, stat, child) =>
              Text("Yellow:${stat.count}", style: TextStyle(fontSize: 20)),
        ));
  }
}

class BlueBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("---------BlueBox---------build---------");
    return Container(
      color: Colors.blue,
      width: 150,
      height: 150,
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NextPage()));
        },
        child: Consumer<CountState>(
          builder: (ctx, stat, child) =>
              Text("Blue:${stat.count}", style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}

class GreenBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("---------GreenBox---------build---------");
    return Container(
        color: Colors.green,
        width: 150,
        height: 150,
        alignment: Alignment.center,
        child: Consumer<CountState>(
          builder: (ctx, stat, child) =>
              Text("GreenBox:${stat.count}", style: TextStyle(fontSize: 20)),
        ));
  }
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("---------NextPage---------build---------");
    return Scaffold(
      body: Center(
          child: InkWell(
        onTap: () {
          Provider.of<CountState>(context).increment();
        },
        child: Container(
            color: Colors.purple,
            width: 150,
            height: 150,
            alignment: Alignment.center,
            child: Text("111111", style: TextStyle(fontSize: 20))),
      )),
    );
  }
}

class VsTtPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("build _VsTtPage");
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(value: VsVM()),
    ], child: _PageBody());
  }
}


class _PageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("build _pageBody");
    return Scaffold(
      appBar: AppBar(
        title: Text("Vs"),
      ),
      body: SingleChildScrollView(
        child: Consumer<VsVM>(builder: (ctx, vm, child) {
          return Column(children: [
            Text("body text:${vm.downloadStr}"),
            Text("downloa progress:${vm.status}"), 
            LinearProgressIndicator(value: vm.progress,backgroundColor: Colors.cyan,),
            CircularProgressIndicator(value: vm.progress,backgroundColor: Colors.lightGreen,),
            RefreshProgressIndicator(value: vm.progress,backgroundColor: Colors.white,)
          ]);
        }),
      ),
      floatingActionButton: Consumer<VsVM>(
          builder: (ctx, vm, child) => FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  vm.download();
                },
              )),
    );
  }

}

class VsVM with ChangeNotifier {
  var status = "ready";
  var statusBuilder = StringBuffer("Ready==");
  String PrefixServer = "server=/";
  String DNSServer = "/127.0.0.1#1053";
  String PrefixIpset = "ipset=/";
  String IpsetName = "/gfwlist";
  var downloadStr = "";
  var progress = 0.0;

  Future download() async {
    progress = 0.0;
    _appendLine("CheckPermission");
    // var granted = await checkPermission();

    // _appendLine(
    //     "PermssionStatus: ${granted ? 'Permission Granted' : 'permission Denied'}");
    var dio = Dio();
    Response<String> response = await dio.get<String>(
        "https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt",
        onReceiveProgress:  downloadProgress
        );
    if (response.statusCode != 200) {
      _appendLine("status code ${response.statusCode}");
      _appendLine("status Msg ${response.statusMessage}");
      return;
    }
    var valueStr = StringBuffer();
    response.headers.forEach((key,values){
      valueStr.clear();
      values.forEach((item)=> valueStr.write(item) );
      print("$key = ${valueStr.toString()}");




    });

    var httpResult = response.data;
    _appendLine("download gfwlist success");
    httpResult = httpResult.replaceAll("\n", "");
    var decoded = base64.decode(httpResult);
    var resultStr = utf8.decode(decoded);
    _appendLine("parse success");
    var builder2 = StringBuffer();
    var lines = resultStr.split("\n");
    _appendLine("all count ${lines.length}");
    lines.forEach((line) {
      if (line.startsWith("||")) {
        line = line.replaceFirst("||", "");
        line = line.replaceAll("\n", "");
        builder2.writeln("$PrefixServer$line$DNSServer");
        builder2.writeln("$PrefixIpset$line$IpsetName");
      } else {
       // builder2.writeln(line);
      }
    });
    _appendLine("convert gfwlist success");
    // print(builder2.toString());
    Directory appDocDir = await getExternalStorageDirectory();
    String appDocPath = appDocDir.path;
    var fileName = "/gfwlist.conf";
    var file = File("$appDocPath$fileName");
    var exists = await file.exists();
    _appendLine("file exists $exists");
    if (exists) {
      await file.delete();
    }
    await file.create();
    await file.writeAsString(builder2.toString());
    _appendLine("write exists ${file.toString()}");
  }

  void downloadProgress(int count, int total){
    progress = count / total;
    downloadStr = "$count/$total ===== ${(progress * 100).toStringAsFixed(1)}%";
    print(downloadStr + "\n");
    notifyListeners();
  }

  // Future<bool> checkPermission() async {
  //   PermissionStatus permission = await PermissionHandler()
  //       .checkPermissionStatus(PermissionGroup.storage);
  //   var granted = permission.value == PermissionStatus.granted.value;
  //   if (granted) {
  //     return granted;
  //   }

  //   Map<PermissionGroup, PermissionStatus> permission2 =
  //       await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  //   var denied = StringBuffer();
  //   permission2.forEach((PermissionGroup key, PermissionStatus value) {
  //     var granted = value.value == PermissionStatus.granted.value;

  //     if (!granted) {
  //       denied.write("${key.toString()}  === ${value.toString()}");
  //     }
  //   });
  //   print(denied);
  //   return granted;
  // }

  void _setStatus(String value) {
    this.status = value;
    notifyListeners();
  }

  void _appendLine(String value) {
    statusBuilder.writeln(value);
    _setStatus(statusBuilder.toString());
  }
}
