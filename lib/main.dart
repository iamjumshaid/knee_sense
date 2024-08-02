import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'doctor_home_page.dart';
import 'doctor_exercises_page.dart';

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
        // Add more routes as needed
      },
    );
  }
}
