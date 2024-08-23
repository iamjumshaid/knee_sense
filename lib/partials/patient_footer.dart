import 'package:flutter/material.dart';

class PatientFooter extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final IconData calibrationIcon;

  PatientFooter({
    required this.currentIndex,
    required this.onTap,
    this.calibrationIcon = Icons.healing, // Default icon if not provided
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(calibrationIcon), // Use the provided calibration icon
          label: 'Calibration',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Exercises',
        ),
      ],
    );
  }
}
