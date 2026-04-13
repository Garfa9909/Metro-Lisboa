import 'package:cmproject/data/metro_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Line.dart';
import '../models/station.dart';
import '/pages/pages.dart';

class ListPage extends StatelessWidget
{
  const ListPage({super.key});

  @override
  Widget build(BuildContext context)
  {
    MetroRepository repository = context.read<MetroRepository>();
    return Scaffold(
      key: ValueKey("list-screen"),
        appBar: AppBar(title:Text(pages[1].title)),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView(
              key:ValueKey("list-view"),
                shrinkWrap: true,
                children: repository.getAllStations().map( (station) => stationEntry(station) ).toList()

            )
          ],
        )
        
    );
  }

  Widget stationEntry(Station station)
  {
    return Column(children: [
      SizedBox(height: 15,),
      stationButton(station),
      SizedBox(height: 15,)
    ],);
  }

  Widget stationButton(Station station)
  {
    return TextButton(
        onPressed: (){},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(station.name),
            SizedBox(width: 20,),
            linesInfo(station),
          ],
        ));
  }

  Widget linesInfo(Station station)
  {
    if(station.line2 == null)
    {
        return lineDisplay(station.line1);
    }
    else
    {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            lineDisplay(station.line1),
            SizedBox(width:10),
            lineDisplay(station.line2),
          ],
        );
    }

  }

  Widget lineDisplay(Line? line)
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: line?.color, // Fill color
            shape: BoxShape.circle,
          ),
        ),
        Text(line!.name)
      ],
    );
  }

}