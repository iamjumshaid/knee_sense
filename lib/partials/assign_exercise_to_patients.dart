import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motion_toast/motion_toast.dart';

class AssignExerciseToPatients extends StatefulWidget {
  final String exerciseId;

  AssignExerciseToPatients({required this.exerciseId});

  @override
  _AssignExerciseToPatientsState createState() => _AssignExerciseToPatientsState();
}

class _AssignExerciseToPatientsState extends State<AssignExerciseToPatients> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedPatient;
  String _comment = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Assign Exercise'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('is_patient', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                var patients = snapshot.data!.docs;
                return DropdownButtonFormField(
                  value: _selectedPatient,
                  items: patients.map((patient) {
                    return DropdownMenuItem(
                      value: patient.id,
                      child: Text(patient['email']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPatient = value as String?;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Patient'),
                  validator: (value) =>
                      value == null ? 'Please select a patient' : null,
                );
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Comment'),
              onChanged: (value) {
                setState(() {
                  _comment = value;
                });
              },
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a comment' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await FirebaseFirestore.instance.collection('assigned_exercises').add({
                'patient_id': _selectedPatient,
                'exercise_id': widget.exerciseId,
                'comment': _comment,
              });
              MotionToast.success(
                title: Text("Success"),
                description: Text("Exercise assigned successfully"),
              ).show(context);
              Navigator.of(context).pop();
            }
          },
          child: Text('Assign'),
        ),
      ],
    );
  }
}
