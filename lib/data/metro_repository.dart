import 'package:cmproject/data/sqflite_metro_datasource.dart';
import 'package:cmproject/models/incident_report.dart';
import 'package:cmproject/models/station.dart';
import 'package:cmproject/services/connectivity_service.dart';

import 'http_metro_datasource.dart';

class MetroRepository
{

  final HttpMetroDataSource httpSource;
  final SqfliteMetroDataSource sqfliteSource;
  final ConnectivityService connectivityService;

  MetroRepository({required this.httpSource, required this.sqfliteSource, required this.connectivityService});

  Future<List<Station>> getAllStations() async
  {
    if(await connectivityService.isOnline())
    {
      final stations = await httpSource.getAllStations();
      await sqfliteSource.saveStations(stations);

      return stations;

    }
    else  //offline
    {
      List<Station> stations = await sqfliteSource.getAllStations();
      if(stations.isEmpty)
      {
        throw Exception("Check your connectivity and try again later.");
      }

      return stations;
    }
  }

  Future<Station> getStationDetail(String id) async
  {
    Station station;
    if(await connectivityService.isOnline())
    {
      station = await httpSource.getStationDetail(id);
    }
    else  //Offline
    {
      station = await sqfliteSource.getStationDetail(id);
    }

    List<IncidentReport> incidents = await sqfliteSource.getStationIncidents(station.id);
    station.setReports(incidents);
    return station;
  }

  Future<void> attachIncident(String id, IncidentReport report) async
  {
    await sqfliteSource.attachIncident(id, report);
  }
}
