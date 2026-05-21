import 'dart:convert';

import 'package:cmproject/http/http_client.dart';
import 'package:cmproject/data/metro_datasource.dart';
import 'package:cmproject/models/incident_report.dart';

import '../models/station.dart';

class HttpMetroDataSource extends MetroDataSource
{
  final HttpClient? _client;
  final key = "a5855068-66f3-3d26-8b3e-7c692a9e195c";

  HttpMetroDataSource({HttpClient? client}) : _client = client;

  @override
  Future<List<Station>> getAllStations() async
  {
    final response = await _client!.get(url: 'https://api.metrolisboa.pt:8243/estadoServicoML/1.0.1/infoEstacao/todos',
    headers: {'Authorization': 'Bearer $key'});

    if(response.statusCode == 200)
    {
      final responseJSON = jsonDecode(response.body);
      List stationsJSON = responseJSON['resposta'];


      List<Station> stations = [];

      for(final st in stationsJSON)
      {
        //Converting the sting to a list of lines
        List<dynamic> linesJson = st['linha'].replaceAll('[', '').replaceAll(']', '').split(',').map((e) => e.trim()).toList();
        final List<String> linesStr = List<String>.from(linesJson);
        for(String line in linesStr) //Stations with 2 lines are added twice
        {
          stations.add(Station.fromMap(st, line,),);
        }
      }

      return stations;
    }

    else
    {
      throw Exception("Status code: ${response.statusCode}");
    }
  }

  @override
  Future<void> attachIncident(String id, IncidentReport report)
  {
    throw UnimplementedError();
  }

  @override
  Future<Station> getStationDetail(String id) async
  {
    final stationId = id.split('_')[0];
    final line = id.split('_')[1];  //The id we receive has the station ID and the line, separated by a _

    final response = await _client!.get(url: 'https://api.metrolisboa.pt:8243/estadoServicoML/1.0.1/infoEstacao/$stationId',
        headers: {'Authorization': 'Bearer $key'});

    if(response.statusCode == 200)
    {
      final responseJSON = jsonDecode(response.body);
      List stationsJSON = responseJSON['resposta'];

      Station station = Station.fromMap(stationsJSON[0], line);
      return station;
    }

    else
    {
      throw Exception("Status code: ${response.statusCode}");
    }
  }

  @override
  Future<List<Station>> getStationsByName(String name) async
  {
    List<Station> allStations = await getAllStations();
    List<Station> stations = List.empty(growable: true);
    for(Station station in allStations)
    {
      if(station.name == name)
      {
        stations.add(station);
      }
    }

    return stations;
  }

  @override
  Future<void> insertStation(Station station) {
    // TODO: implement insertStation
    throw UnimplementedError();
  }
}