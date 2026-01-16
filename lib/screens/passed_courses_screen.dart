import 'package:flutter/material.dart';

class PassedCoursesScreen extends StatelessWidget {
  const PassedCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Degree Progress', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset('assets/logo.png', width: 100),
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
           
            const Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: 0.45, 
                    strokeWidth: 10,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A237E)),
                  ),
                ),
                Column(
                  children: [
                    Text('3.42', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    Text('CGPA', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('BS Software Engineering', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

          
            const TabBar(
              isScrollable: true, 
              labelColor: Color(0xFF1A237E),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF1A237E),
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: 'Semester 1'),
                Tab(text: 'Semester 2'),
                Tab(text: 'Semester 3'),
              ],
            ),

            
            Expanded(
              child: Container(
                color: Colors.grey[50], 
                child: TabBarView(
                  children: [
                    _buildSemesterTranscript(
                      sgpa: '3.50', 
                      courses: [
                        {'name': 'Intro to Computing', 'code': 'CS-101', 'grade': 'A', 'credits': '3'},
                        {'name': 'Functional English', 'code': 'ENG-101', 'grade': 'A-', 'credits': '3'},
                        {'name': 'Calculus I', 'code': 'MATH-101', 'grade': 'B+', 'credits': '3'},
                        {'name': 'Applied Physics', 'code': 'PHY-101', 'grade': 'A', 'credits': '3'},
                      ]
                    ),
                    _buildSemesterTranscript(
                      sgpa: '3.20', 
                      courses: [
                        {'name': 'Programming Fundamentals', 'code': 'CS-102', 'grade': 'B', 'credits': '4'},
                        {'name': 'Calculus II', 'code': 'MATH-102', 'grade': 'B+', 'credits': '3'},
                        {'name': 'Communication Skills', 'code': 'ENG-102', 'grade': 'A', 'credits': '3'},
                        {'name': 'Islamic Studies', 'code': 'ISL-101', 'grade': 'A', 'credits': '2'},
                      ]
                    ),
                    _buildSemesterTranscript(
                      sgpa: '3.65', 
                      courses: [
                        {'name': 'Object Oriented Prog.', 'code': 'CS-201', 'grade': 'A', 'credits': '4'},
                        {'name': 'Data Structures', 'code': 'CS-202', 'grade': 'A-', 'credits': '4'},
                        {'name': 'Linear Algebra', 'code': 'MATH-201', 'grade': 'B+', 'credits': '3'},
                      ]
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 0, 
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Courses'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildSemesterTranscript({required String sgpa, required List<Map<String, String>> courses}) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // SGPA Header Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE8EAF6), 
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFC5CAE9)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Semester GPA (SGPA)', style: TextStyle(fontWeight: FontWeight.w600)),
              Text(sgpa, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        
        ...courses.map((course) => _buildTranscriptTile(
          course['name']!, 
          course['code']!, 
          course['grade']!,
          course['credits']!
        )),
      ],
    );
  }

  Widget _buildTranscriptTile(String title, String code, String grade, String credits) {
    Color gradeColor = Colors.green;
    if (grade.startsWith('B')) gradeColor = Colors.orange;
    if (grade.startsWith('C')) gradeColor = Colors.amber;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text('$code • $credits Credits', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ),
        trailing: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: gradeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: gradeColor.withOpacity(0.5)),
          ),
          child: Text(
            grade,
            style: TextStyle(fontWeight: FontWeight.bold, color: gradeColor, fontSize: 16),
          ),
        ),
      ),
    );
  }
}