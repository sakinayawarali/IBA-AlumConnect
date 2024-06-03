import 'package:devproj/theme/app_colours.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:devproj/models/events_model.dart'; 

class MyCalendar extends StatefulWidget {
  const MyCalendar({Key? key}) : super(key: key);
  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  late Map<DateTime, List<Event>> selectedEvents;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectedEvents = {};
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('events').get();
    setState(() {
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Event event = Event.fromMap(data);
        DateTime eventDate = (data['date'] as Timestamp).toDate();
        if (selectedEvents[eventDate] == null) selectedEvents[eventDate] = [];
        selectedEvents[eventDate]?.add(event);
      }
    });
  }

  List<Event> _getEventsFromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2021, 1, 1),
              lastDay: DateTime.utc(2024, 12, 31),
              focusedDay: focusedDay,
              selectedDayPredicate: (day) => isSameDay(selectedDay, day),
              calendarFormat: CalendarFormat.month,
              eventLoader: _getEventsFromDay,
              calendarStyle: CalendarStyle(
                markerDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  this.selectedDay = selectedDay;
                  this.focusedDay = focusedDay; // update focusedDay
                });
              },
            ),
            SizedBox(height: 20.0),
            ..._getEventsFromDay(selectedDay).map(
              (event) => ListTile(
                title: Text(event.title),
                subtitle: Text(
                    '${event.date}\n${event.location}\n${event.description}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewEventsScreen extends StatelessWidget {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Events'),
        backgroundColor: AppColors.mediumTeal,
      ),
      body: MyCalendar(),
    );
  }
}
