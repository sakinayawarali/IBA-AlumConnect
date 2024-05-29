import 'package:flutter/material.dart';
import 'package:devproj/theme/app_colours.dart';

class ViewEventsScreen extends StatelessWidget {
  final List<Event> events = [
    Event(
      title: 'Fundraising Gala',
      date: 'June 15, 2024',
      location: 'Grand Hotel Ballroom',
      description:
          'Join us for a glamorous evening of fundraising to support student scholarships.',
    ),
    Event(
      title: 'Tech Start-up Summit',
      date: 'July 5, 2024',
      location: 'Convention Center',
      description:
          'A gathering of tech enthusiasts and entrepreneurs to share ideas and innovations.',
    ),
    // Add more events as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Events'),
        backgroundColor: AppColors.darkGrey,
      ),
      backgroundColor: AppColors.darkGrey,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upcoming Events',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return _buildEventCard(events[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    return Card(
      color: Colors.white.withOpacity(0.3),
      margin: EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Date: ${event.date}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Location: ${event.location}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              event.description,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Event {
  final String title;
  final String date;
  final String location;
  final String description;

  Event({
    required this.title,
    required this.date,
    required this.location,
    required this.description,
  });
}
