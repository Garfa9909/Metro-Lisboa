import 'package:cmproject/models/incident_report.dart';
import 'package:cmproject/models/station.dart';

class MetroRepository
{
  List<Station> stations = List.empty(growable: true);

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