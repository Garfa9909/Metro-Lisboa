import 'dart:io';

import 'package:cmproject/data/empty_data_source.dart';
import 'package:cmproject/live_location_module.dart';
import 'package:cmproject/data/http_metro_datasource.dart';
import 'package:cmproject/data/metro_repository.dart';
import 'package:cmproject/data/sqflite_metro_datasource.dart';
import 'package:cmproject/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cmproject/http/http_client.dart';

import 'connectivity_module.dart';
import 'data/generic_data_source.dart';
import 'http/my_http_overrides.dart';
import 'location_module.dart';

void main()
{
  HttpOverrides.global = MyHttpOverrides();
  GenericDataSource generic = EmptyDataSource();
  HttpMetroDataSource http = HttpMetroDataSource(client: HttpClient());
  SqfliteMetroDataSource sql = SqfliteMetroDataSource();
  LocationModule loc = LiveLocationModule();
  ConnectivityModule con = ConnectivityModule();
  runApp(MultiProvider(
    providers: [
      Provider<GenericDataSource>(create: (context){return generic;}),
      Provider<HttpMetroDataSource>(create: (context){return http;}),
      Provider<SqfliteMetroDataSource>(create: (context){return sql;}),
      Provider<LocationModule>(create: (context){return loc;}),
      Provider<ConnectivityModule>(create: (context){return con;}),
    ],
    child: const MyApp(),
  ),
  );

}

class MyApp extends StatefulWidget
{
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context)
  {
    MetroRepository repository = MetroRepository(httpSource: context.read<HttpMetroDataSource>(), sqfliteSource: context.read<SqfliteMetroDataSource>(), connectivityModule: context.read<ConnectivityModule>());

    return FutureBuilder(
        future: repository.sqfliteSource.init(),
        builder: (_, snapshot)
        {
          if(snapshot.connectionState == ConnectionState.done)
            {
              return MaterialApp(
                title: 'CharcaMetro NEO',
                home: MainPage(),
              );
            }
          else
            {
              return MaterialApp(
                home: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
        });

  }
}
