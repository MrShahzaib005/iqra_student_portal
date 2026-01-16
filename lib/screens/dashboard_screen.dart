import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Get the current logged-in user
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Security Fallback: If no user is found, force logout
      return const Center(child: Text("Error: No user logged in"));
    }

    return Scaffold(
      // 2. Wrap the Body in a StreamBuilder to listen to Database changes
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          // Case A: Waiting for data (Show Loading)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Case B: Error
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // Case C: Data Received
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User data not found"));
          }

          // 3. Extract the Data Map
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final String fullName = userData['fullName'] ?? 'Student';
          final String department = userData['department'] ?? 'Department';

          // 4. Build the UI with Real Data
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // Top Bar
                  Row(
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: 35,
                        errorBuilder: (_, __, ___) => const Icon(Icons.school),
                      ),
                      const Spacer(),
                      const CircleAvatar(
                        // Placeholder image for now
                        backgroundImage: AssetImage('assets/profile.jpg'),
                        radius: 18,
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.notifications_outlined,
                          size: 28,
                        ),
                        onPressed: () {
                          // NEW LOGIC: Go to notifications screen
                          Navigator.pushNamed(context, '/notifications');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // --- REAL DYNAMIC DATA HERE ---
                  Text(
                    'Welcome, $fullName!', // <--- REAL NAME
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    department, // <--- REAL DEPARTMENT
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // -----------------------------
                  const SizedBox(height: 25),

                  // GRID MENU
                  // GRID MENU - CLEAN 2x2 LAYOUT
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2, // 2 Columns is cleaner for these cards
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.3, // Wider cards
                    children: [
                      _buildMenuButton(
                        context,
                        'My Courses',
                        Icons.menu_book_rounded,
                        Colors.indigo,
                        '/enrolled',
                      ),
                      _buildMenuButton(
                        context,
                        'Attendance',
                        Icons.fact_check_rounded,
                        Colors.teal,
                        '/attendance',
                      ),
                      _buildMenuButton(
                        context,
                        'Fee Voucher',
                        Icons.receipt_long_rounded,
                        Colors.orange,
                        '/fees',
                      ),
                      _buildMenuButton(
                        context,
                        'Transcript',
                        Icons.bar_chart_rounded,
                        Colors.purple,
                        '/passed-courses',
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Upcoming Classes Section (Static for now, can be dynamic later)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Upcoming Class',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/timetable'),
                        child: const Text('See All'),
                      ),
                    ],
                  ),

                  // Upcoming Class Card
                  Card(
                    elevation: 0,
                    color: Colors.grey[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.computer,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Database Systems',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Mon, 10:00 AM • Online',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1A237E),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          // Use pushReplacement to avoid building a huge stack of pages
          if (index == 1) Navigator.pushReplacementNamed(context, '/enrolled');
          if (index == 2) Navigator.pushReplacementNamed(context, '/profile');
          if (index == 3) Navigator.pushReplacementNamed(context, '/settings');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String? routeName,
  ) {
    return InkWell(
      onTap: () {
        if (routeName != null) Navigator.pushNamed(context, routeName);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
