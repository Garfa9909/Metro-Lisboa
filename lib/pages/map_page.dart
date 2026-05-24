import 'package:cmproject/data/metro_repository.dart';
import 'package:cmproject/models/station.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

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
  //Ask for location permission when loading
  @override
  void initState()
  {
    super.initState();
    requestLocationPermission();
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
    MetroRepository repository =
    context.read<MetroRepository>();

    return Scaffold(
      key: ValueKey("map-screen"),

      appBar: AppBar(
        title: Text(pages[2].title),
        titleTextStyle:
        TextStyle(fontSize: 30, color: Colors.white),
        backgroundColor: Colors.black,
        toolbarHeight: 70,
      ),

      body: FutureBuilder<List<Station>>(
        future: repository.getAllStations(),

        builder: (_, snapshot)
        {
          if(snapshot.connectionState != ConnectionState.done)
          {
            return Center(child: CircularProgressIndicator(),);
          }

          else
          {
            if(snapshot.hasError)
            {
              return Center(child: Text(snapshot.error.toString(),),);
            }

            else
            {
              List<Station> stations = snapshot.data!;

              Set<Marker> markers = stations.map((station)
                {
                  return Marker(

                    markerId: MarkerId(station.id),
                    position: LatLng(station.latitude, station.longitude,),

                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              DetailsPage(stationId: station.id,),
                        ),
                      );
                    },
                  );
                },
              ).toSet();

              return GoogleMap(

                initialCameraPosition:
                CameraPosition(
                  target: LatLng(stations[0].latitude, stations[0].longitude,),
                  zoom:13
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,

                markers: markers,
              );
            }
          }
        },
      ),
    );
  }
}