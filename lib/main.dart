
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test1/splash.dart';

void main() { 
  debugDefaultTargetPlatformOverride = TargetPlatform.android;
  runApp(MyApp());
  }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.brown,
          brightness: Brightness.light,
          primaryColor: Colors.indigo,
        ),
        home: Scaffold(
          body: SplashPage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

    var current = 0;

  void onBottomClick(int position){
    setState(() {
      current = position; 
    }); 
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("tittile"),
          bottom: TabBar(tabs: [
            Tab(icon: Icon(Icons.directions_car)),
            Tab(icon: Icon(Icons.directions_transit)),
            Tab(icon: Icon(Icons.directions_bike)),
          ]),
        ),
        body: TabBarView(
          children: [
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(title: Text("first"), icon:(Icon(Icons.ac_unit)), ),
              BottomNavigationBarItem(title: Text("second"), icon:(Icon(Icons.access_alarm)) ),
              BottomNavigationBarItem( title: Text("Third"),icon:(Icon(Icons.adb)) ),
              BottomNavigationBarItem( title: Text("Third"),icon:(Icon(Icons.cached)) ),
              BottomNavigationBarItem( title: Text("Third"),icon:(Icon(Icons.call)) ),
              ],
              onTap: onBottomClick,
              currentIndex: current, 
              selectedItemColor: Colors.red,
              unselectedItemColor: Colors.black,

        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showLicensePage(context: context),
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
