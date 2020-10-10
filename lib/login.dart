import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test1/auth2.dart';
import 'package:test1/expensive.dart';
import 'package:test1/gfwlist.dart';
import 'package:test1/list.dart';
import 'package:test1/main.dart';
import 'package:test1/thread.dart';
import 'package:test1/video.dart';
import 'package:test1/vs.dart';
import 'package:test1/widgets.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_size/window_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  var txt =
      r"""Fuchsia is an open source capability-based operating system currently being developed by Google. It first became known to the public when the project appeared on a self hosted form of git in August 2016 without any official announcement. The source documentation describes the reasoning behind the name as "Pink + Purple == Fuchsia (a new Operating System)"[1], which is a reference to Pink (Apple's first effort at a object-oriented, microkernel based operating system), and Purple (the original iPhone's codename)[2]. In contrast to prior Google-developed operating systems such as Chrome OS and Android, which are based on the Linux kernel, Fuchsia is based on a new microkernel called Zircon, named after the mineral.

The GitHub project suggests Fuchsia can run on many platforms, from embedded systems to smartphones, tablets, and personal computers. In May 2017, Fuchsia was updated with a user interface, along with a developer writing that the project was not a "dumping ground of a dead thing", prompting media speculation about Google's intentions with the operating system, including the possibility of it replacing Android. On July 1, 2019 Google announced the homepage of the project, fuchsia.dev, which provides source code and documentation for the newly announced operating system.[3]""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.teal, Colors.pink],
          stops: [0.0, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.spaceAround,
            runAlignment: WrapAlignment.start,
            children: <Widget>[
              //Text(txt),
              FlatButton(
                child: Text("FlatButton"),
                onPressed: () {
                  var bytes = utf8.encode("input");
                  var encoded = sha256.convert(bytes);
                  print("encode : $encoded");

                  print("NumberOf Processors:${Platform.numberOfProcessors}");
                  print("Platform Version:${Platform.version}");
                  print("Operation System:${Platform.operatingSystem}");
                  print("System Version:${Platform.operatingSystemVersion}");
                  print("Path Separator:${Platform.pathSeparator}");
                  print("Path Of Executable:${Platform.resolvedExecutable}");
                  print("Current Platform: $defaultTargetPlatform");
                },
                color: Colors.blue,
                colorBrightness: Brightness.light,
                splashColor: Colors.indigo,
              ),
              RaisedButton(
                child: Text("Windows File Test"),
                onPressed: () async {
                  print("flatbutton");
                  var file = File(
                      "G:\\work\\test1\\build\\windows\\x64\\Debug\\Runner\\test.txt");
                  if (await file.exists()) {
                    await file.delete();
                  }
                  await file.create(recursive: true);
                  await file.writeAsString("test content");
                  var success = await file.exists();
                  print("write success $success");
                  var content = await file.readAsString();
                  print("the file content is: ${content}");
                },
              ),
              RaisedButton(
                child: Text("toListPage"),
                onPressed: () {
                  print("flatbutton");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ListPage()));
                },
              ),
              RaisedButton(
                child: Text("Url Launcher"),
                onPressed: () async {
                  await launch("http://pl.goinbowl.com");
                },
              ),
              RaisedButton(
                child: Text("pathprovider"),
                onPressed: () async {
                  print("flatbutton");
                  var documentDir = await getApplicationDocumentsDirectory();
                  print("DocDir $documentDir");
                  var tempDir = await getTemporaryDirectory();
                  print("tempDir $tempDir");
                  var downloads = await getApplicationSupportDirectory();
                  print("downloadPath $downloads");
                },
              ),
              RaisedButton(
                child: Text("toTestHome"),
                onPressed: () {
                  print("flatbutton");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TestHome()));
                },
              ),
              RaisedButton(
                child: Text("Get Pref"),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var val = prefs.getString("key1");
                  //var pref = await SimplePref.getPref("first.xml");
                  //var value = pref.getString("test", "AAA");
                  print("value : $val");
                },
              ),
              RaisedButton(
                child: Text("Save Pref"),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                   prefs.setString("key1","this is value");
                },
              ),
              RaisedButton(
                child: Text("gfwlist"),
                onPressed: () {
                  print("flatbutton");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GfwListPage()));
                },
              ),
              RaisedButton(
                child: Text("toThreading"),
                onPressed: () {
                  print("flatbutton");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ThreadPage()));
                },
              ),
              RaisedButton(
                child: Text("VideoPage"),
                onPressed: () {
                  print("flatbutton");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => VideoPage()));
                },
              ),
              RaisedButton(
                child: Text("Window Size"),
                onPressed: () async {
                  print("flatbutton");
                  var result = await getCurrentScreen();
                  print("${result.frame.toString()}");
                },
              ),
              RaisedButton(
                child: Text("Spider iqiyi"),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Auth()));
                },
              ),
              RaisedButton(
                child: Text("ViewPager"),
                onPressed: () {
                  print("flatbutton");
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Auth()));
                },
              ),
              RaisedButton(
                child: Text("Show SVG"),
                onPressed: () async {
                  print("flatbutton");

                  final String assetName = 'assets/lizard.svg';
                  var svg =
                      await DefaultAssetBundle.of(context).load(assetName);
                  var data = svg.buffer.asUint8List();
                  Navigator.push(
                      context,
                      //MaterialPageRoute(builder: (context) => SvgPage()));
                      MaterialPageRoute(builder: (context) => VideoPage()));
                },
              ),
              RaisedButton(
                child: Text("DoH Json Test"),
                onPressed: () async {
                  print("flatbutton");
                  var url =
                      "https://dns.google/resolve?name=twitter.com&type=a&do=1";
                  var dio = Dio();
                  dio.options.headers["user-agent"] =
                      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36";
                  dio.options.contentType = "text";
                  var httpAdapter =
                      dio.httpClientAdapter as DefaultHttpClientAdapter;
                  httpAdapter.onHttpClientCreate = (HttpClient client) {
                    client.findProxy = (url) {
                      return "PROXY localhost:8001;";
                    };
                    client.badCertificateCallback =
                        (X509Certificate cert, String host, int port) => true;
                  };
                  Response<String> result = await dio.get(url);
                  var content = result.data;
                  Map<String, dynamic> resJson = jsonDecode(content);
                  List<dynamic> answer = resJson["Answer"];
                  answer.forEach((element) {
                    var name = element["name"];
                    var ip = element["data"];
                    print("addr:$name:$ip");
                  });
                  print("flatbutton end");
                },
              ),
              RaisedButton(
                child: Text("Widgets"),
                onPressed: () {
                  print("flatbutton");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WidgetsPage()));
                },
              ),
              RaisedButton(
                child: Text("Back"),
                onPressed: () {
                  print("flatbutton");
                  Navigator.of(context).pop(true);
                },
              ),
              OutlineButton(
                child: Text("to Main"),
                onPressed: () => {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                      (route) => false)
                },
              ),
              RaisedButton(
                child: Text("Expensive Paint"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExpensivePage()),
                  );
                },
              ),
              RaisedButton(
                child: Text("Share To"),
                onPressed: () async {
                  Share.share("zzzzzzzzzzzzz", subject: "subject");
                },
              ),
              RaisedButton(
                child: Text("Connectivity Check"),
                onPressed: () async {
                  var status = await (Connectivity().checkConnectivity());
                  Toast.show("Current Network is $status", context);
                  var dt = DateTime.now().add(Duration(days: 120, hours: 6));
                  print("$dt");
                },
              ),
              Row(children: [Text("Localization Txt:"),Text(AppLocalizations.of(context).helloWorld)],)

            ],
          ),
        ),
      ),
    );
  }
}

class User {
  String name;
  int id;
  String email;
  String addr;
  String icon;

  User(this.name, this.id, this.email, this.addr, this.icon);
}
