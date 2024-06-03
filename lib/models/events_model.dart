import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String type;
  String participants;
  String title;
  DateTime date;
  String location;
  String description;

  Event({
    required this.type,
    required this.participants,
    required this.title,
    required this.date,
    required this.location,
    required this.description,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      type: map['type'],
      participants: map['participants'],
      title: map['title'],
      date: (map['date'] as Timestamp).toDate(),
      location: map['location'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'participants': participants,
      'title': title,
      'date': date,
      'location': location,
      'description': description,
    };
  }
}
