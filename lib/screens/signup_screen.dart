import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controllers
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Dropdown Selections
  String? _selectedDepartment;
  String? _selectedSemester;

  // Loading State
  bool _isLoading = false;

  final List<String> _departments = [
    'Computer Science', 'Software Engineering', 'Business Administration', 
    'Artificial Intelligence', 'Media Science'
  ];

  final List<String> _semesters = [
    '1st Semester', '2nd Semester', '3rd Semester', '4th Semester',
    '5th Semester', '6th Semester', '7th Semester', '8th Semester'
  ];

  // --- THE BACKEND LOGIC ---
  Future<void> _signUp() async {
    // 1. Basic Validation
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match!')));
      return;
    }
    if (_selectedDepartment == null || _selectedSemester == null || _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Create User in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 3. Save Student Details to Firestore
      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'fullName': _nameController.text.trim(),
        'studentId': _idController.text.trim(),
        'email': _emailController.text.trim(),
        'department': _selectedDepartment,
        'semester': _selectedSemester,
        'role': 'student',
        'createdAt': DateTime.now(),
      });

      // 4. NEW LOGIC: Force Logout immediately so they must login manually
      await FirebaseAuth.instance.signOut();

      if (mounted) {
        // Show Green Success Message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully! Please Log In.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Navigate back to Login Screen
        Navigator.pop(context);
      }

    } on FirebaseAuthException catch (e) {
      String message = "An error occurred";
      if (e.code == 'weak-password') message = "The password is too weak.";
      if (e.code == 'email-already-in-use') message = "An account already exists for that email.";
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/logo.png', height: 80, errorBuilder: (_, __, ___) => const Icon(Icons.school, size: 80, color: Colors.blue)),
              const SizedBox(height: 20),
              const Text('SIGN UP', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),

              _buildTextField(Icons.person_outline, 'Full Name', _nameController),
              const SizedBox(height: 16),
              _buildTextField(Icons.badge_outlined, 'Student ID (e.g. SP-2024-007)', _idController),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                initialValue: _selectedDepartment,
                decoration: _inputDecoration(Icons.domain, 'Select Department'),
                items: _departments.map((dept) => DropdownMenuItem(value: dept, child: Text(dept))).toList(),
                onChanged: (val) => setState(() => _selectedDepartment = val),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _selectedSemester,
                decoration: _inputDecoration(Icons.calendar_today, 'Current Semester'),
                items: _semesters.map((sem) => DropdownMenuItem(value: sem, child: Text(sem))).toList(),
                onChanged: (val) => setState(() => _selectedSemester = val),
              ),
              const SizedBox(height: 16),

              _buildTextField(Icons.email_outlined, 'University Email', _emailController),
              const SizedBox(height: 16),
              _buildTextField(Icons.lock_outline, 'Password', _passwordController, isPassword: true),
              const SizedBox(height: 16),
              _buildTextField(Icons.lock_outline, 'Confirm Password', _confirmPasswordController, isPassword: true),
              const SizedBox(height: 30),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: _isLoading ? null : _signUp,
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('CREATE ACCOUNT', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Log In'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hint, TextEditingController controller, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: _inputDecoration(icon, hint),
    );
  }

  InputDecoration _inputDecoration(IconData icon, String hint) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide.none),
      filled: true,
      fillColor: Colors.grey[100],
    );
  }
}