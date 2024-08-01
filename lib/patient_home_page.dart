import 'package:flutter/material.dart';

class PatientHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patient Home')),
      body: Center(child: Text('Welcome Patient!')),
    );
  }
}
