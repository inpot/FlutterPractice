import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:test1/login.dart';
import 'package:test1/main.dart';
import 'package:test1/regist.dart';
import 'package:toast/toast.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int current = 2;
  var watting = 2;

// final Connectivity _connectivity = Connectivity();
//   StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.topLeft,
      child: Column(children:<Widget>[ Row(
        children: <Widget>[
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(child: Text("$current", style: TextStyle(fontSize:24,),), onPressed: current <= 0 ? toNextPage : null,),
          ),
        ],
      ),
          Spacer(), 
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
            child: current <= 0 ?Row(children: <Widget>[
                RaisedButton(child: Text("Login"), onPressed: toLogin,),
                RaisedButton(child: Text("Regist"), onPressed: toRegist,), 

            ], mainAxisAlignment: MainAxisAlignment.spaceAround,):null
          )
      

      ]),
      color: Colors.black12,
    );
  }

void toRegist(){

Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistPage()));

}
void toLogin(){

var fu = Navigator.push<bool>(context, MaterialPageRoute(builder: (context)=>LoginPage()));
fu.then((bool res){ 
print("return result $res"); 
});


}


  void toNextPage(){ 
        Navigator.pushAndRemoveUntil(context,
         MaterialPageRoute(builder: (context) => MyHomePage()),
          (route)=>false ); 
        //Navigator.replace(context, newRoute: MaterialPageRoute(builder: (context) => MyHomePage()),);
  }

  @override
  void dispose() {
    timer.cancel();
   // _connectivitySubscription.cancel();
    super.dispose();
  }

  void onChange(ConnectivityResult result){
        Toast.show("Connectivity Change $result", context); 
  }

  Timer timer;
  @override
  void initState() {
    timer = new Timer.periodic(Duration(seconds: 1), (aaa) {
      setState(() {
        current = watting - aaa.tick;
        if (current <= 0) {
          aaa.cancel();
        }
        print("ticker $current");
      });
    });

   // _connectivitySubscription = _connectivity.onConnectivityChanged.listen(onChange);
    super.initState();
  }
}
