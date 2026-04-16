import 'package:flutter/material.dart';
import '/pages/pages.dart';

class DashboardPage extends StatelessWidget
{
  const DashboardPage({super.key, required this.onChangeTab});

  final Function onChangeTab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: ValueKey("dashboard-screen"),
        appBar: AppBar(title: Text(pages[0].title),
            titleTextStyle: TextStyle(fontSize: 30, color: Colors.white),
            backgroundColor: Colors.black,
            toolbarHeight: 70),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height*0.2,
              decoration: BoxDecoration(
                  color: Color(0xffff5050)),
              child: 
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Image.asset("assets/images/logo.png"),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("Get started:", style: TextStyle(color: Colors.black, fontSize: 30),)],
              ),
            ),

            buildButton("Check Stations", 1, Icons.list, "dashboard-stations-button", context),
            SizedBox(height:30),
            buildButton("See stations in map", 2, Icons.map, "dashboard-map-button", context)
          ],
        )
    );
  }

  Widget buildButton(String text, int destination, IconData icon, String key, BuildContext context)
  {
    return TextButton(
      key: ValueKey(key),
        onPressed: ()
        {
          onChangeTab(destination);
        },
        style: TextButton.styleFrom(backgroundColor: Colors.black,),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width*0.7,
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 35,),
                SizedBox(width:10),
                Text(text, style: TextStyle(color:Colors.white, fontSize: 20),),
              ],
            ),
          ),
        )
        );
  }
}
