import 'dart:convert';

import 'package:cmproject/http/http_client.dart';
import 'package:cmproject/data/metro_datasource.dart';
import 'package:cmproject/models/incident_report.dart';

import '../models/station.dart';

class HttpMetroDataSource extends MetroDataSource
{
  final HttpClient? _client;
  String token = "";
  final consumerKey="VkZMEg7gKHeiF9X62AZ8Qp_oWnMa";
  final consumerSecret="3fWpJ0Iffh8z0b89Th3M97mvQU4a";



  HttpMetroDataSource({HttpClient? client}) : _client = client;

  Future<String> getAccessToken() async
  {
    final encoded = base64Encode(utf8.encode("$consumerKey:$consumerSecret"));
    final response = await _client!.post(url: "https://api.metrolisboa.pt:8243/token",
        headers: {"Authorization": "Basic $encoded"},
        body: {"grant_type":"client_credentials",});
    if(response.statusCode == 405)
      {
        return "error";
      }
    final responseJSON = jsonDecode(response.body);
    return responseJSON["access_token"];
  }

  //Checks if access token is valid and if not, generates new one
  Future<void> checkToken() async
  {
    final response = await _client!.get(url: 'https://api.metrolisboa.pt:8243/estadoServicoML/1.0.1/infoEstacao/todos',
        headers: {'Authorization': 'Bearer $token'});

    //If token is null or expired, create new one
    if(response.statusCode == 401 || response.statusCode == 403)
    {
      token = await getAccessToken();
    }
  }

  @override
  Future<List<Station>> getAllStations() async
  {
    await checkToken();
    final response = await _client!.get(url: 'https://api.metrolisboa.pt:8243/estadoServicoML/1.0.1/infoEstacao/todos',
    headers: {'Authorization': 'Bearer $token'});

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

    await checkToken();
    final response = await _client!.get(url: 'https://api.metrolisboa.pt:8243/estadoServicoML/1.0.1/infoEstacao/$stationId',
        headers: {'Authorization': 'Bearer $token'});

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
  Future<void> insertStation(Station station)
  {
    throw Exception("Unavailable");
  }
}