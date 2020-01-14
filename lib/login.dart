import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:test1/auth2.dart';
import 'package:test1/expensive.dart';
import 'package:test1/list.dart';
import 'package:test1/main.dart';
import 'package:test1/svg.dart';
import 'package:test1/thread.dart';
import 'package:test1/video.dart';
import 'package:test1/vs.dart';
import 'package:test1/widgets.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatelessWidget {
    var txt = r"""Fuchsia is an open source capability-based operating system currently being developed by Google. It first became known to the public when the project appeared on a self hosted form of git in August 2016 without any official announcement. The source documentation describes the reasoning behind the name as "Pink + Purple == Fuchsia (a new Operating System)"[1], which is a reference to Pink (Apple's first effort at a object-oriented, microkernel based operating system), and Purple (the original iPhone's codename)[2]. In contrast to prior Google-developed operating systems such as Chrome OS and Android, which are based on the Linux kernel, Fuchsia is based on a new microkernel called Zircon, named after the mineral.

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
        color: Colors.greenAccent,
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
                },
                color: Colors.blue,
                colorBrightness: Brightness.light,
                splashColor: Colors.indigo,
            ),
            RaisedButton(
                child: Text("toListPage"),
                onPressed: () {
                  print("flatbutton");
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => ListPage()));
                },
            ),
            RaisedButton(
                child: Text("toTestHome"),
                onPressed: () {
                  print("flatbutton");
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => TestHome()));
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
                  var svg = await DefaultAssetBundle.of(context).load(assetName);
                  var data = svg.buffer.asUint8List();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SvgPage()));
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
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                      (route) => false)
                },
            ),
            RaisedButton(
                child: Text("Expensive Paint"),
                onPressed: () {
                  Navigator.push( context, MaterialPageRoute(builder: (context) => ExpensivePage()),);
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
