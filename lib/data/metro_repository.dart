import 'package:cmproject/data/sqflite_metro_datasource.dart';
import 'package:cmproject/models/incident_report.dart';
import 'package:cmproject/models/station.dart';

import 'http_metro_datasource.dart';

class MetroRepository
{

  final HttpMetroDataSource httpSource;
  final SqfliteMetroDataSource sqfliteSource;

  MetroRepository({required this.httpSource, required this.sqfliteSource,});

  Future<List<Station>> getAllStations() async
  {

    //try //Online
    //{


      final stations = await httpSource.getAllStations();


      //await sqliteSource.saveStations(stations);

      return stations;

    //}
    /*catch (e)  //Offline
    {

      //return await sqfliteSource.getAllStations();
    }*/
  }

  Future<Station> getStationDetail(String id) async
  {
    throw UnimplementedError();
  }
}
