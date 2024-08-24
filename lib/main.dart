import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'doctor_home_page.dart';
import 'doctor_exercises_page.dart';
import 'patient_home_page.dart';
import 'patient_caliberation.dart';
import 'patient_exercises_history.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Knee Sense',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: LoginScreen(),
      routes: {
        '/home': (context) => DoctorHomePage(),
        '/exercises': (context) => DoctorExercisesPage(),
        '/patient_exercises_history': (context) => PatientExercisesHistoryPage(),
      },
      onGenerateRoute: (settings) {
        final userId = FirebaseAuth.instance.currentUser!.uid;

        if (settings.name == '/patient_home') {
          return MaterialPageRoute(
            builder: (context) => PatientHomePage(userId: userId),
          );
        } else if (settings.name == '/calibration') {
          return MaterialPageRoute(
            builder: (context) => PatientCaliberationPage(userId: userId),
          );
        }

        // Return null for other routes to let MaterialApp handle them
        return null;
      },
    );
  }
}
