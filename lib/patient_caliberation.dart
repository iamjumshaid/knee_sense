import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'partials/doctor_header.dart';
import 'partials/patient_footer.dart';

class PatientCaliberationPage extends StatelessWidget {
  final String userId;

  PatientCaliberationPage({required this.userId});

  void _completeCaliberation(BuildContext context) async {
    try {
      // Update the is_caliberated field to true for the current user
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'is_caliberated': true,
      });

      // Optionally, show a success message or navigate to another page
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Calibration complete!')));

      // Navigate back to the home page or another appropriate page
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to complete calibration: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: 'Calibration'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Aligning the heading "How to wear orthosis" to the left
            Text(
              'How to wear orthosis',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 20),
            // Image in the center
            Center(
              child: Image.asset(
                'assets/ideal_wear.png',
                height: 200, // Adjust the height as necessary
              ),
            ),
            SizedBox(height: 30),
            // Instructions heading aligned to the left
            Text(
              'Instructions:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 10),
            // Step-by-step instructions left aligned
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('1. First instruction', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text('2. Second instruction', style: TextStyle(fontSize: 16)),
              ],
            ),
            Spacer(),
            // Centered Done button with an icon
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _completeCaliberation(context),
                label: Text('Done', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: PatientFooter(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            // Already on Calibration page, do nothing
          } else if (index == 2) {
            Navigator.pushNamed(context, '/exercises');
          }
        },
      ),
    );
  }
}
