import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Get a reference to the Firestore instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Create a list of patient data
  List<Map<String, dynamic>> patientData = [
    {
      'contact': '+491771414387',
      'doc_id': 'DhCmpR6ChDOHElePs7Xu4VJ9al3',
      'name': 'Jumshaid Khan',
      'problem': 'Knee accident injury having pain in left knee'
    },
    {
      'contact': '+491771414388',
      'doc_id': 'DhCmpR6ChDOHElePs7Xu4VJ9al4',
      'name': 'John Doe',
      'problem': 'Knee pain due to sports injury'
    },
    {
      'contact': '+491771414389',
      'doc_id': 'DhCmpR6ChDOHElePs7Xu4VJ9al5',
      'name': 'Jane Smith',
      'problem': 'Knee surgery recovery'
    },
    {
      'contact': '+491771414390',
      'doc_id': 'DhCmpR6ChDOHElePs7Xu4VJ9al6',
      'name': 'Bob Johnson',
      'problem': 'Arthritis in knee'
    },
    {
      'contact': '+491771414391',
      'doc_id': 'DhCmpR6ChDOHElePs7Xu4VJ9al7',
      'name': 'Alice Williams',
      'problem': 'Knee ligament tear'
    },
    {
      'contact': '+491771414392',
      'doc_id': 'DhCmpR6ChDOHElePs7Xu4VJ9al8',
      'name': 'Michael Brown',
      'problem': 'Post knee replacement pain'
    },
    {
      'contact': '+491771414393',
      'doc_id': 'DhCmpR6ChDOHElePs7Xu4VJ9al9',
      'name': 'Chris Davis',
      'problem': 'Bursitis in knee'
    },
    {
      'contact': '+491771414394',
      'doc_id': 'DhCmpR6ChDOHElePs7Xu4VJ9al10',
      'name': 'Emma Wilson',
      'problem': 'Meniscus tear'
    },
    {
      'contact': '+491771414395',
      'doc_id': 'DhCmpR6ChDOHElePs7Xu4VJ9al11',
      'name': 'Olivia Martin',
      'problem': 'Knee instability'
    },
    {
      'contact': '+491771414396',
      'doc_id': 'DhCmpR6ChDOHElePs7Xu4VJ9al12',
      'name': 'Liam Lee',
      'problem': 'Runner’s knee'
    }
  ];

  // Add records to Firestore
  WriteBatch batch = firestore.batch();

  for (var patient in patientData) {
    DocumentReference docRef = firestore.collection('patients').doc();
    batch.set(docRef, patient);
  }

  await batch.commit();

  print('Records added successfully!');
}
