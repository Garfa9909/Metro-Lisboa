import 'dart:core';

import '../pages/Line.dart';
import 'incident_report.dart';

class Station
{
  final String id;
  final String name;
  final double latitude, longitude;
  final String lineName;
  final List<IncidentReport> reports = List.empty(growable: true);

  Station(this.id, this.name, this.latitude, this.longitude, this.lineName);

  void attachIncident(IncidentReport incident)
  {
    reports.add(incident);
  }
}