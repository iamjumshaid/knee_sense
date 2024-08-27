import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';  // Import fl_chart package
import 'partials/doctor_header.dart';
import 'partials/doctor_footer.dart';

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

  List<FlSpot> _createFlSpots(Map<String, String> data) {
    final Map<int, List<double>> intervalData = {};

    // Group data into 10-second intervals
    data.forEach((key, value) {
      int time = int.tryParse(key) ?? 0;
      double angle = double.tryParse(value) ?? 0.0;
      int interval = (time ~/ 10) * 10;

      if (!intervalData.containsKey(interval)) {
        intervalData[interval] = [];
      }
      intervalData[interval]!.add(angle);
    });

    // Create average FlSpots for each interval
    final List<FlSpot> spots = [];
    intervalData.forEach((interval, angles) {
      double averageAngle = angles.reduce((a, b) => a + b) / angles.length;
      spots.add(FlSpot(interval.toDouble(), averageAngle));
    });

    return spots;
  }

  Widget _buildLineChart(List<FlSpot> spots, Color color, String xAxisLabel, String yAxisLabel) {
    final double minY = spots.isNotEmpty ? spots.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 1 : 0;
    final double maxY = spots.isNotEmpty ? spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 1 : 1;
    final double maxX = spots.isNotEmpty ? spots.last.x : 0;

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,  // Increase interval to reduce the number of Y-axis labels
              getTitlesWidget: (value, meta) {
                // Skip the overlapping Y-axis value `82.3`
                if (value == 82.3 || value == 80.0 || value == 78.0) {
                  return Container();
                }
                return Text(value.toStringAsFixed(1), style: TextStyle(fontSize: 12));
              },
              reservedSize: 40,
            ),
            axisNameWidget: Text(
              yAxisLabel,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            axisNameSize: 20,
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),  // Hide right Y-axis labels
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,  // Increased to allow full visibility of the last X-axis value
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString(), style: TextStyle(fontSize: 12));
              },
            ),
            axisNameWidget: Text(
              xAxisLabel,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            axisNameSize: 20,
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),  // Hide top X-axis labels
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.black, width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
        ],
        minX: 0,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: 'Exercise Detail'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('exercises')
              .where('exercise_id', isEqualTo: exerciseId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('Exercise not found.'));
            }

            var doc = snapshot.data!.docs.first;
            var data = doc.data() as Map<String, dynamic>;

            var timeTaken = data.containsKey('time_taken') ? data['time_taken'] : 'N/A';
            var sets = data.containsKey('sets') ? data['sets'] : 'N/A';
            var comments = data.containsKey('comments') ? data['comments'] : 'No comments';
            var emotion = data.containsKey('emotion') ? data['emotion'] : 'neutral';
            var angleData = data['angle_data'] as Map<String, dynamic>? ?? {};
            var temperatureData = data['temperature_data'] as Map<String, dynamic>? ?? {};

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Icon(Icons.fitness_center, color: Colors.white),
                        radius: 30,
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          exerciseName,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
                  SizedBox(height: 20),
                  Text(
                    'Knee Angle:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Container(
                    height: 300,  // Restored the original height
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: _buildLineChart(
                      _createFlSpots(angleData.cast<String, String>()),
                      Colors.blue,
                      'Time (seconds)',
                      'Angle (degrees)',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Temperature Graph:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Container(
                    height: 300,  // Restored the original height
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: _buildLineChart(
                      _createFlSpots(temperatureData.cast<String, String>()),
                      Colors.red,
                      'Time (seconds)',
                      'Temperature (°C)',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: AppFooter(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            // Already on home page, do nothing
          } else if (index == 1) {
            Navigator.pushNamed(context, '/exercises');
          } else if (index == 2) {
            // Implement navigation to profile page
          }
        },
      ),
    );
  }
}
