import 'package:cmproject/data/metro_datasource.dart';
import 'package:cmproject/models/incident_report.dart';
import 'package:cmproject/models/station.dart';

class SqfliteMetroDataSource extends MetroDataSource
{
  @override
  Future<void> attachIncident(String id, IncidentReport report) {
    // TODO: implement attachIncident
    throw UnimplementedError();
  }

  @override
  Future<List<Station>> getAllStations() {
    // TODO: implement getAllStations
    throw UnimplementedError();
  }

  @override
  Future<Station> getStationDetail(String id) {
    // TODO: implement getStationDetail
    throw UnimplementedError();
  }

  @override
  Future<List<Station>> getStationsByName(String name) {
    // TODO: implement getStationsByName
    throw UnimplementedError();
  }

  @override
  Future<void> insertStation(Station station) {
    // TODO: implement insertStation
    throw UnimplementedError();
  }
  // So devem implementar aqui os métodos que existem na classe MetroDataSource
}