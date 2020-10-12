import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class GfwListPage extends StatelessWidget {
  var vm = GfwVM();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("GfwList")),
        body: MultiProvider(
          providers: [ChangeNotifierProvider.value(value: vm)],
          child: _GfwPageBody(vm),
        ));
  }
}

class _GfwPageBody extends StatelessWidget {
  GfwVM vm;
  final RegExp ipRegExp =
      new RegExp(r"^((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})(\.((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})){3}$");
  final RegExp ipsetRegExp = new RegExp(r"^[a-z]{3-10}$");
  _GfwPageBody(this.vm);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("GfwList 2 dnsmasq"),
        TextFormField(
          decoration: InputDecoration(
            labelText: "UpString Dns Server port",
            hintText: "127.0.0.1@1053",
          ),
          initialValue: "127.0.0.1@1053",
          validator: (value) {
            vm.DNSServer = null;
            var length = 0;
            if (value == null)
              length = 0;
            else {
              value = value.trim();
              length = value.length;
            }
            if (value.length < 10) {
              return "长度不正确";
            }
            var strs = value.split("@");
            if (strs.length != 2) {
              return "格式不正确，请用@作ip和port的分割号";
            }
            var ipMatch = ipRegExp.hasMatch(strs[1]);
            if (!ipMatch) {
              return "ip格式不正确";
            }
            int port = int.parse(strs[2]);
            if (port <= 0 || port > 65535) {
              return "端口号的范围是0到65535";
            }
            vm.DNSServer = value;
            return null;
          },
        ),
        TextFormField(
          decoration: InputDecoration(labelText: "ipset Name", hintText: "ipset Name"),
          initialValue: "gfwlist",
          validator: (value) {
            var length = 0;
            vm.ipsetName = null;
            if (value == null)
              length = 0;
            else {
              value = value.trim();
              length = value.length;
            }
            if (length > 10 || length < 3) {
              return "ipset Name长度应为3-10";
            }

            var ipMatch = ipsetRegExp.hasMatch(value);
            if (!ipMatch) {
              return "ipset应当全小写字母";
            }
            vm.ipsetName = value;
            return null;
          },
        ),
        Consumer(builder: (_, GfwVM vm, widget) {
          return Text("${vm.status}");
        }),
        RaisedButton(
            child: Text("2Dnsmasq"),
            onPressed: () async {
              var result = await showSavePanel();
              if (result.paths.length > 0) {
                vm.savePath = result.paths[0];
                print("${result.paths[0]}");
                vm.convert2dnsmasq();
              }
              Toast.show("No file choosed!!", context);
            }),
        Text("GfwList 2 dnsmasq")
      ],
    );
  }
}

class GfwVM with ChangeNotifier {
  var status = "ready";
  var statusBuilder = StringBuffer("Ready==");
  final SPLASH = "/";
  String PrefixServer = "server=";
  String DNSServer = "127.0.0.1#1053";
  String PrefixIpset = "ipset=";
  String ipsetName = "gfwlist";
  var downloadStr = "";
  var progress = 0.0;
  var savePath = "D:\\";

  Future convert2dnsmasq() async {
    progress = 0.0;
    _appendLine("CheckPermission");
    _appendLine("parse success");
    var builder2 = StringBuffer();
    var gfwlistStr = await getGfwlist();
    var lines = gfwlistStr.split("\n");
    _appendLine("all count ${lines.length}");
    lines.forEach((line) {
      if (line.startsWith("||")) {
        line = line.replaceFirst("||", "");
        line = line.replaceAll("\n", "");
        builder2.writeln("$PrefixServer$SPLASH$line$SPLASH$DNSServer");
        builder2.writeln("$PrefixIpset$SPLASH$line$SPLASH$ipsetName");
      } else {
        // builder2.writeln(line);
      }
    });
    _appendLine("convert gfwlist success");
    // print(builder2.toString());
    // Android Directory appDocDir = await getExternalStorageDirectory();
    //String appDocPath = appDocDir.path;
    //String appDocPath = savePath;
    //var fileName = "/gfwlist.conf";
    var file = File(savePath);
    var exists = await file.exists();
    _appendLine("file exists $exists");
    if (exists) {
      await file.delete();
    }
    await file.create();
    await file.writeAsString(builder2.toString());
    _appendLine("write exists ${file.toString()}");
  }

  void _setStatus(String value) {
    this.status = value;
    notifyListeners();
  }

  void _appendLine(String value) {
    statusBuilder.writeln(value);
    _setStatus(statusBuilder.toString());
  }
}

Future<String> getGfwlist() async {
  var dio = Dio();
  var httpAdapter = dio.httpClientAdapter as DefaultHttpClientAdapter;
  httpAdapter.onHttpClientCreate = (HttpClient client) {
    client.findProxy = (url) {
      return "PROXY localhost:8001;";
    };
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  };
  Response<String> response = await dio.get<String>(
      "https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt",
      onReceiveProgress: downloadProgress);
  if (response.statusCode != 200) {
    return "";
  }
  var valueStr = StringBuffer();
  response.headers.forEach((key, values) {
    valueStr.clear();
    values.forEach((item) => valueStr.write(item));
    print("$key = ${valueStr.toString()}");
  });

  var httpResult = response.data;
  httpResult = httpResult.replaceAll("\n", "");
  var decoded = base64.decode(httpResult);
  var resultStr = utf8.decode(decoded);
  return resultStr;
}

void downloadProgress(int count, int total) {
  var progress = count / total;
  var downloadStr = "$count/$total ===== ${(progress * 100).toStringAsFixed(1)}%";
  print(downloadStr + "\n");
}

Future<bool> checkPermission() async {
  PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  var granted = permission.value == PermissionStatus.granted.value;
  if (granted) {
    return granted;
  }

  Map<PermissionGroup, PermissionStatus> permission2 =
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  var denied = StringBuffer();
  permission2.forEach((PermissionGroup key, PermissionStatus value) {
    print("permssion ${key.toString()}");
    if (key.value == PermissionGroup.storage.value) {
      var granted = (value.value == PermissionStatus.granted.value);
      print("granted ${granted}");
      if (!granted) {
        denied.write("${key.toString()}  === ${value.toString()}");
      }
    }
  });
  print(denied);
  return granted;
}
