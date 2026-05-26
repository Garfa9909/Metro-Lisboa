import 'package:cmproject/connectivity_module.dart';
import 'package:cmproject/data/http_metro_datasource.dart';
import 'package:cmproject/data/metro_repository.dart';
import 'package:cmproject/data/sqflite_metro_datasource.dart';
import 'package:cmproject/models/incident_report.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
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
  Position? _userLocation;
  //Ask for location permission when loading
  @override
  void initState()
  {
    super.initState();
    requestLocationPermission();

    getUserLocation();
  }

  Future<void> getUserLocation() async
  {
    final location = await Geolocator.getCurrentPosition();
    setState(()
    {

      _userLocation = location;

    });
  }

  Future<void> requestLocationPermission() async
  {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied)
    {
      await Geolocator.requestPermission();
    }
  }

  @override
  Widget build(BuildContext context)
  {
    MetroRepository repository = MetroRepository(httpSource: context.read<HttpMetroDataSource>(), sqfliteSource: context.read<SqfliteMetroDataSource>(), connectivityModule: context.read<ConnectivityModule>());

    return FutureBuilder<Station>(
      future: repository.getStationDetail(widget.stationId),
      builder: (_, snapshot)
      {
        if(snapshot.connectionState != ConnectionState.done)
        {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        else
        {
          if(snapshot.hasError)
          {
            return Scaffold(
              body: Center(
                child: Text(snapshot.error.toString()),
              ),
            );
          }

          else
          {
            Station station = snapshot.data!;
            Line? line = Line.getByName(station.lineName);

            return Scaffold(
              key: ValueKey("detail-screen"),
              backgroundColor: line?.color,
              appBar: AppBar(
                title:Text(station.name),
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
                    buildDistanceText(station.latitude, station.longitude),

                    SizedBox(height: 20,),

                    Text("Incidents:", style: TextStyle(color: Colors.black, fontSize: 30)),
                    buildIncidentList(station),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
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

  Widget buildDistanceText(double lat, double long)
  {
    if(_userLocation==null)
    {
      return Text("Trying to get user location...", style: TextStyle(color: Colors.black, fontSize: 20));
    }

    else
    {
      String unit = "m";

      var dist = Geolocator.distanceBetween(_userLocation!.latitude, _userLocation!.longitude, lat, long);
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
}