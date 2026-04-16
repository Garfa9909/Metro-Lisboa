import 'package:cmproject/data/metro_repository.dart';
import 'package:cmproject/pages/details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'line.dart';
import '../models/station.dart';
import '/pages/pages.dart';

class ListPage extends StatefulWidget
{
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Station> searchResults = List.empty(growable: true);
  String _search = "";

  @override
  Widget build(BuildContext context)
  {
    MetroRepository repository = context.read<MetroRepository>();
    updateResults(repository);

    return Scaffold(
      key: ValueKey("list-screen"),
        appBar: AppBar(title: Text(pages[1].title),
          titleTextStyle: TextStyle(fontSize: 30, color: Colors.white),
          backgroundColor: Colors.black,
          toolbarHeight: 70),
        body:
            Padding(
              padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SearchBar(
                      hintText: "Type to search",
                      onChanged:(value){
                        setState(() {
                          _search = value;
                        });
                        },
                    ),
                    SizedBox(height: 30,),
                    SingleChildScrollView(
                      child: SizedBox(
                        height:MediaQuery.of(context).size.height*0.55,
                        child: ListView(
                          key:ValueKey("list-view"),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: searchResults.map( (station) => stationEntry(station) ).toList()

                        ),
                      ),
                    ),
                  ],
                ),
            )
          ,


    );
  }

  Widget stationEntry(Station station)
  {
    return ListTile(title: stationButton(station));
  }

  Widget stationButton(Station station)
  {
    return TextButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailsPage(stationId: station.id))
          );
        },
        style: TextButton.styleFrom(backgroundColor: Colors.black,),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(station.name, style: TextStyle(fontSize: 20, color: Colors.white),),
            SizedBox(width: 20,),
            lineDisplay(Line.getByName(station.lineName)),
          ],
        ));
  }

  Widget lineDisplay(Line? line)
  {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: line?.color, // Fill color
            shape: BoxShape.circle,
            border: BoxBorder.fromBorderSide(BorderSide(
              color: Colors.white,
              width: 3.0,)
            )
          ),
        ),
        Text("Linha ${line!.name}", style: TextStyle(fontSize: 15, color: Colors.white),)
      ],
    );
  }

  void updateResults(MetroRepository repository)
  {
    searchResults = List.empty(growable:true);
    for(Station station in repository.getAllStations())
      {
        if(station.name.toLowerCase().contains(_search))
          {
            searchResults.add(station);
          }
      }
  }
}