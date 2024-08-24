import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'partials/doctor_header.dart';
import 'partials/patient_footer.dart';
import 'patient_caliberation.dart';
import 'exercise_page.dart';
import 'patient_exercises_history.dart';

class PatientHomePage extends StatelessWidget {
  final String userId;

  PatientHomePage({required this.userId});

  void _navigateToExercise(BuildContext context, String exerciseId,
      String exerciseName, String instructions) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExercisePage(
          exerciseId: exerciseId,
          exerciseName: exerciseName,
          instructions: instructions,
          patientId: userId,
        ),
      ),
    );
  }

  void _navigateToCaliberation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientCaliberationPage(userId: userId),
      ),
    );
  }

  void _navigateToExerciseHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PatientExercisesHistoryPage()),
    );
  }

  Future<bool> _isExerciseCompleted(String exerciseId) async {
    QuerySnapshot exercisesSnapshot = await FirebaseFirestore.instance
        .collection('exercises')
        .where('exercise_id', isEqualTo: exerciseId)
        .where('patient_id', isEqualTo: userId)
        .get();

    return exercisesSnapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: 'Patient Home'),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('User data not found.'));
          }
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          bool isCalibrated = userData['is_caliberated'] ?? false;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isCalibrated)
                  GestureDetector(
                    onTap: () => _navigateToCaliberation(context),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Fix your calibration',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                Text(
                  'Assigned Exercises',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('assigned_exercises')
                        .where('patient_id', isEqualTo: userId)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No exercises assigned.'));
                      }
                      return ListView(
                        children:
                            snapshot.data!.docs.map((assignedExerciseDoc) {
                          var assignedExerciseData = assignedExerciseDoc.data()
                              as Map<String, dynamic>;
                          String exerciseId =
                              assignedExerciseData['exercise_id'];
                          String comment = assignedExerciseData['comment'];

                          return FutureBuilder<bool>(
                            future: _isExerciseCompleted(exerciseId),
                            builder: (context, futureSnapshot) {
                              if (futureSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              if (futureSnapshot.hasData &&
                                  futureSnapshot.data == false) {
                                return FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('doc_exercises')
                                      .doc(exerciseId)
                                      .get(),
                                  builder: (context, exerciseSnapshot) {
                                    if (exerciseSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (!exerciseSnapshot.hasData ||
                                        !exerciseSnapshot.data!.exists) {
                                      return ListTile(
                                          title: Text('Exercise not found'));
                                    }
                                    var exerciseData = exerciseSnapshot.data!
                                        .data() as Map<String, dynamic>;
                                    String exerciseName =
                                        exerciseData['name'];

                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      padding: EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.fitness_center,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  exerciseName,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.info_outline,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              SizedBox(width: 5),
                                              Expanded(
                                                child: Text(
                                                  'Instructions: $comment',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: ElevatedButton.icon(
                                              onPressed: isCalibrated
                                                  ? () => _navigateToExercise(
                                                      context,
                                                      exerciseId,
                                                      exerciseName,
                                                      comment)
                                                  : null,
                                              icon: Icon(
                                                Icons.play_arrow,
                                                size: 20,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                              ),
                                              label: Text(
                                                'Start exercise',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: isCalibrated
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Colors.grey,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                              return Container(); // Return an empty container if the exercise is already completed
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: PatientFooter(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            // Already on Home page, do nothing
          } else if (index == 1) {
            _navigateToCaliberation(context);
          } else if (index == 2) {
            _navigateToExerciseHistory(context);
          }
        },
      ),
    );
  }
}
