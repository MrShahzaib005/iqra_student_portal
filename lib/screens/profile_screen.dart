import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Get Current User
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("No User Logged In")));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('MY PROFILE', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset('assets/logo.png', width: 100),
          ),
        ],
      ),
      // 2. Listen to Database
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          // Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error State
          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Error fetching profile"));
          }

          // 3. Extract Real Data
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final String fullName = data['fullName'] ?? 'N/A';
          final String studentId = data['studentId'] ?? 'N/A';
          final String email = data['email'] ?? 'N/A';
          final String semester = data['semester'] ?? 'N/A';
          // Note: We didn't ask for Phone in Signup, so we handle it gracefully
          final String phone = data['phone'] ?? 'Not provided';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Profile Pic
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/profile.jpg'),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                          onPressed: () {
                            // Feature for later: Upload Photo to Firebase Storage
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Photo Upload coming soon!'))
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 10),
                  Text(
                    'Welcome, $fullName!', // <--- REAL NAME
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    studentId, // <--- REAL ID
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  // Personal Information Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Personal Information',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Info Card with REAL DATA
                  Card(
                    elevation: 2,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        _buildReadOnlyTile('Full Name', fullName),
                        _buildReadOnlyTile('Student ID', studentId),
                        _buildReadOnlyTile('University Email', email),
                        _buildReadOnlyTile('Phone Number', phone), // Handles missing data
                        _buildReadOnlyTile('Current Semester', semester),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      
      // Bottom Navigation (Stays Standard)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, 
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1A237E),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 0) Navigator.pushNamed(context, '/dashboard');
          if (index == 1) Navigator.pushNamed(context, '/enrolled');
          if (index == 3) Navigator.pushNamed(context, '/settings');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildReadOnlyTile(String title, String value) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      trailing: Text(
        value,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}