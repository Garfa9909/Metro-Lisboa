import 'package:cmproject/data/metro_repository.dart';
import 'package:cmproject/models/incident_report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/station.dart';
import 'Line.dart';

class DetailsPage extends StatefulWidget
{
  DetailsPage({super.key, required this.stationId});

  final String stationId;

  @override
  State<DetailsPage> createState() => _MainPageState();
}

class _MainPageState extends State<DetailsPage> {
  int _waitingTime1 = 2;  //Placeholder values, in the future they will be obtained from API
  int _waitingTime2 = 4;

  @override
  Widget build(BuildContext context)
  {
    MetroRepository repository = context.read<MetroRepository>();
    Station? station = repository.getStationDetail(widget.stationId);
    Line? line = Line.getByName(station!.lineName);
    return Scaffold(
      key: ValueKey("detail-screen"),
      backgroundColor: line?.color,
      appBar: AppBar(title:Text(station.name),
        titleTextStyle: TextStyle(fontSize: 30, color: Colors.white),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white, size: 40),
        toolbarHeight: 70,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 40,
              width: 40,
              child: Image.asset(
                line!.imageLink
              ),
            ),
          )
        ],
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Linha ${line.name}", style: TextStyle(color: Colors.black, fontSize: 20)),
            Text("Latitude: ${station.latitude}", style: TextStyle(color: Colors.black, fontSize: 20), ),
            Text("Longitude: ${station.longitude}", style: TextStyle(color: Colors.black, fontSize: 20)),
            SizedBox(height: 20,),
            Row(children: [
              Icon(Icons.arrow_forward, size: 40,),
              Text(line.start, style: TextStyle(color: Colors.black, fontSize: 25)),
            ],),
            Text("$_waitingTime1 min", style: TextStyle(color: Colors.black, fontSize: 20)),

            SizedBox(height: 10,),

            Row(children: [
              Icon(Icons.arrow_forward, size: 40,),
              Text(line.end, style: TextStyle(color: Colors.black, fontSize: 25)),
            ],),
            Text("$_waitingTime2 min", style: TextStyle(color: Colors.black, fontSize: 20)),

            SizedBox(height: 20,),
            Text("Incidents:", style: TextStyle(color: Colors.black, fontSize: 30)),
            SingleChildScrollView(
              child: SizedBox(
                height: 220,
                child: ListView(
                  shrinkWrap: true,
                  key:ValueKey("detail-screen-incidents-list"),
                  children: station.reports.map( (incident) => buildIncidentEntry(incident) ).toList(),
                ),
              ),
            )


          ],
        ),
      ),
    );
  }

  Widget buildIncidentEntry(IncidentReport incident)
  {
    return ListTile(
      title:Container(
        decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.white, width: 5),
            borderRadius: BorderRadius.all(Radius.circular(20)),

        ),
        child:
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
              children: [
                Text(DateFormat("dd/MM/yyyy HH:mm").format(incident.timestamp), style: TextStyle(color: Colors.white,),),
                SizedBox(width:20),
                Text(incident.type.displayName, style: TextStyle(color: Colors.white,),),
            ],
          ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("${incident.rate}/5", style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ConstrainedBox(constraints: BoxConstraints(maxWidth:300),child: Text(showNotes(incident.notes), style: TextStyle(color: Colors.white,),)),
                ],
              ),


          ],
          ),
        ),
      ),
    );
  }

  String showNotes(String? notes)
  {
    if(notes == null)
      {
        return "No notes";
      }
    else
      {
        return notes;
      }
  }
}