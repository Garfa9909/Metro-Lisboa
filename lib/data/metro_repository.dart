import 'package:cmproject/models/incident_report.dart';
import 'package:cmproject/models/station.dart';

import '../pages/Line.dart';

class MetroRepository
{
  List<Station> stations = [Station(id: "or", name: "Oriente", latitude:38.76772137189328, longitude:-9.09880630030998, lineName:"Red",),
    Station(id:"cais", name:"Cais do Sodré", latitude:38.706536481524, longitude:-9.14345375711721, lineName:"Green"),
    Station(id:"cg", name:"Campo Grande", latitude:38.7603439284084, longitude:-9.157692828750722, lineName:"Yellow"),];

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