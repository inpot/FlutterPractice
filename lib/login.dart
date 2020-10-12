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
import 'package:menubar/menubar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
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
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text("System Infomation"),
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
                  var file = File("G:\\work\\test1\\build\\windows\\x64\\Debug\\Runner\\test.txt");
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListPage()));
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TestHome()));
                },
              ),
              RaisedButton(
                child: Text("Get Pref"),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  var val = prefs.getString("key1");
                  print("value : $val");
                },
              ),
              RaisedButton(
                child: Text("Save Pref"),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString("key1", "this is value");
                },
              ),
              RaisedButton(
                child: Text("gfwlist"),
                onPressed: () {
                  print("flatbutton");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GfwListPage()));
                },
              ),
              RaisedButton(
                child: Text("toThreading"),
                onPressed: () {
                  print("flatbutton");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ThreadPage()));
                },
              ),
              RaisedButton(
                child: Text("VideoPage"),
                onPressed: () {
                  print("flatbutton");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPage()));
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Auth()));
                },
              ),
              RaisedButton(
                child: Text("ViewPager"),
                onPressed: () {
                  print("flatbutton");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Auth()));
                },
              ),
              RaisedButton(
                child: Text("Show SVG"),
                onPressed: () async {
                  print("flatbutton");

                  final String assetName = 'assets/lizard.svg';
                  var svg = await DefaultAssetBundle.of(context).load(assetName);
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
                  var url = "https://dns.google/resolve?name=twitter.com&type=a&do=1";
                  var dio = Dio();
                  dio.options.headers["user-agent"] =
                      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36";
                  dio.options.contentType = "text";
                  var httpAdapter = dio.httpClientAdapter as DefaultHttpClientAdapter;
                  httpAdapter.onHttpClientCreate = (HttpClient client) {
                    client.findProxy = (url) {
                      return "PROXY localhost:8001;";
                    };
                    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WidgetsPage()));
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
                      context, MaterialPageRoute(builder: (context) => MyHomePage()), (route) => false)
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
              Text(AppLocalizations.of(context).helloWorld("Localization:")),
              RaisedButton(
                child: Text("Desktop MenuBar"),
                onPressed: () async {
                  //Share.share("zzzzzzzzzzzzz", subject: "subject");
                  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
                    setApplicationMenu([
                      Submenu(label: "SubMenu1", children: [MenuItem(label: "menuItem1", enabled: false)]),
                      Submenu(label: "SubMenu2", children: [
                        MenuItem(label: "menuItem1"),
                        MenuItem(label: "menuItem2"),
                        MenuItem(label: "menuItem3")
                      ]),
                      Submenu(label: "SubMenu3", children: [MenuItem(label: "menuItem1")]),
                    ]);
                  }
                },
              ),
              RaisedButton(
                  child: Text("NavigationRail"),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NavigationH()));
                  })
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

class NavigationH extends StatelessWidget {
  var railVM = NavigationRailVM();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      MultiProvider(
          providers: [ChangeNotifierProvider.value(value: railVM)],
          builder: (context, child) {
            var vm = context.watch<NavigationRailVM>();
            var rail = NavigationRail(
              destinations: [
                NavigationRailDestination(icon: Icon(Icons.ac_unit), label: Text("Destnation0")),
                NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text("Destnation1")),
                NavigationRailDestination(icon: Icon(Icons.baby_changing_station), label: Text("Destnation2")),
                NavigationRailDestination(icon: Icon(Icons.cached), label: Text("Destnation3")),
              ],
              selectedIndex: context.watch<NavigationRailVM>().Current,
              onDestinationSelected: (value) => vm.Current = value,
            );
            var body = Row(
              children: [rail, buildDetail(vm.Current)],
            );

            return body;
          }),
      Container(
        alignment: Alignment.bottomLeft,
        margin: EdgeInsets.all(40),
        child: Material(
          borderRadius: BorderRadius.circular(8),
          child: RaisedButton(
              onPressed: () => print("Click"),
              child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.access_alarms), Text("data")])),
        ),
      )
    ]));
  }

  Widget buildDetail(int index) {
    print("buildDetail $index");
    return Expanded(
      child: Center(child: Text("This is $index")),
    );
  }
}

class NavigationRailBody extends StatelessElement {
  NavigationRailBody(StatelessWidget widget) : super(widget);
}

class NavigationRailVM extends ChangeNotifier {
  var _current = 0;
  int get Current {
    return _current;
  }

  set Current(int value) {
    _current = value;
    notifyListeners();
  }
}
