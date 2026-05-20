import 'dart:convert';

import 'package:cmproject/http/http_client.dart';
import 'package:cmproject/data/metro_datasource.dart';
import 'package:cmproject/models/incident_report.dart';

import '../models/station.dart';

class HttpMetroDataSource extends MetroDataSource
{
  final HttpClient _client;

  HttpMetroDataSource({required HttpClient client}) : _client = client;

  @override
  Future<List<Station>> getAllStations() async
  {
    final response = await _client.get(url: 'https://api.metrolisboa.pt:8243/estadoServicoML/1.0.1/infoEstacao/todos',
    headers: {'Authorization': 'Bearer e8a60f7f-8667-3525-97fe-b9435b82534b'});

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
  Future<void> attachIncident(String id, IncidentReport report) {
    // TODO: implement attachIncident
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
}