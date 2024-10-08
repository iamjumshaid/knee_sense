import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      Navigator.pushNamed(context, '/patient_home');  // Changed from pop to pushNamed
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
            // Updated Step-by-step instructions
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('1. Prepare: Make sure the knee area is clean and dry.', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text('2. Position: Align the orthosis over your knee joint, ensuring that the sensors are correctly positioned.', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text('3. Secure: Fasten the straps snugly around your leg, ensuring a comfortable yet firm fit, without restricting blood flow.', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text('4. Check: Confirm that the orthosis is properly aligned and provides support without causing discomfort.', style: TextStyle(fontSize: 16)),
              ],
            ),
            Spacer(),
            // Centered Done button with an icon
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _completeCaliberation(context),
                icon: Icon(Icons.check, color: Colors.white), // Added an icon
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
            Navigator.pushNamed(context, '/patient_home');
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
