import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'partials/doctor_header.dart';

class ExercisePage extends StatefulWidget {
  final String exerciseId;
  final String exerciseName;
  final String instructions;
  final String patientId;

  ExercisePage(
      {required this.exerciseId,
      required this.exerciseName,
      required this.instructions,
      required this.patientId});

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  late Timer _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _finishExercise(BuildContext context) {
    _timer.cancel();
    _showFeedbackDialog(context);
  }

  void _showFeedbackDialog(BuildContext context) {
    String selectedEmotion = '';
    TextEditingController _commentsController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('How you felt?'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.sentiment_very_satisfied,
                          color: selectedEmotion == 'very_satisfied'
                              ? Colors.green
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedEmotion = 'very_satisfied';
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.sentiment_satisfied,
                          color: selectedEmotion == 'satisfied'
                              ? Colors.green
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedEmotion = 'satisfied';
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.sentiment_neutral,
                          color: selectedEmotion == 'neutral'
                              ? Colors.green
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedEmotion = 'neutral';
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.sentiment_dissatisfied,
                          color: selectedEmotion == 'dissatisfied'
                              ? Colors.green
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedEmotion = 'dissatisfied';
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.sentiment_very_dissatisfied,
                          color: selectedEmotion == 'very_dissatisfied'
                              ? Colors.green
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedEmotion = 'very_dissatisfied';
                          });
                        },
                      ),
                    ],
                  ),
                  TextField(
                    controller: _commentsController,
                    decoration:
                        InputDecoration(hintText: 'Enter your comments'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _submitFeedback(
                      context,
                      selectedEmotion,
                      _commentsController.text,
                      _formatTime(_seconds),
                    );
                  },
                  child: Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _submitFeedback(BuildContext context, String emotion, String comments,
      String timeTaken) async {
    try {
      await FirebaseFirestore.instance.collection('exercises').add({
        'exercise_id': widget.exerciseId,
        'patient_id': widget.patientId,
        'emotion': emotion,
        'comments': comments,
        'time_taken': timeTaken,
        'timestamp': Timestamp.now(),
      });
      Navigator.of(context).pop(); // Close the feedback dialog
      Navigator.of(context).pop(); // Close the exercise screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit feedback: $e')));
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: 'Perform exercise'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise Name
            Text(
              widget.exerciseName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 20),
            // GIF in the middle
            Center(
              child: Image.asset(
                'assets/how_to_perform.gif',
                height: 200, // Adjust the height as necessary
              ),
            ),
            SizedBox(height: 30),
            // Doctor's Instructions
            Text(
              'Doctor\'s Instructions:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.instructions,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            // Timer, Angle, Temperature, and Finish Button on the same line
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.timer, color: Theme.of(context).primaryColor),
                    SizedBox(width: 5),
                    Text(
                      'Time: ${_formatTime(_seconds)}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.rotate_right,
                        color: Theme.of(context).primaryColor),
                    SizedBox(width: 5),
                    Text(
                      'Angle: 90°',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.thermostat,
                        color: Theme.of(context).primaryColor),
                    SizedBox(width: 5),
                    Text(
                      'Temp: 37°C',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _finishExercise(context),
                icon: Icon(Icons.stop, color: Colors.white),
                label: Text('Finish', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
