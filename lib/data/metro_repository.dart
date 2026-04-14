import 'package:cmproject/models/incident_report.dart';
import 'package:cmproject/models/station.dart';

import '../pages/Line.dart';

class MetroRepository
{
  List<Station> stations = [Station("or", "Oriente", 38.76772137189328, -9.09880630030998, "Red",),
    Station("cais", "Cais do Sodré", 38.706536481524, -9.14345375711721, "Green"),
    Station("cg", "Campo Grande", 38.7603439284084, -9.157692828750722, "Yellow"),];

  Station? getStationDetail(String? id)
  {
    Station? res;

    for(Station station in stations)
    {
      if(station.id == id)  res = station;
    }

    return res;
  }

  List<Station> getAllStations()
  {
    return stations;
  }

  void attachIncident(String id, IncidentReport report)
  {
    getStationDetail(id)?.attachIncident(report);
  }

  void insertStation(Station station)
  {
    stations.add(station);
  }

  List<Station> getStationsByName(String name)
  {
    List<Station> res = List.empty(growable: true);
    for(Station station in stations)
    {
      if(station.name == name)
      {
        res.add(station);
      }
    }

    return res;
  }
}