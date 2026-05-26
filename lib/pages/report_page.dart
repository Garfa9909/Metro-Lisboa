import 'package:cmproject/data/metro_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../connectivity_module.dart';
import '../data/http_metro_datasource.dart';
import '../data/sqflite_metro_datasource.dart';
import '../models/incident_report.dart';
import '../models/station.dart';
import '/pages/pages.dart';
import 'package:testable_form_field/testable_form_field.dart';

class ReportPage extends StatefulWidget
{
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage>
{
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late Station _station;
  late IncidentType _incidentType;
  late int _rating;
  late DateTime _dateTime;
  String  _notes = "";


  @override
  Widget build(BuildContext context)
  {
    MetroRepository repository = MetroRepository(httpSource: context.read<HttpMetroDataSource>(), sqfliteSource: context.read<SqfliteMetroDataSource>(), connectivityModule: context.read<ConnectivityModule>());

    return Scaffold(
      key: ValueKey("incidents-report-screen"),
      appBar: AppBar(
        title: Text(pages[3].title),
        titleTextStyle: TextStyle(fontSize: 30, color: Colors.white),
        backgroundColor: Colors.black,
        toolbarHeight: 70,
      ),
      body: FutureBuilder(
        future: repository.getAllStations(),
        builder: (_, snapshot)
        {
          if(snapshot.connectionState != ConnectionState.done)
          {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          else
          {
            if(snapshot.hasError)
            {
              return Center(
                child: Text("Error"),
              );
            }

            else
            {
              return buildForm(snapshot.data!, repository.attachIncident);
            }
          }
        },
      ),
    );
  }

  Widget buildForm(List<Station> stations, Function submit)
  {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              buildStationSelect(stations),

              SizedBox(height: 20),

              buildIncidentTypeSelect(IncidentType.values),

              SizedBox(height: 20),

              buildRatingSelect(),

              SizedBox(height: 20),

              buildDateTimeSelect(),

              SizedBox(height: 20),

              buildNotesField(),

              SizedBox(height: 20),

              ElevatedButton(
                key: ValueKey("incident-form-submit-button"),
                onPressed: () => submitForm(submit),
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FormField<Station> buildStationSelect(List<Station> options)
  {
    return TestableFormField<Station>(
      key:ValueKey("incident-station-selection-field"),
      getValue: () => _station,
      internalSetValue: (state, value)
      {
        _station = value;
        state.didChange(value);
      },
      validator: (value){
        if(value == null)
          {
            return "Preencha a estação";
          }
        return null;
      },
      onSaved: (value)
      {
        _station = value!;
      },

      builder: (field)
      {
        return DropdownButtonFormField(
            items: options.map((option) => DropdownMenuItem(
              value: option,
              child: Text("${option.name} - ${option.lineName}"),
            )).toList(),
            decoration: InputDecoration(
              labelText: "Station",
              errorText: field.errorText,
            ),
            onChanged: (value)
        {
          field.didChange(value);
        });
      },
    );
  }

  FormField<IncidentType> buildIncidentTypeSelect(List<IncidentType> options)
  {
    return TestableFormField<IncidentType>(
      key:ValueKey("incident-type-selection-field"),
      getValue: () => _incidentType,
      internalSetValue: (state, value)
      {
        _incidentType = value;
        state.didChange(value);
      },
      validator: (value){
        if(value == null)
        {
          return "Preencha o tipo de incidente";
        }
        return null;
      },
      onSaved: (value)
      {
        _incidentType = value!;
      },

      builder: (field)
      {
        return DropdownButtonFormField(
            items: options.map((option) => DropdownMenuItem(
              value: option,
              child: Text(option.displayName),
            )).toList(),
            decoration: InputDecoration(
              labelText: "Incident Type",
              errorText: field.errorText,
            ),
            onChanged: (value)
            {
              field.didChange(value);
            });
      },
    );
  }

  FormField<int> buildRatingSelect()
  {
    return TestableFormField<int>(
      key:ValueKey("incident-rating-field"),
      getValue: () => _rating,
      internalSetValue: (state, value)
      {
        _rating = value;
        state.didChange(value);
      },
      validator: (value){
        if(value == null)
        {
          return "Preencha a avaliação";
        }
        else if(value < 1 || value > 5)
        {
          return "Rating must be between 1 and 5";
        }
        return null;
      },
      onSaved: (value)
      {
        _rating = value!;
      },

      builder: (field)
      {
        return TextField(
            decoration: InputDecoration(
              labelText: "Rating",
              errorText: field.errorText,
            ),
            onChanged: (value)
            {
              final parsed = int.tryParse(value);
              field.didChange(parsed);
            });
      },
    );
  }

  FormField<DateTime> buildDateTimeSelect()
  {
    return TestableFormField<DateTime>(
      key:ValueKey("incident-datetime-field"),
      getValue: () => _dateTime,
      internalSetValue: (state, value)
      {
        _dateTime = value;
        state.didChange(value);
      },
      validator: (value){
        if(value == null)
        {
          return "Preencha a data e hora";
        }
        return null;
      },
      onSaved: (value)
      {
        _dateTime = value!;
      },

      builder: (field)
      {
        return TextField(
            decoration: InputDecoration(
              labelText: "Date and time",
              errorText: field.errorText,
            ),
            onChanged: (value)
            {
              final parsed = DateTime.tryParse(value);
              field.didChange(parsed);
            });
      },
    );
  }

  FormField<String> buildNotesField()
  {
    return TestableFormField<String>(
      key:ValueKey("incident-notes-field"),
      getValue: () => _notes,
      internalSetValue: (state, value)
      {
        _notes = value;
        state.didChange(value);
      },
      onSaved: (value)
      {
        if(value != null)
          {
            _notes = value;
          }
          else
          {
            _notes = "";
          }
      },

      builder: (field)
      {
        return TextFormField(
            decoration: InputDecoration(
              labelText: "Notes",
              errorText: field.errorText,
            ),
            onChanged: (value)
            {
              field.didChange(value);
            });
      },
    );
  }
  
  void submitForm(Function submit)
  {
    if (_formKey.currentState!.validate())
    {
      _formKey.currentState!.save();
      IncidentReport report = IncidentReport(timestamp:_dateTime, rate:_rating, type:_incidentType,notes: _notes);
      Station station = _station;
      submit(station.id, report); //Calls repository.attachIncident
      _formKey.currentState?.reset();
    }
  }
}