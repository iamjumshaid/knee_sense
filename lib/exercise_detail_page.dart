import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'partials/doctor_header.dart';
import 'partials/doctor_footer.dart';
import 'package:intl/intl.dart';

class ExerciseDetailPage extends StatelessWidget {
  final String exerciseId;
  final String exerciseName;

  ExerciseDetailPage({
    required this.exerciseId,
    required this.exerciseName,
  });

  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: 'Exercise Detail'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('exercises')
              .doc(exerciseId)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('Exercise not found.'));
            }

            var doc = snapshot.data!;
            var data = doc.data() as Map<String, dynamic>;

            var timeTaken = data.containsKey('time_taken') ? data['time_taken'] : 'N/A';
            var sets = data.containsKey('sets') ? data['sets'] : 'N/A';
            var comments = data.containsKey('comments') ? data['comments'] : 'No comments';
            var emotion = data.containsKey('emotion') ? data['emotion'] : 'neutral';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 10),
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.fitness_center, color: Colors.white),
                      radius: 30,
                    ),
                    SizedBox(width: 20),
                    Text(
                      exerciseName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.timer, color: Theme.of(context).primaryColor),
                    SizedBox(width: 5),
                    Text('Time: $timeTaken minutes'),
                    SizedBox(width: 20),
                    Icon(Icons.format_list_numbered, color: Theme.of(context).primaryColor),
                    SizedBox(width: 5),
                    Text('Sets: $sets'),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Feeling:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: emotion == 'very_dissatisfied' ? Colors.red : Colors.grey,
                    ),
                    Icon(
                      Icons.sentiment_dissatisfied,
                      color: emotion == 'dissatisfied' ? Colors.orange : Colors.grey,
                    ),
                    Icon(
                      Icons.sentiment_neutral,
                      color: emotion == 'neutral' ? Colors.yellow : Colors.grey,
                    ),
                    Icon(
                      Icons.sentiment_satisfied,
                      color: emotion == 'satisfied' ? Colors.lightGreen : Colors.grey,
                    ),
                    Icon(
                      Icons.sentiment_very_satisfied,
                      color: emotion == 'very_satisfied' ? Colors.green : Colors.grey,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Comments:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  comments,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: AppFooter(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation here
        },
      ),
    );
  }
}
