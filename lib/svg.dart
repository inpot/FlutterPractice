import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgPage extends StatelessWidget {
  final Uint8List svgData;

  const SvgPage({Key key, this.svgData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final String assetName = 'assets/lizard.svg';
    var svgW = SvgPicture.asset(
          assetName,
          fit: BoxFit.fill,
        );
    return Scaffold(
      appBar: AppBar(
        title: Text("SVG page"),
      ),
      body: Column(children: [
        SvgPicture.network(
          "https://www.svgrepo.com/show/2046/dog.svg",
          placeholderBuilder: (context) => CircularProgressIndicator(),
        ),
        SvgPicture.asset('assets/lizard.svg'),
        SvgPicture.asset('assets/tiger.svg',color: Colors.green, colorBlendMode: BlendMode.saturation, width: 120, height: 120,),

      ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.category),
        onPressed: () => loadSvg(context),
      ),
    );
  }

  void loadSvg(BuildContext context) async {
    print("svg {svg.lengthInBytes}");
  }
}
