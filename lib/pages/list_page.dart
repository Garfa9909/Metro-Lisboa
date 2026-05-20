import 'package:cmproject/data/metro_repository.dart';
import 'package:cmproject/pages/details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'line.dart';
import '../models/station.dart';
import '/pages/pages.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  String _search = "";

  late Future<List<Station>> stationsFuture;

  @override
  void initState() {
    super.initState();

    final repository = context.read<MetroRepository>();
    stationsFuture = repository.getAllStations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey("list-screen"),
      appBar: AppBar(
        title: Text(pages[1].title),
        titleTextStyle: TextStyle(fontSize: 30, color: Colors.white),
        backgroundColor: Colors.black,
        toolbarHeight: 70,
      ),
      body: FutureBuilder<List<Station>>(
        future: stationsFuture,
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final stations = snapshot.data ?? [];

          return buildList(stations);
        },
      ),
    );
  }

  Widget buildList(List<Station> stations) {

    final searchResults = stations.where((station) {
      return station.name
          .toLowerCase()
          .contains(_search.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SearchBar(
            hintText: "Type to search",
            onChanged: (value) {
              setState(() {
                _search = value;
              });
            },
          ),
          SizedBox(height: 30),
          Expanded(
            child: ListView(
              key: ValueKey("list-view"),
              children: searchResults
                  .map((station) => stationEntry(station))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget stationEntry(Station station) {
    return ListTile(
      title: stationButton(station),
    );
  }

  Widget stationButton(Station station) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailsPage(stationId: station.id),
          ),
        );
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            station.name,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(width: 20),
          lineDisplay(Line.getByName(station.lineName)),
        ],
      ),
    );
  }

  Widget lineDisplay(Line? line) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: line?.color,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3.0,
            ),
          ),
        ),
        Text(
          "Linha ${line!.name}",
          style: TextStyle(fontSize: 15, color: Colors.white),
        )
      ],
    );
  }
}