import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'partials/doctor_header.dart';
import 'partials/doctor_footer.dart';
import 'partials/assign_exercise_to_patients.dart';
import 'add_exercise_page.dart';

class DoctorExercisesPage extends StatelessWidget {
  void _navigateToAddExercise(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddExercisePage()),
    );
  }

  void _showAssignExerciseDialog(BuildContext context, String exerciseId) {
    showDialog(
      context: context,
      builder: (context) => AssignExerciseToPatients(exerciseId: exerciseId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: 'Exercises'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'List of Exercises',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _navigateToAddExercise(context),
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('Add Exercise', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('doc_exercises').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No exercises found.'));
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        padding: EdgeInsets.all(12.0),
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
                                Expanded(
                                  child: Text(
                                    doc['name'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.directions_walk, color: Theme.of(context).primaryColor),
                                SizedBox(width: 5),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Target Area: ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: doc['target_area'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton.icon(
                                onPressed: () => _showAssignExerciseDialog(context, doc.id),
                                icon: Icon(Icons.assignment_ind, color: Colors.white, size: 18),
                                label: Text('Assign', style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  minimumSize: Size(100, 36),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            // Already on the exercises page, do nothing
          } else if (index == 2) {
            // Implement navigation to profile page
          }
        },
      ),
    );
  }
}
