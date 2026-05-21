import 'dart:core';
import 'incident_report.dart';

class Station
{
  final String id;
  final String name;
  final double latitude, longitude;
  final String lineName;
  List<IncidentReport> reports;

  factory Station.fromMap(Map<String, dynamic> map, String line)
  {
    return Station(
      id: '${map['stop_id']}_$line',
      name: map["stop_name"],
      latitude: double.parse(map["stop_lat"]),
      longitude: double.parse(map["stop_lon"]),
      lineName: line,

    );
  }

  factory Station.fromDB(Map<String, dynamic> map)
  {
    return Station(
      id: map["id"],
      name: map["name"],
      latitude: map["latitude"],
      longitude: map["longitude"],
      lineName: map["lineName"],

    );
  }

  Map<String, dynamic> toDB()
  {
    return {

      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'lineName': lineName,
    };
  }

  Station({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.lineName,
    reports,
  }) : reports = reports ?? List.empty(growable: true);

  void setReports(List<IncidentReport> reports)
  {
    this.reports = reports;
  }

}