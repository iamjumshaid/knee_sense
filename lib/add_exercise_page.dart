import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'partials/doctor_header.dart';
import 'partials/doctor_footer.dart';

class AddExercisePage extends StatefulWidget {
  @override
  _AddExercisePageState createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _targetMuscleController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  File? _image;
  File? _video;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _video = File(pickedFile.path);
      }
    });
  }

  Future<void> _addExercise() async {
    if (_formKey.currentState!.validate()) {
      String imageUrl = '';
      String videoUrl = '';

      // Upload image if selected
      if (_image != null) {
        final ref = FirebaseStorage.instance.ref().child('exercise_images/${DateTime.now().toIso8601String()}');
        await ref.putFile(_image!);
        imageUrl = await ref.getDownloadURL();
      }

      // Upload video if selected
      if (_video != null) {
        final ref = FirebaseStorage.instance.ref().child('exercise_videos/${DateTime.now().toIso8601String()}');
        await ref.putFile(_video!);
        videoUrl = await ref.getDownloadURL();
      }

      // Add exercise to Firestore
      await FirebaseFirestore.instance.collection('doc_exercises').add({
        'name': _nameController.text,
        'targetMuscle': _targetMuscleController.text,
        'instructions': _instructionsController.text,
        'url': _urlController.text,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
        'timestamp': Timestamp.now(),
      });

      // Show success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exercise added successfully!')));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: 'Add New Exercise'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Row(
                children: [
                  Icon(Icons.directions_run, color: Theme.of(context).primaryColor, size: 30),
                  SizedBox(width: 10),
                  Text(
                    'Knee Exercise',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Exercise Name *',
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the exercise name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _targetMuscleController,
                decoration: InputDecoration(
                  labelText: 'Target Muscle *',
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the target muscle';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _instructionsController,
                decoration: InputDecoration(
                  labelText: 'How to do instructions',
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                maxLines: 3,  // Allow for multi-line input for instructions
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _urlController,
                decoration: InputDecoration(
                  labelText: 'URL',
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Upload Exercise Image/Video *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.image, color: Theme.of(context).primaryColor),
                    onPressed: _pickImage,
                  ),
                  IconButton(
                    icon: Icon(Icons.video_library, color: Theme.of(context).primaryColor),
                    onPressed: _pickVideo,
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addExercise,
                child: Text('Add', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
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
