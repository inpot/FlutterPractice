import 'package:flutter/material.dart';
import 'package:test1/list.dart';
import 'package:test1/main.dart';
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
            child: Text("toVs"),
            onPressed: () {
              print("flatbutton");
              Navigator.push(context, MaterialPageRoute(builder: (context)=>VsTtPage()));
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