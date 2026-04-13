import 'package:cmproject/data/metro_repository.dart';
import 'package:cmproject/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main()
{
  MetroRepository repository = MetroRepository();
  runApp(Provider<MetroRepository>(
      create: (context){ return repository; }, child: const CharcaMetro())
  );
}

class CharcaMetro extends StatelessWidget
{
  const CharcaMetro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CharcaMetro NEO',
      home: MainPage(),
    );
  }
}
