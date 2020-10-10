import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:test1/spider.dart';
import 'package:test1/spiderXh.dart';
import 'package:test1/splash.dart';
import 'dart:math' as math;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  // debugRepaintRainbowEnabled = true;
  // debugProfilePaintsEnabled =true;
  // debugProfileBuildsEnabled = true;
  // debugPaintSizeEnabled = true;
  // debugDefaultTargetPlatformOverride = TargetPlatform.android;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
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
  var imgs = [
    "20200115163628.jpg",
    "20200115163729.jpg",
    "20200115163739.jpg",
    "20200115163755.jpg",
    "20200115163801.jpg",
    "20200115163807.jpg",
    "20200115163815.jpg",
    "20200116110120.jpg",
    "20200116110201.jpg",
    "20200116110211.jpg",
    "20200116110218.jpg",
    "20200116110238.jpg",
    "20200116110246.jpg",
    "20200116110255.jpg",
    "20200116110303.jpg",
    "20200116110308.jpg",
    "20200116110757.jpg",
    "20200116110815.jpg",
    "20200116110829.jpg",
    "20200116110842.jpg",
    "20200116142851.jpg",
    "20200116142906.jpg",
    "20200116142927.jpg",
    "20200116142938.jpg",
    "20200116142946.jpg",
    "20200116143022.jpg",
    "20200116143148.jpg",
    "20200116143202.jpg",
    "20200116143212.jpg",
    "20200116143254.jpg",
    "20200116143302.jpg",
    "20200116143307.jpg",
    "20200116143314.jpg",
    "20200116143327.jpg",
    "20200116143351.jpg",
    "20200116143401.jpg",
    "20200116143408.jpg",
    "20200116143414.jpg",
    "20200116143420.jpg",
    "20200116143511.jpg",
    "20200116143524.jpg",
    "640.webp",
    "6402.webp",
    "64022.jpg",
  ];

  void onBottomClick(int position) {
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
    print("build main");
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
            SpiderPage(),
            SpiderXh(),
            SingleChildScrollView(
              child: Wrap(
                children: imgs
                    .map((img) => ClipOval(
                          child: Image.asset(
                            "assets/$img",
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ))
                    .toList(),
              ),
            )
          ],
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //     items: [
        //       BottomNavigationBarItem(title: Text("first"), icon:(Icon(Icons.ac_unit)), ),
        //       BottomNavigationBarItem(title: Text("second"), icon:(Icon(Icons.access_alarm)) ),
        //       BottomNavigationBarItem( title: Text("Third"),icon:(Icon(Icons.adb)) ),
        //       BottomNavigationBarItem( title: Text("Third"),icon:(Icon(Icons.cached)) ),
        //       // BottomNavigationBarItem( title: Text("Third"),icon:(Icon(Icons.call)) ),
        //       ],
        //       type: BottomNavigationBarType.fixed,

        //       onTap: onBottomClick,
        //       currentIndex: current,
        //       selectedItemColor: Colors.red,
        //       unselectedItemColor: Colors.black,

        // ),
        bottomNavigationBar: BottomAppBar(
          //   shape: OutterCirclerNoched(),
          color: Colors.deepOrangeAccent,
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home),
                  color: current == 0 ? Colors.green : Colors.white,
                  onPressed: () {
                    setState(() {
                      current = 0;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.home),
                  color: current == 1 ? Colors.green : Colors.white,
                  onPressed: () {
                    setState(() {
                      current = 1;
                    });
                  },
                ),
                Opacity(
                  opacity: 0.0,
                  child: IconButton(
                    icon: Icon(Icons.home),
                    color: Colors.transparent,
                    onPressed: null,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.home),
                  color: current == 2 ? Colors.green : Colors.white,
                  onPressed: () {
                    setState(() {
                      current = 2;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.airplay),
                  color: current == 3 ? Colors.green : Colors.white,
                  onPressed: () {
                    setState(() {
                      current = 3;
                    });
                  },
                ),
              ]),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () => showLicensePage(context: context),
          child: Icon(Icons.add),
          backgroundColor: Colors.blueGrey,
        ),
      ),
    );
  }

  List<Widget> generateImage() {
    var result = imgs
        .map((img) => ClipOval(
              child: Image.asset(
                "assets/$img",
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ))
        .toList();

    return result;
  }
}

class OutterCirclerNoched extends CircularNotchedRectangle {
  @override
  Path getOuterPath(Rect host, Rect guest) {
    if (guest == null || !host.overlaps(guest)) return Path()..addRect(host);

    // The guest's shape is a circle bounded by the guest rectangle.
    // So the guest's radius is half the guest width.
    final double notchRadius = guest.width / 2.0;

    // We build a path for the notch from 3 segments:
    // Segment A - a Bezier curve from the host's top edge to segment B.
    // Segment B - an arc with radius notchRadius.
    // Segment C - a Bezier curve from segment B back to the host's top edge.
    //
    // A detailed explanation and the derivation of the formulas below is
    // available at: https://goo.gl/Ufzrqn

    const double s1 = 15.0;
    const double s2 = 1.0;

    final double r = notchRadius;
    final double a = -1.0 * r - s2;
    final double b = host.top - guest.center.dy;

    final double n2 = math.sqrt(b * b * r * r * (a * a + b * b - r * r));
    final double p2xA = ((a * r * r) - n2) / (a * a + b * b);
    final double p2xB = ((a * r * r) + n2) / (a * a + b * b);
    final double p2yA = math.sqrt(r * r - p2xA * p2xA);
    final double p2yB = math.sqrt(r * r - p2xB * p2xB);

    final List<Offset> p = List<Offset>(6);

    // p0, p1, and p2 are the control points for segment A.
    p[0] = Offset(a - s1, b);
    p[1] = Offset(a, b);
    final double cmp = b < 0 ? -1.0 : 1.0;
    p[2] = cmp * p2yA > cmp * p2yB ? Offset(p2xA, p2yA) : Offset(p2xB, p2yB);

    // p3, p4, and p5 are the control points for segment B, which is a mirror
    // of segment A around the y axis.
    p[3] = Offset(-1.0 * p[2].dx + 10, p[2].dy);
    p[4] = Offset(-1.0 * p[1].dx + 5, p[1].dy);
    p[5] = Offset(-1.0 * p[0].dx + 10, p[0].dy);

    // translate all points back to the absolute coordinate system.
    for (int i = 0; i < p.length; i += 1) p[i] += guest.center;

    return Path()
      ..moveTo(host.left, host.top)
      ..lineTo(p[1].dx - 5, p[1].dy)
      ..arcToPoint(
        p[4],
        radius: Radius.circular(notchRadius),
        clockwise: true,
      )
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
  }
}
