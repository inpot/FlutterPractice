import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgPage extends StatelessWidget {
  final String assetName = 'assets/lizard.svg';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("SVG page"),
        ),
        body:
        Center(
          child: SvgPicture.network(
 "https://www.svgrepo.com/show/2046/dog.svg",
 placeholderBuilder: (context) => CircularProgressIndicator(),
 height: 128.0,
),
        ),


         
        floatingActionButton: FloatingActionButton(child: Icon(Icons.category),onPressed: ()=>print("click"),),
        
        );
  }
}
