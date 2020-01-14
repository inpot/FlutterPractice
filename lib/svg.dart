import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgPage extends StatelessWidget {
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
        InkWell(
          child: SvgPicture.network(
            "https://www.svgrepo.com/show/2046/dog.svg",
            placeholderBuilder: (context) => CircularProgressIndicator(),
          ),
          onTap: () => print("OnTapFirst"),
        ),
        InkWell(
          child: SvgPicture.asset('assets/lizard.svg'),
          onTap: () => print("InkWell click"),
        ),
        InkWell(
          child: SvgPicture.asset(
            'assets/tiger.svg',
            color: Colors.green,
            colorBlendMode: BlendMode.saturation,
            width: 120,
            height: 120,
          ),
          onTap: () => print("OnTapFirst"),
          onDoubleTap: () => print("OnDoubleTap"),
          onTapCancel: () => print("OnTapCancle"),
          onLongPress: () => print("OnLongPress"),
        ),
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
