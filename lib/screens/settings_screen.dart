import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State for toggles
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _darkModeEnabled = false;

  // Logout Logic
  Future<void> _logout() async {
    // 1. Sign out from Firebase
    await FirebaseAuth.instance.signOut();
    
    if (mounted) {
      // 2. Clear history and go to Login
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  // --- LOGIC: CHANGE PASSWORD ---
  Future<void> _changePassword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      // Send reset email to current user
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset link sent to ${user.email}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  // Dummy Message for Some Features
  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature is coming in the next update!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1.ACCOUNT
          _buildSectionHeader('Account Security'),
          _buildSettingsTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: _changePassword, // Logic Created above
          ),
          _buildSwitchTile(
            icon: Icons.fingerprint,
            title: 'Biometric Login',
            subtitle: 'Use FaceID or Fingerprint',
            value: _biometricEnabled,
            onChanged: (val) {
              setState(() => _biometricEnabled = val);
              _showComingSoon("Biometric Login");
            },
          ),
          _buildSettingsTile(
            icon: Icons.shield_outlined,
            title: 'Two-Factor Authentication',
            trailingText: 'Off',
            onTap: () => _showComingSoon("2FA"),
          ),

          const SizedBox(height: 20),

          // SECTION 2: PREFERENCES
          _buildSectionHeader('Preferences'),
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            value: _notificationsEnabled,
            onChanged: (val) => setState(() => _notificationsEnabled = val),
          ),
          _buildSwitchTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            value: _darkModeEnabled,
            onChanged: (val) {
              setState(() => _darkModeEnabled = val);
              // We just toggle the switch visually, but warn the user it does nothing yet
              if (val) _showComingSoon("Dark Mode"); 
            },
          ),
           _buildSettingsTile(
            icon: Icons.language,
            title: 'Language',
            trailingText: 'English',
            onTap: () => _showComingSoon("Language selection"),
          ),

          const SizedBox(height: 20),

          // SECTION 3: SUPPORT
          _buildSectionHeader('Support'),
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: 'Help Center & FAQ',
            onTap: () => _showComingSoon("Help Center"),
          ),
          _buildSettingsTile(
            icon: Icons.bug_report_outlined,
            title: 'Report a Bug',
            onTap: () => _showComingSoon("Bug Reporting"),
          ),
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () => _showComingSoon("Privacy Policy"),
          ),

          const SizedBox(height: 30),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[50], 
                foregroundColor: Colors.red, 
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _logout, // Logout Logic created above
              child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
      
      // Bottom Navbar 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3, 
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1A237E),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/dashboard');
          if (index == 1) Navigator.pushReplacementNamed(context, '/enrolled');
          if (index == 2) Navigator.pushReplacementNamed(context, '/profile');
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

  // Widget Builders

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingText != null) 
              Text(trailingText, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            if (trailingText != null) const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: SwitchListTile(
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }
}