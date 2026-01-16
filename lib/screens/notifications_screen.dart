import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Class Cancelled',
        'message': 'The Software Engineering class scheduled for 09:00 AM today has been cancelled.',
        'time': '10 mins ago',
        'type': 'alert', // red
      },
      {
        'title': 'Assignment Due Soon',
        'message': 'Reminder: Technical Writing assignment is due tomorrow at 11:59 PM.',
        'time': '2 hours ago',
        'type': 'warning', // orange
      },
      {
        'title': 'Fee Challan Generated',
        'message': 'Your fee voucher for Spring 2026 is now available for download.',
        'time': '1 day ago',
        'type': 'info', // blue
      },
      {
        'title': 'Sports Week Registration',
        'message': 'Registration for the Inter-Department Football tournament is now open!',
        'time': '2 days ago',
        'type': 'success', // green
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = notifications[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            leading: _buildIcon(item['type']),
            title: Text(
              item['title'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(item['message'], style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                const SizedBox(height: 6),
                Text(item['time'], style: TextStyle(color: Colors.grey[400], fontSize: 11)),
              ],
            ),
            isThreeLine: true,
          );
        },
      ),
    );
  }

  Widget _buildIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'alert':
        icon = Icons.error_outline;
        color = Colors.red;
        break;
      case 'warning':
        icon = Icons.warning_amber_rounded;
        color = Colors.orange;
        break;
      case 'success':
        icon = Icons.check_circle_outline;
        color = Colors.green;
        break;
      case 'info':
      default:
        icon = Icons.info_outline;
        color = Colors.blue;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}