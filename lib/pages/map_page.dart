import 'package:flutter/material.dart';
import '/pages/pages.dart';

class MapPage extends StatelessWidget
{
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: ValueKey("map-screen"),
        appBar: AppBar(title:Text(pages[2].title)),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Map")
          ],
        )
    );
  }
}