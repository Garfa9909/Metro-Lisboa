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

  IncidentReport({
    required this.timestamp,
    required this.rate,
    required this.type,
    this.notes});

}
