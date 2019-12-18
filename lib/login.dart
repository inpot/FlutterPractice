import 'package:flutter/material.dart';
import 'package:test1/auth2.dart';
import 'package:test1/list.dart';
import 'package:test1/main.dart';
import 'package:test1/thread.dart';
import 'package:test1/video.dart';
import 'package:test1/vs.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Text("Login"),
          FlatButton(
            child: Text("FlatButton"),
            onPressed: () => print("flatbutton"),
            color: Colors.blue,
            colorBrightness: Brightness.light,
            splashColor: Colors.indigo,
          ),
          RaisedButton(
            child: Text("toListPage"),
            onPressed: () {
              print("flatbutton");
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ListPage()));
            },
          ),
          RaisedButton(
            child: Text("toTestHome"),
            onPressed: () {
              print("flatbutton");
              Navigator.push(context, MaterialPageRoute(builder: (context)=>TestHome()));
            },
          ),
          RaisedButton(
            child: Text("toThreading"),
            onPressed: () {
              print("flatbutton");
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ThreadPage()));
            },
          ),

          RaisedButton(
            child: Text("VideoPage"),
            onPressed: () {
              print("flatbutton");
              Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoPage()));
            },
          ),
          RaisedButton(
            child: Text("ViewPager"),
            onPressed: () {
              print("flatbutton");
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Auth()));
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
            child: Text("toMain"),
            onPressed: () => {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                  (route) => false)
            },
          ),
        ],
      )),
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