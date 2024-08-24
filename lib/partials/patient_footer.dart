import 'package:flutter/material.dart';

class PatientFooter extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  PatientFooter({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.adjust),
          label: 'Calibration',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Exercises',
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacementNamed(context, '/patient_home'); // Ensure this route leads to the patient home page
        } else if (index == 1) {
          Navigator.pushReplacementNamed(context, '/calibration'); // Ensure this route leads to the calibration page
        } else if (index == 2) {
          Navigator.pushReplacementNamed(context, '/patient_exercises_history'); // Ensure this route leads to the exercises history page
        }
      },
    );
  }
}
