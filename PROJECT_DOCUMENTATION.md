🎓 Iqra Student Portal - Technical Documentation
Tech Stack: Flutter (UI) + Firebase (Backend)

1. Core Configuration (main.dart)
This is the entry point of the application.

WidgetsFlutterBinding.ensureInitialized():

Why? Flutter needs to set up its internal communication channels before we can talk to Firebase. If we don't call this, the app crashes before starting.

Firebase.initializeApp():

Why? Connects our app to the Google servers using the keys in firebase_options.dart.

routes Map:

Why? We used Named Routes (e.g., /dashboard, /login). This makes the code cleaner than pushing massive MaterialPageRoute blocks everywhere.

2. Authentication (signup_screen.dart & login_screen.dart)
We split the logic into two parts: Auth and Database.

FirebaseAuth.instance.createUserWithEmailAndPassword:

What it does: Creates the secure account on Google's servers.

Why? Google handles the encryption. We never see or store the raw password.

FirebaseFirestore.instance.collection('users').set(...):

Why? The Auth system only holds email and password. We needed to store the "Student Name," "Semester," and "Department." We create a database document using the Same UID as the Auth user to link them together.

signOut() immediately after SignUp:

Why? For security. By default, Firebase logs you in after signup. We force the user to go back and log in manually to verify they remember their password.

3. The Dashboard (dashboard_screen.dart)
The brain of the app.

StreamBuilder (Crucial Concept):

What it does: It opens a permanent connection to the database.

Why? Unlike FutureBuilder (which fetches once), StreamBuilder listens for changes. If the admin changes the student's name in the database, the Dashboard updates instantly without the user refreshing.

Grid Layout:

Why? We chose a 2x2 Grid for the main modules (Courses, Attendance, Fees, Transcript) because it is the most efficient way to access high-priority features with one thumb.

4. Feature Modules (Attendance, Fees, Timetable)
Mock Data (List<Map<String, dynamic>>):

What it is: We used hardcoded lists for these screens instead of a database.

Why? For an MVP (Minimum Viable Product), modeling a complex Relational Database for daily attendance is overkill. This demonstrates the UI/UX flow perfectly without backend complexity.

DefaultTabController (Timetable):

Why? Used to create the Mon-Fri tabs. It manages the swipe gestures and state automatically, keeping the code simple.

5. Settings & Security (settings_screen.dart)
FirebaseAuth.instance.signOut():

Why? Destroys the session token on the phone.

Navigator.pushNamedAndRemoveUntil:

Why? When logging out, this command wipes the "Back Button History." This prevents a user from logging out, pressing "Back," and accidentally seeing the dashboard again.

sendPasswordResetEmail():

Why? It triggers Firebase's built-in email service. We didn't have to code an email server ourselves.

🛑 Common Viva/Presentation Questions & Answers
Q: Why did you choose Firebase instead of SQL?

A: Firebase provides a "Real-time Database" and handling Authentication out of the box. It allowed us to build the entire backend (Login, Database, Cloud connection) in much less time than setting up a MySQL server.

Q: How does the app know which user's data to show?

A: We use FirebaseAuth.instance.currentUser.uid. This gives us the unique ID of the person logged in. We use that exact ID to fetch their specific document from the Firestore users collection.

Q: Is the data secure?

A: Yes. Passwords are handled entirely by Google (we never touch them). The database access can be restricted using Firestore Security Rules (e.g., "Users can only read their own data").

Q: Why didn't you implement real-time Attendance?

A: The scope of this project was to build the Student Portal experience. Connecting to the university's legacy attendance system would require API access we don't have. We built the UI to show how it would look.