
import 'package:flutter/material.dart';

class WidgetsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Widgets"),),

      body: _WidgetsBody(),

    );
    
    
      }
}

class _WidgetsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: AnimatedW(),);
  }
    
}

class AnimatedW extends StatefulWidget {
  @override
  _AnimatedWState createState() => _AnimatedWState();
}

class _AnimatedWState extends State<AnimatedW> {
  Color color = Colors.teal;
  String content = r'aaaaalib/widgets.dart:48:7: Error: Place positional arguments before named arguments. Try moving the positional argument before the named arguments, or add a name to the argument.';
  var width = 200.0;
  var height = 200.0;
  bool start = true;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      RaisedButton(child: Text("Animate"),onPressed: (){
          setState(() {
            start = !start;
          });

      },),
      AnimatedContainer(
        //color: start ? Colors.red :Colors.purple,
        child:  Icon(Icons.chevron_right),
        width: start ? 200.0: 100.0,
        height: start ? 100.0: 200.0, 
        duration: Duration(milliseconds: 200), 
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular( start? 0:20)), 
          border: Border.all(width:start ? 2: 6),
          color: start? Colors.indigo : Colors.deepOrange
      
          
          
           ),
        
      )

    ],);  }
}