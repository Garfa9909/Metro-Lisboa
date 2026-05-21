import 'package:cmproject/data/metro_datasource.dart';
import 'package:cmproject/models/incident_report.dart';
import 'package:cmproject/models/station.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteMetroDataSource extends MetroDataSource
{
  Database? _database;

  Future<void> init() async
  {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'metro.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE station('
              'id TEXT PRIMARY KEY,'
              'name TEXT,'
              'latitude DOUBLE,'
              'longitude DOUBLE,'
              'lineName TEXT)'
        );

        await db.execute(
            '''
          CREATE TABLE incident(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            stationId TEXT,
            timestamp TEXT,
            rate INTEGER,
            notes TEXT,
            type TEXT,
        
            FOREIGN KEY(stationId) REFERENCES stations(id)
          )
          '''
        );
      },
      version:1,
    );
  }

  @override
  Future<void> attachIncident(String id, IncidentReport report) async
  {
    if(_database == null)
    {
      throw Exception("Database not initialized");
    }

    await _database!.insert('incident', report.toDB(id));
  }

  @override
  Future<List<Station>> getAllStations() async
  {
    if(_database == null)
    {
      throw Exception("Database not initialized");
    }

    List result = await _database!.rawQuery("SELECT * FROM station");
    return result.map((entry) => Station.fromDB(entry)).toList();
  }

  @override
  Future<Station> getStationDetail(String id) async
  {
    Station station;
    if(_database == null)
    {
      throw Exception("Database not initialized");
    }
    List result = await _database!.rawQuery("SELECT * FROM station WHERE id = ?", [id]);
    if(result.isNotEmpty)
    {
      return Station.fromDB(result.first);
    }
    else
    {
      throw Exception("Station doesn't exist");
    }


  }

  @override
  Future<List<Station>> getStationsByName(String name) async
  {
    if(_database == null)
    {
      throw Exception("Database not initialized");
    }
    List result = await _database!.rawQuery("SELECT * FROM station WHERE name = ?", [name]);
    return result.map((entry) => Station.fromDB(entry)).toList();
  }

  @override
  Future<void> insertStation(Station station) async
  {
    if(_database == null)
    {
      throw Exception("Database not initialized");
    }

    await _database!.insert('station', station.toDB());
  }

  //Deletes stations and saves new ones
  Future<void> saveStations(List<Station> stations) async
  {
    await deleteStations();

    for(Station station in stations)
    {
      await insertStation(station);
    }

  }

  Future<List<IncidentReport>> getStationIncidents(String id) async
  {
    if(_database == null)
    {
      throw Exception("Database not initialized");
    }
    List result = await _database!.rawQuery("SELECT * FROM incident WHERE stationId = ?", [id]);
    return result.map((entry) => IncidentReport.fromDB(entry)).toList();
  }

  Future<void> deleteStations() async
  {
    if(_database == null)
    {
      throw Exception("Database not initialized");
    }
    await _database!.rawQuery("DELETE FROM station");
  }

}