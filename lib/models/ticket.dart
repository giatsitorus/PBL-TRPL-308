import 'dart:ffi';

class Ticket {
  final String subject;
  final String description;
  final String state;
  final String user_id;
  final String create_date;
  Ticket(this.subject, this.description, this.state, this.user_id, this.create_date);
}