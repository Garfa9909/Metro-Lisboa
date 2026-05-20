import 'dart:io';

import 'package:cmproject/data/http_metro_datasource.dart';
import 'package:cmproject/data/metro_repository.dart';
import 'package:cmproject/data/sqflite_metro_datasource.dart';
import 'package:cmproject/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cmproject/http/http_client.dart';

import 'http/my_http_overrides.dart';

void main()
{
  HttpOverrides.global = MyHttpOverrides();
  MetroRepository repository = MetroRepository(httpSource: HttpMetroDataSource(client: HttpClient()), sqfliteSource: SqfliteMetroDataSource());
  runApp(Provider<MetroRepository>(
      create: (context){ return repository; }, child: const MyApp())
  );
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CharcaMetro NEO',
      home: MainPage(),
    );
  }
}
