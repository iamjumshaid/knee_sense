import 'dart:async';
import 'dart:convert';  // For JSON decoding
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;  // For HTTP requests
import 'partials/doctor_header.dart';

class ExercisePage extends StatefulWidget {
  final String exerciseId;
  final String exerciseName;
  final String instructions;  // Doctor's instructions
  final String patientId;

  ExercisePage({
    required this.exerciseId,
    required this.exerciseName,
    required this.instructions,
    required this.patientId,
  });

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  late Timer _timer;
  late Timer _dataFetchTimer;
  int _seconds = 0;
  String imageUrl = '';
  String howToInstructions = '';
  String angle = '0.00';  // Rounded to 2 decimal places
  String temperature = '0.00';  // Rounded to 2 decimal places

  // JSON maps to store the time-series data
  Map<String, String> angleData = {};
  Map<String, String> temperatureData = {};

  @override
  void initState() {
    super.initState();
    _startTimer();
    _loadDocExerciseData();
    _startDataFetchTimer();  // Start periodic data fetching
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  Future<void> _loadDocExerciseData() async {
    try {
      DocumentSnapshot docExerciseSnapshot = await FirebaseFirestore.instance
          .collection('doc_exercises')
          .doc(widget.exerciseId)
          .get();

      if (docExerciseSnapshot.exists) {
        setState(() {
          imageUrl = docExerciseSnapshot['imageUrl'] ?? '';
          howToInstructions = docExerciseSnapshot['instructions'] ?? 'No instructions provided.';
        });
      }
    } catch (e) {
      print('Failed to load exercise data: $e');
    }
  }

  void _startDataFetchTimer() {
    _dataFetchTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _fetchRealtimeData();
    });
  }

  Future<void> _fetchRealtimeData() async {
    try {
      final response = await http.get(
        Uri.parse('https://knee-sense-default-rtdb.europe-west1.firebasedatabase.app/.json'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          angle = data['Angle']['Angle'].toStringAsFixed(2);
          temperature = data['Temp']['mean'].toStringAsFixed(2);

          // Store data in the maps
          angleData[_seconds.toString()] = angle;
          temperatureData[_seconds.toString()] = temperature;
        });
      } else {
        print('Failed to load real-time data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching real-time data: $e');
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _finishExercise(BuildContext context) {
    _timer.cancel();
    _dataFetchTimer.cancel();
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
        'angle_data': angleData,
        'temperature_data': temperatureData,
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
    _dataFetchTimer.cancel();
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
            // Display Image from Firestore or a Placeholder if not available
            Center(
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/how_to_perform.gif',
                      height: 200,
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
            // How to do Instructions
            Text(
              'How to do:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 10),
            Text(
              howToInstructions.isNotEmpty ? howToInstructions : 'No instructions provided.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            // Timer, Angle, Temperature, and Finish Button on the same line
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.timer, color: Theme.of(context).primaryColor),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Time: ${_formatTime(_seconds)}',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.rotate_right, color: Theme.of(context).primaryColor),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Angle: $angle°',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.thermostat, color: Theme.of(context).primaryColor),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Temp: $temperature°C',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
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
