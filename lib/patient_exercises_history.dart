import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'partials/doctor_header.dart';
import 'partials/patient_footer.dart';

class PatientExercisesHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    print('Current user ID: $userId');

    return Scaffold(
      appBar: AppHeader(title: 'Performed Exercises'),  // Page title
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performed Exercises',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 16.0),  // Space before the list starts
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('exercises')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasData && snapshot.data != null) {
                    final documents = snapshot.data!.docs;
                    if (documents.isEmpty) {
                      return Center(child: Text('No exercise history found.'));
                    }

                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        var exerciseData = documents[index].data() as Map<String, dynamic>;
                        var exerciseId = exerciseData['exercise_id'];

                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('doc_exercises')
                              .doc(exerciseId)
                              .get(),
                          builder: (context, docSnapshot) {
                            if (docSnapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (docSnapshot.hasData && docSnapshot.data != null) {
                              var exerciseDetails = docSnapshot.data!.data() as Map<String, dynamic>?;
                              var exerciseName = exerciseDetails != null ? exerciseDetails['name'] : 'Unknown Exercise';

                              // Emojis based on emotion
                              String emotionText = exerciseData['emotion'] ?? 'neutral';
                              List<String> allEmojis = ['😔', '😕', '😐', '😊', '😁'];
                              Map<String, int> emotionMap = {
                                'very_dissatisfied': 0,
                                'dissatisfied': 1,
                                'neutral': 2,
                                'satisfied': 3,
                                'very_satisfied': 4,
                              };

                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                padding: EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.fitness_center, color: Theme.of(context).primaryColor),
                                        SizedBox(width: 10),
                                        Text(
                                          exerciseName,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(Icons.mood, color: Theme.of(context).primaryColor),
                                        SizedBox(width: 10),
                                        Text(
                                          'Emotion: ',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        ...List.generate(
                                          allEmojis.length,
                                          (i) => Text(
                                            allEmojis[i],
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: i == emotionMap[emotionText] ? Colors.teal : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.comment, color: Theme.of(context).primaryColor),
                                        SizedBox(width: 10),
                                        Text(
                                          'Comments: ',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(child: Text(exerciseData['comments'] ?? 'No comments')),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.timer, color: Theme.of(context).primaryColor),
                                        SizedBox(width: 10),
                                        Text(
                                          'Time taken: ',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(exerciseData['time_taken'] ?? 'N/A'),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                                        SizedBox(width: 10),
                                        Text(
                                          'Date: ',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${(exerciseData['timestamp'] as Timestamp).toDate().toLocal()}',
                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Center(child: Text('Error fetching exercise details.'));
                            }
                          },
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No exercise history found.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PatientFooter(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/patient_home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/calibration');
          } else if (index == 2) {
            // Already on Exercises page, do nothing
          }
        },
      ),
    );
  }
}
