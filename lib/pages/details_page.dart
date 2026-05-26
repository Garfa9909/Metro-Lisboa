import 'package:cmproject/connectivity_module.dart';
import 'package:cmproject/data/http_metro_datasource.dart';
import 'package:cmproject/data/metro_repository.dart';
import 'package:cmproject/data/sqflite_metro_datasource.dart';
import 'package:cmproject/location_module.dart';
import 'package:cmproject/models/incident_report.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../models/station.dart';
import 'line.dart';

class DetailsPage extends StatefulWidget
{
  DetailsPage({super.key, required this.stationId});

  final String stationId;

  @override
  State<DetailsPage> createState() => _MainPageState();
}

class _MainPageState extends State<DetailsPage>
{

  late Future<LocationData> locationFuture;
  @override
  void initState()
  {
    super.initState();
    LocationModule locationModule = context.read<LocationModule>();

    //Test doesn't give any values so placeholder ones will be created if null.
    locationFuture = locationModule.onLocationChanged().firstWhere(
          (event) => event.latitude != null && event.longitude != null,
      orElse: () => LocationData.fromMap({
        "latitude": 0,
        "longitude": 0,
      }),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    MetroRepository repository =
    MetroRepository(
      httpSource:
      context.read<HttpMetroDataSource>(),
      sqfliteSource:
      context.read<SqfliteMetroDataSource>(),
      connectivityModule:
      context.read<ConnectivityModule>(),
    );

    return FutureBuilder<Station>(
      future: repository.getStationDetail(widget.stationId),
      builder: (_, snapshot)
      {
        if(snapshot.connectionState != ConnectionState.done)
        {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if(snapshot.hasError)
        {
          return Scaffold(
            body: Center(child: Text(snapshot.error.toString())),
          );
        }

        final station = snapshot.data!;
        final line = Line.getByName(station.lineName);

        return FutureBuilder<LocationData>(
          future: locationFuture,
          builder: (_, locationSnapshot)
          {
            bool permissions = locationSnapshot.hasData && locationSnapshot.data != null && locationSnapshot.data!.latitude != null && locationSnapshot.data!.longitude != null;
            Widget distanceText = Text("Can't calculate distance because there's no access to user location", style: TextStyle(color: Colors.black, fontSize: 20));
            if(permissions)
            {
              final userLat = locationSnapshot.data!.latitude!;
              final userLon = locationSnapshot.data!.longitude!;
              distanceText = buildDistanceText(userLat, userLon, station.latitude, station.longitude);
            }

            return Scaffold(
              key: ValueKey("detail-screen"),
              backgroundColor: line?.color,
              appBar: AppBar( title:Text(station.name),
                  titleTextStyle: TextStyle(fontSize: 30, color: Colors.white),
                  backgroundColor: Colors.black,
                  iconTheme: IconThemeData(color: Colors.white, size: 40),
                  toolbarHeight: 70,
                  actions: [
                    Padding( padding: const EdgeInsets.all(16.0),
                    child: SizedBox( height: 40, width: 40,
                        child: Image.asset( line!.imageLink ),)
                    )
                  ]
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Linha ${line.name}",
                        style: const TextStyle(fontSize: 20)),

                    distanceText,
                    const SizedBox(height: 20),

                    const Text("Incidents:",
                        style: TextStyle(fontSize: 30)),

                    buildIncidentList(station),
                  ],),
              ),
            );
          },
        );
        },);
  }

  Widget buildIncidentList(Station station)
  {
    if(station.reports.isEmpty)
    {
      return Text("No incident reports", style: TextStyle(color: Colors.black, fontSize: 20));
    }

    else
    {
      return SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height*0.55,
          child: ListView(
            shrinkWrap: true,
            key:ValueKey("detail-screen-incidents-list"),
            children: station.reports.map( (incident) => buildIncidentEntry(incident) ).toList(),
          ),
        ),
      );
    }
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

  Widget buildDistanceText(double lat, double long, double lat1, double long1)
  {
      String unit = "m";
      var dist = Geolocator.distanceBetween(lat, long, lat1, long1);
      String d = dist.toStringAsFixed(0);
        if(dist >= 1000)
        {
            dist/=1000;
            d = dist.toStringAsFixed(2);
            unit = "km";
        }

        return Text("Distance to station: $d$unit", style: TextStyle(color: Colors.black, fontSize: 20));
    }

}