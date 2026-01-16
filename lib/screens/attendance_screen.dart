import 'package:flutter/material.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data for Prototype
    final List<Map<String, dynamic>> attendanceData = [
      {
        'subject': 'Software Engineering',
        'code': 'SE-301',
        'total': 26,
        'present': 24,
        'percentage': 0.92,
        'status': 'Safe'
      },
      {
        'subject': 'Database Systems',
        'code': 'CS-201',
        'total': 26,
        'present': 20,
        'percentage': 0.76,
        'status': 'Warning'
      },
      {
        'subject': 'Linear Algebra',
        'code': 'MATH-201',
        'total': 12,
        'present': 12,
        'percentage': 1.0,
        'status': 'Safe'
      },
      {
        'subject': 'Technical Writing',
        'code': 'ENG-205',
        'total': 26,
        'present': 18,
        'percentage': 0.69,
        'status': 'Danger' // Below 70% usually means trouble
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: attendanceData.length,
        itemBuilder: (context, index) {
          final course = attendanceData[index];
          return _buildAttendanceCard(
            course['subject'],
            course['code'],
            course['present'],
            course['total'],
            course['percentage'],
            course['status'],
          );
        },
      ),
    );
  }

  Widget _buildAttendanceCard(
      String subject, String code, int present, int total, double percent, String status) {
    
    // Color Logic
    Color statusColor = Colors.green;
    if (status == 'Warning') statusColor = Colors.orange;
    if (status == 'Danger') statusColor = Colors.red;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subject, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(code, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            
            // Progress Bar
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: percent,
                    backgroundColor: Colors.grey[200],
                    color: statusColor,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  '${(percent * 100).toInt()}%',
                  style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Attended: $present/$total', style: const TextStyle(color: Colors.grey)),
                Text('Skips Left: ${4 - (total - present)}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}