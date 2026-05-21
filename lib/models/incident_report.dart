enum IncidentType
{
  Escalator('Escalator'),
  Elevator('Elevator'),
  TicketMachine('Ticket Machine'),
  Turnstile('Turnstile'),
  Other('Other');

  final String displayName;

  const IncidentType(this.displayName);
}

class IncidentReport
{

  final DateTime timestamp;
  final int rate;
  final String? notes;
  final IncidentType type;

  factory IncidentReport.fromDB(Map<String, dynamic> map)
  {
    return IncidentReport(
      timestamp: DateTime.parse(map["timestamp"]),
      rate: map["rate"],
      notes: map["notes"],
      type: IncidentType.values.firstWhere(
            (e) => e.name == map['type'],
      ),

    );
  }

  Map<String, dynamic> toDB(String stationId)
  {
    return
      {
      'stationId': stationId,
      'timestamp': timestamp.toString(),
      'rate': rate,
      'notes': notes,
      'type': type.name,
    };
  }

  IncidentReport({
    required this.timestamp,
    required this.rate,
    required this.type,
    this.notes});

}
