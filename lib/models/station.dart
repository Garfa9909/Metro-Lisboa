import 'dart:core';

import 'Line.dart';
import 'incident_report.dart';

class Station
{
  final String id;
  final String name;
  final double latitude, longitude;
  final Line line1;
  final Line? line2;  //Only some stations have 2 lines
  final List<IncidentReport> reports = List.empty(growable: true);

  Station(this.id, this.name, this.latitude, this.longitude, this.line1, this.line2);

  void attachIncicent(IncidentReport incident)
  {
    reports.add(incident);
  }
}