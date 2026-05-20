import 'dart:core';
import 'incident_report.dart';

class Station
{
  final String id;
  final String name;
  final double latitude, longitude;
  final String lineName;
  final List<IncidentReport> reports;

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

  Station({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.lineName,
    reports,
  }) : reports = reports ?? List.empty(growable: true);



  void attachIncident(IncidentReport incident)
  {
    reports.add(incident);
  }
}