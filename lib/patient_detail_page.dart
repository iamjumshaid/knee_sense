import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'partials/doctor_header.dart';
import 'partials/doctor_footer.dart';
import 'package:intl/intl.dart';
import 'exercise_detail_page.dart';

class PatientDetailPage extends StatelessWidget {
  final String patientId;
  final String name;
  final String contact;
  final String problem;

  PatientDetailPage({
    required this.patientId,
    required this.name,
    required this.contact,
    required this.problem,
  });

  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void _navigateToExerciseDetail(BuildContext context, DocumentSnapshot doc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseDetailPage(
          exerciseId: doc.id,
          exerciseName: doc['exercise_name'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: 'Patient Detail'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(Icons.person, color: Colors.white),
                  radius: 30,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Age: 23',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Contact: $contact',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Problem: $problem',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Exercise History',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('exercises')
                    .where('patient_id', isEqualTo: patientId)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No exercises found.'));
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      return GestureDetector(
                        onTap: () => _navigateToExerciseDetail(context, doc),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).primaryColor.withOpacity(0.15),
                                Theme.of(context).primaryColor.withOpacity(0.2),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Theme.of(context).primaryColor,
                                      child: Icon(Icons.fitness_center, color: Colors.white),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      doc['exercise_name'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.date_range, color: Theme.of(context).primaryColor),
                                    SizedBox(width: 5),
                                    Text('Date: ${formatDate(doc['date'])}'),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.timer, color: Theme.of(context).primaryColor),
                                    SizedBox(width: 5),
                                    Text('Time taken: ${doc['time_taken']} minutes'),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.sentiment_satisfied, color: Theme.of(context).primaryColor),
                                    SizedBox(width: 5),
                                    Text('How patient felt: '),
                                    Icon(
                                      Icons.sentiment_very_dissatisfied,
                                      color: doc['emotion'] == 'very_dissatisfied'
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    Icon(
                                      Icons.sentiment_dissatisfied,
                                      color: doc['emotion'] == 'dissatisfied'
                                          ? Colors.orange
                                          : Colors.grey,
                                    ),
                                    Icon(
                                      Icons.sentiment_neutral,
                                      color: doc['emotion'] == 'neutral'
                                          ? Colors.yellow
                                          : Colors.grey,
                                    ),
                                    Icon(
                                      Icons.sentiment_satisfied,
                                      color: doc['emotion'] == 'satisfied'
                                          ? Colors.lightGreen
                                          : Colors.grey,
                                    ),
                                    Icon(
                                      Icons.sentiment_very_satisfied,
                                      color: doc['emotion'] == 'very_satisfied'
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
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
