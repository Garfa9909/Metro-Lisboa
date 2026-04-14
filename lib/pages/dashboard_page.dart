import 'package:flutter/material.dart';
import '/pages/pages.dart';

class DashboardPage extends StatelessWidget
{
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: ValueKey("dashboard-screen"),
        appBar: AppBar(title: Text(pages[0].title),
            titleTextStyle: TextStyle(fontSize: 30, color: Colors.white),
            backgroundColor: Colors.black,
            toolbarHeight: 70),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Dashboard")
          ],
        )
    );
  }
}
