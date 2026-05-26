import 'package:cmproject/data/sqflite_metro_datasource.dart';
import 'package:cmproject/models/incident_report.dart';
import 'package:cmproject/models/station.dart';

import '../connectivity_module.dart';
import 'http_metro_datasource.dart';

class MetroRepository
{

  final HttpMetroDataSource httpSource;
  final SqfliteMetroDataSource sqfliteSource;
  final ConnectivityModule connectivityModule;

  MetroRepository({required this.httpSource, required this.sqfliteSource, required this.connectivityModule});

  Future<List<Station>> getAllStations() async
  {
    if(await connectivityModule.checkConnectivity())
    {
      final stations = await httpSource.getAllStations();
      await sqfliteSource.saveStations(stations);

      return stations;

    }
    else  //offline
    {
      List<Station> stations = await sqfliteSource.getAllStations();

      return stations;
    }
  }

  Future<Station> getStationDetail(String id) async
  {
    Station station;

    station = await sqfliteSource.getStationDetail(id);

    return station;
  }

  Future<void> attachIncident(String id, IncidentReport report) async
  {
    await sqfliteSource.attachIncident(id, report);
  }
}
