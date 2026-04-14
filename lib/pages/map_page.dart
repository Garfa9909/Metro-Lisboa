import 'package:flutter/material.dart';
import '/pages/pages.dart';

class MapPage extends StatelessWidget
{
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: ValueKey("map-screen"),
        appBar: AppBar(title: Text(pages[2].title),
            titleTextStyle: TextStyle(fontSize: 30, color: Colors.white),
            backgroundColor: Colors.black,
            toolbarHeight: 70),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Map")
          ],
        )
    );
  }
}