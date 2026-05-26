import 'package:cmproject/data/metro_repository.dart';
import 'package:cmproject/location_module.dart';
import 'package:cmproject/models/station.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../connectivity_module.dart';
import '../data/http_metro_datasource.dart';
import '../data/sqflite_metro_datasource.dart';
import '/pages/pages.dart';
import 'details_page.dart';


class MapPage extends StatefulWidget
{
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage>
{
  late Future<List<Station>> stationsFuture;
  late Future<LocationData> locationFuture;

  @override
  void initState()
  {
    super.initState();
    MetroRepository repository = MetroRepository(httpSource: context.read<HttpMetroDataSource>(), sqfliteSource: context.read<SqfliteMetroDataSource>(), connectivityModule: context.read<ConnectivityModule>(),);
    LocationModule locationModule = context.read<LocationModule>();
    locationFuture = locationModule.onLocationChanged().first;
    stationsFuture = repository.getAllStations();
  }

  @override
  Widget build(BuildContext context)
  {


    return Scaffold(
      key: ValueKey("map-screen"),

      appBar: AppBar(
        title: Text(pages[2].title),
        titleTextStyle:
        TextStyle(fontSize: 30, color: Colors.white),
        backgroundColor: Colors.black,
        toolbarHeight: 70,
      ),

      body: FutureBuilder<LocationData>(
        future: locationFuture,
        builder: (_, locationSnapshot) {
          if (locationSnapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          bool permissions = locationSnapshot.hasData && locationSnapshot.data != null && locationSnapshot.data!.latitude != null && locationSnapshot.data!.longitude != null;
          {
              return FutureBuilder<List<Station>>(
                future: stationsFuture,
                builder: (_, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }

                  final stations = snapshot.data!;

                  final markers = stations.map((station) {
                    return Marker(
                      markerId: MarkerId(station.id),
                      position: LatLng(station.latitude, station.longitude,),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailsPage(stationId: station.id),
                          ),
                        );
                      },
                    );
                  }).toSet();

                  return GoogleMap(
                    initialCameraPosition: CameraPosition(target: LatLng(stations[0].latitude, stations[0].longitude), zoom: 13,),
                    myLocationEnabled: permissions,
                    myLocationButtonEnabled: permissions,
                    markers: markers,
                  );
                },
              );
            }
        },
      )
    );
  }
}