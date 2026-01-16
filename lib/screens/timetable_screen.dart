import 'package:flutter/material.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Mon, Tue, Wed, Thu, Fri
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Weekly Timetable', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
          bottom: const TabBar(
            isScrollable: true, // Allows scrolling if screen is narrow
            labelColor: Color(0xFF1A237E),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF1A237E),
            tabs: [
              Tab(text: 'MON'),
              Tab(text: 'TUE'),
              Tab(text: 'WED'),
              Tab(text: 'THU'),
              Tab(text: 'FRI'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _DaySchedule(day: 'Monday'),    // Content for Mon
            _DaySchedule(day: 'Tuesday'),   // Content for Tue
            _DaySchedule(day: 'Wednesday'), // Content for Wed
            _DaySchedule(day: 'Thursday'),  // Content for Thu
            _DaySchedule(day: 'Friday'),    // Content for Fri
          ],
        ),
      ),
    );
  }
}

// A Reusable Widget for the List of Classes
class _DaySchedule extends StatelessWidget {
  final String day;
  const _DaySchedule({required this.day});

  @override
  Widget build(BuildContext context) {
    // Mock Data: Different classes based on the day
    final List<Map<String, String>> classes = _getClassesForDay(day);

    if (classes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.weekend, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 10),
            Text('No classes on $day', style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final cls = classes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Time Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cls['time']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(cls['duration']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                // Class Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cls['subject']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A237E))),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(cls['room']!, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper to return fake data
  List<Map<String, String>> _getClassesForDay(String day) {
    if (day == 'Monday') {
      return [
        {'time': '09:00 AM', 'duration': '3 Hrs', 'subject': 'Software Engineering', 'room': 'Lab 4'},
        {'time': '01:00 PM', 'duration': '2 Hrs', 'subject': 'Technical Writing', 'room': 'Room 302'},
      ];
    } else if (day == 'Tuesday') {
      return [
        {'time': '11:00 AM', 'duration': '3 Hrs', 'subject': 'Database Systems', 'room': 'Lab 2'},
      ];
    } else if (day == 'Wednesday') {
      return [
        {'time': '09:00 AM', 'duration': '3 Hrs', 'subject': 'Linear Algebra', 'room': 'Room 105'},
        {'time': '02:00 PM', 'duration': '3 Hrs', 'subject': 'Web Development', 'room': 'Lab 1'},
      ];
    } else if (day == 'Thursday') {
      return [
        {'time': '10:00 AM', 'duration': '2 Hrs', 'subject': 'Islamic Studies', 'room': 'Room 201'},
      ];
    }
    return []; // Friday Off
  }
}