import 'package:flutter/material.dart';
import '/pages/pages.dart';

class ReportPage extends StatelessWidget
{
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: ValueKey("incidents-report-screen"),
        appBar: AppBar(title:Text(pages[3].title)),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Report")
          ],
        )
    );
  }
}