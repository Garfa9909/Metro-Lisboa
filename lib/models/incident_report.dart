enum IncidentType
{
  escalator('Escalator'),
  elevator('Elevator'),
  ticketMachine('Ticket Machine'),
  turnstile('Turnstile'),
  other('Other');

  final String displayName;

  const IncidentType(this.displayName);
}

class IncidentReport
{

  final DateTime timestamp;
  final int rate;
  final String? notes;
  final IncidentType type;

  IncidentReport(this.timestamp, this.rate, this.type, this.notes);

}
