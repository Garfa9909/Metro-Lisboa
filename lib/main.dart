import 'dart:io';

import 'package:cmproject/data/http_metro_datasource.dart';
import 'package:cmproject/data/metro_repository.dart';
import 'package:cmproject/data/sqflite_metro_datasource.dart';
import 'package:cmproject/pages/main_page.dart';
import 'package:cmproject/services/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cmproject/http/http_client.dart';

import 'http/my_http_overrides.dart';

void main()
{
  HttpOverrides.global = MyHttpOverrides();
  MetroRepository repository = MetroRepository(httpSource: HttpMetroDataSource(client: HttpClient()), sqfliteSource: SqfliteMetroDataSource(), connectivityService: ConnectivityService());
  runApp(Provider<MetroRepository>(
      create: (context){ return repository; }, child: const MyApp())
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
    final MetroRepository repository = context.read<MetroRepository>();
    
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
